import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import * as fs from "fs";
import * as path from "path";

// MV Design tokens for compliance checking
const MV_COLORS: Record<string, string> = {
  "#E8F5EC": "mv-green-50 / bg-mv-green-pale",
  "#C5E6CE": "mv-green-100",
  "#9ED6AE": "mv-green-200",
  "#6BBF8A": "mv-green-300",
  "#3D9A5F": "mv-green-400 / text-mv-green-light",
  "#227A4B": "mv-green-500 / bg-primary / text-mv-green",
  "#1D6A41": "mv-green-600 / bg-primary-hover",
  "#185A37": "mv-green-700 / bg-mv-green-dark",
  "#134A2D": "mv-green-800",
  "#0E3A23": "mv-green-900",
  "#FFF4E6": "mv-orange-50 / bg-mv-orange-light",
  "#FFE4C4": "mv-orange-100",
  "#F28B2D": "mv-orange-400",
  "#E85D04": "mv-orange-500 / bg-mv-orange",
  "#D4540A": "mv-orange-600",
  "#FFFBEB": "mv-yellow-50",
  "#FEF3C7": "mv-yellow-100",
  "#F0C94D": "mv-yellow-400",
  "#E5B83C": "mv-yellow-500 / text-mv-yellow",
  "#D4A72C": "mv-yellow-600",
  "#FAFAFA": "mv-gray-50 / bg-background",
  "#F5F5F5": "mv-gray-100",
  "#F0F0F0": "mv-gray-150",
  "#E8E8E8": "mv-gray-200 / border-mv-gray-200",
  "#D4D4D4": "mv-gray-300",
  "#A3A3A3": "mv-gray-400",
  "#737373": "mv-gray-500 / text-mv-gray-500",
  "#525252": "mv-gray-600",
  "#404040": "mv-gray-700",
  "#262626": "mv-gray-800",
  "#171717": "mv-gray-900 / text-foreground",
};

interface AnalysisResult {
  file: string;
  lineCount: number;
  isClientComponent: boolean;
  hooks: string[];
  propsInterface: string | null;
  imports: string[];
  designTokenViolations: string[];
  accessibilityIssues: string[];
  recommendations: string[];
}

function analyzeComponentFile(filePath: string): AnalysisResult {
  const content = fs.readFileSync(filePath, "utf-8");
  const lines = content.split("\n");

  const result: AnalysisResult = {
    file: filePath,
    lineCount: lines.length,
    isClientComponent: /^['"]use client['"]/.test(content),
    hooks: [],
    propsInterface: null,
    imports: [],
    designTokenViolations: [],
    accessibilityIssues: [],
    recommendations: [],
  };

  // Extract hooks
  const hookMatches = content.match(/\buse[A-Z]\w+/g);
  if (hookMatches) {
    result.hooks = [...new Set(hookMatches)];
  }

  // Extract props interface
  const propsMatch = content.match(/interface\s+(\w+Props)\s*\{/);
  if (propsMatch) {
    result.propsInterface = propsMatch[1];
  }

  // Extract imports
  const importMatches = content.matchAll(/import\s+.*?\s+from\s+['"]([^'"]+)['"]/g);
  for (const match of importMatches) {
    result.imports.push(match[1]);
  }

  // Check for hardcoded colors in Tailwind classes
  const hardcodedColors = content.matchAll(/(bg|text|border|ring|shadow|from|to|via)-\[#([0-9a-fA-F]{3,8})\]/g);
  for (const match of hardcodedColors) {
    const hex = `#${match[2].toUpperCase()}`;
    const token = MV_COLORS[hex];
    if (token) {
      result.designTokenViolations.push(
        `Linea con ${match[0]}: Usar token MV '${token}' en lugar de color hardcodeado`
      );
    } else {
      result.designTokenViolations.push(
        `${match[0]}: Color no definido en design system de MV. Verificar si debe usarse un token existente.`
      );
    }
  }

  // Check for raw <img> without next/image
  if (/<img\s/.test(content) && !content.includes("from 'next/image'") && !content.includes('from "next/image"')) {
    result.recommendations.push("Usar next/image en lugar de <img> para optimizacion de imagenes");
  }

  // Accessibility checks
  // Check for click handlers on divs/spans without role
  const clickableDivs = content.match(/<(div|span)\s[^>]*onClick/g);
  if (clickableDivs) {
    result.accessibilityIssues.push(
      `${clickableDivs.length} elemento(s) <div>/<span> con onClick. Usar <button> o agregar role="button" y tabIndex={0}`
    );
  }

  // Check for images without alt
  const imagesWithoutAlt = content.match(/<(img|Image)\s(?![^>]*\balt\b)[^>]*>/g);
  if (imagesWithoutAlt) {
    result.accessibilityIssues.push(
      `${imagesWithoutAlt.length} imagen(es) sin atributo alt`
    );
  }

  // Check for interactive elements without aria-label when no text
  const iconButtons = content.match(/<button[^>]*>\s*<[A-Z]\w+[^>]*\/>\s*<\/button>/g);
  if (iconButtons) {
    for (const btn of iconButtons) {
      if (!btn.includes("aria-label")) {
        result.accessibilityIssues.push(
          "Boton con solo icono sin aria-label"
        );
      }
    }
  }

  // Component size recommendation
  if (result.lineCount > 200) {
    result.recommendations.push(
      `Componente con ${result.lineCount} lineas. Considerar dividir en sub-componentes (recomendado: < 200 lineas)`
    );
  }

  // 'use client' recommendation
  if (result.isClientComponent && result.hooks.length === 0) {
    result.recommendations.push(
      "'use client' puede ser innecesario si no se usan hooks ni event handlers"
    );
  }

  // Font family check
  if (/<h[1-6]/.test(content) && !content.includes("font-heading")) {
    result.recommendations.push(
      "Headings (h1-h6) deben usar clase 'font-heading' para tipografia Inter"
    );
  }

  return result;
}

function formatAnalysis(analysis: AnalysisResult): string {
  let output = `## Analisis de Componente: ${path.basename(analysis.file)}\n\n`;
  output += `- **Lineas:** ${analysis.lineCount}\n`;
  output += `- **Tipo:** ${analysis.isClientComponent ? "Client Component" : "Server Component"}\n`;
  output += `- **Props:** ${analysis.propsInterface ?? "No definido"}\n`;
  output += `- **Hooks:** ${analysis.hooks.length > 0 ? analysis.hooks.join(", ") : "Ninguno"}\n`;
  output += `- **Imports:** ${analysis.imports.length}\n\n`;

  if (analysis.designTokenViolations.length > 0) {
    output += `### Design Token Violations (${analysis.designTokenViolations.length})\n`;
    for (const v of analysis.designTokenViolations) {
      output += `- ${v}\n`;
    }
    output += "\n";
  }

  if (analysis.accessibilityIssues.length > 0) {
    output += `### Accessibility Issues (${analysis.accessibilityIssues.length})\n`;
    for (const issue of analysis.accessibilityIssues) {
      output += `- ${issue}\n`;
    }
    output += "\n";
  }

  if (analysis.recommendations.length > 0) {
    output += `### Recommendations\n`;
    for (const rec of analysis.recommendations) {
      output += `- ${rec}\n`;
    }
    output += "\n";
  }

  const score =
    100 -
    analysis.designTokenViolations.length * 10 -
    analysis.accessibilityIssues.length * 15 -
    analysis.recommendations.length * 5;

  output += `### Score: ${Math.max(0, score)}/100\n`;

  return output;
}

// Create MCP server
const server = new McpServer({
  name: "mv-component-analyzer",
  version: "1.0.0",
});

// Tool: analyze_component
server.tool(
  "analyze_component",
  "Analizar un componente React/Next.js para cumplimiento del design system de MV, accesibilidad y mejores practicas",
  {
    filePath: z.string().describe("Ruta absoluta al archivo del componente (.tsx/.ts/.jsx)"),
  },
  async ({ filePath }) => {
    try {
      if (!fs.existsSync(filePath)) {
        return { content: [{ type: "text" as const, text: `Error: Archivo no encontrado: ${filePath}` }] };
      }
      const analysis = analyzeComponentFile(filePath);
      return { content: [{ type: "text" as const, text: formatAnalysis(analysis) }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error analizando componente: ${msg}` }] };
    }
  }
);

// Tool: check_design_system_compliance
server.tool(
  "check_design_system_compliance",
  "Verificar que un archivo cumple con el design system de Manzana Verde (colores, tipografia, tokens)",
  {
    filePath: z.string().describe("Ruta absoluta al archivo a verificar"),
  },
  async ({ filePath }) => {
    try {
      if (!fs.existsSync(filePath)) {
        return { content: [{ type: "text" as const, text: `Error: Archivo no encontrado: ${filePath}` }] };
      }

      const content = fs.readFileSync(filePath, "utf-8");
      const violations: string[] = [];

      // Check hardcoded hex colors in Tailwind
      const colorMatches = content.matchAll(/(bg|text|border|ring|shadow|from|to|via)-\[#([0-9a-fA-F]{3,8})\]/g);
      for (const match of colorMatches) {
        const hex = `#${match[2].toUpperCase()}`;
        const token = MV_COLORS[hex];
        violations.push(
          `${match[0]} → Usar ${token ?? "verificar si existe token MV"}`
        );
      }

      // Check for generic Tailwind colors that should use MV tokens
      const genericColors = content.matchAll(/\b(bg|text|border)-(green|orange|yellow|gray)-\d{2,3}\b/g);
      for (const match of genericColors) {
        violations.push(
          `${match[0]} → Usar tokens MV (ej: bg-primary, text-mv-green, border-mv-gray-200)`
        );
      }

      // Check font usage
      if (/<h[1-6]/.test(content) && !content.includes("font-heading")) {
        violations.push("Headings sin 'font-heading' - deben usar tipografia Inter");
      }

      if (/<p|<span/.test(content) && !content.includes("font-body") && !content.includes("font-heading")) {
        violations.push("Texto sin 'font-body' - considerar agregar para tipografia Nunito");
      }

      let result = `## Design System Compliance: ${path.basename(filePath)}\n\n`;

      if (violations.length === 0) {
        result += "OK - Sin violaciones del design system detectadas.\n";
      } else {
        result += `${violations.length} violacion(es) encontrada(s):\n\n`;
        for (const v of violations) {
          result += `- ${v}\n`;
        }
        result += "\nReferencia: /mv-design-system para tokens completos\n";
      }

      return { content: [{ type: "text" as const, text: result }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error: ${msg}` }] };
    }
  }
);

// Tool: find_missing_tests
server.tool(
  "find_missing_tests",
  "Buscar archivos de codigo que no tienen test correspondiente en un directorio",
  {
    directoryPath: z.string().describe("Ruta absoluta al directorio a escanear"),
  },
  async ({ directoryPath }) => {
    try {
      if (!fs.existsSync(directoryPath)) {
        return { content: [{ type: "text" as const, text: `Error: Directorio no encontrado: ${directoryPath}` }] };
      }

      const missingTests: string[] = [];
      const extensions = [".tsx", ".ts", ".jsx", ".js"];
      const testPatterns = [".test.", ".spec."];
      const excludeDirs = ["node_modules", "dist", ".next", "coverage", "__tests__"];
      const excludeFiles = ["index.ts", "index.tsx", "types.ts", "constants.ts", "config.ts"];

      function scanDir(dir: string) {
        const entries = fs.readdirSync(dir, { withFileTypes: true });
        for (const entry of entries) {
          const fullPath = path.join(dir, entry.name);
          if (entry.isDirectory()) {
            if (!excludeDirs.includes(entry.name)) {
              scanDir(fullPath);
            }
          } else if (entry.isFile()) {
            const ext = path.extname(entry.name);
            if (!extensions.includes(ext)) continue;
            if (testPatterns.some((p) => entry.name.includes(p))) continue;
            if (entry.name.endsWith(".d.ts")) continue;
            if (excludeFiles.includes(entry.name)) continue;

            // Check if test file exists
            const baseName = entry.name.replace(ext, "");
            const testFileExists = testPatterns.some((pattern) =>
              fs.existsSync(path.join(dir, `${baseName}${pattern}${ext.slice(1)}`)) ||
              fs.existsSync(path.join(dir, `${baseName}${pattern}tsx`)) ||
              fs.existsSync(path.join(dir, `${baseName}${pattern}ts`))
            );

            if (!testFileExists) {
              missingTests.push(path.relative(directoryPath, fullPath));
            }
          }
        }
      }

      scanDir(directoryPath);

      let result = `## Missing Tests Report: ${path.basename(directoryPath)}\n\n`;

      if (missingTests.length === 0) {
        result += "OK - Todos los archivos tienen test correspondiente.\n";
      } else {
        result += `${missingTests.length} archivo(s) sin test:\n\n`;
        for (const file of missingTests) {
          result += `- ${file}\n`;
        }
        result += "\nReferencia: /mv-testing para guia de como escribir tests\n";
      }

      return { content: [{ type: "text" as const, text: result }] };
    } catch (error) {
      const msg = error instanceof Error ? error.message : "Error desconocido";
      return { content: [{ type: "text" as const, text: `Error: ${msg}` }] };
    }
  }
);

// Tool: analyze_page_seo
server.tool(
  "analyze_page_seo",
  "Verificar completitud de metadata SEO en una pagina Next.js",
  {
    filePath: z.string().describe("Ruta absoluta al archivo page.tsx"),
  },
  async ({ filePath }) => {
    try {
      if (!fs.existsSync(filePath)) {
        return { content: [{ type: "text" as const, text: `Error: Archivo no encontrado: ${filePath}` }] };
      }

      const content = fs.readFileSync(filePath, "utf-8");
      const checks: { name: string; pass: boolean; detail: string }[] = [];

      // Check for metadata export
      const hasStaticMetadata = /export\s+const\s+metadata/.test(content);
      const hasDynamicMetadata = /export\s+async\s+function\s+generateMetadata/.test(content);

      checks.push({
        name: "Metadata export",
        pass: hasStaticMetadata || hasDynamicMetadata,
        detail: hasStaticMetadata
          ? "Static metadata"
          : hasDynamicMetadata
            ? "Dynamic generateMetadata"
            : "No metadata export found",
      });

      // Check for title
      checks.push({
        name: "Title",
        pass: /title:\s*['"`]/.test(content) || /title:/.test(content),
        detail: /title/.test(content) ? "Title defined" : "Missing title",
      });

      // Check for description
      checks.push({
        name: "Description",
        pass: /description:\s*['"`]/.test(content),
        detail: /description/.test(content) ? "Description defined" : "Missing description",
      });

      // Check for Open Graph
      checks.push({
        name: "Open Graph",
        pass: /openGraph/.test(content),
        detail: /openGraph/.test(content) ? "OG tags defined" : "Missing Open Graph tags",
      });

      // Check for viewport-friendly structure
      checks.push({
        name: "Responsive structure",
        pass: /max-w-|container|px-4|sm:px/.test(content),
        detail: /max-w-|container/.test(content) ? "Has max-width container" : "No responsive container detected",
      });

      let result = `## SEO Analysis: ${path.basename(filePath)}\n\n`;
      let passed = 0;

      for (const check of checks) {
        const icon = check.pass ? "PASS" : "FAIL";
        result += `- [${icon}] ${check.name}: ${check.detail}\n`;
        if (check.pass) passed++;
      }

      result += `\nScore: ${passed}/${checks.length}\n`;

      if (passed < checks.length) {
        result += "\nSugerencia: Agregar metadata faltante para mejor SEO.\n";
        result += "Referencia: /new-page para template completo de pagina con metadata\n";
      }

      return { content: [{ type: "text" as const, text: result }] };
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
  console.error("mv-component-analyzer MCP server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
