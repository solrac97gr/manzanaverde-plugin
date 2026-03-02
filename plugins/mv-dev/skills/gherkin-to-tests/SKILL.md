---
description: Leer archivos Gherkin (.feature) de features/ y generar tests ejecutables (Jest, React Testing Library, Playwright) segun el tipo de escenario. Activa el gherkin-test-generator-agent.
---

# Gherkin → Tests

Convierte los archivos `.feature` del directorio `features/` del proyecto en tests ejecutables siguiendo los estandares de Manzana Verde.

## Que hace este skill

1. **Descubre** todos los archivos `.feature` en `features/`
2. **Parsea** cada archivo y extrae los escenarios Gherkin
3. **Clasifica** cada escenario segun el tipo de test mas adecuado:
   - **Playwright E2E** → Flujos de usuario completos, navegacion entre paginas
   - **RTL Componente** → Interacciones UI, renderizado, estados de componente
   - **RTL + MSW Integracion** → Carga de datos desde API, manejo de errores de red
   - **Jest/Vitest Unit** → Funciones puras, hooks aislados, calculos, formateo
4. **Genera** los archivos de test con estructura MV estandar
5. **Verifica** cobertura de edge cases criticos de MV (plan vencido, sin stock, etc.)
6. **Reporta** los archivos creados, escenarios cubiertos y advertencias

## Estructura esperada del proyecto

```
features/
├── meals/
│   ├── meal-selection.feature
│   └── meal-selection-edge-cases.feature
├── subscriptions/
│   └── plan-selection.feature
├── auth/
│   └── login.feature
└── shared/
    └── common-scenarios.feature
```

Si no tienes archivos `.feature`, generarlos primero con:
- `/mv-dev:notion-gherkin` - desde documentacion de Notion
- O creandolos manualmente en formato Gherkin BDD

## Tests generados

Los tests se crean siguiendo la estructura de MV:

```
src/
├── features/
│   ├── meals/
│   │   └── components/
│   │       └── MealSelector.test.tsx    ← generado desde meal-selection.feature
│   └── subscriptions/
│       └── hooks/
│           └── usePlan.test.ts          ← generado desde plan-selection.feature
tests/
├── integration/
│   └── meal-loading.test.tsx            ← escenarios con API
└── e2e/
    └── order-flow.spec.ts               ← flujos E2E completos
```

## Como usar

Simplemente invoca el skill y el agente se encargara del resto:

```
/mv-dev:gherkin-to-tests
```

O pedirle directamente a Claude Code:

```
"genera los tests para los archivos .feature de este proyecto"
"convierte los gherkin de features/ en tests de jest y playwright"
"implementa los tests BDD del directorio features/"
```

## Requisitos

- Archivos `.feature` en el directorio `features/` del proyecto
- Stack de testing configurado (ver `/mv-dev:mv-testing`)
- Para tests E2E: Playwright instalado (`npx playwright install`)
- Para tests de integracion: MSW instalado (`npm install msw --save-dev`)

## Edge cases MV verificados

El agente verifica y genera tests para los edge cases criticos de Manzana Verde:

| Edge case | Test generado |
|---|---|
| Plan vencido | RTL: muestra mensaje de renovacion |
| Fuera de zona de cobertura | RTL: muestra aviso y lista de espera |
| Comida sin stock | RTL: item marcado como agotado |
| Hora limite superada | RTL: no permite modificar pedido del dia |
| Error de red / API caida | Integration: mensaje amigable + retry |
| Sesion expirada (JWT) | E2E: redirige al login |
| Multi-pais (PE, CO, MX, CL) | `it.each()` con los 4 paises |

## Siguiente paso

Despues de generar los tests, correr:

```bash
npm test -- --run          # ejecutar todos los tests
npm test -- --coverage     # verificar cobertura >= 80%
npx playwright test        # ejecutar tests E2E
```

Si los tests fallan porque los componentes no existen aun: es TDD correcto. Implementa los componentes para que los tests pasen.
