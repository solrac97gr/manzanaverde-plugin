---
description: Descubrimiento tecnico para proyectos nuevos - analiza un brief de negocio y encuentra APIs, tablas y servicios existentes de MV que puedes reutilizar
---

# Discovery - Descubrimiento Tecnico

Este skill analiza un brief de negocio y busca en la infraestructura existente de MV (APIs, tablas SQL, servicios) todo lo que el proyecto puede reutilizar. El output es un spec tecnico estructurado que sirve como input para `/mv-dev:start-project`.

## Cuando usar

- **Antes de empezar un proyecto nuevo** - Para saber que ya existe y que hay que construir
- **Cuando el usuario tiene una idea pero no sabe por donde empezar** - El discovery le da un mapa tecnico
- **Cuando hay un PRD y quieres validar viabilidad** - Confirma que las APIs y datos necesarios existen

## Input

El usuario proporciona un **brief de negocio**. Puede ser:

1. **Una descripcion corta** - Ej: "Quiero hacer una landing donde el usuario ponga su direccion y vea si tiene cobertura, y si la tiene, le muestre el menu del dia"
2. **Una ruta a un archivo PRD** - Ej: `prd.md`, `./docs/prd-campana.md`. Leer el archivo completo con Read.
3. **Una explicacion conversacional** - El usuario describe lo que quiere en lenguaje natural

Si el brief es muy vago, preguntar:
- Que debe hacer el proyecto (funcionalidad principal)
- Quien lo va a usar (usuarios finales, equipo interno, partners)
- Que datos necesita mostrar o procesar

## Proceso de Discovery

### Paso 1: Extraer requerimientos del brief

Del brief del usuario, identificar:

- **Entidades del dominio** - Que objetos maneja (usuarios, pedidos, planes, comidas, direcciones, etc.)
- **Acciones del usuario** - Que puede hacer (ver menu, hacer pedido, verificar cobertura, etc.)
- **Datos que necesita** - Que informacion consume o produce
- **Integraciones** - Con que sistemas externos interactua (pagos, delivery, notificaciones, etc.)

### Paso 2: Buscar APIs existentes en Notion

Usar `/mv-dev:mv-docs` para buscar en Notion las APIs relevantes. Buscar por cada entidad y accion identificada:

```
Por cada entidad/accion del brief:
  1. Buscar en Notion: "[entidad] API", "[entidad] endpoint"
  2. Si hay resultados: leer la pagina y extraer endpoints, params, responses
  3. Si no hay resultados: buscar con terminos mas amplios
  4. Documentar: que existe, que falta, que necesita adaptacion
```

**Terminos de busqueda sugeridos:**

| Entidad del brief | Buscar en Notion |
|-------------------|-----------------|
| Cobertura/direcciones | "coverage API", "addresses endpoint", "zones" |
| Menu/comidas | "meals API", "menu endpoint", "catalog" |
| Pedidos | "orders API", "orders endpoint" |
| Planes/suscripciones | "plans API", "subscriptions endpoint" |
| Usuarios/perfiles | "users API", "auth endpoint", "profile" |
| Pagos | "payments API", "billing endpoint" |
| Delivery/entregas | "deliveries API", "tracking endpoint", "logistics" |
| Cupones/promos | "coupons API", "promotions endpoint" |

### Paso 3: Buscar tablas SQL relevantes

Usar `/mv-dev:mv-docs` para buscar tablas en Notion:

```
Por cada entidad del brief:
  1. Buscar en Notion: "[entidad] table", "[entidad] schema"
  2. Si hay resultados: extraer columnas principales, tipos, relaciones
  3. Marcar: que tablas existen, cuales necesitaria crear el proyecto
```

**Si el MCP server `mv-db-query` esta disponible**, complementar con queries reales:
- `list_tables` para ver todas las tablas disponibles
- `describe_table` para ver el schema de tablas relevantes

### Paso 4: Identificar gaps

Comparar lo que el brief necesita vs lo que ya existe:

- **APIs que existen y sirven tal cual** - Solo consumir
- **APIs que existen pero necesitan extension** - Nuevos endpoints o params
- **APIs que NO existen** - Hay que construirlas
- **Tablas que existen** - Solo consultar
- **Tablas que NO existen** - Hay que crearlas (o usar Supabase)
- **Servicios externos necesarios** - Pasarelas de pago, SMS, email, etc.

### Paso 5: Determinar tipo de proyecto

Basado en los gaps, recomendar:

| Situacion | Tipo de proyecto |
|-----------|-----------------|
| Solo consume APIs existentes, no crea datos | **Frontend** (Next.js + Vercel) |
| Necesita APIs nuevas pero sin UI | **Backend** (Express + Railway) |
| Necesita APIs nuevas + UI | **Monorepo** (Frontend + Backend + Shared) |
| Solo consulta datos existentes | **Frontend** con MCP server de DB |

## Output: Spec Tecnico

Generar el siguiente documento estructurado:

```yaml
# SPEC TECNICO - [Nombre del Proyecto]
# Generado por /mv-dev:discovery
# Fecha: [fecha]

## Resumen
# [1-2 lineas describiendo que hace el proyecto]

## Tipo de Proyecto Recomendado
# Frontend | Backend | Monorepo
# Razon: [por que este tipo]

## APIs Existentes Relevantes
# APIs de MV que el proyecto puede consumir directamente

- GET /api/v1/coverage/check
  # Verifica si una direccion tiene cobertura
  # Params: lat, lng, country_code
  # Response: { success, data: { covered: boolean, zone: string } }

- GET /api/v1/meals?country_code=PE&date=2025-01-15
  # Lista comidas del menu del dia
  # Params: country_code, date, category (optional)
  # Response: { success, data: Meal[], meta: { total, page } }

# [... mas endpoints encontrados]

## Tablas de BD Relevantes
# Tablas existentes que el proyecto consultara o usara como referencia

- coverage_zones: id, country_code, zone_name, polygon, active
  # Zonas de cobertura por pais

- meals: id, name, description, category, calories, country_code, available_date
  # Catalogo de comidas

# [... mas tablas encontradas]

## APIs que Hay que Construir
# Endpoints nuevos que NO existen y el proyecto necesita crear
# (vacio si el proyecto solo consume APIs existentes)

- POST /api/v1/waitlist
  # Registrar usuario en lista de espera cuando no hay cobertura
  # Body: { email, address, country_code }
  # Requiere: nueva tabla waitlist

## Tablas que Hay que Crear
# Tablas nuevas que el proyecto necesita
# (vacio si solo usa tablas existentes)

- waitlist: id, email, address, lat, lng, country_code, created_at
  # Lista de espera para usuarios sin cobertura

## Dependencias Externas
# Servicios de terceros que el proyecto necesita

- Google Maps API (geocoding de direcciones)
- [otros si aplica]

## Datos No Encontrados
# Cosas que el brief necesita pero no se encontraron en Notion ni en la BD
# El usuario debe validar con el equipo si existen en otro lugar

- [dato/API/tabla que no se encontro]
```

## Despues del Discovery

Informar al usuario:

1. **Resumen ejecutivo** - "Tu proyecto puede reutilizar X APIs y Y tablas existentes. Necesita construir Z endpoints nuevos."
2. **Recomendacion de tipo** - "Recomiendo un proyecto [tipo] porque [razon]."
3. **Siguiente paso** - "Cuando estes listo, ejecuta `/mv-dev:start-project` y usa este spec como referencia."
4. **Guardar el spec** - Preguntar al usuario si quiere guardar el spec como archivo (ej: `discovery-spec.yaml` o `docs/DISCOVERY.md`)

### Integracion con start-project

Si el usuario ejecuta `/mv-dev:start-project` despues del discovery:

- El tipo de proyecto ya esta recomendado (no preguntar de nuevo)
- Las APIs encontradas se pre-documentan en `docs/API.md`
- Las tablas encontradas se pre-documentan en `docs/TABLES.md`
- La logica de negocio del brief se documenta en `docs/BUSINESS_LOGIC.md`
- Los gaps identificados se agregan como TODOs en `docs/CHANGELOG.md`

## Requisitos

- **Notion (`NOTION_TOKEN`)**: Necesario para buscar APIs y tablas en la documentacion de MV
- **MCP server `mv-db-query`**: Opcional, mejora el discovery con schemas reales de la BD
- **Sin Notion**: El discovery funciona parcial - solo puede recomendar tipo de proyecto y estructura basandose en el brief, pero no puede validar APIs ni tablas existentes. Informar al usuario que configure el token para un discovery completo.

## Ejemplo completo

**Input del usuario:**
```
Quiero hacer una landing donde el usuario ponga su direccion y vea si tiene cobertura de MV.
Si la tiene, le muestre el menu del dia con precios.
Si no la tiene, que pueda dejar su email para avisarle cuando llegue MV a su zona.
```

**Proceso:**
1. Entidades: cobertura, direcciones, menu/comidas, lista de espera
2. Buscar en Notion: "coverage API" → encontrado, "meals API" → encontrado, "waitlist API" → no encontrado
3. Buscar tablas: "coverage_zones" → encontrada, "meals" → encontrada, "waitlist" → no encontrada
4. Gaps: necesita API/tabla de waitlist, necesita Google Maps para geocoding
5. Tipo: Frontend si waitlist se resuelve con Supabase, Monorepo si necesita backend propio

**Output resumido:**
```
SPEC TECNICO - mv-landing-cobertura

Tipo: Frontend (Next.js + Vercel + Supabase para waitlist)

APIs existentes: coverage/check, meals (por pais y fecha)
Tablas existentes: coverage_zones, meals, meal_prices
Hay que crear: tabla waitlist en Supabase
Dependencias: Google Maps Geocoding API
```
