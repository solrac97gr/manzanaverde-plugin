---
description: Deployar el proyecto actual a staging de Manzana Verde con pre-flight checks, deploy y health check
---

# Deploy a Staging de Manzana Verde

Ejecuta pre-flight checks, deploya a staging y verifica que el deploy sea exitoso.

## Paso 1: Pre-flight Checks

Ejecutar estas verificaciones antes de deployar. **Si cualquiera falla, DETENER y reportar al usuario.**

### 1.1 Lint

```bash
npx eslint . --max-warnings=0
```

Si falla: Reportar los errores de lint y ofrecer corregirlos.

### 1.2 Type Check

```bash
npx tsc --noEmit
```

Si falla: Reportar los errores de tipo y ofrecer corregirlos.

### 1.3 Tests

```bash
npm test
```

Si falla: Reportar los tests fallidos y ofrecer investigar.

### 1.4 Build

```bash
npm run build
```

Si falla: Reportar los errores de build y ofrecer corregirlos.

### 1.5 Secrets Scan

Buscar patrones de secrets en todos los archivos `.ts`, `.tsx`, `.js`, `.jsx`:

- API keys (`sk_`, `pk_`, `api_key`)
- Connection strings (`mysql://`, `postgres://`)
- Tokens hardcodeados
- Archivos `.env` en el stage de git

Si se detectan: DETENER y alertar inmediatamente.

### 1.6 Branch Check

```bash
# Verificar que estamos en un branch (no main/master)
git branch --show-current

# Verificar que el branch esta actualizado con remote
git fetch origin
git status
```

Si estamos en `main`: DETENER y pedir crear un branch.
Si hay cambios sin commit: DETENER y pedir commit primero.

## Paso 2: Determinar tipo de proyecto

Detectar automaticamente:

- Si existe `next.config.*` → **Frontend (Vercel)**
- Si existe `src/index.ts` con Express → **Backend (Railway)**
- Si existe `packages/` → **Monorepo (ambos)**

## Paso 3: Deploy

### Frontend → Vercel

```bash
# Asegurar que los cambios estan commiteados
git add .
git status

# Push al remote (esto triggerea el deploy automatico en Vercel)
git push origin $(git branch --show-current)
```

Reportar al usuario:
- Branch pusheado
- Vercel creara un preview deploy automaticamente
- El URL del preview aparecera en el PR de GitHub
- Si ya existe PR, el deploy se actualiza automaticamente

### Backend → Railway

```bash
# Push al remote
git push origin $(git branch --show-current)
```

Reportar al usuario:
- Si el branch es `develop`, Railway deploya automaticamente
- Si es otro branch, necesitan crear PR y mergear a `develop`

### Monorepo

Ejecutar push una sola vez, ambos deploys se disparan automaticamente.

## Paso 4: Verificacion Post-Deploy

Esperar unos segundos y luego verificar:

### Health Check del Frontend

```bash
# El URL del preview deploy se puede obtener de Vercel
# o esperar a que aparezca en el PR de GitHub
curl -s [STAGING_URL]/api/health 2>/dev/null || echo "Health check endpoint not found - verify deployment manually"
```

### Health Check del Backend

```bash
curl -s [BACKEND_STAGING_URL]/api/health | python3 -m json.tool
```

Respuesta esperada:
```json
{
  "status": "ok",
  "version": "x.x.x",
  "env": "staging"
}
```

## Paso 5: Reporte al usuario

Generar un reporte:

```
## Deploy Report

### Pre-flight Checks
- [PASS] Lint: Sin errores
- [PASS] Types: TypeScript OK
- [PASS] Tests: X tests, X passed
- [PASS] Build: Exitoso
- [PASS] Secrets: No detectados
- [PASS] Branch: feature/nombre-feature

### Deploy
- Tipo: Frontend/Backend/Monorepo
- Branch: feature/nombre-feature
- Push: OK
- Preview URL: [URL del deploy]

### Post-Deploy
- Health Check: OK / PENDING

### Siguiente pasos
1. Verificar el preview deploy en [URL]
2. Si todo se ve bien, crear PR a `develop`
3. Solicitar code review
```

## Troubleshooting

### Build falla en Vercel pero local funciona

- Verificar que las variables de entorno estan configuradas en Vercel
- Verificar que no hay dependencias faltantes (peerDependencies)
- Revisar logs en: Vercel Dashboard → Deployments → [deploy] → Build Logs

### Railway deploy falla

- Verificar que `PORT` se lee de `process.env.PORT`
- Verificar que el health check endpoint `/api/health` responde
- Revisar logs en: Railway Dashboard → Service → Logs

### Preview deploy no aparece

- Verificar que hay un PR abierto en GitHub
- Verificar que la app de Vercel tiene acceso al repo
- Verificar en GitHub → PR → Checks tab
