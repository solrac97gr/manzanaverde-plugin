#!/bin/bash
# Wrapper script for Notion MCP server that passes environment variables correctly

# Check if NOTION_TOKEN is set
if [ -z "$NOTION_TOKEN" ]; then
    echo "Error: NOTION_TOKEN environment variable is not set" >&2
    exit 1
fi

# Execute the Notion MCP server with the token
exec npx -y @notionhq/notion-mcp-server "$@"
