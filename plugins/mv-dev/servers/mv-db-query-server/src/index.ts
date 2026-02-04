import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import mysql from "mysql2/promise";

// Configuration from environment variables
const DB_CONFIG = {
  host: process.env.MV_STAGING_DB_HOST,
  port: parseInt(process.env.MV_STAGING_DB_PORT ?? "3306", 10),
  user: process.env.MV_STAGING_DB_USER,
  password: process.env.MV_STAGING_DB_PASSWORD,
  database: process.env.MV_STAGING_DB_NAME,
  connectTimeout: 10000,
  waitForConnections: true,
  connectionLimit: 5,
};

// Blocked tables containing sensitive data
const BLOCKED_TABLES = new Set(
  (process.env.MV_DB_BLOCKED_TABLES ?? "user_credentials,payment_methods,stripe_tokens,admin_sessions")
    .split(",")
    .map((t) => t.trim().toLowerCase())
);

const MAX_LIMIT = 100;

// Lazy connection pool
let pool: mysql.Pool | null = null;

function getPool(): mysql.Pool {
  if (!pool) {
    if (!DB_CONFIG.host || !DB_CONFIG.user || !DB_CONFIG.password || !DB_CONFIG.database) {
      throw new Error(
        "Base de datos no configurada. Configura las variables de entorno:\n" +
        "  MV_STAGING_DB_HOST\n" +
        "  MV_STAGING_DB_USER\n" +
        "  MV_STAGING_DB_PASSWORD\n" +
        "  MV_STAGING_DB_NAME"
      );
    }
    pool = mysql.createPool(DB_CONFIG);
  }
  return pool;
}

// SQL validation
function validateSQL(sql: string): { valid: boolean; error?: string } {
  const trimmed = sql.trim();
  const upper = trimmed.toUpperCase();

  // Only allow SELECT statements
  if (!upper.startsWith("SELECT")) {
    return { valid: false, error: "Solo se permiten queries SELECT. Operaciones de escritura estan prohibidas." };
  }

  // Block destructive keywords anywhere in the query
  const destructive = ["DELETE", "UPDATE", "INSERT", "DROP", "ALTER", "TRUNCATE", "CREATE", "REPLACE", "GRANT", "REVOKE"];
  for (const keyword of destructive) {
    // Use word boundary matching to avoid false positives
    const regex = new RegExp(`\\b${keyword}\\b`, "i");
    if (regex.test(trimmed) && keyword !== "CREATE") {
      return { valid: false, error: `Operacion '${keyword}' no permitida. Solo SELECT esta permitido.` };
    }
    // For CREATE, only block if it's not inside a string or subquery context
    if (keyword === "CREATE" && regex.test(trimmed) && !upper.startsWith("SELECT")) {
      return { valid: false, error: `Operacion '${keyword}' no permitida.` };
    }
  }

  // Require LIMIT clause
  if (!upper.includes("LIMIT")) {
    return { valid: false, error: "El query debe incluir una clausula LIMIT (maximo 100)." };
  }

  // Validate LIMIT value
  const limitMatch = upper.match(/LIMIT\s+(\d+)/);
  if (limitMatch) {
    const limitValue = parseInt(limitMatch[1], 10);
    if (limitValue > MAX_LIMIT) {
      return { valid: false, error: `LIMIT maximo es ${MAX_LIMIT}. Tu query tiene LIMIT ${limitValue}.` };
    }
  }

  // Check for blocked tables
  for (const table of BLOCKED_TABLES) {
    const tableRegex = new RegExp(`\\b${table}\\b`, "i");
    if (tableRegex.test(trimmed)) {
      return { valid: false, error: `Acceso a la tabla '${table}' esta bloqueado por contener datos sensibles.` };
    }
  }

  return { valid: true };
}

// Format results as readable table
function formatResults(rows: Record<string, unknown>[]): string {
  if (rows.length === 0) return "No se encontraron resultados.";

  const columns = Object.keys(rows[0]);
  const widths = columns.map((col) => {
    const maxDataWidth = Math.max(...rows.map((row) => String(row[col] ?? "NULL").length));
    return Math.max(col.length, maxDataWidth, 4);
  });

  const header = columns.map((col, i) => col.padEnd(widths[i])).join(" | ");
  const separator = widths.map((w) => "-".repeat(w)).join("-+-");

  const dataRows = rows.map((row) =>
    columns.map((col, i) => String(row[col] ?? "NULL").padEnd(widths[i])).join(" | ")
  );

  return [header, separator, ...dataRows].join("\n") + `\n\n(${rows.length} fila${rows.length === 1 ? "" : "s"})`;
}

// Create MCP server
const server = new McpServer({
  name: "mv-db-query",
  version: "1.0.0",
});

// Tool: query_staging_db
server.tool(
  "query_staging_db",
  "Ejecutar un query SELECT de solo lectura contra la base de datos staging de MV. Debe incluir LIMIT (max 100). Solo SELECT permitido.",
  {
    sql: z.string().describe("Query SQL SELECT (debe incluir LIMIT, maximo 100 filas)"),
    params: z.array(z.union([z.string(), z.number()])).optional().describe("Valores parametrizados para placeholders ? en el SQL"),
  },
  async ({ sql, params }) => {
    const validation = validateSQL(sql);
    if (!validation.valid) {
      return { content: [{ type: "text" as const, text: `Error: ${validation.error}` }] };
    }

    try {
      const db = getPool();
      const [rows] = await db.execute(sql, params ?? []);
      const resultRows = rows as Record<string, unknown>[];
      const formatted = formatResults(resultRows);

      return { content: [{ type: "text" as const, text: formatted }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error ejecutando query: ${msg}` }] };
    }
  }
);

// Tool: list_tables
server.tool(
  "list_tables",
  "Listar todas las tablas disponibles en la base de datos staging de MV",
  {},
  async () => {
    try {
      const db = getPool();
      const [rows] = await db.execute("SHOW TABLES");
      const tables = (rows as Record<string, string>[]).map((row) => Object.values(row)[0]);

      const visibleTables = tables.filter((t) => !BLOCKED_TABLES.has(t.toLowerCase()));
      const blockedCount = tables.length - visibleTables.length;

      let result = "Tablas disponibles:\n\n";
      result += visibleTables.map((t) => `  - ${t}`).join("\n");
      if (blockedCount > 0) {
        result += `\n\n(${blockedCount} tabla${blockedCount === 1 ? "" : "s"} bloqueada${blockedCount === 1 ? "" : "s"} por contener datos sensibles)`;
      }

      return { content: [{ type: "text" as const, text: result }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error: ${msg}` }] };
    }
  }
);

// Tool: describe_table
server.tool(
  "describe_table",
  "Ver la estructura (columnas, tipos, keys) de una tabla en la base de datos staging de MV",
  {
    table: z.string().describe("Nombre de la tabla a describir"),
  },
  async ({ table }) => {
    // Validate table name (alphanumeric and underscores only)
    if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(table)) {
      return { content: [{ type: "text" as const, text: "Error: Nombre de tabla invalido." }] };
    }

    if (BLOCKED_TABLES.has(table.toLowerCase())) {
      return { content: [{ type: "text" as const, text: `Error: La tabla '${table}' esta bloqueada por contener datos sensibles.` }] };
    }

    try {
      const db = getPool();
      const [rows] = await db.execute(`DESCRIBE \`${table}\``);
      const columns = rows as Record<string, unknown>[];
      const formatted = formatResults(columns);

      return { content: [{ type: "text" as const, text: `Estructura de tabla '${table}':\n\n${formatted}` }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error: ${msg}` }] };
    }
  }
);

// Tool: get_sample_data
server.tool(
  "get_sample_data",
  "Obtener datos de ejemplo de una tabla en staging (maximo 10 filas)",
  {
    table: z.string().describe("Nombre de la tabla"),
    limit: z.number().max(10).default(5).describe("Numero de filas (maximo 10)"),
  },
  async ({ table, limit }) => {
    if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(table)) {
      return { content: [{ type: "text" as const, text: "Error: Nombre de tabla invalido." }] };
    }

    if (BLOCKED_TABLES.has(table.toLowerCase())) {
      return { content: [{ type: "text" as const, text: `Error: La tabla '${table}' esta bloqueada por contener datos sensibles.` }] };
    }

    const safeLimit = Math.min(Math.max(1, limit), 10);

    try {
      const db = getPool();
      const [rows] = await db.execute(`SELECT * FROM \`${table}\` LIMIT ?`, [safeLimit]);
      const resultRows = rows as Record<string, unknown>[];
      const formatted = formatResults(resultRows);

      return { content: [{ type: "text" as const, text: `Datos de ejemplo de '${table}':\n\n${formatted}` }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error: ${msg}` }] };
    }
  }
);

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("mv-db-query MCP server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
