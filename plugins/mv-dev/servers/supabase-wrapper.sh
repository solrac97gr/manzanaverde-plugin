#!/bin/bash
# Wrapper script for Supabase MCP server

if [ -z "$SUPABASE_ACCESS_TOKEN" ]; then
    echo "Error: SUPABASE_ACCESS_TOKEN environment variable is not set" >&2
    exit 1
fi

exec npx -y @supabase/mcp-server-supabase@latest --access-token "$SUPABASE_ACCESS_TOKEN" "$@"
