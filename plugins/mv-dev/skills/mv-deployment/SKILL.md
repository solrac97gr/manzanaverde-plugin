---
description: Procedimientos de deployment a staging y produccion de Manzana Verde - Vercel para frontend, Railway para backend
---

# Deployment en Manzana Verde

Guia para deployar proyectos de MV a staging y produccion.

## Infraestructura

| Componente | Staging | Produccion |
|------------|---------|------------|
| Frontend (Next.js) | Vercel Preview | Vercel Production |
| Backend (Express) | Railway Dev | Railway Production |
| Base de datos | MySQL Staging | MySQL Production |
| CDN/Assets | Vercel Edge | Vercel Edge |

## Flujo de Deployment

```
feature/branch → PR → Preview Deploy → Code Review → Merge a develop → Staging → Test → Merge a main → Production
```

### 1. Preview Deploys (Automatico)

Cada push a un branch con PR genera un preview deploy automatico en Vercel:

```
https://mv-web-app-feature-nueva-pagina.vercel.app
```

### 2. Staging Deploy

Al mergear un PR a la rama `develop`:
- **Frontend:** Vercel deploya automaticamente desde `develop`
- **Backend:** Railway deploya automaticamente desde `develop`

### 3. Production Deploy

Al mergear `develop` a `main`:
- **Frontend:** Vercel deploya a produccion
- **Backend:** Railway deploya a produccion
- **Requiere:** Approval del Tech Lead

## Pre-Deployment Checklist

Antes de deployar, verificar:

```bash
# 1. Lint limpio
npx eslint . --max-warnings=0

# 2. Types correctos
npx tsc --noEmit

# 3. Tests pasan
npm test

# 4. Build exitoso
npm run build

# 5. No hay secrets en el codigo
# (El hook validate-secrets.sh lo hace automaticamente)
```

## Frontend (Vercel)

### Configuracion

Cada proyecto Next.js necesita en Vercel:

1. **Framework Preset:** Next.js
2. **Build Command:** `npm run build`
3. **Output Directory:** `.next`
4. **Node Version:** 20.x
5. **Environment Variables:** Configurar en Vercel Dashboard

### Variables de Entorno en Vercel

```bash
# Staging (develop branch)
NEXT_PUBLIC_API_URL=https://staging-api.manzanaverde.com
NEXT_PUBLIC_ENV=staging

# Production (main branch)
NEXT_PUBLIC_API_URL=https://api.manzanaverde.com
NEXT_PUBLIC_ENV=production
```

### Verificar Deployment

```bash
# Verificar que el deploy esta OK
curl -s https://staging.manzanaverde.com/api/health | jq .

# Deberia retornar:
# { "status": "ok", "version": "1.x.x", "env": "staging" }
```

## Backend (Railway)

### Configuracion

Cada proyecto Express necesita en Railway:

1. **Start Command:** `npm start`
2. **Build Command:** `npm run build`
3. **Health Check Path:** `/api/health`
4. **Port:** Variable `PORT` (Railway la asigna automaticamente)

### Variables de Entorno en Railway

```bash
# Staging
DB_HOST=staging-db.manzanaverde.com
DB_PORT=3306
DB_USER=mv_staging
DB_PASSWORD=<secret>
DB_NAME=mv_staging
JWT_SECRET=<secret>
NODE_ENV=staging

# Production
DB_HOST=prod-db.manzanaverde.com
# ... etc
```

### Health Check del Backend

```typescript
// routes/health.ts
router.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    version: process.env.npm_package_version,
    env: process.env.NODE_ENV,
    timestamp: new Date().toISOString(),
  });
});
```

## Monorepo Deployment

Para proyectos monorepo con frontend + backend:

```
packages/
├── frontend/  → Vercel (Root Directory: packages/frontend)
├── backend/   → Railway (Root Directory: packages/backend)
└── shared/    → Incluido en build de ambos
```

### Vercel

- **Root Directory:** `packages/frontend`
- **Install Command:** `npm install --workspace=packages/frontend --workspace=packages/shared`
- **Build Command:** `npm run build --workspace=packages/frontend`

### Railway

- **Root Directory:** `packages/backend`
- **Build Command:** `npm run build`
- **Start Command:** `npm start`

## Rollback

### Frontend (Vercel)

1. Ir a Vercel Dashboard → Deployments
2. Encontrar el ultimo deployment funcional
3. Click en "..." → "Promote to Production"

O via CLI:
```bash
# Listar deployments
npx vercel ls

# Promover deployment anterior
npx vercel promote <deployment-url>
```

### Backend (Railway)

1. Ir a Railway Dashboard → Deployments
2. Click en el deployment anterior exitoso
3. Click en "Redeploy"

O hacer revert del commit y push:
```bash
git revert HEAD
git push origin develop
```

## Troubleshooting

### Build falla en Vercel

1. Revisar logs de build en Vercel Dashboard
2. Causas comunes:
   - TypeScript errors no detectados localmente
   - Variables de entorno faltantes
   - Dependencias no instaladas
3. Solucion: correr `npm run build` localmente primero

### Deploy falla en Railway

1. Revisar logs en Railway Dashboard
2. Causas comunes:
   - Puerto no configurado (usar `process.env.PORT`)
   - Health check timeout (endpoint `/api/health` no responde)
   - Conexion a BD falla (verificar credenciales)
3. Solucion: probar localmente con `NODE_ENV=staging npm start`

### Preview deploy no funciona

1. Verificar que el PR esta abierto en GitHub
2. Verificar que Vercel tiene acceso al repo
3. Revisar la tab "Checks" del PR en GitHub

## Logs y Monitoreo

### Frontend
```bash
# Vercel logs en tiempo real
npx vercel logs <deployment-url> --follow
```

### Backend
```bash
# Railway logs (via dashboard o CLI)
railway logs --follow
```
