#!/bin/bash
# Wrapper script for mv-db-query MCP server that passes DB environment variables correctly

# Check if required DB variables are set
if [ -z "$DB_ACCESS_TYPE" ] || [ -z "$DB_ACCESS_HOST" ] || [ -z "$DB_ACCESS_USER" ] || [ -z "$DB_ACCESS_PASSWORD" ] || [ -z "$DB_ACCESS_NAME" ]; then
    echo "Error: DB_ACCESS_* environment variables are not fully configured" >&2
    echo "Required: DB_ACCESS_TYPE, DB_ACCESS_HOST, DB_ACCESS_USER, DB_ACCESS_PASSWORD, DB_ACCESS_NAME" >&2
    exit 1
fi

# Get the plugin root directory (parent of servers/)
PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVER_DIR="$PLUGIN_ROOT/servers/mv-db-query-server"

# Auto-install native dependencies if not present (first run)
if [ ! -d "$SERVER_DIR/node_modules/mysql2" ] || [ ! -d "$SERVER_DIR/node_modules/pg" ]; then
    echo "⚙️  Installing database drivers (mysql2, pg) - first run only..." >&2
    cd "$SERVER_DIR"
    npm install --production --silent mysql2 pg >&2
    echo "✅ Database drivers installed" >&2
fi

# Execute the mv-db-query MCP server with node
exec node "$SERVER_DIR/dist/index.js" "$@"
