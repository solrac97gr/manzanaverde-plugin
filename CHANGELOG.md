# Changelog

Todos los cambios notables del plugin mv-dev se documentan aqui.

## [1.4.0] - 2026-02-06

### Added
- **SessionStart hook** para deteccion de tokens MCP faltantes al inicio de sesion (`check-mcp-tokens.sh`)
- Replicacion completa de contenido markdown a bloques nativos de Notion en el sync de docs (en vez de solo links a GitHub)
- Sync on demand: la sincronizacion docs/ → Notion ahora se ejecuta tambien cuando el usuario lo pide explicitamente, no solo en git push
- Tabla de conversion markdown → bloques Notion en doc-agent y mv-docs skill
- Mapeo explicito de archivos docs/*.md a sub-paginas de Notion

### Changed
- Seccion de sync en `doc-agent.md` reescrita con instrucciones detalladas de replicacion
- Seccion push en `mv-docs/SKILL.md` actualizada con los mismos patrones de replicacion

## [1.3.0] - 2026-02-06

### Added
- MCP server **Notion** oficial para documentacion de proyectos
- MCP server **Supabase** para bases de datos y migraciones
- MCP server **mv-component-analyzer** para analisis de componentes React/Next.js
- Hook de validacion **validate-api-patterns.sh** para endpoints Express
- Hook de validacion **validate-nextjs-patterns.sh** para paginas y componentes
- Agente **doc-agent** con estrategia dual-write (docs/ + Notion)
- Skill **mv-docs** para consulta centralizada de documentacion

### Changed
- Skills actualizados con guias de desarrollo mas claras
- Configuracion de env vars documentada en CLAUDE.md con instrucciones por token

## [1.2.0] - 2026-02-05

### Added
- Variables de entorno para MCP servers (`DB_ACCESS_*`, `CONTEXT7_API_KEY`, `SUPABASE_ACCESS_TOKEN`, `NOTION_TOKEN`)
- Documentacion de setup en CLAUDE.md

## [1.1.0] - 2026-02-04

### Added
- Skills de conocimiento: `mv-api-consumer`, `mv-db-queries`, `mv-design-system`, `mv-testing`, `mv-deployment`
- Skill `start-project` para iniciar proyectos MV
- Skill `new-feature` para scaffold de features
- Skill `new-page` para paginas Next.js
- Skill `create-api` para endpoints Express
- Hook **validate-secrets.sh** para deteccion de credenciales en codigo

## [1.0.0] - 2026-02-04

### Added
- Estructura inicial del plugin mv-dev
- CLAUDE.md con contexto global de Manzana Verde (stack, design tokens, reglas)
- MCP servers: **context7**, **memory-keeper**, **playwright**
- MCP server custom **mv-db-query** para queries de solo lectura a staging
- Scripts de validacion: pre-commit, pre-push, quality-gate
