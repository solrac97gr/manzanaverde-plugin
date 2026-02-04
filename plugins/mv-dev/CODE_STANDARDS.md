# Estandares de Codigo - Manzana Verde

## TypeScript

- **Strict mode** obligatorio: `"strict": true` en tsconfig.json
- **Nunca** usar `any`. Usar tipos especificos o `unknown` con type guards
- Interfaces con prefijo descriptivo: `MealPlan`, `OrderResponse`, `UserProfile`
- Enums como `const` objects o union types (no TypeScript enums)
- Export con nombre (named exports), no default exports

```typescript
// Bien
export interface MealPlan {
  id: string;
  name: string;
  meals: Meal[];
  priceInCents: number;
}

// Mal
export default interface IMealPlan { ... }
```

## React / Next.js

- **Componentes funcionales** exclusivamente. No class components
- **Server Components** por defecto. `'use client'` solo cuando hay interactividad
- Props tipadas con interface dedicada
- Hooks custom para logica reutilizable (prefijo `use`)
- No hacer API calls directos en componentes. Usar hooks o services

```typescript
// Bien
interface MealCardProps {
  meal: Meal;
  onSelect: (id: string) => void;
}

export function MealCard({ meal, onSelect }: MealCardProps) {
  return (
    <div className="rounded-2xl bg-white shadow-sm border border-mv-gray-200 p-4">
      <h3 className="font-heading text-lg font-semibold text-mv-gray-900">
        {meal.name}
      </h3>
    </div>
  );
}
```

## Tailwind CSS

- Usar **design tokens de MV** (`bg-primary`, `text-mv-green`, etc.)
- **Nunca** hardcodear colores hex en clases
- Mobile-first: clases base para mobile, prefijos `sm:`, `md:`, `lg:` para responsive
- Componentes consistentes: `rounded-2xl` para cards, `rounded-xl` para botones

## API Backend

- Formato de respuesta estandar: `{ success, data, error, meta }`
- Validacion de input con **Zod** en cada endpoint
- Middleware `requireAuth` en rutas protegidas
- Try/catch con error logging estructurado
- Queries parametrizados (nunca concatenar strings SQL)

```typescript
// Bien
router.post('/orders', requireAuth, async (req, res) => {
  try {
    const body = createOrderSchema.parse(req.body);
    const order = await orderService.create(body, req.user.id);
    res.json({ success: true, data: order });
  } catch (error) {
    if (error instanceof ZodError) {
      res.status(400).json({ success: false, data: null, error: 'Datos invalidos' });
      return;
    }
    console.error('[OrderController] Error creating order:', error);
    res.status(500).json({ success: false, data: null, error: 'Error interno' });
  }
});
```

## Testing

- Cobertura minima: **80%** general, **100%** para hooks y utilidades
- Archivos de test colocados junto al source: `Component.test.tsx`
- Testing Library: queries centradas en el usuario (`getByRole`, `getByText`)
- Mocks con MSW para APIs, `jest.mock` para modulos
- E2E con Playwright para flujos criticos

## Git

- Branches: `feature/nombre`, `fix/nombre`, `hotfix/nombre`
- Commits: mensajes descriptivos en ingles, imperativo
- PRs: siempre a `develop`, nunca directo a `main`
- Code review obligatorio antes de merge
