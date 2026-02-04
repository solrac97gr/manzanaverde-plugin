# Arquitectura del Plugin MV Dev

## Estructura

```
mv-dev/
├── .claude-plugin/plugin.json   # Declaracion de hooks y MCP servers
├── skills/                      # Comandos invocables (/skill-name)
├── agents/                      # Revisores inteligentes
├── scripts/                     # Scripts de validacion bash
├── servers/                     # MCP servers TypeScript
└── templates/                   # Templates de codigo
```

## Como funciona

### Skills
Archivos `SKILL.md` con frontmatter YAML. Cuando un usuario invoca `/skill-name`, Claude lee el SKILL.md y sigue las instrucciones detalladas para ejecutar la tarea.

### Agentes
Archivos `.md` que definen el expertise y criterios de revision de cada agente. Se activan contextualmente cuando Claude detecta que un archivo o tarea cae dentro de su dominio.

### Hooks (PostToolUse)
Despues de que Claude escribe o edita un archivo, los hooks configurados en `plugin.json` ejecutan scripts de validacion automaticamente. Si un script retorna exit code 1, Claude recibe el feedback y corrige el problema.

### MCP Servers
Servidores TypeScript que exponen herramientas adicionales a Claude via el Model Context Protocol. Cada server se compila a JavaScript y se ejecuta con `node`.

## Arquitectura de proyectos MV

### Frontend (Next.js)

```
src/
├── app/                    # App Router de Next.js
│   ├── layout.tsx          # Layout raiz
│   ├── page.tsx            # Pagina principal
│   └── [feature]/          # Rutas por feature
├── components/             # Componentes compartidos
│   ├── ui/                 # Componentes UI base
│   └── layout/             # Componentes de layout
├── lib/                    # Utilidades y configuracion
│   ├── api.ts              # Cliente API
│   ├── utils.ts            # Utilidades generales
│   └── constants.ts        # Constantes
├── hooks/                  # Custom hooks
├── services/               # Logica de negocio y API calls
├── types/                  # Tipos TypeScript
└── styles/                 # Estilos globales y tokens
```

### Backend (Express)

```
src/
├── routes/                 # Definicion de rutas
├── controllers/            # Request handlers
├── services/               # Logica de negocio
├── models/                 # Modelos de datos
├── middleware/              # Auth, validation, error handling
├── types/                  # Tipos TypeScript
└── config/                 # Configuracion y env vars
```

### Monorepo

```
packages/
├── frontend/               # Next.js app
├── backend/                # Express API
└── shared/                 # Tipos y utilidades compartidas
    ├── types/
    └── utils/
```
