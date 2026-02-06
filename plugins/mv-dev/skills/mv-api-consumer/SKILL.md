---
description: Como consumir correctamente las APIs de Manzana Verde - autenticacion, endpoints, manejo de errores y paginacion
---

# Consumo de APIs de Manzana Verde

Guia completa para consumir las APIs de MV de forma correcta y segura.

## URL Base

```
Staging: ${MV_STAGING_API_URL}  (variable de entorno)
Produccion: NUNCA usar directamente
```

**IMPORTANTE:** Siempre usar la URL de staging para desarrollo y testing.

## Autenticacion

Todas las APIs protegidas usan JWT Bearer tokens.

### Flujo de autenticacion

```typescript
// 1. Obtener token
const loginResponse = await fetch(`${API_URL}/api/v1/auth/login`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password }),
});
const { data: { accessToken, refreshToken } } = await loginResponse.json();

// 2. Usar token en requests
const response = await fetch(`${API_URL}/api/v1/meals`, {
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json',
  },
});

// 3. Refrescar token cuando expire (401)
const refreshResponse = await fetch(`${API_URL}/api/v1/auth/refresh`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ refreshToken }),
});
```

### Headers estandar

```typescript
const headers = {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-Client-Version': '1.0.0',
  'X-Platform': 'web',
};
```

## Formato de Respuesta

Todas las APIs retornan este formato:

```typescript
interface ApiResponse<T> {
  success: boolean;
  data: T;
  error?: string;
  meta?: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}
```

## Paginacion

```typescript
// Request
GET /api/v1/meals?page=1&limit=20

// Response
{
  "success": true,
  "data": [...],
  "meta": {
    "total": 150,
    "page": 1,
    "limit": 20,
    "totalPages": 8
  }
}
```

### Hook de paginacion recomendado

```typescript
function usePagination<T>(endpoint: string) {
  const [page, setPage] = useState(1);
  const [data, setData] = useState<T[]>([]);
  const [meta, setMeta] = useState<PaginationMeta | null>(null);
  const [loading, setLoading] = useState(false);

  const fetchPage = async (pageNum: number) => {
    setLoading(true);
    const response = await apiClient.get<ApiResponse<T[]>>(
      `${endpoint}?page=${pageNum}&limit=20`
    );
    setData(response.data);
    setMeta(response.meta ?? null);
    setPage(pageNum);
    setLoading(false);
  };

  return { data, meta, page, loading, fetchPage, setPage };
}
```

## Manejo de Errores

```typescript
async function apiRequest<T>(url: string, options?: RequestInit): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(url, {
      ...options,
      headers: { ...getDefaultHeaders(), ...options?.headers },
    });

    if (response.status === 401) {
      // Intentar refresh token
      const refreshed = await refreshAccessToken();
      if (refreshed) return apiRequest(url, options); // Reintentar
      throw new Error('Session expirada');
    }

    if (response.status === 429) {
      // Rate limited - esperar y reintentar
      const retryAfter = response.headers.get('Retry-After') ?? '5';
      await new Promise(resolve => setTimeout(resolve, parseInt(retryAfter) * 1000));
      return apiRequest(url, options);
    }

    const data = await response.json();

    if (!response.ok) {
      console.error(`[API] Error ${response.status}:`, data.error);
      return { success: false, data: null as T, error: data.error ?? 'Error desconocido' };
    }

    return data;
  } catch (error) {
    console.error('[API] Network error:', error);
    return { success: false, data: null as T, error: 'Error de conexion' };
  }
}
```

## Documentacion de APIs en Notion (Fuente de Verdad)

**IMPORTANTE:** La documentacion completa y actualizada de todas las APIs de MV esta en Notion. Antes de asumir endpoints, parametros o responses, **usar `/mv-dev:mv-docs` para buscar la documentacion real** en Notion. Las APIs documentadas abajo son una referencia general, pero Notion siempre tiene la version mas actualizada.

## Dominios de API Principales (Referencia General)

| Dominio | Base Path | Descripcion |
|---------|-----------|-------------|
| Meals | `/api/v1/meals` | Catalogo de comidas |
| Orders | `/api/v1/orders` | Pedidos |
| Users | `/api/v1/users` | Perfiles de usuario |
| Plans | `/api/v1/plans` | Planes de suscripcion |
| Deliveries | `/api/v1/deliveries` | Entregas y tracking |
| Auth | `/api/v1/auth` | Login, refresh, logout |
| Payments | `/api/v1/payments` | Metodos de pago |
| Addresses | `/api/v1/addresses` | Direcciones de entrega |

> Para ver los endpoints detallados, parametros, y responses actualizados de cualquiera de estos dominios, usar `/mv-dev:mv-docs` y buscar en Notion.

## Operaciones comunes

### GET - Listar recursos
```typescript
const meals = await apiRequest<Meal[]>(`${API_URL}/api/v1/meals?page=1&limit=20`);
```

### GET - Obtener recurso individual
```typescript
const meal = await apiRequest<Meal>(`${API_URL}/api/v1/meals/${mealId}`);
```

### POST - Crear recurso
```typescript
const newOrder = await apiRequest<Order>(`${API_URL}/api/v1/orders`, {
  method: 'POST',
  body: JSON.stringify({ planId, deliveryAddressId, meals: selectedMealIds }),
});
```

### PATCH - Actualizar recurso
```typescript
const updated = await apiRequest<UserProfile>(`${API_URL}/api/v1/users/${userId}`, {
  method: 'PATCH',
  body: JSON.stringify({ name: 'Nuevo nombre' }),
});
```

## Cliente API recomendado

Para proyectos Next.js, crear un cliente API centralizado en `lib/api.ts`:

```typescript
const API_URL = process.env.NEXT_PUBLIC_API_URL ?? process.env.MV_STAGING_API_URL;

export const api = {
  get: <T>(path: string) => apiRequest<T>(`${API_URL}${path}`),
  post: <T>(path: string, body: unknown) => apiRequest<T>(`${API_URL}${path}`, {
    method: 'POST',
    body: JSON.stringify(body),
  }),
  patch: <T>(path: string, body: unknown) => apiRequest<T>(`${API_URL}${path}`, {
    method: 'PATCH',
    body: JSON.stringify(body),
  }),
  delete: <T>(path: string) => apiRequest<T>(`${API_URL}${path}`, { method: 'DELETE' }),
};
```

## Alternativa: MCP Server de Base de Datos

Para necesidades de solo lectura (reportes, dashboards), puedes usar directamente el MCP server `mv-db-query` en lugar de consumir la API. Esto es mas rapido para consultas ad-hoc.

## Skill relacionado

- `/mv-dev:mv-docs` - Buscar documentacion actualizada de APIs y tablas en Notion (fuente de verdad)
