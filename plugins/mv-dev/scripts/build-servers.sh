#!/bin/bash
# Build script para compilar los MCP servers custom del plugin

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🔨 Building MCP servers..."

# Build mv-component-analyzer
echo "  📦 Building mv-component-analyzer..."
cd "$PLUGIN_ROOT/servers/mv-component-analyzer"
npm install --silent
npm run build --silent

# Build mv-db-query-server
echo "  📦 Building mv-db-query-server..."
cd "$PLUGIN_ROOT/servers/mv-db-query-server"
npm install --silent
npm run build --silent

echo "✅ All MCP servers built successfully!"
