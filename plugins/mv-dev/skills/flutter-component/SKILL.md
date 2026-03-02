---
description: Crea un widget reutilizable en Flutter para proyectos MV - con design tokens, variantes, accesibilidad y widget tests
---

# Flutter Component - Widget Reutilizable en Flutter

Crea un widget (componente) reutilizable que siga el design system de Manzana Verde, sea accesible y este bien documentado para que todo el equipo pueda usarlo.

---

## Cuando usar este skill

- Cuando vas a crear un boton, card, badge, chip, input u otro elemento de UI
- Cuando una pantalla tiene un elemento visual que se repite en otro lugar
- Cuando el equipo decide crear un componente para el design system de MV en Flutter
- Cuando quieres asegurar que un elemento visual sea coherente en toda la app

---

## Paso 0: Verificar si ya existe

Antes de crear un componente nuevo, verificar:

1. Buscar en `lib/core/widgets/` si ya existe algo similar
2. Buscar en `lib/shared/widgets/` si el proyecto tiene esa estructura
3. Buscar por el nombre del componente en todo el proyecto
4. Revisar el `docs/COMPONENTS.md` si existe

Si ya existe algo similar, mostrar al usuario las opciones:
```
Ya encontre un componente similar: [Nombre]
Opciones:
A) Extender el existente agregando la variante que necesitas
B) Crear uno nuevo si las diferencias son muy grandes
C) Ver el componente existente y decidir
```

---

## Paso 1: Preguntar sobre el componente

### Pregunta 1: Tipo de componente

```
¿Que tipo de componente quieres crear?

A) Boton - para acciones del usuario
B) Card - contenedor de informacion con borde y sombra
C) Input / Campo de texto - para que el usuario ingrese datos
D) Badge / Chip / Tag - etiquetas de estado o categoria
E) Lista / Item de lista - elemento de una lista
F) Modal / Bottom sheet - contenido superpuesto
G) Imagen / Avatar - con loading y fallback
H) Elemento de navegacion (tab, menu item)
I) Elemento especifico de MV (describir)
```

### Pregunta 2: Nombre y descripcion

```
¿Como se llama el componente y que hace?

Ejemplo:
- Nombre: "PlanCard"
- Que hace: "Muestra un plan de alimentacion con nombre, precio, dias y boton de seleccion"

Por favor dame:
1. Nombre (en PascalCase, ej: PedidoCard, MvButton, PlanBadge)
2. Que muestra o que hace
```

### Pregunta 3: Variantes

```
¿El componente tiene variantes o estados?

Ejemplos de variantes:
- Boton: primario, secundario, destructivo, deshabilitado
- Card: con imagen, sin imagen, seleccionada, deshabilitada
- Badge: verde (activo), naranja (pendiente), rojo (cancelado)

¿Tu componente tiene variantes?
A) No, es un componente simple sin variantes
B) Si, tiene variantes (describir cuales)
C) Tiene estados interactivos (hover, pressed, disabled, loading)
```

### Pregunta 4: Contenido

```
¿Que informacion o propiedades necesita el componente?

Ayudame a identificar los "props" (datos que recibe desde afuera):
- ¿Muestra texto? ¿Cual texto es fijo y cual viene de fuera?
- ¿Muestra imagenes? ¿La URL viene de fuera?
- ¿Tiene botones de accion? ¿Que accion realiza al presionar?
- ¿Tiene badges o indicadores de estado?
```

### Pregunta 5: Donde se usa

```
¿En que pantallas o contextos se va a usar este componente?

A) En una pantalla especifica (cual?)
B) En varias pantallas similares
C) En toda la app (es un componente del design system)
```

---

## Paso 2: Generar el componente

### 2.1 Componente simple (StatelessWidget)

Para componentes que solo muestran informacion:

```dart
// lib/core/widgets/[component_name].dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_borders.dart';
import '../theme/app_shadows.dart';

/// [Descripcion de que hace el componente]
///
/// Uso:
/// ```dart
/// [ComponentName](
///   titulo: 'Plan Semanal',
///   precio: 1500,
///   onTap: () => navigateTo('/plan/1'),
/// )
/// ```
class [ComponentName] extends StatelessWidget {
  /// [Descripcion del parametro]
  final String titulo;

  /// [Descripcion del parametro]
  final int precio;

  /// Callback cuando el usuario toca el componente
  final VoidCallback? onTap;

  const [ComponentName]({
    super.key,
    required this.titulo,
    required this.precio,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: AppBorders.card,
          border: Border.all(color: AppColors.mvGray200),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: AppTypography.h4),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _formatPrecio(precio),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.mvGreen500,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatPrecio(int centavos) {
    // Los precios en MV se guardan en centavos
    final soles = centavos / 100;
    return 'S/ ${soles.toStringAsFixed(2)}';
  }
}
```

### 2.2 Componente con variantes usando enum

```dart
// lib/core/widgets/mv_badge.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_borders.dart';

/// Variantes del badge de MV
enum MvBadgeVariant {
  /// Estado activo / exitoso - verde MV
  success,
  /// Estado pendiente / advertencia - naranja MV
  pending,
  /// Estado cancelado / error - rojo
  error,
  /// Estado informativo - gris
  neutral,
}

/// Badge de estado para Manzana Verde
///
/// Uso:
/// ```dart
/// MvBadge(label: 'Activo', variant: MvBadgeVariant.success)
/// MvBadge(label: 'Pendiente', variant: MvBadgeVariant.pending)
/// ```
class MvBadge extends StatelessWidget {
  final String label;
  final MvBadgeVariant variant;

  const MvBadge({
    super.key,
    required this.label,
    this.variant = MvBadgeVariant.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppBorders.badge,
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _BadgeColors _getColors() {
    switch (variant) {
      case MvBadgeVariant.success:
        return _BadgeColors(
          background: AppColors.mvGreen50,
          text: AppColors.mvGreen600,
        );
      case MvBadgeVariant.pending:
        return _BadgeColors(
          background: const Color(0xFFFFF0E8),
          text: AppColors.mvOrange500,
        );
      case MvBadgeVariant.error:
        return _BadgeColors(
          background: const Color(0xFFFEE2E2),
          text: AppColors.error,
        );
      case MvBadgeVariant.neutral:
        return _BadgeColors(
          background: AppColors.mvGray200,
          text: AppColors.mvGray500,
        );
    }
  }
}

class _BadgeColors {
  final Color background;
  final Color text;
  const _BadgeColors({required this.background, required this.text});
}
```

### 2.3 Boton primario de MV

```dart
// lib/core/widgets/mv_button.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_borders.dart';
import '../theme/app_shadows.dart';

enum MvButtonVariant { primary, secondary, ghost, destructive }
enum MvButtonSize { small, medium, large }

/// Boton estandar de Manzana Verde
///
/// Uso:
/// ```dart
/// MvButton(label: 'Ver planes', onPressed: () {})
/// MvButton(label: 'Cancelar', variant: MvButtonVariant.secondary, onPressed: () {})
/// MvButton(label: 'Eliminar', variant: MvButtonVariant.destructive, onPressed: () {})
/// ```
class MvButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final MvButtonVariant variant;
  final MvButtonSize size;
  final bool isLoading;
  final IconData? icon;

  const MvButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MvButtonVariant.primary,
    this.size = MvButtonSize.medium,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final colors = _getColors();
    final padding = _getPadding();

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: variant == MvButtonVariant.primary && !isDisabled
            ? AppShadows.primaryButton
            : null,
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.mvGray200
              : colors.background,
          foregroundColor: isDisabled
              ? AppColors.mvGray500
              : colors.text,
          elevation: 0,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorders.button,
            side: variant == MvButtonVariant.secondary
                ? const BorderSide(color: AppColors.mvGreen500)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.text,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: AppTypography.button.copyWith(
                    color: isDisabled ? AppColors.mvGray500 : colors.text,
                  )),
                ],
              ),
      ),
    );
  }

  _ButtonColors _getColors() {
    switch (variant) {
      case MvButtonVariant.primary:
        return _ButtonColors(
          background: AppColors.mvGreen500,
          text: Colors.white,
        );
      case MvButtonVariant.secondary:
        return _ButtonColors(
          background: Colors.transparent,
          text: AppColors.mvGreen500,
        );
      case MvButtonVariant.ghost:
        return _ButtonColors(
          background: AppColors.mvGreen50,
          text: AppColors.mvGreen500,
        );
      case MvButtonVariant.destructive:
        return _ButtonColors(
          background: const Color(0xFFFEE2E2),
          text: AppColors.error,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case MvButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case MvButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case MvButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color text;
  const _ButtonColors({required this.background, required this.text});
}
```

---

## Paso 3: Tests del componente

```dart
// test/core/widgets/[component_name]_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:[proyecto]/core/widgets/[component_name].dart';
import 'package:[proyecto]/core/theme/app_colors.dart';

void main() {
  group('[ComponentName]', () {
    // Test 1: Renderizado basico
    testWidgets('se renderiza correctamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: [ComponentName](
              titulo: 'Test',
              // otros props
            ),
          ),
        ),
      );

      expect(find.byType([ComponentName]), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    // Test 2: Callback de tap
    testWidgets('llama onTap cuando se presiona', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: [ComponentName](
              titulo: 'Test',
              onTap: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType([ComponentName]));
      expect(tapCount, equals(1));
    });

    // Test 3: Estado deshabilitado (si aplica)
    testWidgets('no llama onTap cuando esta deshabilitado', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: [ComponentName](
              titulo: 'Test',
              // isDisabled: true,
              onTap: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType([ComponentName]));
      expect(tapCount, equals(0));
    });

    // Test 4: Variantes (si aplica)
    testWidgets('variante success muestra color verde', (tester) async {
      // Si es un badge con variantes
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MvBadge(
              label: 'Activo',
              variant: MvBadgeVariant.success,
            ),
          ),
        ),
      );

      // Verificar que existe el widget
      expect(find.text('Activo'), findsOneWidget);
    });
  });
}
```

---

## Paso 4: Documentar el componente

Agregar o actualizar `docs/COMPONENTS.md`:

```markdown
## [ComponentName]

**Ubicacion:** `lib/core/widgets/[component_name].dart`
**Tipo:** Stateless / Stateful

### Props

| Prop | Tipo | Requerido | Default | Descripcion |
|------|------|-----------|---------|-------------|
| `titulo` | `String` | Si | - | Titulo principal del componente |
| `onTap` | `VoidCallback?` | No | `null` | Accion al presionar |

### Variantes (si aplica)

| Variante | Uso |
|----------|-----|
| `success` | Para estados activos o exitosos |
| `pending` | Para estados pendientes |

### Uso

```dart
[ComponentName](
  titulo: 'Ejemplo',
  onTap: () {},
)
```

### Donde se usa
- [PantallaEjemplo]Screen
- [OtraPantalla]Screen
```

---

## Reglas criticas

1. **NUNCA** hardcodear colores hex en el componente, usar `AppColors.*`
2. **NUNCA** hardcodear `fontSize`, `fontWeight`, usar `AppTypography.*`
3. **NUNCA** hardcodear valores de padding/margin, usar `AppSpacing.*`
4. **NUNCA** hardcodear `BorderRadius`, usar `AppBorders.*`
5. **SIEMPRE** usar `const` en el constructor si es posible
6. **SIEMPRE** agregar documentacion `///` al componente y sus props
7. **SIEMPRE** crear al menos 3 tests (renderizado, interaccion, variante)
8. **SIEMPRE** documentar en `docs/COMPONENTS.md`

---

## Checklist antes de marcar como completo

```
✅ El componente usa AppColors, AppTypography, AppSpacing, AppBorders
✅ Tiene documentacion /// en la clase y en cada prop
✅ Tiene ejemplo de uso en la documentacion
✅ Tiene tests: renderizado, interaccion (si aplica), variantes (si aplica)
✅ Esta documentado en docs/COMPONENTS.md
✅ El nombre sigue PascalCase y el archivo snake_case
✅ No tiene logica de negocio (solo logica de presentacion)
```

---

## Relacionado

- Skill `/mv-dev:flutter-visual-style` - Design tokens a usar
- Skill `/mv-dev:flutter-brand-identity` - Voz, iconos y estilo visual de MV
- Skill `/mv-dev:flutter-new-screen` - Como usar el componente en pantallas
