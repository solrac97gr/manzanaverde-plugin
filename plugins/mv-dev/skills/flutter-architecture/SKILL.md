---
description: Guia de arquitectura para proyectos Flutter de MV - define o revisa la estructura del proyecto con opciones explicadas para personas no tecnicas
---

# Flutter Architecture - Arquitectura de Proyectos Flutter

Defines o revisa la arquitectura de un proyecto Flutter de Manzana Verde, asegurandote de que sea escalable, mantenible y consistente con los estandares del equipo.

---

## Cuando usar este skill

- Cuando se va a iniciar un nuevo proyecto Flutter
- Cuando el equipo siente que el proyecto esta creciendo y se esta volviendo dificil de mantener
- Cuando hay dudas sobre donde poner un archivo nuevo
- Cuando hay inconsistencias en como esta organizado el codigo
- Cuando se va a hacer una revision de arquitectura

---

## Paso 1: Entender el contexto del proyecto

**Antes de recomendar nada, hacer las siguientes preguntas:**

### Pregunta 1: Estado del proyecto

Mostrar opciones al usuario:

```
¿En que etapa esta tu proyecto Flutter?

A) Proyecto nuevo - aun no existe codigo
B) Proyecto existente pequeño - menos de 5 pantallas, funciona bien
C) Proyecto existente mediano - 5-15 pantallas, algunas partes se estan complicando
D) Proyecto existente grande - mas de 15 pantallas, es dificil agregar cosas nuevas sin romper otras
```

### Pregunta 2: Tipo de app

```
¿Que tipo de aplicacion es?

A) App de consumo (usuarios finales, flujos simples, principalmente mostrar informacion)
B) App transaccional (usuarios hacen pedidos, pagos, reservas)
C) App operativa interna (para el equipo de MV, dashboards, gestion)
D) Combinacion de las anteriores - describir cual
```

### Pregunta 3: Equipo

```
¿Cuantas personas trabajan en el proyecto Flutter?

A) 1 desarrollador (solo yo)
B) 2-3 desarrolladores
C) 4 o mas desarrolladores
```

### Pregunta 4: Experiencia del equipo con Flutter

```
¿Que tan experimentado es el equipo con Flutter?

A) Principiante - estamos aprendiendo Flutter
B) Intermedio - sabemos Flutter pero no hemos hecho proyectos grandes
C) Avanzado - tenemos experiencia con proyectos Flutter de produccion
```

---

## Paso 2: Leer el proyecto existente (si aplica)

Si el proyecto ya existe, usar las herramientas disponibles para:

1. **Leer la estructura de carpetas** con `ls -la` recursivo
2. **Buscar el `pubspec.yaml`** para entender las dependencias actuales
3. **Identificar patrones actuales** buscando archivos como `*_bloc.dart`, `*_provider.dart`, `*_controller.dart`, `*_viewmodel.dart`
4. **Contar pantallas** buscando archivos `*_screen.dart` o `*_page.dart`
5. **Detectar anti-patrones** buscando logica de negocio en widgets

Resumir los hallazgos antes de hacer recomendaciones.

---

## Paso 3: Recomendar arquitectura

Basado en las respuestas, presentar las opciones de arquitectura con **ventajas y desventajas en terminos no tecnicos**:

### Opcion A: Arquitectura Simple (Feature-First Basica)

**Ideal para:** Proyectos nuevos pequeños, equipos aprendiendo Flutter, apps con 1-2 desarrolladores.

**Como funciona (sin tecnicismos):** Organizas tu codigo por funcionalidades (login, pedidos, perfil) y cada funcionalidad tiene sus pantallas y datos juntos. Simple y directo.

```
lib/
├── features/
│   ├── login/
│   │   ├── login_screen.dart
│   │   └── login_service.dart
│   ├── pedidos/
│   │   ├── pedidos_screen.dart
│   │   └── pedidos_service.dart
│   └── perfil/
│       ├── perfil_screen.dart
│       └── perfil_service.dart
├── shared/
│   ├── widgets/        # Botones, cards reusables
│   ├── theme/          # Colores y tipografia MV
│   └── services/       # Conexion al API de MV
└── main.dart
```

**✅ Ventajas:**
- Facil de aprender, cualquier desarrollador entiende donde va cada cosa
- Rapido de implementar, ideal para MVPs y proyectos pequeños
- Menos archivos, menos confusion

**❌ Desventajas:**
- A medida que crece, cada pantalla puede volverse muy grande y dificil de entender
- Dificil de hacer pruebas automatizadas
- Dos desarrolladores pueden pisar el trabajo del otro facilmente
- No escala bien si la app crece a 20+ pantallas

**Recomendado cuando:** Equipo nuevo en Flutter, proyecto con menos de 10 pantallas, plazos muy cortos.

---

### Opcion B: MVVM con Provider/Riverpod (Recomendado para la mayoria de proyectos MV)

**Ideal para:** Proyectos medianos, equipos de 2-4 personas, apps transaccionales.

**Como funciona (sin tecnicismos):** Separas la pantalla visual (View) de la logica de lo que hace (ViewModel). La pantalla solo se preocupa por verse bien; el ViewModel se preocupa por los datos y las acciones. Es como separar el decorado del escenario de los actores.

```
lib/
├── features/
│   └── pedidos/
│       ├── presentation/
│       │   ├── pedidos_screen.dart        # Solo UI, sin logica
│       │   └── widgets/
│       │       └── pedido_card.dart
│       ├── viewmodel/
│       │   └── pedidos_viewmodel.dart     # Logica de la pantalla
│       └── data/
│           ├── pedidos_repository.dart    # Habla con el API
│           └── pedido_model.dart          # Como se ve un pedido
├── core/
│   ├── theme/           # Design system de MV
│   ├── navigation/      # Como navegar entre pantallas
│   ├── network/         # Configuracion del API
│   └── widgets/         # Componentes reusables
└── main.dart
```

**✅ Ventajas:**
- Pantallas mas limpias y faciles de leer
- Facil de hacer pruebas automatizadas (se puede testear la logica sin abrir la app)
- Varios desarrolladores pueden trabajar en paralelo sin conflictos
- Facil de cambiar el backend sin tocar la UI
- Patron bien conocido por la industria

**❌ Desventajas:**
- Mas archivos que la Opcion A (pero cada uno es mas pequeño y claro)
- Requiere entender el patron antes de comenzar
- Puede ser overkill para apps muy simples

**Recomendado cuando:** La mayoria de proyectos MV de produccion, apps con APIs, 2+ desarrolladores.

---

### Opcion C: Clean Architecture con BLoC (Para proyectos enterprise)

**Ideal para:** Proyectos grandes con equipos de 4+ personas, logica de negocio compleja, apps criticas.

**Como funciona (sin tecnicismos):** Divide todo en 3 capas completamente independientes: la capa de datos (como se obtiene la informacion), la capa de negocio (las reglas de la empresa), y la capa de presentacion (lo que ve el usuario). Cada capa no sabe como funciona la otra, solo se comunican por contratos.

```
lib/
├── features/
│   └── pedidos/
│       ├── data/                          # Capa de datos
│       │   ├── datasources/
│       │   │   └── pedidos_remote_datasource.dart
│       │   ├── models/
│       │   │   └── pedido_model.dart
│       │   └── repositories/
│       │       └── pedidos_repository_impl.dart
│       ├── domain/                        # Capa de negocio (reglas MV)
│       │   ├── entities/
│       │   │   └── pedido_entity.dart
│       │   ├── repositories/
│       │   │   └── pedidos_repository.dart
│       │   └── usecases/
│       │       ├── get_pedidos_usecase.dart
│       │       └── crear_pedido_usecase.dart
│       └── presentation/                  # Capa de UI
│           ├── bloc/
│           │   ├── pedidos_bloc.dart
│           │   ├── pedidos_event.dart
│           │   └── pedidos_state.dart
│           ├── screens/
│           │   └── pedidos_screen.dart
│           └── widgets/
│               └── pedido_card.dart
├── core/
│   ├── error/
│   ├── network/
│   └── usecases/
└── main.dart
```

**✅ Ventajas:**
- La arquitectura mas robusta y escalable que existe para Flutter
- Completamente testeable, cada pieza se puede probar aislada
- Cambios en el backend no afectan la UI y viceversa
- Ideal para equipos grandes donde cada uno se especializa en una capa
- Estandar de la industria para apps criticas

**❌ Desventajas:**
- Muchos archivos, puede ser intimidante para nuevos desarrolladores
- Lleva mas tiempo configurar al inicio
- Para un proyecto pequeno, puede ser como usar un Ferrari para ir al supermercado
- Curva de aprendizaje considerable para el equipo

**Recomendado cuando:** App principal de MV con millones de usuarios, equipo de 4+ devs, necesidades de compliance, integraciones complejas.

---

## Paso 4: Recomendar gestion de estado

Despues de elegir la arquitectura, preguntar sobre manejo de estado:

```
¿Que tecnologia quieres usar para manejar el estado de la app?
(El "estado" es la informacion que cambia mientras el usuario usa la app:
si esta cargando, si hubo un error, que datos mostrar, etc.)

A) setState - El mas simple, nativo de Flutter
   ✅ Facil de aprender | ❌ No escala para apps grandes

B) Provider - El estandar recomendado por Google para apps medianas
   ✅ Buena documentacion, facil de aprender | ❌ Puede volverse complejo en apps grandes

C) Riverpod - El Provider "mejorado", mas moderno
   ✅ Muy seguro, facil de testear, muy popular en 2024 | ❌ Curva de aprendizaje inicial

D) BLoC - Patron de eventos y estados, muy estructurado
   ✅ Muy predecible, ideal para equipos grandes | ❌ Mucho codigo boilerplate

E) GetX - Todo en uno (rutas, estado, inyeccion de dependencias)
   ✅ Rapido de implementar | ❌ Dificil de testear, rompe separacion de concerns
```

**Mostrar recomendacion basada en arquitectura elegida:**
- Opcion A → setState o Provider
- Opcion B → Provider o Riverpod (recomendado Riverpod si el equipo tiene experiencia)
- Opcion C → BLoC

---

## Paso 5: Recomendar navegacion

```
¿Como quieres manejar la navegacion entre pantallas?

A) Navigator 1.0 (push/pop) - El clasico de Flutter
   ✅ Muy simple, todos los tutoriales usan esto | ❌ Dificil para deep links y web

B) GoRouter - El paquete recomendado por Google actualmente
   ✅ Soporte para deep links, URLs limpias, facil de leer | ❌ Requiere configuracion inicial

C) Auto Route - Navegacion con generacion de codigo
   ✅ Menos codigo manual, type-safe | ❌ Depende de generacion de codigo (build_runner)
```

**Recomendacion:** GoRouter para la mayoria de proyectos MV (soporte para deep links desde WhatsApp, URLs compartibles).

---

## Paso 6: Generar estructura del proyecto

Una vez el usuario haya tomado decisiones, generar:

1. **Estructura de carpetas completa** con comandos `mkdir` para crear directorios
2. **Archivos base** segun la arquitectura elegida:
   - `pubspec.yaml` con las dependencias correctas
   - `main.dart` configurado
   - `app_theme.dart` con los design tokens de MV
   - `app_router.dart` con la navegacion configurada
   - Estructura de ejemplo de una feature completa
3. **README de arquitectura** en `docs/ARCHITECTURE.md` documentando las decisiones

---

## Paso 7: Documentar las decisiones

Actualizar o crear `docs/ARCHITECTURE.md` con:

```markdown
# Arquitectura del Proyecto Flutter

## Patron elegido
[Nombre del patron y razon de la eleccion]

## Gestion de estado
[Tecnologia elegida y razon]

## Navegacion
[Solucion elegida y razon]

## Estructura de carpetas
[Arbol de directorios]

## Como agregar una nueva feature
[Guia paso a paso siguiendo la arquitectura]

## Decisiones importantes
| Fecha | Decision | Razon |
|-------|----------|-------|
| [hoy] | [decision] | [razon] |
```

---

## Reglas criticas para proyectos Flutter de MV

1. **NUNCA** poner logica de negocio en los widgets (pantallas)
2. **NUNCA** hacer llamadas al API directamente desde un widget
3. **NUNCA** hardcodear colores hex en widgets, usar los tokens del `AppTheme`
4. **NUNCA** usar `print()` en codigo de produccion, usar el logger configurado
5. **SIEMPRE** usar `const` en widgets cuando sea posible (mejora performance)
6. **SIEMPRE** nombrar archivos en `snake_case` (estandar Dart)
7. **SIEMPRE** nombrar clases en `PascalCase`
8. **SIEMPRE** documentar decisiones de arquitectura en `docs/ARCHITECTURE.md`

---

## Si el proyecto ya tiene arquitectura problematica

Si se detectan anti-patrones, generar un **plan de migracion gradual** (no reescribir todo):

1. **Inventario:** Listar los archivos con problemas mas graves
2. **Prioridad:** Ordenar por impacto en el negocio
3. **Migracion por feature:** Migrar una feature a la vez sin romper las demas
4. **Feature flags:** Usar flags para activar/desactivar la nueva arquitectura por pantalla
5. **Plan realista:** Mostrar cuantas features hay que migrar y sugerir orden

---

## Relacionado

- Skill `/mv-dev:flutter-new-feature` - Crear una nueva feature siguiendo la arquitectura
- Skill `/mv-dev:flutter-new-screen` - Crear una nueva pantalla
- Skill `/mv-dev:flutter-visual-style` - Configurar el design system de MV en Flutter
- Skill `/mv-dev:flutter-brand-identity` - Revisar identidad de marca en Flutter
