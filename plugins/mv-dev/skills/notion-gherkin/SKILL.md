---
description: Obtener requerimientos desde Notion y generar archivos Gherkin (.feature) listos para BDD con todos los edge cases de MV
---

# Notion → Gherkin: Generacion de Archivos de Aceptacion

Genera archivos `.feature` en formato Gherkin a partir de la documentacion de requerimientos en Notion o en `docs/BUSINESS_LOGIC.md`. Los archivos generados siguen las convenciones BDD de Manzana Verde e incluyen edge cases especificos del negocio (multi-pais, plan vencido, sin cobertura, sin stock).

## Cuando usar

- Necesitas definir criterios de aceptacion para una feature nueva
- Quieres traducir un PRD o user story de Notion a tests de aceptacion
- El equipo de QA necesita `.feature` files para Cucumber o Playwright
- Quieres documentar el comportamiento esperado de una funcionalidad existente

## Paso 1: Identificar la fuente de requerimientos

Preguntar al usuario (si no lo especifico):

1. **Fuente:** ¿Los requerimientos estan en Notion o en `docs/BUSINESS_LOGIC.md`?
2. **Funcionalidad:** ¿Para que feature o modulo se generan los escenarios?
3. **Alcance:** ¿Se incluyen edge cases de todos los paises (PE, CO, MX, CL)?

Si la fuente es Notion, verificar que `NOTION_TOKEN` este configurado antes de continuar.

## Paso 2: Obtener los requerimientos

### Si la fuente es Notion

Usar el MCP server de Notion para buscar la documentacion:

```
Terminos de busqueda sugeridos:
  "[funcionalidad] PRD"
  "[funcionalidad] requerimientos"
  "[funcionalidad] user stories"
  "[funcionalidad] criterios aceptacion"
```

Leer la pagina encontrada y extraer:
- Descripcion de la funcionalidad
- Reglas de negocio y restricciones
- Flujos de usuario (happy path + errores)
- Criterios de aceptacion definidos

Mostrar un resumen al usuario y pedir confirmacion antes de generar.

### Si la fuente es docs/

```
1. Leer docs/BUSINESS_LOGIC.md
2. Identificar las reglas y flujos relevantes para la funcionalidad solicitada
3. Proceder directamente a generar
```

## Paso 3: Mapear requerimientos a escenarios

Identificar y organizar antes de escribir:

| Que encontre | Que genero |
|--------------|------------|
| Flujo principal exitoso | `Escenario:` happy path |
| Validacion o restriccion | `Escenario:` con datos invalidos |
| Datos que varían por pais/moneda | `Esquema del escenario:` + `Ejemplos:` |
| Contexto compartido entre escenarios | `Antecedente:` |
| Feature completa con actor | `Caracteristica:` con `Como/Quiero/Para que` |

**Edge cases de MV a evaluar siempre:**
- Plan vencido / pausado
- Direccion fuera de zona de cobertura
- Comida sin stock
- Hora limite de pedido superada
- Error de red / servicio no disponible
- Sesion expirada (JWT)
- Cupon o descuento invalido

## Paso 4: Crear los archivos `.feature`

Crear la carpeta `features/` si no existe. Estructura de archivos:

```
features/
├── [dominio]/
│   ├── [funcionalidad].feature              # Flujos principales
│   └── [funcionalidad]-edge-cases.feature   # Casos borde y errores
└── shared/
    └── [escenarios-compartidos].feature
```

**Dominios comunes de MV:** `meals/`, `subscriptions/`, `orders/`, `delivery/`, `auth/`, `payments/`

**Cabecera obligatoria en cada archivo:**

```gherkin
# language: es
# Generado por: Notion Gherkin Agent - Manzana Verde
# Fuente: [Nombre de la pagina Notion o docs/BUSINESS_LOGIC.md]
# Fecha: [YYYY-MM-DD]
# Paises: PE, CO, MX, CL
```

**Template de feature completa:**

```gherkin
# language: es
# Generado por: Notion Gherkin Agent - Manzana Verde
# Fuente: [fuente]
# Fecha: [YYYY-MM-DD]
# Paises: PE, CO, MX, CL

Caracteristica: [Nombre descriptivo de la funcionalidad]
  Como [tipo de usuario de MV]
  Quiero [accion o funcionalidad]
  Para que [beneficio de negocio]

  Antecedente:
    Dado que el usuario esta autenticado en la plataforma MV
    Y el usuario tiene un plan activo

  Escenario: [Happy path]
    Dado que [estado inicial del sistema]
    Cuando [el usuario realiza la accion principal]
    Entonces [resultado esperado]
    Y [condicion adicional de exito]

  Escenario: [Caso de validacion]
    Dado que [estado inicial]
    Cuando [el usuario realiza una accion invalida]
    Entonces [se muestra el error especifico]
    Y [el sistema no ejecuta la accion no deseada]

  Esquema del escenario: [Escenario que varia por pais]
    Dado que el usuario esta registrado en el pais "<pais>"
    Cuando [accion dependiente del pais]
    Entonces [resultado] en moneda "<moneda>"

    Ejemplos:
      | pais | moneda |
      | PE   | PEN    |
      | CO   | COP    |
      | MX   | MXN    |
      | CL   | CLP    |
```

## Paso 5: Reportar resultados al usuario

Despues de generar todos los archivos, informar:

```
Archivos Gherkin generados:
  - features/[dominio]/[funcionalidad].feature  ([N] escenarios)
  - features/[dominio]/[funcionalidad]-edge-cases.feature  ([N] escenarios)

Total: [N] archivos, [N] escenarios

Edge cases MV cubiertos:
  ✅ / ❌  Plan vencido
  ✅ / ❌  Zona sin cobertura
  ✅ / ❌  Sin stock
  ✅ / ❌  Error de red
  ✅ / ❌  Multi-pais (PE, CO, MX, CL)

Requiere revision manual:
  ⚠️  [Item ambiguo o no documentado]

Siguiente paso sugerido:
  - Integrar con Playwright: /mv-dev:mv-testing
  - Subir a Notion: /mv-dev:mv-docs
```

## Reglas

1. **No inventar requerimientos** - Solo usar lo documentado en Notion o `docs/`
2. **Siempre incluir la cabecera** con fuente y fecha en cada `.feature`
3. **Siempre evaluar los edge cases de MV** aunque no esten en los requerimientos
4. **Escenarios especificos** - No usar nombres vagos como "Escenario: Funciona bien"
5. **Un dominio por carpeta** - No mezclar `meals/` y `subscriptions/` en el mismo `.feature`
6. **Multi-pais con Esquema** - Si hay datos de pais/moneda, usar `Esquema del escenario:` con los 4 paises de MV
7. **Confirmar antes de generar** cuando la fuente es Notion (mostrar resumen primero)
8. **Separar happy path de edge cases** en archivos distintos para facilitar mantenimiento

## Requisitos

- `NOTION_TOKEN` configurado para obtener requerimientos desde Notion (opcional si se usa `docs/`)
- Si `NOTION_TOKEN` no esta configurado, los requerimientos pueden venir de `docs/BUSINESS_LOGIC.md` o del usuario directamente

## Sin Notion

Si `NOTION_TOKEN` no esta configurado:

```
Para obtener requerimientos desde Notion necesitas configurar el token:

1. Ir a https://www.notion.so/my-integrations
2. Crear integracion "MV Claude Code" con permisos de Read content
3. Copiar el token (formato: ntn_...)
4. Agregar la variable de entorno:
   Mac/Linux  → ~/.zshrc:    export NOTION_TOKEN="ntn_tu-token"
   Windows PS → $PROFILE:    $env:NOTION_TOKEN = "ntn_tu-token"
5. Recargar terminal (source ~/.zshrc | reiniciar PowerShell)
6. Reiniciar Claude Code

Alternativa sin token: puedo generar los Gherkin desde docs/BUSINESS_LOGIC.md
o desde los requerimientos que me describas directamente en el chat.
```
