---
description: Mantiene la consistencia visual en proyectos Flutter de MV - configura y valida design tokens, tipografia, colores y estilos segun el design system oficial
---

# Flutter Visual Style - Consistencia Visual en Flutter

Configura, valida y mantiene el design system de Manzana Verde en proyectos Flutter. Asegura que toda la app se vea cohesiva y que cumpla con los estandares visuales del equipo.

---

## Cuando usar este skill

- Al iniciar un proyecto Flutter nuevo (configurar el tema desde cero)
- Cuando una pantalla o componente "no se ve como Manzana Verde"
- Cuando hay colores hardcodeados en el codigo
- Cuando se quiere revisar que todo el proyecto cumple el design system
- Cuando llega un nuevo diseno de Figma y hay que actualizar el tema
- Antes de lanzar una nueva version de la app

---

## Paso 1: Entender el estado actual

**Preguntar al usuario:**

### Pregunta 1: ¿Tienes un archivo de tema configurado?

```
¿Ya tienes configurado el tema visual (colores, fuentes, estilos) en el proyecto?

A) No, es un proyecto nuevo o nunca hemos configurado un tema
B) Si, tenemos algo configurado pero no estamos seguros si esta bien
C) Si, tenemos un tema pero necesitamos actualizarlo con el design system de MV
```

### Pregunta 2: ¿Tienes acceso al diseno?

```
¿Tienes acceso a los archivos de diseno de esta app?

A) Si, tengo Figma con los disenos
B) Si, tengo otro formato (Adobe XD, Sketch, PDFs)
C) No, solo tengo la referencia del design system de MV en el CLAUDE.md
D) Quiero que coincida exactamente con la web app de MV
```

### Pregunta 3: ¿Que quieres hacer?

```
¿Que necesitas hacer con el estilo visual?

A) Configurar el tema completo desde cero
B) Revisar y corregir el tema existente
C) Agregar nuevos colores/estilos al tema existente
D) Auditar todo el proyecto para detectar estilos hardcodeados
```

---

## Paso 2: Leer el proyecto existente (si aplica)

Si el proyecto ya existe, buscar:

1. Archivos de tema: `*theme*.dart`, `*colors*.dart`, `*styles*.dart`, `*tokens*.dart`
2. Instancias de colores hardcodeados: buscar patrones `Color(0x`, `Colors.` especificos
3. Instancias de tamanos de fuente hardcodeados: buscar `fontSize:` con numeros directos
4. Instancias de `TextStyle(` directo en widgets
5. Uso de `Padding(padding: EdgeInsets.` con numeros magicos

Reportar los hallazgos antes de proceder.

---

## Paso 3: Configurar o actualizar el tema

### 3.1 Estructura de archivos recomendada

```
lib/core/theme/
├── app_theme.dart          # ThemeData principal (light + dark si aplica)
├── app_colors.dart         # Todos los colores de MV
├── app_typography.dart     # Fuentes y estilos de texto
├── app_spacing.dart        # Constantes de espaciado
├── app_borders.dart        # Border radius estandares
└── app_shadows.dart        # Sombras estandares
```

### 3.2 Colores oficiales de Manzana Verde

Crear `lib/core/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

/// Colores oficiales de Manzana Verde
/// NUNCA usar colores hex directamente en widgets, siempre usar estas constantes
abstract class AppColors {
  // =========== PRIMARIOS ===========
  /// Color primario de marca MV - verde principal
  static const Color mvGreen500 = Color(0xFF227A4B);
  /// Hover de botones primarios
  static const Color mvGreen600 = Color(0xFF1D6A41);
  /// Active/pressed
  static const Color mvGreen700 = Color(0xFF185A37);
  /// Fondo sutil primario
  static const Color mvGreen50 = Color(0xFFE8F5EC);

  // =========== SECUNDARIOS ===========
  /// Color secundario - naranja para badges y alertas
  static const Color mvOrange500 = Color(0xFFE85D04);
  /// Color terciario - amarillo para promos y highlights
  static const Color mvYellow500 = Color(0xFFE5B83C);

  // =========== GRISES ===========
  /// Texto principal
  static const Color mvGray900 = Color(0xFF171717);
  /// Texto secundario / muted
  static const Color mvGray500 = Color(0xFF737373);
  /// Bordes estandar
  static const Color mvGray200 = Color(0xFFE8E8E8);
  /// Fondo de pagina
  static const Color mvGray50 = Color(0xFFFAFAFA);

  // =========== SEMANTICOS ===========
  static const Color success = mvGreen500;
  static const Color warning = mvOrange500;
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0EA5E9);

  // =========== BACKGROUNDS ===========
  static const Color backgroundPage = mvGray50;
  static const Color backgroundCard = Colors.white;
  static const Color backgroundPrimary = mvGreen50;
}
```

### 3.3 Tipografia oficial de Manzana Verde

**Preguntar:**
```
¿Ya tienes las fuentes Inter y Nunito configuradas en el proyecto?

A) No, necesito agregarlas
B) Si, ya estan en el pubspec.yaml
C) No se como verificarlo
```

Si no estan configuradas, generar los pasos:

1. Agregar al `pubspec.yaml`:
```yaml
dependencies:
  google_fonts: ^6.1.0   # Para Inter y Nunito de Google Fonts
```

2. Crear `lib/core/theme/app_typography.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tipografia oficial de Manzana Verde
/// - Headings: Inter (400-800)
/// - Body/UI: Nunito (400-700)
abstract class AppTypography {
  // =========== HEADINGS (Inter) ===========
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.mvGray900,
    height: 1.2,
  );

  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.mvGray900,
    height: 1.25,
  );

  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.mvGray900,
    height: 1.3,
  );

  static TextStyle get h4 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.mvGray900,
    height: 1.35,
  );

  // =========== BODY (Nunito) ===========
  static TextStyle get bodyLarge => GoogleFonts.nunito(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.mvGray900,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.mvGray900,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.mvGray500,
    height: 1.5,
  );

  static TextStyle get label => GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.mvGray900,
    height: 1.4,
    letterSpacing: 0.3,
  );

  static TextStyle get button => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.25,
  );

  static TextStyle get caption => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mvGray500,
    height: 1.4,
  );
}
```

### 3.4 Espaciado estandar

Crear `lib/core/theme/app_spacing.dart`:

```dart
/// Sistema de espaciado de Manzana Verde
/// Base: 4px, todos los valores son multiplos de 4
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;

  /// Padding horizontal estandar para pantallas
  static const double screenHorizontal = 16.0;
  /// Padding vertical estandar para pantallas
  static const double screenVertical = 24.0;
  /// Padding interno de cards
  static const double cardPadding = 16.0;
  /// Espacio entre items de lista
  static const double listItemSpacing = 12.0;
}
```

### 3.5 Border radius estandar

Crear `lib/core/theme/app_borders.dart`:

```dart
import 'package:flutter/material.dart';

/// Border radius estandar de Manzana Verde
abstract class AppBorders {
  /// Inputs: rounded-md (8px)
  static const BorderRadius input = BorderRadius.all(Radius.circular(8));
  /// Botones: rounded-xl (12px)
  static const BorderRadius button = BorderRadius.all(Radius.circular(12));
  /// Cards: rounded-2xl (16px)
  static const BorderRadius card = BorderRadius.all(Radius.circular(16));
  /// Badges: rounded-lg (10px)
  static const BorderRadius badge = BorderRadius.all(Radius.circular(10));
  /// Dialogs: rounded-2xl (16px)
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(16));
  /// Bottom sheets: solo esquinas superiores
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );
}
```

### 3.6 Sombras estandar

Crear `lib/core/theme/app_shadows.dart`:

```dart
import 'package:flutter/material.dart';

abstract class AppShadows {
  /// Sombra sutil para cards
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Sombra para botones primarios
  static const List<BoxShadow> primaryButton = [
    BoxShadow(
      color: Color(0x40227A4B),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// Sombra para modales y bottom sheets
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];
}
```

### 3.7 ThemeData principal

Crear/actualizar `lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_borders.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.mvGreen500,
      primary: AppColors.mvGreen500,
      onPrimary: Colors.white,
      secondary: AppColors.mvOrange500,
      background: AppColors.backgroundPage,
      surface: AppColors.backgroundCard,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.backgroundPage,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      headlineMedium: AppTypography.h3,
      titleLarge: AppTypography.h4,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelSmall: AppTypography.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mvGreen500,
        foregroundColor: Colors.white,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: AppBorders.button),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: const BorderSide(color: AppColors.mvGray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: const BorderSide(color: AppColors.mvGray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: const BorderSide(color: AppColors.mvGreen500, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      color: AppColors.backgroundCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.card,
        side: const BorderSide(color: AppColors.mvGray200),
      ),
    ),
  );
}
```

---

## Paso 4: Auditoria del proyecto existente

Si el usuario quiere auditar el proyecto, buscar y reportar:

### Problemas criticos (deben corregirse)

| Problema | Como detectarlo | Como corregirlo |
|----------|----------------|----------------|
| Colores hardcodeados | `Color(0xFF...)` en widgets | Reemplazar con `AppColors.` |
| Colores de Material | `Colors.green`, `Colors.red` | Reemplazar con `AppColors.` |
| FontSize hardcodeados | `fontSize: 16` en TextStyle | Reemplazar con `AppTypography.` |
| Padding numeros magicos | `EdgeInsets.all(13)` | Reemplazar con `AppSpacing.` |
| BorderRadius hardcodeados | `BorderRadius.circular(8)` | Reemplazar con `AppBorders.` |
| TextStyle directo en widget | `TextStyle(...)` inline | Mover a `AppTypography.` |

### Generar reporte de auditoria

```
## Auditoria de Estilos - [Nombre del Proyecto]
Fecha: [fecha]

### Resumen
- Archivos revisados: X
- Problemas encontrados: X
- Criticos: X
- Advertencias: X

### Problemas criticos
[Lista de archivos y lineas con problemas]

### Plan de correccion
[Orden sugerido para corregir]
```

---

## Paso 5: Verificacion rapida

Lista de verificacion para confirmar que el tema esta bien configurado:

```
✅ app_colors.dart tiene todos los colores de MV
✅ app_typography.dart usa Inter para headings y Nunito para body
✅ app_spacing.dart tiene constantes de espaciado en multiplos de 4
✅ app_borders.dart tiene los border radius estandar
✅ app_theme.dart configura el ThemeData con los tokens
✅ main.dart usa AppTheme.light en el MaterialApp
✅ No hay colores hardcodeados en ninguna pantalla o widget
✅ No hay fontSize hardcodeados fuera de AppTypography
✅ google_fonts esta en pubspec.yaml
```

---

## Reglas criticas

1. **NUNCA** usar `Color(0xFFxxxxxx)` directamente en un widget
2. **NUNCA** usar `Colors.green`, `Colors.red`, etc. sin ser de AppColors
3. **NUNCA** hardcodear `fontSize` en un widget, siempre usar `AppTypography`
4. **NUNCA** hardcodear valores de `EdgeInsets` con numeros que no sean multiplos de 4
5. **SIEMPRE** usar `AppColors.mvGreen500` en lugar de `#227A4B`
6. **SIEMPRE** usar `const` en los constructores de `EdgeInsets`, `BorderRadius`, etc.

---

## Relacionado

- Skill `/mv-dev:flutter-brand-identity` - Revisar identidad de marca completa
- Skill `/mv-dev:flutter-component` - Crear componentes con los estilos correctos
- Skill `/mv-dev:flutter-architecture` - Donde colocar los archivos de tema
- Archivo `DESIGN_TOKENS.md` en la raiz del plugin - Referencia completa del design system
