---
description: Crea una nueva pantalla Flutter para proyectos MV - con navegacion correcta, design tokens aplicados, estados de carga/error y widget tests
---

# Flutter New Screen - Nueva Pantalla en Flutter

Crea una pantalla completa en un proyecto Flutter de Manzana Verde con la estructura correcta segun la arquitectura del proyecto, aplicando el design system de MV y cubriendo todos los estados visuales necesarios.

---

## Cuando usar este skill

- Cuando hay que agregar una nueva pantalla a la app
- Cuando se recibe un diseno de Figma de una pantalla nueva
- Cuando se agrega un nuevo destino a la navegacion
- Cuando una pantalla existente necesita ser refactorizada completamente

---

## Paso 0: Leer el proyecto

Antes de preguntar nada, revisar:

1. `lib/core/navigation/` o el archivo de rutas para entender como esta configurada la navegacion
2. Una pantalla existente para entender el patron en uso
3. `lib/core/theme/` para confirmar que existen los tokens de MV
4. `docs/ARCHITECTURE.md` si existe

---

## Paso 1: Preguntar sobre la pantalla

### Pregunta 1: Identidad de la pantalla

```
¿Que pantalla vamos a crear?

Necesito saber:
1. Nombre de la pantalla (ej: "DetallePedido", "SeleccionPlan", "EditarPerfil")
2. ¿Para que sirve? Describe lo que el usuario hace en esta pantalla
3. ¿Quien puede acceder?
   A) Cualquier usuario (publica, sin login)
   B) Solo usuarios con sesion iniciada
   C) Solo usuarios con cierto rol o plan activo
```

### Pregunta 2: Tipo de pantalla

```
¿Que tipo de pantalla es?

A) Pantalla de lista - muestra una lista de elementos (pedidos, platos, etc.)
B) Pantalla de detalle - muestra la informacion completa de un elemento
C) Pantalla de formulario - el usuario ingresa o edita informacion
D) Pantalla de confirmacion / resultado - muestra el resultado de una accion
E) Pantalla de onboarding / informativa - explica algo al usuario
F) Dashboard / resumen - muestra varios tipos de informacion juntos
```

### Pregunta 3: Contenido de la pantalla

```
¿De donde vienen los datos que muestra esta pantalla?

A) Del API de MV (hay que hacer una llamada al servidor)
B) De la sesion del usuario (ya disponibles en la app)
C) Se pasan como parametros desde la pantalla anterior
D) Son datos locales / estaticos (no cambian)
E) Combinacion (describir)
```

### Pregunta 4: Navegacion

```
¿Como se accede a esta pantalla y a donde puede ir el usuario desde ahi?

1. ¿Desde donde se llega? (ej: "desde el menu principal", "al hacer tap en un pedido")
2. ¿A donde puede ir el usuario? (ej: "puede ir a DetallePlato", "puede volver atras")
3. ¿Esta pantalla tiene tabs o secciones internas?
   A) No, es una pantalla simple
   B) Si, tiene tabs (describir)
   C) Si, tiene scroll con secciones
```

### Pregunta 5: Diseno

```
¿Tienes el diseno de esta pantalla?

A) Si, tengo un Figma / screenshot - por favor compartelo o describelo
B) No, quiero que siga el estilo estandar de MV
C) No, pero la pantalla [NombrePantalla] es similar, base en esa
```

---

## Paso 2: Generar la pantalla

### 2.1 Estructura base de cualquier pantalla MV

```dart
// lib/features/[feature-name]/presentation/[screen_name]_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class [ScreenName]Screen extends StatelessWidget {
  // Parametros de navegacion (si aplica)
  final String? id;

  const [ScreenName]Screen({
    super.key,
    this.id,
  });

  /// Nombre de la ruta para GoRouter
  static const String routeName = '/[screen-name]';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: _buildAppBar(context),
      body: _[ScreenName]Body(id: id),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '[Titulo de la pantalla]',
        style: AppTypography.h4,
      ),
      backgroundColor: AppColors.backgroundCard,
      elevation: 0,
      foregroundColor: AppColors.mvGray900,
      // Solo mostrar boton de regreso si es necesario
      automaticallyImplyLeading: true,
    );
  }
}
```

### 2.2 Patron para pantalla de LISTA

```dart
class _[ScreenName]Body extends StatelessWidget {
  const _[ScreenName]Body();

  @override
  Widget build(BuildContext context) {
    // Con ViewModel/BLoC/Provider segun la arquitectura del proyecto
    return [ScreenName]Consumer(
      builder: (context, state) {
        if (state.isLoading) return const _LoadingView();
        if (state.hasError) return _ErrorView(message: state.errorMessage);
        if (state.items.isEmpty) return const _EmptyView();
        return _ListView(items: state.items);
      },
    );
  }
}

// Estado de carga
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.mvGreen500,
      ),
    );
  }
}

// Estado de error
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Algo salio mal',
              style: AppTypography.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mvGray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(
              onPressed: () => context.read<[ScreenName]ViewModel>().retry(),
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}

// Estado vacio
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.mvGray200,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No hay elementos todavia',
              style: AppTypography.h4.copyWith(
                color: AppColors.mvGray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Lista con datos
class _ListView extends StatelessWidget {
  final List<dynamic> items;
  const _ListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.screenVertical,
      ),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => [ItemCard](item: items[index]),
    );
  }
}
```

### 2.3 Patron para pantalla de FORMULARIO

```dart
class _[ScreenName]Body extends StatelessWidget {
  const _[ScreenName]Body();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.screenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campos del formulario
          _buildFormField(
            label: 'Nombre',
            hint: 'Ingresa tu nombre',
          ),
          const SizedBox(height: AppSpacing.lg),

          // Boton de accion principal
          ElevatedButton(
            onPressed: () => _handleSubmit(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          decoration: InputDecoration(hintText: hint),
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    // Logica de submit en el ViewModel/BLoC
  }
}
```

### 2.4 Registrar la ruta

```dart
// En app_router.dart - agregar la nueva ruta
GoRoute(
  path: '/[screen-name]',
  name: '[ScreenName]Screen.routeName',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    return [ScreenName]Screen(id: id);
  },
),
```

---

## Paso 3: Widget tests de la pantalla

```dart
// test/features/[feature-name]/presentation/[screen_name]_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:[proyecto]/features/[feature-name]/presentation/[screen_name]_screen.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('[ScreenName]Screen', () {
    testWidgets('renderiza la pantalla correctamente', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const [ScreenName]Screen()),
      );
      expect(find.byType([ScreenName]Screen), findsOneWidget);
    });

    testWidgets('muestra AppBar con el titulo correcto', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const [ScreenName]Screen()),
      );
      expect(find.text('[Titulo de la pantalla]'), findsOneWidget);
    });

    testWidgets('muestra estado de carga inicialmente', (tester) async {
      // Mock con estado de carga
      await tester.pumpWidget(
        buildTestableWidget(const [ScreenName]Screen()),
      );
      await tester.pump();
      // Verificar segun el patron de carga del proyecto
    });

    testWidgets('muestra estado vacio cuando no hay datos', (tester) async {
      // Mock con lista vacia
      await tester.pumpWidget(
        buildTestableWidget(const [ScreenName]Screen()),
      );
      await tester.pumpAndSettle();
      // Verificar mensaje de vacio
    });

    testWidgets('navega correctamente al hacer tap', (tester) async {
      // Test de navegacion
    });
  });
}
```

---

## Paso 4: Checklist antes de marcar como completa

```
Pantalla: [ScreenName]Screen

✅ Usa AppColors, AppTypography, AppSpacing (sin valores hardcodeados)
✅ Tiene AppBar con titulo correcto
✅ Maneja estado de carga (CircularProgressIndicator en AppColors.mvGreen500)
✅ Maneja estado de error (con boton para reintentar)
✅ Maneja estado vacio (con mensaje amigable)
✅ Maneja estado con datos (la pantalla principal)
✅ La logica de datos esta fuera del widget (en ViewModel/BLoC)
✅ La ruta esta registrada en app_router.dart
✅ Widget tests cubren los estados principales
✅ La pantalla esta documentada en docs/PROJECT_SCOPE.md
```

---

## Relacionado

- Skill `/mv-dev:flutter-new-feature` - Para crear la feature completa que contiene esta pantalla
- Skill `/mv-dev:flutter-component` - Para crear los widgets reutilizables que usa la pantalla
- Skill `/mv-dev:flutter-visual-style` - Para el design system de MV
- Skill `/mv-dev:flutter-brand-identity` - Para la voz y tono del contenido de la pantalla
