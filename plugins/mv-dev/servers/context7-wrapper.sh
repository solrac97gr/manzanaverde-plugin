#!/bin/bash
# Wrapper script for Context7 MCP server

# Context7 works without API key but with rate limits
# If CONTEXT7_API_KEY is set, pass it
if [ -n "$CONTEXT7_API_KEY" ]; then
    exec npx -y @upstash/context7-mcp --api-key "$CONTEXT7_API_KEY" "$@"
else
    exec npx -y @upstash/context7-mcp "$@"
fi
