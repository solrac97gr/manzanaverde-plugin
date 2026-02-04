---
description: Design system de Manzana Verde - colores, tipografia, componentes, spacing y patrones de UI con Tailwind CSS v4
---

# Design System de Manzana Verde

Referencia completa del design system para crear interfaces consistentes con la identidad visual de MV.

## Colores de Marca

### Verde Primario (Color principal)

| Token | Hex | Clase Tailwind | Uso |
|-------|-----|----------------|-----|
| `mv-green-50` | `#E8F5EC` | `bg-mv-green-pale` | Fondos sutiles, badges |
| `mv-green-100` | `#C5E6CE` | `bg-[#C5E6CE]` | Fondos muted, hover suave |
| `mv-green-200` | `#9ED6AE` | `bg-[#9ED6AE]` | Bordes decorativos |
| `mv-green-300` | `#6BBF8A` | `text-[#6BBF8A]` | Iconos secundarios |
| `mv-green-400` | `#3D9A5F` | `text-mv-green-light` | Texto sobre fondos claros |
| **`mv-green-500`** | **`#227A4B`** | **`bg-primary` / `text-mv-green`** | **Color principal** |
| `mv-green-600` | `#1D6A41` | `bg-primary-hover` | Hover de botones |
| `mv-green-700` | `#185A37` | `bg-mv-green-dark` | Active/pressed |
| `mv-green-800` | `#134A2D` | `text-[#134A2D]` | Alto contraste |
| `mv-green-900` | `#0E3A23` | `text-[#0E3A23]` | Sombras oscuras |

### Naranja Secundario

| Token | Hex | Clase Tailwind | Uso |
|-------|-----|----------------|-----|
| `mv-orange-50` | `#FFF4E6` | `bg-mv-orange-light` | Fondos de alertas |
| `mv-orange-500` | `#E85D04` | `bg-mv-orange` | Badges, ETAs, warnings |
| `mv-orange-600` | `#D4540A` | `hover:bg-[#D4540A]` | Hover naranja |

### Amarillo Terciario

| Token | Hex | Clase Tailwind | Uso |
|-------|-----|----------------|-----|
| `mv-yellow-50` | `#FFFBEB` | `bg-[#FFFBEB]` | Fondos de promos |
| `mv-yellow-500` | `#E5B83C` | `text-mv-yellow` | Promos, estrellas |

### Semanticos

| Estado | Hex | Clase | Uso |
|--------|-----|-------|-----|
| Success | `#227A4B` | `text-green-700` | Confirmaciones |
| Warning | `#E85D04` | `text-orange-600` | Advertencias |
| Error | `#DC2626` | `text-red-600` | Errores |
| Info | `#0EA5E9` | `text-sky-500` | Informacion |

### Neutros

| Token | Hex | Uso |
|-------|-----|-----|
| `mv-gray-50` | `#FAFAFA` | Fondo de pagina |
| `mv-gray-100` | `#F5F5F5` | Fondos de secciones |
| `mv-gray-200` | `#E8E8E8` | Bordes estandar |
| `mv-gray-300` | `#D4D4D4` | Bordes hover |
| `mv-gray-400` | `#A3A3A3` | Placeholder text |
| `mv-gray-500` | `#737373` | Texto secundario |
| `mv-gray-700` | `#404040` | Texto oscuro |
| `mv-gray-900` | `#171717` | Texto principal |

## Tipografia

### Familias

- **Headings:** `Inter` (font-heading)
- **Body/UI:** `Nunito` (font-body)

```html
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Nunito:wght@400;500;600;700&display=swap" rel="stylesheet">
```

### Escala

| Elemento | Fuente | Tamano | Peso | Tailwind |
|----------|--------|--------|------|----------|
| h1 | Inter | 28px | 700 | `font-heading text-[28px] font-bold` |
| h2 | Inter | 22px | 600 | `font-heading text-[22px] font-semibold` |
| h3 | Inter | 18px | 600 | `font-heading text-lg font-semibold` |
| h4 | Inter | 16px | 600 | `font-heading text-base font-semibold` |
| Body | Nunito | 15px | 400 | `font-body text-[15px]` |
| Body bold | Nunito | 15px | 600 | `font-body text-[15px] font-semibold` |
| Buttons | Nunito | 14-16px | 600-700 | `font-body text-sm font-semibold` |
| Small | Nunito | 12-13px | 500 | `font-body text-xs font-medium` |
| Caption | Nunito | 10-12px | 400-500 | `font-body text-[10px]` |

### Rendering
```css
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
```

## Spacing

Base: **4px**. Usar multiplos de Tailwind.

| Token | Valor | Tailwind | Uso |
|-------|-------|----------|-----|
| space-1 | 4px | `p-1` / `gap-1` | Gaps minimos |
| space-2 | 8px | `p-2` / `gap-2` | Padding de badges |
| space-3 | 12px | `p-3` / `gap-3` | Padding de botones |
| space-4 | 16px | `p-4` / `gap-4` | **Base** - padding de cards |
| space-6 | 24px | `p-6` / `gap-6` | Padding de contenedores |
| space-8 | 32px | `p-8` / `gap-8` | Separacion de secciones |

### Responsive padding

| Viewport | Padding | Tailwind |
|----------|---------|----------|
| Mobile | 16px | `px-4` |
| Tablet | 24px | `sm:px-6` |
| Desktop | 32px | `lg:px-8` |

## Border Radius

| Componente | Tailwind | Valor |
|------------|----------|-------|
| Cards principales | `rounded-2xl` | 16px |
| Botones | `rounded-xl` | 12px |
| Badges/Pills | `rounded-lg` | 8px |
| Inputs | `rounded-md` | 6px |
| Avatares | `rounded-full` | 9999px |

## Sombras

| Token | Tailwind | Uso |
|-------|----------|-----|
| shadow-xs | `shadow-xs` | Inputs |
| shadow-sm | `shadow-sm` | Cards default |
| shadow-md | `shadow-md` | Cards hover |
| shadow-lg | `shadow-lg` | Modales |
| shadow-primary | `shadow-[0_4px_14px_0_rgb(34_122_75/0.25)]` | CTAs |

## Componentes Base

### Boton Primario

```tsx
<button className="
  bg-gradient-to-b from-[#227A4B] to-[#1D6A41]
  hover:from-[#1D6A41] hover:to-[#185A37]
  text-white font-body font-semibold
  px-6 py-3 rounded-xl
  shadow-[0_4px_14px_0_rgb(34_122_75/0.25)]
  hover:shadow-[0_8px_25px_0_rgb(34_122_75/0.3)]
  transition-all duration-200
  active:scale-[0.98]
">
  Ordenar ahora
</button>
```

### Boton Secundario

```tsx
<button className="
  bg-white border border-mv-gray-200
  hover:border-primary hover:text-primary
  text-mv-gray-700 font-body font-semibold
  px-6 py-3 rounded-xl
  shadow-sm hover:shadow-md
  transition-all duration-200
">
  Ver menu
</button>
```

### Card

```tsx
<div className="
  bg-white rounded-2xl
  border border-mv-gray-200
  shadow-sm hover:shadow-md
  transition-shadow duration-200
  p-4
">
  {/* Contenido */}
</div>
```

### Input

```tsx
<input className="
  w-full px-4 py-3
  rounded-md border border-mv-gray-200
  bg-white text-mv-gray-900
  placeholder:text-mv-gray-400
  focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary
  font-body text-[15px]
  transition-colors duration-150
" />
```

### Badge

```tsx
// Success badge
<span className="inline-flex items-center px-2.5 py-1 rounded-lg bg-mv-green-pale text-mv-green font-body text-xs font-medium">
  Entregado
</span>

// Warning badge
<span className="inline-flex items-center px-2.5 py-1 rounded-lg bg-mv-orange-light text-mv-orange font-body text-xs font-medium">
  En camino
</span>
```

### Modal (Mobile-first)

```tsx
<div className="
  fixed inset-0 z-50
  flex items-end sm:items-center justify-center
">
  {/* Overlay */}
  <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />

  {/* Content */}
  <div className="
    relative bg-white w-full sm:max-w-lg
    rounded-t-[28px] sm:rounded-2xl
    p-6 pb-[max(24px,env(safe-area-inset-bottom))]
    animate-slideUp
  ">
    {/* ... */}
  </div>
</div>
```

## Iconos

Usar **Lucide React** exclusivamente.

```tsx
import { ShoppingCart, Heart, MapPin, Clock, ChevronRight } from 'lucide-react';

// Tamanos estandar
<ShoppingCart className="w-5 h-5" />     // Default
<Heart className="w-4 h-4" />            // Pequeno
<MapPin className="w-6 h-6" />           // Grande
```

## Imagenes

Siempre usar `next/image` de Next.js:

```tsx
import Image from 'next/image';

<Image
  src={meal.imageUrl}
  alt={meal.name}
  width={400}
  height={300}
  className="rounded-xl object-cover"
  priority={isAboveTheFold}
/>
```

## Animaciones

### Transiciones estandar

```css
transition-all duration-200          /* Default */
transition-all duration-150          /* Micro-interacciones */
transition-all duration-300          /* Modales, slideUp */
```

### Clases de animacion

```css
animate-fadeIn      /* Aparicion suave */
animate-slideUp     /* Cards, contenido que sube */
animate-slideDown   /* Dropdowns */
animate-scaleIn     /* Modales */
```

## Tailwind v4 - Configuracion del Theme

Incluir en el CSS principal del proyecto:

```css
@import "tailwindcss";

@theme inline {
  --color-background: #FAFAFA;
  --color-foreground: #171717;
  --color-primary: #227A4B;
  --color-primary-hover: #1D6A41;
  --color-primary-light: #E8F5EC;
  --color-mv-green: #227A4B;
  --color-mv-green-dark: #185A37;
  --color-mv-green-light: #3D9A5F;
  --color-mv-green-pale: #E8F5EC;
  --color-mv-orange: #E85D04;
  --color-mv-orange-light: #FFF4E6;
  --color-mv-yellow: #E5B83C;
  --font-heading: 'Inter', system-ui, sans-serif;
  --font-body: 'Nunito', system-ui, sans-serif;
}
```

## Breakpoints

| Prefix | Min-width | Dispositivo |
|--------|-----------|-------------|
| (base) | 0px | Mobile |
| `sm` | 640px | Tablet |
| `md` | 768px | Tablet grande |
| `lg` | 1024px | Desktop |
| `xl` | 1280px | Desktop grande |

**Estrategia:** Mobile-first. Siempre empezar con mobile y agregar prefijos para pantallas mayores.

## Accesibilidad

- Contraste minimo: 4.5:1 para texto, 3:1 para elementos grandes
- Focus visible: `focus:outline-2 focus:outline-primary focus:outline-offset-2`
- ARIA labels en todos los elementos interactivos sin texto visible
- Navegacion por teclado en todos los componentes interactivos
- Semantic HTML: `<button>` para acciones, `<a>` para navegacion
