---
description: Buscar documentacion de APIs y tablas SQL de Manzana Verde - docs del proyecto sincronizados con Notion, docs generales directo de Notion
---

# MV Docs - Documentacion Centralizada

Este skill es el **punto central de consulta** para toda la documentacion tecnica de Manzana Verde.

**Usar este skill siempre que necesites:**
- Saber que endpoints tiene una API de MV
- Conocer la estructura de una tabla SQL
- Entender un flujo de negocio documentado
- Buscar especificaciones tecnicas de cualquier servicio de MV

## Dos fuentes de documentacion

La documentacion se divide en dos tipos con estrategias diferentes:

### 1. Documentacion del proyecto (`docs/` ↔ Notion)

Cada proyecto creado con `/mv-dev:start-project` tiene una carpeta `docs/` que se **sincroniza** con la pagina del proyecto en Notion. Esta documentacion es **exclusiva de este proyecto**:

```
docs/
├── BUSINESS_LOGIC.md        # Logica de negocio de ESTE proyecto
├── API.md                   # Endpoints que ESTE proyecto expone
├── TABLES.md                # Tablas SQL que ESTE proyecto usa/crea
├── COMPONENTS.md            # Componentes de ESTE proyecto
├── ARCHITECTURE.md          # Arquitectura de ESTE proyecto
└── CHANGELOG.md             # Historial de cambios de ESTE proyecto
```

- Se versionan con git → cualquiera que clone el repo tiene la doc
- Se sincronizan con la pagina del proyecto en Notion (remote)
- **Notion es el remote**, `docs/` es el local (como git push/pull)

### 2. Documentacion general de MV (solo Notion)

La documentacion compartida de MV (tablas SQL globales, APIs de otros servicios, flujos generales) vive **solo en Notion** y se consulta directo con el API. No se guarda localmente porque:
- No pertenece a ningun proyecto especifico
- Puede cambiar sin que este proyecto lo sepa
- Siempre debe consultarse la version mas reciente

## Como buscar documentacion

### Para documentacion del proyecto actual

```
1. Leer docs/ del proyecto (rapido, sin API, funciona siempre)
2. Si docs/ esta desactualizado o el usuario pide sync → pull de Notion
```

**Si el usuario pregunta sobre algo de ESTE proyecto:**

| Pregunta | Archivo |
|----------|---------|
| "que endpoints tiene este proyecto?" | `docs/API.md` |
| "logica de negocio de este proyecto" | `docs/BUSINESS_LOGIC.md` |
| "que componentes tiene este proyecto?" | `docs/COMPONENTS.md` |
| "arquitectura del proyecto" | `docs/ARCHITECTURE.md` |
| "que tablas usa este proyecto?" | `docs/TABLES.md` |

### Para documentacion general de MV

```
1. Buscar en Notion directo con API-post-search
2. Leer la pagina encontrada con API-get-block-children
3. Presentar la informacion al usuario (NO guardar en docs/)
```

**Si el usuario pregunta sobre algo general de MV:**

| Pregunta | Donde buscar |
|----------|-------------|
| "que campos tiene la tabla users?" | Notion → buscar "users table" |
| "como funciona la api de payments?" | Notion → buscar "payments API" |
| "como es el flujo de suscripcion?" | Notion → buscar "subscription flow" |
| "estructura de la tabla orders" | Notion → buscar "orders schema" |

**Terminos de busqueda en Notion:**
- APIs: "[nombre] API", "[recurso] endpoint" (ej: "meals API", "orders endpoint")
- Tablas: "[nombre] table", "[nombre] schema" (ej: "users table", "orders schema")
- Flujos: "[nombre] flow", "[dominio] logic" (ej: "subscription flow", "delivery logic")

**Estrategia de busqueda si no hay resultados:**
1. Busqueda exacta primero
2. Busqueda amplia si no hay resultados (ej: si "meals_nutritional_info" no da resultados, buscar solo "meals")
3. Buscar por dominio general (ej: "logistics", "payments", "catalog")

## Requisito para documentacion general

La documentacion general requiere `NOTION_TOKEN`. Si no esta configurado, informar al usuario:

```
Para buscar documentacion general de MV en Notion necesitas configurar el token:

1. Ir a https://www.notion.so/my-integrations
2. Crear integracion "MV Claude Code" con permisos de Read content
3. Copiar el token (formato: ntn_...)
4. Agregar a tu ~/.zshrc:
   export NOTION_TOKEN="ntn_tu-token"
5. Ejecutar: source ~/.zshrc
6. Reiniciar Claude Code

Guia completa: ver SETUP.md del plugin (seccion 2)
```

La documentacion del proyecto (`docs/`) siempre funciona sin token.

## Sincronizacion docs/ ↔ Notion

La carpeta `docs/` se sincroniza con la pagina del proyecto en Notion. Notion es el **remote** (como un repo git remoto).

### Pull: Notion → docs/ (descargar)

Cuando el usuario dice "sincroniza los docs", "descarga los docs", o "actualiza docs desde Notion":

1. Obtener el link de GitHub del proyecto:
   - Leer `.git/config` → extraer `remote origin` URL
   - O leer `package.json` campo `repository`
2. Buscar la pagina del proyecto en Notion (por nombre o link de GitHub)
3. Leer todas las sub-paginas del proyecto
4. **Sobreescribir** los archivos en `docs/`:
   - Sub-pagina "Business Logic" → `docs/BUSINESS_LOGIC.md`
   - Sub-pagina "API Documentation" → `docs/API.md`
   - Sub-pagina "Tables" → `docs/TABLES.md`
   - Sub-pagina "Components" → `docs/COMPONENTS.md`
   - Sub-pagina "Architecture" → `docs/ARCHITECTURE.md`
   - Sub-pagina "Changelog" → `docs/CHANGELOG.md`
5. Informar al usuario que archivos se actualizaron

### Push: docs/ → Notion (subir)

Cuando el usuario dice "sube los docs a Notion", "sincroniza a Notion", o "push docs":

1. Leer los archivos de `docs/`
2. Buscar la pagina del proyecto en Notion
3. Actualizar las sub-paginas en Notion con el contenido local
4. Informar al usuario que secciones se actualizaron

### Auto-sync en git push

**IMPORTANTE:** Cada vez que se hace `git push` a GitHub, se debe sincronizar automaticamente `docs/` a Notion. El flujo es:

1. Claude detecta que se va a hacer `git push`
2. **Antes del push**: verificar si hay cambios en `docs/` (comparar con el ultimo sync)
3. Si hay cambios y `NOTION_TOKEN` esta configurado:
   a. Obtener el link de GitHub del proyecto (de `.git/config` → remote origin URL)
   b. Buscar la pagina del proyecto en Notion **por ese link** (identificador unico)
   c. Actualizar las sub-paginas correspondientes con el contenido de `docs/`
4. Hacer el `git push` normalmente
5. Informar: "Docs sincronizados a Notion (pagina: [nombre-proyecto]) antes del push"

Si `NOTION_TOKEN` no esta configurado, hacer el `git push` normal sin sync e informar que los docs solo se subieron a GitHub.

### Flujo tipico

```
Persona A (crea el proyecto):
  /mv-dev:start-project → crea docs/ + pagina en Notion
  Desarrolla features → actualiza docs/ localmente
  git push → auto-sync docs/ → Notion + push a GitHub

Persona B (continua el proyecto):
  git clone → tiene docs/ del ultimo push
  "sincroniza los docs" → pull Notion → docs/ (para tener lo mas reciente)
  Desarrolla features → actualiza docs/ localmente
  git push → auto-sync docs/ → Notion + push a GitHub
```

## Como decidir que buscar donde

| El usuario pregunta... | Tipo | Donde |
|------------------------|------|-------|
| "que endpoints tiene **este proyecto**?" | Proyecto | `docs/API.md` |
| "que campos tiene la tabla **users**?" | General MV | Notion API |
| "logica de negocio de **este proyecto**" | Proyecto | `docs/BUSINESS_LOGIC.md` |
| "como funciona **la api de payments**?" | General MV | Notion API |
| "que componentes tiene **este proyecto**?" | Proyecto | `docs/COMPONENTS.md` |
| "estructura de la tabla **orders**" | General MV | Notion API |
| "sincroniza los docs" | Sync | Pull Notion → `docs/` |

**Regla:** Si se refiere a "este proyecto" o algo documentado en `docs/` → local. Si es documentacion compartida de MV → Notion API.

## Integracion con otros skills

Este skill es **referenciado por otros skills** como fuente de verdad:

- **`/mv-dev:mv-api-consumer`** - Consulta endpoints reales antes de asumir rutas o parametros
- **`/mv-dev:mv-db-queries`** - Consulta schema real antes de asumir columnas o tipos
- **`/mv-dev:create-api`** - Verifica si ya existe documentacion del recurso antes de crear
- **`/mv-dev:new-feature`** - Consulta la logica de negocio antes de implementar

## Ejemplos de uso

### Ejemplo 1: Documentacion del proyecto (local)
```
Usuario: "que logica de negocio tiene este proyecto?"

1. Leer docs/BUSINESS_LOGIC.md
2. Responder con las reglas de negocio, flujos y validaciones
```

### Ejemplo 2: Documentacion general de MV (Notion)
```
Usuario: "que campos tiene la tabla users?"

1. Buscar en Notion: "users table"
2. Leer pagina encontrada
3. Responder con la estructura: id, name, email, phone...
(No se guarda en docs/ porque no es del proyecto)
```

### Ejemplo 3: Sync desde Notion
```
Usuario: "sincroniza los docs desde Notion"

1. Leer .git/config → remote = https://github.com/manzanaverde/mv-web-app
2. Buscar en Notion: "mv-web-app"
3. Leer todas las sub-paginas
4. Sobreescribir docs/BUSINESS_LOGIC.md, docs/API.md, etc.
5. Responder: "Docs sincronizados. Archivos actualizados: ..."
```

### Ejemplo 4: Push a Notion
```
Usuario: "sube los docs a Notion"

1. Leer docs/BUSINESS_LOGIC.md, docs/API.md, etc.
2. Buscar pagina del proyecto en Notion
3. Actualizar sub-paginas con el contenido local
4. Responder: "Docs subidos a Notion. Secciones actualizadas: ..."
```

## Notas importantes

- **`docs/` es solo de este proyecto** - No guardar documentacion general de MV en `docs/`. Solo lo que pertenece a este proyecto.
- **Notion es el remote** - Como git: `docs/` es tu copia local, Notion es el remoto. Push para subir, pull para bajar.
- **No inventar documentacion** - Si no existe ni en `docs/` ni en Notion, no inventar. Informar que no se encontro.
- **`docs/` se commitea** - Son parte del repo. Cualquiera que clone tiene la doc del proyecto.
- **Sin token funciona parcial** - `docs/` siempre funciona. Solo sync y busqueda general necesitan `NOTION_TOKEN`.
