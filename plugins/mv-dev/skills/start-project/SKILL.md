---
description: Iniciar un nuevo proyecto de Manzana Verde - Next.js frontend, Express backend, o monorepo completo
---

# Iniciar Proyecto de Manzana Verde

Este skill guia la creacion de un nuevo proyecto alineado con los estandares de MV.

## Paso 0: Verificar si hay un discovery previo

Antes de preguntar nada, verificar si existe un archivo `discovery-spec.yaml` o `docs/DISCOVERY.md` en el directorio actual. Si existe, **usarlo como base**:

- **Tipo de proyecto**: ya recomendado en el spec (no preguntar de nuevo)
- **APIs existentes**: pre-documentar en `docs/API.md`
- **Tablas existentes**: pre-documentar en `docs/TABLES.md`
- **Logica de negocio**: documentar en `docs/BUSINESS_LOGIC.md`
- **Gaps identificados**: agregar como TODOs en `docs/CHANGELOG.md`

Si el usuario hizo `/mv-dev:discovery` en la misma sesion, el spec ya esta en contexto. Usarlo directamente.

**Sugerir discovery si no existe:** Si el usuario no hizo discovery y el brief suena complejo (multiples entidades, integraciones con APIs existentes), sugerir: "Antes de crear el proyecto, puedes ejecutar `/mv-dev:discovery` para identificar que APIs y tablas existentes puedes reutilizar."

## Paso 1: Preguntar al usuario

Antes de crear cualquier archivo, preguntar (omitir lo que ya se sabe por discovery o PRD):

1. **Nombre del proyecto** - Ej: `mv-landing-campana`, `mv-calculadora-planes`
2. **Tipo de proyecto** (omitir si el discovery ya lo recomendo):
   - **Frontend** - Solo Next.js + Vercel (landing pages, dashboards, herramientas UI)
   - **Backend** - Solo Express + Railway (APIs, workers, servicios)
   - **Monorepo** - Frontend + Backend + Shared types (apps completas con logica de negocio)
3. **Descripcion del proyecto** - Puede ser:
   - **Una linea de descripcion** - Ej: "Landing page para la campana de verano 2025"
   - **Ruta a un archivo PRD** - Ej: `prd.md`, `./docs/prd-campana.md`, `PRD.md`. Si el usuario proporciona una ruta a un archivo PRD, leerlo con la herramienta Read y extraer de el: la descripcion del proyecto, las features principales, los requisitos tecnicos, y cualquier detalle relevante para la arquitectura. Usar esta informacion para tomar decisiones informadas en los pasos siguientes (tipo de proyecto, estructura de carpetas, paginas a crear, endpoints necesarios, etc.) sin volver a preguntar lo que ya esta definido en el PRD.
   - **Omitir si el discovery ya tiene el brief**
4. **Necesita base de datos?** - Si/No (para backend y monorepo). Omitir si el PRD o discovery ya lo especifica.
5. **Necesita autenticacion?** - Si/No. Omitir si el PRD o discovery ya lo especifica.

## Paso 2: Crear proyecto segun tipo

### Opcion A: Frontend (Next.js + Vercel)

Ejecutar:
```bash
npx create-next-app@latest [nombre-proyecto] --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

Luego crear esta estructura adicional:

```
[nombre-proyecto]/
├── src/
│   ├── app/
│   │   ├── layout.tsx           # Layout raiz con fonts y metadata
│   │   ├── page.tsx             # Pagina principal
│   │   ├── loading.tsx          # Loading state global
│   │   ├── error.tsx            # Error boundary global
│   │   ├── not-found.tsx        # 404 page
│   │   └── globals.css          # CSS global con tokens MV
│   ├── components/
│   │   ├── ui/                  # Componentes UI reutilizables
│   │   │   ├── Button.tsx
│   │   │   └── Card.tsx
│   │   └── layout/
│   │       ├── Header.tsx
│   │       └── Footer.tsx
│   ├── lib/
│   │   ├── api.ts               # Cliente API de MV
│   │   ├── utils.ts             # Utilidades generales
│   │   └── constants.ts         # Constantes
│   ├── hooks/                   # Custom hooks
│   ├── services/                # Logica de negocio
│   ├── types/                   # Tipos TypeScript
│   │   └── index.ts
│   └── styles/                  # Estilos adicionales
├── tests/
│   ├── e2e/                     # Tests Playwright
│   ├── setup.ts                 # Setup de tests
│   └── factories.ts             # Test data factories
├── docs/                        # Documentacion del proyecto (sync con Notion)
│   ├── BUSINESS_LOGIC.md        # Logica de negocio, reglas, flujos
│   ├── API.md                   # Endpoints, params, responses
│   ├── TABLES.md                # Schema de tablas SQL usadas
│   ├── COMPONENTS.md            # Componentes, hooks, servicios
│   ├── ARCHITECTURE.md          # Estructura, patron de datos, env vars
│   └── CHANGELOG.md             # Historial de cambios
├── public/
│   └── favicon.ico
├── .env.example                 # Variables de entorno (sin valores)
├── .env.local                   # Variables de entorno locales (en .gitignore)
├── .gitignore
├── CLAUDE.md                    # Contexto del proyecto para Claude Code
├── next.config.ts
├── tsconfig.json
├── vitest.config.ts
├── playwright.config.ts
└── package.json
```

### globals.css con tokens MV

```css
@import "tailwindcss";

@theme inline {
  --color-background: #FAFAFA;
  --color-foreground: #171717;
  --color-primary: #227A4B;
  --color-primary-hover: #1D6A41;
  --color-primary-light: #E8F5EC;
  --color-mv-green: #227A4B;
  --color-mv-green-dark: #185A37;
  --color-mv-green-light: #3D9A5F;
  --color-mv-green-pale: #E8F5EC;
  --color-mv-orange: #E85D04;
  --color-mv-orange-light: #FFF4E6;
  --color-mv-yellow: #E5B83C;
  --font-heading: 'Inter', system-ui, sans-serif;
  --font-body: 'Nunito', system-ui, sans-serif;
}

:root {
  --mv-green-50: #E8F5EC;
  --mv-green-100: #C5E6CE;
  --mv-green-200: #9ED6AE;
  --mv-green-300: #6BBF8A;
  --mv-green-400: #3D9A5F;
  --mv-green-500: #227A4B;
  --mv-green-600: #1D6A41;
  --mv-green-700: #185A37;
  --mv-green-800: #134A2D;
  --mv-green-900: #0E3A23;
  --mv-orange-50: #FFF4E6;
  --mv-orange-100: #FFE4C4;
  --mv-orange-400: #F28B2D;
  --mv-orange-500: #E85D04;
  --mv-orange-600: #D4540A;
  --mv-yellow-50: #FFFBEB;
  --mv-yellow-100: #FEF3C7;
  --mv-yellow-400: #F0C94D;
  --mv-yellow-500: #E5B83C;
  --mv-yellow-600: #D4A72C;
  --mv-white: #FFFFFF;
  --mv-gray-50: #FAFAFA;
  --mv-gray-100: #F5F5F5;
  --mv-gray-150: #F0F0F0;
  --mv-gray-200: #E8E8E8;
  --mv-gray-300: #D4D4D4;
  --mv-gray-400: #A3A3A3;
  --mv-gray-500: #737373;
  --mv-gray-600: #525252;
  --mv-gray-700: #404040;
  --mv-gray-800: #262626;
  --mv-gray-900: #171717;
  --mv-black: #0A0A0A;
  --mv-success: #227A4B;
  --mv-warning: #E85D04;
  --mv-error: #DC2626;
  --mv-info: #0EA5E9;
}

body {
  background: var(--mv-gray-50);
  color: var(--mv-gray-900);
  font-family: var(--font-body);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

### layout.tsx

```tsx
import type { Metadata } from 'next';
import { Inter, Nunito } from 'next/font/google';
import './globals.css';

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-heading',
  display: 'swap',
});

const nunito = Nunito({
  subsets: ['latin'],
  variable: '--font-body',
  display: 'swap',
});

export const metadata: Metadata = {
  title: '[NOMBRE_PROYECTO] | Manzana Verde',
  description: '[DESCRIPCION]',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es" className={`${inter.variable} ${nunito.variable}`}>
      <body className="bg-background text-foreground font-body antialiased">
        {children}
      </body>
    </html>
  );
}
```

### .env.example

```bash
# API
NEXT_PUBLIC_API_URL=

# Supabase (si el proyecto usa Supabase)
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=

# DB directa (solo si se necesita acceso directo sin Supabase)
DB_ACCESS_TYPE=            # mysql | postgres
DB_ACCESS_HOST=
DB_ACCESS_PORT=3306        # 3306 MySQL, 5432 PostgreSQL
DB_ACCESS_USER=
DB_ACCESS_PASSWORD=
DB_ACCESS_NAME=
```

**Si el proyecto usa Supabase y el `SUPABASE_ACCESS_TOKEN` esta configurado:**
1. Usar la herramienta `get_project_url` del MCP server supabase-mcp para obtener la URL del proyecto
2. Usar la herramienta `get_publishable_keys` para obtener la anon key
3. Escribir ambos valores automaticamente en el `.env.local` del proyecto

Esto evita que el usuario tenga que buscar y copiar estos valores manualmente.

### CLAUDE.md del proyecto

Crear un CLAUDE.md especifico del proyecto:

```markdown
# [NOMBRE_PROYECTO]

[DESCRIPCION]

## Stack
- Next.js 14+ (App Router)
- TypeScript strict
- Tailwind CSS v4 con tokens MV
- Vitest + React Testing Library
- Playwright para E2E

## Estructura
- `src/app/` - Paginas y layouts Next.js
- `src/components/` - Componentes React
- `src/lib/` - Utilidades y configuracion
- `src/hooks/` - Custom hooks
- `src/services/` - Logica de negocio y API calls
- `src/types/` - Tipos TypeScript

## Reglas
- Seguir el design system de MV (ver /mv-dev:mv-design-system)
- Server Components por defecto, 'use client' solo cuando necesario
- Tests para todo componente y hook
- No hardcodear colores, usar tokens
```

### Opcion B: Backend (Express)

```bash
mkdir [nombre-proyecto]
cd [nombre-proyecto]
npm init -y
npm install express cors helmet dotenv zod mysql2 jsonwebtoken
npm install -D typescript @types/node @types/express @types/cors ts-node vitest supertest @types/supertest
npx tsc --init
```

Estructura:

```
[nombre-proyecto]/
├── src/
│   ├── index.ts                 # Entry point
│   ├── app.ts                   # Express app setup
│   ├── routes/
│   │   ├── index.ts             # Route aggregator
│   │   └── health.ts            # Health check
│   ├── controllers/             # Request handlers
│   ├── services/                # Business logic
│   ├── models/                  # Data models
│   ├── middleware/
│   │   ├── auth.ts              # JWT authentication
│   │   ├── errorHandler.ts      # Global error handler
│   │   └── validate.ts          # Zod validation middleware
│   ├── types/
│   │   └── index.ts
│   └── config/
│       ├── database.ts          # MySQL connection
│       └── env.ts               # Environment validation
├── tests/
│   ├── setup.ts
│   └── factories.ts
├── docs/                        # Documentacion del proyecto (sync con Notion)
│   ├── BUSINESS_LOGIC.md
│   ├── API.md
│   ├── TABLES.md
│   ├── COMPONENTS.md
│   ├── ARCHITECTURE.md
│   └── CHANGELOG.md
├── .env.example
├── .gitignore
├── CLAUDE.md
├── tsconfig.json
├── vitest.config.ts
└── package.json
```

### Opcion C: Monorepo

```
[nombre-proyecto]/
├── packages/
│   ├── frontend/                # Next.js (estructura de Opcion A)
│   ├── backend/                 # Express (estructura de Opcion B)
│   └── shared/
│       ├── src/
│       │   ├── types/           # Tipos compartidos
│       │   └── utils/           # Utilidades compartidas
│       ├── package.json
│       └── tsconfig.json
├── docs/                        # Documentacion del proyecto (sync con Notion)
│   ├── BUSINESS_LOGIC.md
│   ├── API.md
│   ├── TABLES.md
│   ├── COMPONENTS.md
│   ├── ARCHITECTURE.md
│   └── CHANGELOG.md
├── package.json                 # Root con workspaces
├── .gitignore
├── CLAUDE.md
└── turbo.json                   # Turborepo config (opcional)
```

Root `package.json`:

```json
{
  "name": "[nombre-proyecto]",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "dev": "npm run dev --workspaces",
    "build": "npm run build --workspaces",
    "test": "npm test --workspaces",
    "lint": "npm run lint --workspaces"
  }
}
```

## Paso 3: Instalar dependencias adicionales

```bash
# Testing
npm install -D vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom @playwright/test msw

# Iconos
npm install lucide-react

# Utilidades
npm install clsx
```

## Paso 4: Inicializar Git

```bash
git init
git add .
git commit -m "Initial project setup: [nombre-proyecto]

MV standard project with Next.js/Express, TypeScript strict,
Tailwind CSS v4 with MV design tokens, and testing setup."
```

## Paso 5: Documentar proyecto

### 5a. Crear documentacion local (SIEMPRE)

Crear los archivos en `docs/` con contenido inicial basado en la informacion del proyecto:

- **`docs/BUSINESS_LOGIC.md`** - Si el usuario proporciono un PRD, extraer toda la logica de negocio (reglas, flujos, entidades, validaciones, edge cases). Si no hay PRD, crear plantilla vacia para llenar despues.
- **`docs/API.md`** - Pre-llenar si el proyecto es backend o monorepo (con el formato estandar de MV). Si es frontend, crear plantilla para cuando se consuman APIs.
- **`docs/TABLES.md`** - Crear plantilla para documentar las tablas SQL que use el proyecto.
- **`docs/COMPONENTS.md`** - Pre-llenar si el proyecto es frontend o monorepo.
- **`docs/ARCHITECTURE.md`** - Estructura de carpetas, patron de datos, dependencias, env vars.
- **`docs/CHANGELOG.md`** - Primera entrada con la creacion del proyecto.

### 5b. Sincronizar con Notion (si hay token)

Si `NOTION_TOKEN` esta configurado:

1. **Preguntar al usuario el link del repositorio en GitHub** (ej: `https://github.com/manzanaverde/mv-landing-campana`). Este link es el identificador unico del proyecto en Notion.
2. **Buscar en Notion** si ya existe una pagina con ese link de GitHub
3. Si **NO existe**: crear la pagina del proyecto en Notion con el mismo contenido que se escribio en `docs/`
4. Si **YA existe**: leer la documentacion existente de Notion, escribirla en `docs/` localmente e informar al usuario que el proyecto ya estaba documentado

Si `NOTION_TOKEN` no esta configurado, informar: "La documentacion se creo localmente en docs/. Para sincronizar con Notion, configura el NOTION_TOKEN (ver SETUP.md)."

## Paso 6: Siguientes pasos

Informar al usuario:

1. Configurar variables de entorno en `.env.local` copiando de `.env.example`
2. Si no lo hizo aun, crear repositorio en GitHub bajo la organizacion de MV
3. Conectar a Vercel/Railway segun tipo de proyecto
4. Empezar a desarrollar con `/mv-dev:new-feature` o `/mv-dev:new-page`
