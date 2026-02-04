---
description: Iniciar un nuevo proyecto de Manzana Verde - Next.js frontend, Express backend, o monorepo completo
---

# Iniciar Proyecto de Manzana Verde

Este skill guia la creacion de un nuevo proyecto alineado con los estandares de MV.

## Paso 1: Preguntar al usuario

Antes de crear cualquier archivo, preguntar:

1. **Nombre del proyecto** - Ej: `mv-landing-campana`, `mv-calculadora-planes`
2. **Tipo de proyecto:**
   - **Frontend** - Solo Next.js + Vercel (landing pages, dashboards, herramientas UI)
   - **Backend** - Solo Express + Railway (APIs, workers, servicios)
   - **Monorepo** - Frontend + Backend + Shared types (apps completas con logica de negocio)
3. **Descripcion corta** - Una linea de que hace el proyecto
4. **Necesita base de datos?** - Si/No (para backend y monorepo)
5. **Necesita autenticacion?** - Si/No

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
MV_STAGING_API_URL=

# Staging DB (solo si se necesita acceso directo)
MV_STAGING_DB_HOST=
MV_STAGING_DB_PORT=3306
MV_STAGING_DB_USER=
MV_STAGING_DB_PASSWORD=
MV_STAGING_DB_NAME=
```

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
- Seguir el design system de MV (ver /mv-design-system)
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

## Paso 5: Siguiente pasos

Informar al usuario:

1. Configurar variables de entorno en `.env.local` copiando de `.env.example`
2. Crear repositorio en GitHub bajo la organizacion de MV
3. Conectar a Vercel/Railway segun tipo de proyecto
4. Empezar a desarrollar con `/new-feature` o `/new-page`
