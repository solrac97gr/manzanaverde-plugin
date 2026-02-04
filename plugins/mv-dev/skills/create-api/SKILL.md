---
description: Crear un nuevo endpoint de API Express siguiendo los patrones de Manzana Verde con validacion Zod y response wrapper
---

# Nuevo Endpoint API de Manzana Verde

Crea un endpoint Express completo con validacion, autenticacion y el formato de respuesta estandar de MV.

## Paso 1: Preguntar al usuario

1. **Recurso** - Ej: `meals`, `orders`, `deliveries`
2. **Operacion:**
   - GET (listar) - `GET /api/v1/[recurso]`
   - GET (detalle) - `GET /api/v1/[recurso]/:id`
   - POST (crear) - `POST /api/v1/[recurso]`
   - PATCH (actualizar) - `PATCH /api/v1/[recurso]/:id`
   - DELETE (eliminar) - `DELETE /api/v1/[recurso]/:id`
3. **Necesita autenticacion?** - Si/No
4. **Descripcion** - Que hace el endpoint
5. **Campos del body** (si POST/PATCH) - Nombre, tipo, requerido?

## Paso 2: Crear archivos

### Schema de validacion (Zod)

```typescript
// schemas/[recurso]Schema.ts
import { z } from 'zod';

export const create[Recurso]Schema = z.object({
  name: z.string().min(1, 'Nombre es requerido').max(200),
  description: z.string().optional(),
  // ... otros campos
});

export const update[Recurso]Schema = create[Recurso]Schema.partial();

export const query[Recurso]Schema = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().positive().max(100).default(20),
  search: z.string().optional(),
  sort: z.enum(['created_at', 'name', 'price']).default('created_at'),
  order: z.enum(['asc', 'desc']).default('desc'),
});

export type Create[Recurso]Input = z.infer<typeof create[Recurso]Schema>;
export type Update[Recurso]Input = z.infer<typeof update[Recurso]Schema>;
export type Query[Recurso]Input = z.infer<typeof query[Recurso]Schema>;
```

### Types

```typescript
// types/[recurso].ts
export interface [Recurso] {
  id: string;
  // ... campos
  createdAt: string;
  updatedAt: string;
}
```

### Service

```typescript
// services/[recurso]Service.ts
import { db } from '@/config/database';
import type { Create[Recurso]Input, Query[Recurso]Input } from '@/schemas/[recurso]Schema';
import type { [Recurso] } from '@/types/[recurso]';

export const [recurso]Service = {
  async list(query: Query[Recurso]Input): Promise<{ data: [Recurso][]; total: number }> {
    const offset = (query.page - 1) * query.limit;

    const [rows] = await db.execute(
      `SELECT * FROM [recurso]s
       WHERE deleted_at IS NULL
       ORDER BY ?? ${query.order === 'asc' ? 'ASC' : 'DESC'}
       LIMIT ? OFFSET ?`,
      [query.sort, query.limit, offset]
    );

    const [[{ total }]] = await db.execute(
      'SELECT COUNT(*) as total FROM [recurso]s WHERE deleted_at IS NULL'
    );

    return { data: rows as [Recurso][], total: (total as { total: number }).total };
  },

  async getById(id: string): Promise<[Recurso] | null> {
    const [rows] = await db.execute(
      'SELECT * FROM [recurso]s WHERE id = ? AND deleted_at IS NULL LIMIT 1',
      [id]
    );
    const results = rows as [Recurso][];
    return results[0] ?? null;
  },

  async create(input: Create[Recurso]Input): Promise<[Recurso]> {
    const id = crypto.randomUUID();
    await db.execute(
      'INSERT INTO [recurso]s (id, name, created_at, updated_at) VALUES (?, ?, NOW(), NOW())',
      [id, input.name]
    );
    return this.getById(id) as Promise<[Recurso]>;
  },

  async update(id: string, input: Partial<Create[Recurso]Input>): Promise<[Recurso] | null> {
    const existing = await this.getById(id);
    if (!existing) return null;

    const fields = Object.entries(input)
      .filter(([, v]) => v !== undefined)
      .map(([k]) => `${k} = ?`);
    const values = Object.values(input).filter(v => v !== undefined);

    if (fields.length > 0) {
      await db.execute(
        `UPDATE [recurso]s SET ${fields.join(', ')}, updated_at = NOW() WHERE id = ?`,
        [...values, id]
      );
    }

    return this.getById(id);
  },
};
```

### Controller

```typescript
// controllers/[recurso]Controller.ts
import type { Request, Response } from 'express';
import { [recurso]Service } from '@/services/[recurso]Service';
import { create[Recurso]Schema, query[Recurso]Schema } from '@/schemas/[recurso]Schema';
import { ZodError } from 'zod';

export const [recurso]Controller = {
  async list(req: Request, res: Response): Promise<void> {
    try {
      const query = query[Recurso]Schema.parse(req.query);
      const { data, total } = await [recurso]Service.list(query);

      res.json({
        success: true,
        data,
        meta: {
          total,
          page: query.page,
          limit: query.limit,
          totalPages: Math.ceil(total / query.limit),
        },
      });
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json({
          success: false,
          data: null,
          error: 'Parametros de consulta invalidos',
        });
        return;
      }
      console.error('[${Recurso}Controller] Error listing:', error);
      res.status(500).json({ success: false, data: null, error: 'Error interno' });
    }
  },

  async getById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const item = await [recurso]Service.getById(id);

      if (!item) {
        res.status(404).json({ success: false, data: null, error: 'No encontrado' });
        return;
      }

      res.json({ success: true, data: item });
    } catch (error) {
      console.error('[${Recurso}Controller] Error getting by id:', error);
      res.status(500).json({ success: false, data: null, error: 'Error interno' });
    }
  },

  async create(req: Request, res: Response): Promise<void> {
    try {
      const input = create[Recurso]Schema.parse(req.body);
      const item = await [recurso]Service.create(input);

      res.status(201).json({ success: true, data: item });
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json({
          success: false,
          data: null,
          error: 'Datos invalidos: ' + error.errors.map(e => e.message).join(', '),
        });
        return;
      }
      console.error('[${Recurso}Controller] Error creating:', error);
      res.status(500).json({ success: false, data: null, error: 'Error interno' });
    }
  },
};
```

### Routes

```typescript
// routes/[recurso]Routes.ts
import { Router } from 'express';
import { [recurso]Controller } from '@/controllers/[recurso]Controller';
import { requireAuth } from '@/middleware/auth';

const router = Router();

// Rutas publicas (si aplica)
// router.get('/', [recurso]Controller.list);

// Rutas protegidas
router.get('/', requireAuth, [recurso]Controller.list);
router.get('/:id', requireAuth, [recurso]Controller.getById);
router.post('/', requireAuth, [recurso]Controller.create);

export const [recurso]Routes = router;
```

### Registrar en routes/index.ts

```typescript
import { [recurso]Routes } from './[recurso]Routes';

router.use('/api/v1/[recurso]s', [recurso]Routes);
```

## Paso 3: Tests

```typescript
// controllers/[recurso]Controller.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '@/app';

describe('[Recurso] API', () => {
  describe('GET /api/v1/[recurso]s', () => {
    it('retorna lista paginada con formato MV', async () => {
      const res = await request(app)
        .get('/api/v1/[recurso]s?page=1&limit=10')
        .set('Authorization', 'Bearer test-token');

      expect(res.status).toBe(200);
      expect(res.body).toMatchObject({
        success: true,
        data: expect.any(Array),
        meta: {
          total: expect.any(Number),
          page: 1,
          limit: 10,
          totalPages: expect.any(Number),
        },
      });
    });

    it('retorna 401 sin token', async () => {
      const res = await request(app).get('/api/v1/[recurso]s');
      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/v1/[recurso]s', () => {
    it('crea recurso con datos validos', async () => {
      const res = await request(app)
        .post('/api/v1/[recurso]s')
        .set('Authorization', 'Bearer test-token')
        .send({ name: 'Test item' });

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
    });

    it('retorna 400 con datos invalidos', async () => {
      const res = await request(app)
        .post('/api/v1/[recurso]s')
        .set('Authorization', 'Bearer test-token')
        .send({});

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
    });
  });
});
```

## Checklist del Endpoint

- [ ] Schema Zod para validacion de input
- [ ] Service con queries parametrizados (nunca concatenar strings)
- [ ] Controller con try/catch y formato de respuesta MV
- [ ] Middleware de auth en rutas protegidas
- [ ] Rutas registradas en el router principal
- [ ] Tests para happy path y error cases
- [ ] Paginacion en endpoints de listado
- [ ] No exponer datos sensibles en respuestas
