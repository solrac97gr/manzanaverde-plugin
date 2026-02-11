---
description: Genera un archivo Gherkin BDD desde una feature documentada en Notion
---

# Crear Feature File desde Notion

Busca una feature documentada en Notion, extrae los requisitos y genera un archivo Gherkin (.feature) con escenarios BDD/Cucumber.

## Paso 1: Buscar la feature en Notion

Usa el MCP de Notion para buscar la página de la feature:

```
Buscar en Notion: "[nombre de la feature]"
```

**Ejemplo:** "Crear modulo Pedido tienda – Menú diario para backoffice"

Si hay múltiples resultados, pregunta al usuario cuál es la correcta.

## Paso 2: Leer el contenido de la feature

Una vez identificada la página correcta:

1. Leer el contenido completo de la página
2. Leer las sub-páginas si existen (requisitos, casos de uso, etc.)
3. Extraer:
   - **Descripción**: Qué hace la feature
   - **Actores**: Quién usa la feature (ej: admin, chef, usuario)
   - **Requisitos funcionales**: Qué debe hacer el sistema
   - **Casos de uso**: Flujos principales
   - **Criterios de aceptación**: Condiciones de éxito
   - **Restricciones**: Validaciones, límites

## Paso 3: Generar el archivo Gherkin

Crear archivo en: `features/[nombre-normalizado].feature`

**Nombre normalizado:** kebab-case, sin acentos, sin espacios
- "Crear modulo Pedido tienda" → `crear-modulo-pedido-tienda.feature`

### Estructura del archivo Gherkin:

```gherkin
# language: es
Característica: [Nombre de la Feature]
  Como [actor]
  Quiero [objetivo]
  Para [beneficio]

  Antecedentes:
    Dado que estoy autenticado como [actor]
    Y tengo permisos de [rol]

  Escenario: [Caso de uso principal]
    Dado que [precondición]
    Cuando [acción del usuario]
    Entonces [resultado esperado]
    Y [verificaciones adicionales]

  Escenario: [Caso de uso alternativo]
    Dado que [precondición]
    Cuando [acción del usuario]
    Entonces [resultado esperado]

  Escenario: [Manejo de errores]
    Dado que [precondición]
    Cuando [acción inválida]
    Entonces [mensaje de error]
    Y [estado del sistema no cambia]

  Esquema del escenario: [Casos múltiples con datos]
    Dado que <precondición>
    Cuando <acción>
    Entonces <resultado>

    Ejemplos:
      | campo1   | campo2   | resultado    |
      | valor1   | valor2   | esperado1    |
      | valor3   | valor4   | esperado2    |
```

## Paso 4: Reglas para generar escenarios

### De Requisitos Funcionales → Escenarios

Para cada requisito funcional, crear al menos:
1. **Escenario happy path**: Flujo exitoso
2. **Escenario de validación**: Datos inválidos
3. **Escenario de permisos**: Usuario sin acceso

### De Casos de Uso → Escenarios

Cada caso de uso documentado → 1 escenario Gherkin

### De Criterios de Aceptación → Verificaciones

Cada criterio → 1 línea `Entonces` o `Y`

### Ejemplos de conversión:

**Requisito:** "El admin puede crear un menú diario con fecha y productos"

**→ Escenario:**
```gherkin
Escenario: Admin crea menú diario exitosamente
  Dado que soy un administrador autenticado
  Y estoy en la página de menús
  Cuando selecciono la fecha "2026-02-15"
  Y agrego los productos "Ensalada César, Pollo al horno, Arroz integral"
  Y hago clic en "Guardar menú"
  Entonces veo el mensaje "Menú creado exitosamente"
  Y el menú aparece en la lista de menús
  Y la fecha es "2026-02-15"
```

**Validación:** "La fecha no puede ser pasada"

**→ Escenario:**
```gherkin
Escenario: Error al crear menú con fecha pasada
  Dado que soy un administrador autenticado
  Y estoy en la página de menús
  Cuando selecciono la fecha "2026-01-01"
  Y hago clic en "Guardar menú"
  Entonces veo el error "La fecha no puede ser pasada"
  Y el menú no se crea
```

## Paso 5: Crear el archivo

```
Write archivo: features/[nombre-normalizado].feature
```

Mostrar al usuario:
- ✅ Ruta del archivo creado
- 📝 Número de escenarios generados
- 🔍 Resumen de lo que cubre el archivo

## Paso 6: Sugerencias adicionales

Después de crear el archivo, sugerir:

1. **Revisar y ajustar**: El archivo es un punto de partida
2. **Agregar más escenarios**: Edge cases específicos
3. **Implementar los steps**: Crear step definitions en el framework de testing
4. **Vincular con código**: Mantener el .feature actualizado con el desarrollo

## Ejemplo completo

**Input:** `create-feature-file "Crear modulo Pedido tienda – Menú diario para backoffice"`

**Output:**
```
✅ Archivo creado: features/crear-modulo-pedido-tienda-menu-diario.feature
📝 6 escenarios generados:
   - Admin crea menú diario exitosamente
   - Admin edita menú existente
   - Error al crear menú con fecha pasada
   - Error sin productos seleccionados
   - Admin visualiza menús por rango de fechas
   - Admin elimina menú no utilizado

🔍 Cobertura:
   - Casos de uso principales: 3/3
   - Validaciones: 2/2
   - Permisos: Verificado para rol admin
```

## Notas importantes

- **Idioma:** Gherkin en español (`# language: es`)
- **Nombres descriptivos:** Los escenarios deben ser auto-explicativos
- **Dado/Cuando/Entonces:** Seguir estrictamente este orden
- **Verificaciones múltiples:** Usar `Y` para verificaciones adicionales
- **Tablas de datos:** Usar `Esquema del escenario` para casos similares con datos diferentes
- **Comentarios:** Agregar `#` para explicar contexto complejo
- **Tags:** Usar `@tag` antes del escenario para categorizar (ej: `@smoke`, `@regression`, `@admin`)

## Configuración del proyecto

Asegurarse que el proyecto tenga:

```
features/
├── [feature-name].feature    # Archivos Gherkin
└── step_definitions/          # Implementaciones de pasos
    └── [feature-name]Steps.ts
```

Framework recomendado: **Cucumber.js** o **Jest-Cucumber**
