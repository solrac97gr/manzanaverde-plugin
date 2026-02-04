---
description: Scaffold completo de una nueva feature en un proyecto de Manzana Verde con enfoque TDD
---

# Nueva Feature en Manzana Verde

Crea una feature completa siguiendo el patron TDD de MV: tipos primero, luego tests, luego implementacion.

## Paso 1: Preguntar al usuario

1. **Nombre de la feature** - Ej: `meal-selector`, `delivery-tracker`, `plan-comparison`
2. **Descripcion** - Que hace esta feature
3. **Tipo:**
   - **Frontend** - Solo componentes UI, hooks, servicios
   - **Backend** - Solo endpoints API, servicios, modelos
   - **Full-stack** - Ambos + tipos compartidos
4. **Necesita API?** - Si necesita consumir o crear endpoints
5. **Necesita base de datos?** - Si necesita nuevas tablas o queries

## Paso 2: Crear estructura de la feature

### Frontend Feature

```
src/features/[feature-name]/
├── components/
│   ├── [FeatureName].tsx         # Componente principal
│   ├── [FeatureName].test.tsx    # Tests del componente
│   └── [SubComponent].tsx        # Sub-componentes si necesario
├── hooks/
│   ├── use[FeatureName].ts       # Hook principal
│   └── use[FeatureName].test.ts  # Tests del hook
├── services/
│   ├── [featureName]Service.ts   # Llamadas API
│   └── [featureName]Service.test.ts
├── types/
│   └── index.ts                  # Tipos de la feature
└── index.ts                      # Public API (re-exports)
```

### Backend Feature

```
src/features/[feature-name]/
├── routes/
│   └── [featureName]Routes.ts    # Definicion de rutas
├── controllers/
│   ├── [featureName]Controller.ts
│   └── [featureName]Controller.test.ts
├── services/
│   ├── [featureName]Service.ts
│   └── [featureName]Service.test.ts
├── models/
│   └── [featureName]Model.ts     # Si necesita BD
├── schemas/
│   └── [featureName]Schema.ts    # Validacion con Zod
├── types/
│   └── index.ts
└── index.ts
```

## Paso 3: Flujo TDD

### 3.1 Tipos primero

Crear los tipos TypeScript de la feature:

```typescript
// types/index.ts
export interface [FeatureName]Props {
  // props del componente principal
}

export interface [FeatureName]Data {
  // datos que maneja la feature
}

export interface [FeatureName]State {
  data: [FeatureName]Data | null;
  loading: boolean;
  error: string | null;
}
```

### 3.2 Tests primero (RED)

Escribir tests que fallen:

```typescript
// components/[FeatureName].test.tsx
import { render, screen } from '@testing-library/react';
import { [FeatureName] } from './[FeatureName]';

describe('[FeatureName]', () => {
  it('renderiza el estado de carga', () => {
    render(<[FeatureName] />);
    expect(screen.getByText(/cargando/i)).toBeInTheDocument();
  });

  it('muestra los datos correctamente', () => {
    // Test con datos mock
  });

  it('muestra error cuando falla', () => {
    // Test de error
  });

  // Edge cases de MV
  it('maneja session expirada', () => {});
  it('maneja datos vacios', () => {});
});
```

### 3.3 Implementacion (GREEN)

Implementar el minimo codigo para que los tests pasen.

### 3.4 Refactor (BLUE)

Mejorar el codigo manteniendo los tests verdes.

## Paso 4: Integrar la feature

### Frontend

1. Agregar ruta en `src/app/` si es una pagina nueva
2. O importar componente donde se necesite
3. Actualizar el `index.ts` de la feature con todos los exports

### Backend

1. Registrar rutas en `src/routes/index.ts`:
```typescript
import { [featureName]Routes } from '@/features/[feature-name]';
router.use('/api/v1/[feature-name]', [featureName]Routes);
```

## Paso 5: Documentar

Crear un comentario en la parte superior del archivo principal:

```typescript
/**
 * Feature: [FeatureName]
 * Descripcion: [Descripcion de la feature]
 * Autor: [Nombre via Claude Code]
 * Fecha: [Fecha actual]
 *
 * Endpoints (si backend):
 * - GET /api/v1/[feature-name] - Listar
 * - POST /api/v1/[feature-name] - Crear
 *
 * Componentes (si frontend):
 * - [FeatureName] - Componente principal
 * - use[FeatureName] - Hook de datos
 */
```

## Paso 6: PR Description

Generar template de PR:

```markdown
## Feature: [FeatureName]

### Que hace
[Descripcion]

### Archivos creados/modificados
- `src/features/[feature-name]/...`

### Testing
- [ ] Unit tests pasan
- [ ] Coverage >= 80%
- [ ] Tests de edge cases MV incluidos

### Screenshots (si UI)
[Agregar screenshots]
```
