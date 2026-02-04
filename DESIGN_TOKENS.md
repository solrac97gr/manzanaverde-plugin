# Design Tokens - Manzana Verde

Sistema de diseño base para todos los proyectos de Manzana Verde. Tokens extraidos de la landing de pedidos WhatsApp (Design System v3.0).

Inspirado en: App oficial Manzana Verde, Sweetgreen, CAVA, Chipotle, Factor.

---

## Colores de Marca

### Verde Primario (Manzana Verde)

Color principal de la marca. Se usa en botones, estados activos, enlaces y elementos de identidad.

| Token              | Hex       | Uso                                  |
|--------------------|-----------|--------------------------------------|
| `mv-green-50`      | `#E8F5EC` | Fondos sutiles, badges ligeros       |
| `mv-green-100`     | `#C5E6CE` | Fondos muted, hover suave            |
| `mv-green-200`     | `#9ED6AE` | Bordes suaves, decorativo            |
| `mv-green-300`     | `#6BBF8A` | Iconos secundarios                   |
| `mv-green-400`     | `#3D9A5F` | Texto sobre fondos claros            |
| **`mv-green-500`** | **`#227A4B`** | **Primary - Color principal de marca** |
| `mv-green-600`     | `#1D6A41` | Hover de botones primarios           |
| `mv-green-700`     | `#185A37` | Active/pressed de botones            |
| `mv-green-800`     | `#134A2D` | Texto sobre fondos claros (alto contraste) |
| `mv-green-900`     | `#0E3A23` | Sombras, bordes oscuros              |

### Naranja Secundario

Acentos del app: badges de envio gratis, tiempos de entrega (ETA), warnings.

| Token              | Hex       | Uso                                |
|--------------------|-----------|------------------------------------|
| `mv-orange-50`     | `#FFF4E6` | Fondos de alertas, banners         |
| `mv-orange-100`    | `#FFE4C4` | Fondos hover de alertas            |
| `mv-orange-400`    | `#F28B2D` | Iconos, badges secundarios         |
| **`mv-orange-500`**| **`#E85D04`** | **Secondary - Naranja principal** |
| `mv-orange-600`    | `#D4540A` | Hover de elementos naranja         |

### Amarillo Terciario

Acento del logo (hoja dorada), elementos promocionales.

| Token              | Hex       | Uso                                |
|--------------------|-----------|------------------------------------|
| `mv-yellow-50`     | `#FFFBEB` | Fondos de promos                   |
| `mv-yellow-100`    | `#FEF3C7` | Fondos hover de promos             |
| `mv-yellow-400`    | `#F0C94D` | Badges, estrellas, highlights      |
| **`mv-yellow-500`**| **`#E5B83C`** | **Tertiary - Amarillo principal** |
| `mv-yellow-600`    | `#D4A72C` | Hover de elementos amarillos       |

---

## Colores Neutros

Escala de grises calibrada para UI limpia y legible.

| Token          | Hex       | Uso                                      |
|----------------|-----------|------------------------------------------|
| `mv-white`     | `#FFFFFF` | Cards, modales, superficies elevadas     |
| `mv-gray-25`   | `#FCFCFC` | Fondo alternativo sutil                  |
| `mv-gray-50`   | `#FAFAFA` | **Fondo de pagina principal**            |
| `mv-gray-100`  | `#F5F5F5` | Fondos de secciones, inputs deshabilitados |
| `mv-gray-150`  | `#F0F0F0` | Divisores sutiles                        |
| `mv-gray-200`  | `#E8E8E8` | **Bordes estandar**, divisores           |
| `mv-gray-300`  | `#D4D4D4` | Bordes hover, scrollbars                 |
| `mv-gray-400`  | `#A3A3A3` | Iconos deshabilitados, placeholder       |
| `mv-gray-500`  | `#737373` | **Texto secundario/muted**               |
| `mv-gray-600`  | `#525252` | Texto medio                              |
| `mv-gray-700`  | `#404040` | Texto oscuro secundario                  |
| `mv-gray-800`  | `#262626` | Texto principal alternativo              |
| `mv-gray-900`  | `#171717` | **Texto principal (headings, body)**     |
| `mv-black`     | `#0A0A0A` | Texto maximo contraste                   |

---

## Colores Semanticos

Para estados y feedback del sistema.

| Token        | Valor          | Hex       | Uso                          |
|--------------|----------------|-----------|------------------------------|
| `success`    | `mv-green-500` | `#227A4B` | Confirmaciones, exito        |
| `warning`    | `mv-orange-500`| `#E85D04` | Advertencias, atencion       |
| `error`      | —              | `#DC2626` | Errores, validacion fallida  |
| `info`       | —              | `#0EA5E9` | Informacion, tips            |

---

## Superficies y Componentes

Aliases semanticos para uso en componentes.

| Token                 | Resuelve a       | Uso                          |
|-----------------------|------------------|------------------------------|
| `background`          | `mv-gray-50`     | Fondo de pagina              |
| `background-card`     | `mv-white`       | Fondo de cards               |
| `background-elevated` | `mv-white`       | Modales, popovers            |
| `foreground`          | `mv-gray-900`    | Texto principal              |
| `foreground-muted`    | `mv-gray-500`    | Texto secundario             |
| `primary`             | `mv-green-500`   | Color de accion principal    |
| `primary-hover`       | `mv-green-600`   | Hover de primary             |
| `primary-active`      | `mv-green-700`   | Active/pressed de primary    |
| `primary-light`       | `mv-green-50`    | Fondos sutiles de primary    |
| `primary-muted`       | `mv-green-100`   | Fondos muted de primary      |

---

## Tipografia

### Familias Tipograficas

| Rol        | Fuente   | Fallback                                     | Pesos           |
|------------|----------|----------------------------------------------|-----------------|
| Headings   | Inter    | system-ui, -apple-system, BlinkMacSystemFont, sans-serif | 400, 500, 600, 700, 800 |
| Body/UI    | Nunito   | system-ui, -apple-system, BlinkMacSystemFont, sans-serif | 400, 500, 600, 700      |

**Fuente:** Google Fonts
**Import:** `https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Nunito:wght@400;500;600;700&display=swap`

### Escala Tipografica

| Elemento     | Fuente  | Tamano  | Peso  | Line-height |
|--------------|---------|---------|-------|-------------|
| h1           | Inter   | 28px    | 700   | 1.25        |
| h2           | Inter   | 22px    | 600   | 1.25        |
| h3           | Inter   | 18px    | 600   | 1.25        |
| h4           | Inter   | 16px    | 600   | 1.25        |
| Body         | Nunito  | 15px    | 400   | 1.5         |
| Body semibold| Nunito  | 15px    | 600   | 1.5         |
| Buttons      | Nunito  | 14-16px | 600-700 | 1.5       |
| Small        | Nunito  | 12-13px | 500   | 1.5         |
| Caption      | Nunito  | 10-12px | 400-500 | 1.5       |

### Rendering

```css
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
```

---

## Bordes

| Token            | Resuelve a    | Uso                            |
|------------------|---------------|--------------------------------|
| `border-default` | `mv-gray-200` | Bordes estandar de cards       |
| `border-subtle`  | `mv-gray-150` | Divisores suaves               |
| `border-hover`   | `mv-gray-300` | Bordes en hover                |
| `border-focus`   | `mv-green-500`| Outline de focus (accesibilidad) |

### Focus Visible

```css
outline: 2px solid var(--primary);
outline-offset: 2px;
```

---

## Sombras

Sistema de elevacion de 5 niveles + sombras de marca.

| Token            | Valor                                                              | Uso                        |
|------------------|--------------------------------------------------------------------|----------------------------|
| `shadow-xs`      | `0 1px 2px 0 rgb(0 0 0 / 0.03)`                                   | Inputs, elementos planos   |
| `shadow-sm`      | `0 1px 3px 0 rgb(0 0 0 / 0.04), 0 1px 2px -1px rgb(0 0 0 / 0.04)` | Cards, botones default     |
| `shadow-md`      | `0 4px 6px -1px rgb(0 0 0 / 0.05), 0 2px 4px -2px rgb(0 0 0 / 0.05)` | Cards hover, elevacion media |
| `shadow-lg`      | `0 10px 15px -3px rgb(0 0 0 / 0.06), 0 4px 6px -4px rgb(0 0 0 / 0.06)` | Modales, dropdowns         |
| `shadow-xl`      | `0 20px 25px -5px rgb(0 0 0 / 0.08), 0 8px 10px -6px rgb(0 0 0 / 0.08)` | Modales criticos, overlays |
| `shadow-primary` | `0 4px 14px 0 rgb(34 122 75 / 0.25)`                              | CTAs, botones primarios    |
| `shadow-primary-lg` | `0 8px 25px 0 rgb(34 122 75 / 0.3)`                           | CTAs enfatizados           |

---

## Border Radius

| Token         | Valor     | Uso                                     |
|---------------|-----------|-----------------------------------------|
| `radius-xs`   | `6px`     | Badges pequenos, tags                   |
| `radius-sm`   | `8px`     | Inputs, botones compactos               |
| `radius-md`   | `12px`    | Botones, contenedores medianos          |
| `radius-lg`   | `16px`    | Cards secundarias                       |
| `radius-xl`   | `20px`    | Cards principales, modales              |
| `radius-2xl`  | `24px`    | Cards hero, contenedores grandes        |
| `radius-3xl`  | `32px`    | Elementos decorativos                   |
| `radius-full` | `9999px`  | Circulos, pills, avatares               |

### Patrones de uso comun

| Componente          | Tailwind Class | Equivale a    |
|---------------------|----------------|---------------|
| Cards principales   | `rounded-2xl`  | ~`radius-xl`  |
| Botones             | `rounded-xl`   | ~`radius-xl`  |
| Badges/Pills        | `rounded-lg`   | ~`radius-lg`  |
| Inputs              | `rounded-md`   | ~`radius-md`  |
| Avatares            | `rounded-full` | `radius-full` |
| Modal (mobile top)  | `rounded-t-[28px]` | Custom    |

---

## Spacing

Escala basada en multiplos de 4px.

| Token      | Valor  | Uso                               |
|------------|--------|-----------------------------------|
| `space-1`  | `4px`  | Gaps minimos, padding interno     |
| `space-2`  | `8px`  | Padding de badges, gaps pequenos  |
| `space-3`  | `12px` | Padding de botones, gaps medianos |
| `space-4`  | `16px` | **Base** - padding de cards, gaps estandar |
| `space-5`  | `20px` | Separacion de secciones pequenas  |
| `space-6`  | `24px` | Padding de contenedores           |
| `space-8`  | `32px` | Separacion de secciones grandes   |
| `space-10` | `40px` | Margenes de seccion               |
| `space-12` | `48px` | Espaciado entre bloques hero      |

### Responsive spacing

| Viewport   | Padding horizontal | Patron Tailwind       |
|------------|--------------------|-----------------------|
| Mobile     | 16px               | `px-4`                |
| Tablet     | 24px               | `sm:px-6`             |
| Desktop    | 32px               | `lg:px-8`             |

---

## Transiciones y Animaciones

### Curvas de Easing

| Nombre   | Valor                              | Uso                                |
|----------|------------------------------------|------------------------------------|
| Standard | `cubic-bezier(0.4, 0, 0.2, 1)`    | Transiciones generales (Material Design) |
| Bounce   | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Interacciones divertidas, notificaciones |

### Duraciones

| Token              | Duracion | Uso                                  |
|--------------------|----------|--------------------------------------|
| `transition-fast`  | `150ms`  | Micro-interacciones (hover, toggle)  |
| `transition-normal`| `200ms`  | Transiciones estandar                |
| `transition-slow`  | `300ms`  | Animaciones de modales, slideUp      |
| `transition-bounce`| `400ms`  | Transiciones playful (con bounce)    |

### Animaciones Pre-definidas

| Nombre           | Tipo      | Uso                                |
|------------------|-----------|------------------------------------|
| `fadeIn`         | Entrada   | Aparicion suave de elementos       |
| `slideUp`        | Entrada   | Cards, contenido que sube          |
| `slideDown`      | Entrada   | Dropdowns, menus                   |
| `scaleIn`        | Entrada   | Modales, popovers                  |
| `pulse-soft`     | Atencion  | Indicadores de carga, badges       |
| `bounce-subtle`  | Atencion  | Botones, llamadas de atencion      |
| `spin`           | Loading   | Spinners de carga                  |
| `shimmer`        | Loading   | Skeleton loading placeholders      |

### Clases CSS de Animacion

```css
.animate-fadeIn    /* fadeIn 200ms ease-out */
.animate-slideUp   /* slideUp 300ms ease-out */
.animate-slideDown /* slideDown 200ms ease-out */
.animate-scaleIn   /* scaleIn 200ms ease-out */
```

---

## Breakpoints (Responsive)

Breakpoints de Tailwind CSS (default).

| Prefix | Min-width | Dispositivo           |
|--------|------------|----------------------|
| (base) | 0px        | Mobile               |
| `sm`   | 640px      | Mobile grande/Tablet |
| `md`   | 768px      | Tablet               |
| `lg`   | 1024px     | Desktop              |
| `xl`   | 1280px     | Desktop grande       |
| `2xl`  | 1536px     | Ultra-wide           |

**Estrategia:** Mobile-first. Clases base aplican a mobile, prefijos para pantallas mayores.

---

## Efectos Especiales

### Backdrop Blur (Efecto Premium)

```css
backdrop-blur-xl         /* 20px blur - headers sticky, overlays */
backdrop-blur-sm         /* 4px blur - elementos sutiles */
-webkit-backdrop-filter  /* Soporte Safari */
```

### Safe Area (Mobile Notches)

```css
padding-bottom: max(16px, env(safe-area-inset-bottom));
```

### Scrollbar Personalizado

```css
scrollbar-width: thin;
scrollbar-color: var(--mv-gray-300) transparent;
/* Webkit: 6px width, radius 3px */
```

---

## Gradientes de Marca

Patrones de gradiente recurrentes en componentes.

| Nombre                 | Valor                                             | Uso                    |
|------------------------|---------------------------------------------------|------------------------|
| Primary Button         | `from-[#227A4B] to-[#1D6A41]`                     | Botones CTA            |
| Primary Button Hover   | `from-[#1D6A41] to-[#185A37]`                     | Hover de CTA           |
| Delivery Toggle Active | `from-[#227A4B] to-[#2a8f5a]`                     | Toggle activo          |
| Promo Badge            | `from-red-500 to-rose-500`                         | Descuentos             |
| Orange Alert BG        | `from-amber-50 to-orange-50`                       | Banners de info        |
| Skeleton Loading       | `90deg, gray-200 25%, gray-100 50%, gray-200 75%` | Placeholders           |

---

## Tailwind Theme Extension (v4)

Configuracion para `@theme inline` en Tailwind CSS v4.

```css
@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --color-primary: var(--primary);
  --color-primary-hover: var(--primary-hover);
  --color-primary-light: var(--primary-light);
  --color-mv-green: var(--mv-green-500);
  --color-mv-green-dark: var(--mv-green-700);
  --color-mv-green-light: var(--mv-green-400);
  --color-mv-green-pale: var(--mv-green-50);
  --color-mv-yellow: var(--mv-yellow-500);
  --color-mv-orange: var(--mv-orange-500);
  --color-mv-orange-light: var(--mv-orange-50);
}
```

Esto permite usar clases como `bg-primary`, `text-mv-green`, `bg-mv-orange-light` directamente en Tailwind.

---

## Uso Rapido - CSS Custom Properties

Para copiar a nuevos proyectos, incluir este bloque completo de variables en `:root`:

```css
:root {
  /* Verdes */
  --mv-green-50: #E8F5EC;
  --mv-green-100: #C5E6CE;
  --mv-green-200: #9ED6AE;
  --mv-green-300: #6BBF8A;
  --mv-green-400: #3D9A5F;
  --mv-green-500: #227A4B;
  --mv-green-600: #1D6A41;
  --mv-green-700: #185A37;
  --mv-green-800: #134A2D;
  --mv-green-900: #0E3A23;

  /* Naranjas */
  --mv-orange-50: #FFF4E6;
  --mv-orange-100: #FFE4C4;
  --mv-orange-400: #F28B2D;
  --mv-orange-500: #E85D04;
  --mv-orange-600: #D4540A;

  /* Amarillos */
  --mv-yellow-50: #FFFBEB;
  --mv-yellow-100: #FEF3C7;
  --mv-yellow-400: #F0C94D;
  --mv-yellow-500: #E5B83C;
  --mv-yellow-600: #D4A72C;

  /* Neutros */
  --mv-white: #FFFFFF;
  --mv-gray-50: #FAFAFA;
  --mv-gray-100: #F5F5F5;
  --mv-gray-150: #F0F0F0;
  --mv-gray-200: #E8E8E8;
  --mv-gray-300: #D4D4D4;
  --mv-gray-400: #A3A3A3;
  --mv-gray-500: #737373;
  --mv-gray-600: #525252;
  --mv-gray-700: #404040;
  --mv-gray-800: #262626;
  --mv-gray-900: #171717;
  --mv-black: #0A0A0A;

  /* Semanticos */
  --mv-success: #227A4B;
  --mv-warning: #E85D04;
  --mv-error: #DC2626;
  --mv-info: #0EA5E9;
}
```
