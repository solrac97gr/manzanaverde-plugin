# MV Dev - Plugin de Claude Code para Manzana Verde

Plugin completo de desarrollo que permite a cualquier miembro del equipo de Manzana Verde crear proyectos de software de forma segura, consistente y alineada con los estandares de la empresa.

## Instalacion

```bash
claude plugin add https://github.com/manzanaverde/manzanaverde-plugin
```

## Que incluye

### Skills (10)

**Conocimiento:**
- `/mv-dev:mv-api-consumer` - Como consumir APIs de MV correctamente
- `/mv-dev:mv-db-queries` - Queries seguros a la base de datos staging
- `/mv-dev:mv-design-system` - Design system, colores, tipografia, componentes
- `/mv-dev:mv-testing` - Como escribir tests en nuestro stack
- `/mv-dev:mv-deployment` - Procedimientos de deployment

**Accion:**
- `/mv-dev:start-project` - Iniciar nuevo proyecto (Next.js, Express, monorepo)
- `/mv-dev:new-feature` - Scaffold completo de feature
- `/mv-dev:new-page` - Nueva pagina Next.js con metadata y loading states
- `/mv-dev:create-api` - Nuevo endpoint Express con validacion
- `/mv-dev:deploy-staging` - Deploy a staging con verificaciones

### Agentes (4)

- **QA Agent** - Genera tests, valida cobertura, identifica edge cases
- **Frontend Agent** - Verifica cumplimiento del design system, patrones Next.js, accesibilidad
- **Backend Agent** - Valida patrones de API, queries seguras, logica de negocio
- **Doc Agent** - Gestiona documentacion, conexion a Notion

### Hooks de Validacion (6)

Ejecutados automaticamente al escribir/editar archivos:

- `validate-secrets.sh` - Detecta secrets expuestos
- `validate-pre-commit.sh` - Lint y formateo
- `validate-pre-push.sh` - Tests y tipos
- `validate-quality-gate.sh` - Cobertura y build
- `validate-nextjs-patterns.sh` - Patrones Next.js
- `validate-api-patterns.sh` - Patrones Express

### MCP Servers (7)

**Externos (incluidos por defecto):**
- **context7** - Documentacion actualizada de librerias (requiere `CONTEXT7_API_KEY`)
- **memory-keeper** - Memoria persistente entre sesiones de Claude Code
- **playwright** - Automatizacion de browser para testing E2E
- **notion** - Acceso oficial a documentacion en Notion (requiere `NOTION_TOKEN`)
- **supabase-mcp** - Gestion de base de datos Supabase en modo read-only (requiere `SUPABASE_ACCESS_TOKEN`)

**Custom de MV:**
- **mv-db-query** - Queries MySQL staging (solo lectura, LIMIT obligatorio)
- **mv-component-analyzer** - Analisis de componentes React/Next.js

## Configuracion

**Lee [SETUP.md](SETUP.md) para la guia completa paso a paso.**

Resumen rapido:

1. Obtener tokens de Context7, Notion y Supabase (ver SETUP.md)
2. Agregar las variables a tu `~/.zshrc`:
   ```bash
   export CONTEXT7_API_KEY="ctx7sk-..."
   export NOTION_TOKEN="ntn_..."
   export SUPABASE_ACCESS_TOKEN="sbp_..."
   ```
3. Reiniciar terminal y Claude Code

## Primer uso

```
# Crear un nuevo proyecto frontend
/mv-dev:start-project

# Crear una nueva feature
/mv-dev:new-feature

# Deployar a staging
/mv-dev:deploy-staging
```

## Soporte

Si tienes problemas, contacta al Tech Lead o abre un issue en este repositorio.
