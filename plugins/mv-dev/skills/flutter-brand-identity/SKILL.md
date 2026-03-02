---
description: Asegura la identidad de marca de Manzana Verde en proyectos Flutter - revisa logo, iconografia, tonalidad, animaciones y experiencia coherente con la marca
---

# Flutter Brand Identity - Identidad de Marca en Flutter

Garantiza que la app Flutter de Manzana Verde comunique correctamente la identidad de la marca: fresca, saludable, confiable y moderna. Va mas alla de los colores: incluye voz, iconos, animaciones, microinteracciones y experiencia general.

---

## Cuando usar este skill

- Antes de lanzar una nueva version de la app
- Cuando un diseno nuevo llega del equipo de UI/UX
- Cuando alguien del equipo dice "esto no se parece a MV"
- Cuando se agrega una pantalla nueva y hay dudas sobre como debe verse y sentirse
- Cuando se cambia el logo, slogan o algun elemento de marca
- Para hacer una revision completa de marca en el proyecto

---

## Paso 1: Entender el alcance de la revision

**Preguntar al usuario:**

### Pregunta 1: ¿Que quieres revisar?

```
¿Que aspecto de la identidad de marca quieres revisar o configurar?

A) Todo - revision completa de marca (logo, colores, tipografia, iconos, tono, animaciones)
B) Solo el logo y elementos graficos de marca
C) Solo la tonalidad del texto (como habla la app al usuario)
D) Solo los iconos e ilustraciones
E) Solo las animaciones y microinteracciones
F) Solo el splash screen y onboarding
```

### Pregunta 2: ¿Tienes los assets de marca?

```
¿Tienes los archivos de los elementos de marca de MV?

A) Si, tengo el logo en SVG/PNG en varias resoluciones
B) Si, tengo algunos pero no todos
C) No, necesito saber cuales son los correctos y donde conseguirlos
D) Solo tengo el logo que ya esta en la app actual
```

---

## Paso 2: Revisar el proyecto existente

Si el proyecto ya existe, buscar:

1. **Assets de marca:** directorio `assets/images/`, `assets/logos/`, `assets/icons/`
2. **Splash screen:** `android/app/src/main/res/drawable*/` y `ios/Runner/Assets.xcassets/`
3. **App icons:** `android/app/src/main/res/mipmap*/` y `ios/Runner/Assets.xcassets/AppIcon`
4. **Textos de UI:** buscar strings hardcodeados en archivos `.dart`
5. **Iconos usados:** buscar `Icon(Icons.`, `Icon(CupertinoIcons.`, paquetes de iconos externos
6. **Animaciones:** buscar `AnimationController`, paquetes como `lottie`, `animated_*`

Reportar lo que se encontro antes de continuar.

---

## Paso 3: Checklist de identidad de marca

### 3.1 Logo y elementos graficos

**Preguntar si no esta claro:**
```
¿Donde aparece el logo de MV en tu app?

A) Solo en el splash screen
B) En el splash screen y en la pantalla de login
C) En el splash screen, login y en el header de la app
D) En otros lugares (describir)
```

**Reglas de uso del logo de MV:**

```dart
// ✅ BIEN: Logo en resoluciones correctas
// Usar SVG cuando sea posible con flutter_svg
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  'assets/logos/mv_logo.svg',
  width: 120,  // Ancho minimo recomendado: 80px
  height: 40,  // Mantener aspect ratio
  colorFilter: null,  // NUNCA cambiar los colores del logo
)

// ✅ BIEN: Espacio respetado alrededor del logo
Padding(
  padding: const EdgeInsets.all(16),  // Minimo 16px de espacio libre alrededor
  child: SvgPicture.asset('assets/logos/mv_logo.svg'),
)

// ❌ MAL: Logo demasiado pequeño
SvgPicture.asset('assets/logos/mv_logo.svg', width: 40)

// ❌ MAL: Logo con color cambiado
SvgPicture.asset(
  'assets/logos/mv_logo.svg',
  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
)
```

**Variantes de logo permitidas:**
- Logo completo (horizontal) - para headers y splash
- Logo icono (solo la manzana) - para app icon y espacios reducidos
- Logo blanco - SOLO sobre fondos oscuros o el verde primario de MV
- NUNCA distorsionar, rotar o cambiar proporciones del logo

### 3.2 App Icon

Generar guia para configurar el app icon correctamente:

```
App Icon de Manzana Verde:
- Fondo: #227A4B (mv-green-500) o blanco
- Icono: La manzana de MV centrada
- Sin texto en el icono (no cabe en tamanos pequenos)
- Tamanos necesarios:
  Android: 48, 72, 96, 144, 192, 512 px
  iOS: 20, 29, 40, 58, 60, 80, 87, 120, 180, 1024 px

Herramienta recomendada para generar todos los tamanos:
- Paquete flutter_launcher_icons en pubspec.yaml
```

Generar configuracion en `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/logos/mv_icon.png"  # 1024x1024 PNG
  min_sdk_android: 21
  adaptive_icon_background: "#227A4B"
  adaptive_icon_foreground: "assets/logos/mv_icon_foreground.png"
```

### 3.3 Splash Screen

**Preguntar:**
```
¿Como es actualmente tu splash screen?

A) No tengo splash screen configurado
B) Es el splash por defecto de Flutter (blanco con logo Flutter)
C) Tenemos algo personalizado pero no se ve bien
D) Ya esta correcto con la marca de MV
```

**Configuracion recomendada del splash screen:**

```
Splash Screen de MV:
- Fondo: #227A4B (verde primario) o #FAFAFA (gris claro)
- Centro: Logo MV completo o icono
- Animacion: Fade in suave (300ms)
- Duracion: Maximo 2 segundos antes de ir a la siguiente pantalla

Paquete recomendado: flutter_native_splash
```

Generar `flutter_native_splash.yaml`:

```yaml
flutter_native_splash:
  color: "#227A4B"
  image: assets/logos/mv_logo_white.png
  android_12:
    image: assets/logos/mv_icon.png
    icon_background_color: "#227A4B"
  ios: true
  android: true
  web: false
```

### 3.4 Tonalidad del texto (Voz de la marca)

**Como habla Manzana Verde:**

La voz de MV es: **cercana, positiva, directa y motivadora**. Como un amigo que te apoya a comer mejor, no como un doctor que te regana.

```dart
// ✅ BIEN: Voz MV - cercana y positiva
Text('¡Tu comida esta en camino!')
Text('Selecciona tus comidas de la semana')
Text('No encontramos pedidos recientes')  // directo, sin drama
Text('Algo salio mal. Intenta de nuevo')  // sencillo, no tecnico

// ❌ MAL: Muy formal o tecnico
Text('Error 404: Recurso no encontrado')
Text('La solicitud ha sido procesada exitosamente')
Text('No existen registros en la base de datos')

// ❌ MAL: Muy agresivo o alarmante
Text('ERROR CRITICO: No se pudo cargar')
Text('¡ADVERTENCIA! Sesion por expirar')
```

**Tabla de tono por situacion:**

| Situacion | Tono | Ejemplo |
|-----------|------|---------|
| Error de conexion | Tranquilo, con solucion | "Sin conexion a internet. Revisa tu red e intenta de nuevo." |
| Exito en pedido | Celebratorio pero discreto | "¡Listo! Tu pedido fue confirmado." |
| Carga de datos | Expectante | "Preparando tu menu..." |
| Lista vacia | Alentador | "Aun no tienes pedidos. ¡Empieza eligiendo tu plan!" |
| Error de formulario | Especifico y utilitario | "El numero de celular debe tener 10 digitos." |
| Onboarding | Emocionante, invitador | "Come rico y saludable, sin complicaciones." |

### 3.5 Iconografia

**Preguntar:**
```
¿Que iconos estas usando actualmente?

A) Solo los iconos de Material Design (Icons.*)
B) Una mezcla de Material y otros
C) Un paquete de iconos especifico (cual?)
D) Iconos personalizados SVG
```

**Recomendacion de iconos para MV:**

```dart
// ✅ Preferido: Lucide Icons (mismo paquete que en web MV)
// Agregar a pubspec.yaml: lucide_icons: ^0.0.x

import 'package:lucide_icons/lucide_icons.dart';

Icon(LucideIcons.shoppingCart, color: AppColors.mvGreen500)
Icon(LucideIcons.user, color: AppColors.mvGray500)
Icon(LucideIcons.home, color: AppColors.mvGreen500)

// ✅ Aceptable: Material Icons para iconos sin equivalente en Lucide
Icon(Icons.qr_code_scanner, color: AppColors.mvGreen500)

// ❌ Evitar mezclar sin criterio
// No usar Cupertino icons (se ven iOS-specific)
// No usar FontAwesome si lucide_icons tiene el equivalente
```

**Tamanos de iconos:**

```dart
// Standard sizes
const double iconSm = 16.0;   // Badges, labels
const double iconMd = 20.0;   // Botones, acciones inline
const double iconLg = 24.0;   // Navegacion, acciones principales
const double iconXl = 32.0;   // Ilustraciones pequeñas, empty states
```

### 3.6 Animaciones y microinteracciones

**La identidad de MV en movimiento:**

```dart
// ✅ BIEN: Transiciones suaves y discretas
// Duraciones recomendadas:
const Duration durationFast = Duration(milliseconds: 150);    // Feedback tactil
const Duration durationNormal = Duration(milliseconds: 250);   // Transiciones UI
const Duration durationSlow = Duration(milliseconds: 400);     // Aparicion de modales

// ✅ BIEN: Curvas naturales
const Curve curveNormal = Curves.easeInOut;
const Curve curveEnter = Curves.easeOut;
const Curve curveExit = Curves.easeIn;

// ✅ BIEN: Feedback en botones
// Usar InkWell o el efecto ripple de Material con el color de MV
InkWell(
  splashColor: AppColors.mvGreen500.withOpacity(0.1),
  highlightColor: AppColors.mvGreen50,
  borderRadius: AppBorders.button,
  onTap: onTap,
  child: child,
)

// ❌ MAL: Animaciones muy llamativas o largas
// No usar animaciones de mas de 600ms para acciones de usuario
// No usar animaciones que bloqueen la interaccion del usuario
// No usar animaciones sin proposito (solo para verse "cool")
```

### 3.7 Estados de carga

Los estados de carga deben ser coherentes con la marca:

```dart
// ✅ BIEN: Loading indicator en color MV
CircularProgressIndicator(
  color: AppColors.mvGreen500,
  strokeWidth: 2.5,
)

// ✅ BIEN: Skeleton loading (recomendado para listas)
// Usar shimmer o skeleton con el color mv-gray-200

// ❌ MAL: Spinners sin personalizar (azul por defecto de Material)
CircularProgressIndicator()  // Sin color = azul de Material
```

### 3.8 Mensajes de error y estados vacios

```dart
// Estructura recomendada para estados vacios
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      LucideIcons.inbox,  // Icono relevante al contexto
      size: 64,
      color: AppColors.mvGray200,
    ),
    SizedBox(height: AppSpacing.lg),
    Text(
      'Aun no tienes pedidos',  // Titulo positivo
      style: AppTypography.h4.copyWith(color: AppColors.mvGray900),
    ),
    SizedBox(height: AppSpacing.sm),
    Text(
      '¡Empieza eligiendo tu plan semanal!',  // Call to action alentador
      style: AppTypography.bodyMedium.copyWith(color: AppColors.mvGray500),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: AppSpacing.xxl),
    ElevatedButton(
      onPressed: onAction,
      child: Text('Ver planes'),
    ),
  ],
)
```

---

## Paso 4: Generar reporte de identidad de marca

Al finalizar la revision, generar un reporte en `docs/BRAND_AUDIT.md`:

```markdown
# Auditoria de Identidad de Marca
Fecha: [fecha]
Proyecto: [nombre]

## Puntuacion General
[X/10] - [calificacion]

## Estado por Area

| Area | Estado | Issues |
|------|--------|--------|
| Logo y elementos graficos | ✅/🚧/❌ | [descripcion] |
| App Icon | ✅/🚧/❌ | [descripcion] |
| Splash Screen | ✅/🚧/❌ | [descripcion] |
| Colores | ✅/🚧/❌ | [descripcion] |
| Tipografia | ✅/🚧/❌ | [descripcion] |
| Tonalidad del texto | ✅/🚧/❌ | [descripcion] |
| Iconografia | ✅/🚧/❌ | [descripcion] |
| Animaciones | ✅/🚧/❌ | [descripcion] |
| Estados de carga | ✅/🚧/❌ | [descripcion] |
| Estados vacios y errores | ✅/🚧/❌ | [descripcion] |

## Issues Criticos (requieren atencion inmediata)
[Lista]

## Issues Menores
[Lista]

## Recomendaciones
[Lista priorizada]
```

---

## Reglas criticas de marca

1. **NUNCA** modificar las proporciones o colores del logo de MV
2. **NUNCA** usar el logo con un fondo que genere mal contraste
3. **NUNCA** usar textos tecnicos o de error crudo hacia el usuario
4. **NUNCA** mezclar estilos de iconos sin criterio (lucide + material + cupertino random)
5. **SIEMPRE** mantener la voz positiva y cercana en todos los textos de UI
6. **SIEMPRE** usar transiciones suaves, nunca abruptas
7. **SIEMPRE** respetar el espacio libre alrededor del logo
8. **SIEMPRE** validar el contraste de colores (minimo 4.5:1 para texto normal)

---

## Relacionado

- Skill `/mv-dev:flutter-visual-style` - Configurar colores, tipografia y estilos
- Skill `/mv-dev:flutter-component` - Crear componentes que respetan la marca
- Skill `/mv-dev:flutter-new-screen` - Crear pantallas con identidad MV
- Archivo `DESIGN_TOKENS.md` en la raiz del plugin - Referencia completa del design system
