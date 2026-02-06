---
description: Buscar documentacion de APIs y tablas SQL de Manzana Verde en Notion - fuente de verdad centralizada
---

# MV Docs - Documentacion Centralizada en Notion

Este skill es el **punto central de consulta** para toda la documentacion tecnica de Manzana Verde. Las APIs, tablas SQL, flujos de negocio y especificaciones tecnicas de MV estan documentadas en Notion dentro del mismo workspace configurado con `NOTION_TOKEN`.

**Usar este skill siempre que necesites:**
- Saber que endpoints tiene una API de MV
- Conocer la estructura de una tabla SQL
- Entender un flujo de negocio documentado
- Buscar especificaciones tecnicas de cualquier servicio de MV

## Requisito

Este skill necesita el `NOTION_TOKEN` configurado. Si no esta configurado, informar al usuario:

```
Para buscar documentacion en Notion necesitas configurar el token:

1. Ir a https://www.notion.so/my-integrations
2. Crear integracion "MV Claude Code" con permisos de Read content
3. Copiar el token (formato: ntn_...)
4. Agregar a tu ~/.zshrc:
   export NOTION_TOKEN="ntn_tu-token"
5. Ejecutar: source ~/.zshrc
6. Reiniciar Claude Code

Guia completa: ver SETUP.md del plugin (seccion 2)
```

## Como buscar documentacion

### Paso 1: Buscar en Notion

Usar el MCP server de Notion (herramienta `API-post-search`) para buscar la documentacion. Los terminos de busqueda deben coincidir con lo que el usuario necesita:

**Si el usuario pregunta sobre una API o endpoint:**
```
Buscar: "[nombre del servicio] API" o "[nombre del recurso] endpoint"
Ejemplo: "meals API", "orders endpoint", "auth API", "payments"
```

**Si el usuario pregunta sobre una tabla SQL:**
```
Buscar: "[nombre de la tabla]" o "[nombre de la tabla] schema" o "[nombre de la tabla] table"
Ejemplo: "meals table", "orders schema", "users", "deliveries"
```

**Si el usuario pregunta sobre un flujo o logica de negocio:**
```
Buscar: "[nombre del flujo]" o "[dominio] logic"
Ejemplo: "suscripcion flow", "delivery logic", "payment flow", "plan upgrade"
```

**Busqueda generica:**
```
Buscar: el termino que el usuario menciono directamente
```

### Paso 2: Leer la pagina encontrada

Una vez encontrada la pagina relevante en Notion, usar `API-get-block-children` para leer el contenido completo de la pagina. Si la pagina tiene sub-paginas, leer tambien las sub-paginas relevantes.

### Paso 3: Presentar la informacion al usuario

Presentar la documentacion encontrada de forma clara y estructurada:

1. **Nombre de la fuente** - Indicar de que pagina de Notion viene la info
2. **Contenido relevante** - Mostrar solo lo que el usuario necesita, no toda la pagina
3. **Contexto adicional** - Si hay relaciones con otros recursos (ej: "esta tabla se usa en el endpoint X"), mencionarlas

### Paso 4: Si no se encuentra documentacion

Si la busqueda en Notion no arroja resultados:

1. Informar al usuario que no se encontro documentacion para ese termino
2. Sugerir terminos de busqueda alternativos
3. Si el usuario tiene informacion local (schema de DB, codigo de API), ofrecerse a documentarlo en Notion usando el doc-agent

## Estrategia de busqueda

Para maximizar los resultados, seguir esta estrategia:

1. **Busqueda exacta primero** - Buscar el termino exacto que el usuario menciona
2. **Busqueda amplia si no hay resultados** - Buscar terminos mas genericos (ej: si "meals_nutritional_info table" no da resultados, buscar solo "meals" o "nutritional")
3. **Buscar en paginas de proyecto** - Las paginas de proyecto creadas con `/mv-dev:start-project` tienen secciones de API Documentation y Architecture que pueden tener la info
4. **Buscar por dominio** - Si el termino es muy especifico, buscar por el dominio general (ej: "logistics", "payments", "catalog", "users")

## Integracion con otros skills

Este skill es **referenciado por otros skills** como fuente de verdad:

- **`/mv-dev:mv-api-consumer`** - Cuando el usuario necesita saber los endpoints reales de una API, este skill busca la documentacion en Notion para obtener rutas, parametros, y responses actualizados.
- **`/mv-dev:mv-db-queries`** - Cuando el usuario necesita saber la estructura real de una tabla, este skill busca el schema documentado en Notion para obtener columnas, tipos, y relaciones actualizadas.
- **`/mv-dev:create-api`** - Antes de crear un endpoint, consultar si ya existe documentacion del recurso en Notion.
- **`/mv-dev:new-feature`** - Antes de implementar una feature, consultar la logica de negocio documentada en Notion.

## Ejemplos de uso

### Usuario pregunta por una API
```
Usuario: "que endpoints tiene la api de pedidos?"

1. Buscar en Notion: "orders API" o "pedidos API"
2. Leer pagina encontrada
3. Responder con los endpoints documentados:
   - GET /api/v1/orders - Listar pedidos
   - POST /api/v1/orders - Crear pedido
   - GET /api/v1/orders/:id - Detalle de pedido
   - PATCH /api/v1/orders/:id - Actualizar pedido
   - etc.
```

### Usuario pregunta por una tabla
```
Usuario: "como es la tabla de meals?"

1. Buscar en Notion: "meals table" o "meals schema"
2. Leer pagina encontrada
3. Responder con la estructura de la tabla:
   - id (INT, PK)
   - name (VARCHAR)
   - calories (INT)
   - etc.
```

### Usuario pregunta por logica de negocio
```
Usuario: "como funciona el flujo de suscripcion?"

1. Buscar en Notion: "suscripcion flow" o "subscription"
2. Leer pagina encontrada
3. Responder con el flujo documentado paso a paso
```

## Notas importantes

- **Notion es la fuente de verdad** - La documentacion en Notion siempre tiene prioridad sobre la documentacion hardcodeada en los skills
- **No inventar documentacion** - Si no existe en Notion, no inventar endpoints, tablas o flujos. Informar que no se encontro y sugerir documentarlo
- **Cache mental** - Si ya buscaste algo en Notion durante la sesion, no volver a buscarlo innecesariamente. Reutilizar la info que ya obtuviste
- **Documentacion viva** - La documentacion en Notion se actualiza frecuentemente. Siempre buscar la version mas reciente
