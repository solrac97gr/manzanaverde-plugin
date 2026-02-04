#!/bin/bash
# validate-nextjs-patterns.sh
# Valida que archivos Next.js sigan los patrones de MV.
# Se ejecuta como PostToolUse hook en Write/Edit de paginas y componentes.
#
# Exit 0 = OK
# Exit 1 = FAIL (con recomendaciones)

FILE_PATH="$1"

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

WARNINGS=0
ERRORS=0

# Solo validar archivos .tsx/.ts
if ! echo "$FILE_PATH" | grep -qE '\.(tsx|ts|jsx|js)$'; then
  exit 0
fi

CONTENT=$(cat "$FILE_PATH" 2>/dev/null)

# 1. Verificar uso de next/image en lugar de <img>
if echo "$CONTENT" | grep -qE '<img\s' 2>/dev/null; then
  if ! echo "$CONTENT" | grep -q "from 'next/image'" 2>/dev/null; then
    echo "ADVERTENCIA: Usar next/image en lugar de <img> para optimizacion de imagenes"
    echo "  Archivo: $FILE_PATH"
    echo "  Solucion: import Image from 'next/image'; y usar <Image src={...} alt={...} width={...} height={...} />"
    echo ""
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# 2. Verificar metadata export en paginas (page.tsx)
if echo "$FILE_PATH" | grep -qE '/page\.(tsx|ts)$' 2>/dev/null; then
  if ! echo "$CONTENT" | grep -qE '(export const metadata|export async function generateMetadata)' 2>/dev/null; then
    echo "ADVERTENCIA: Paginas Next.js deben exportar metadata para SEO"
    echo "  Archivo: $FILE_PATH"
    echo "  Solucion: Agregar export const metadata: Metadata = { title: '...', description: '...' };"
    echo ""
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# 3. Verificar colores hardcodeados (hex) en lugar de design tokens
HARDCODED_COLORS=$(echo "$CONTENT" | grep -noE '(bg|text|border|ring|shadow)-\[#[0-9a-fA-F]{3,8}\]' 2>/dev/null | head -5)
if [ -n "$HARDCODED_COLORS" ]; then
  echo "ADVERTENCIA: Colores hardcodeados detectados. Usar design tokens de MV."
  echo "  Archivo: $FILE_PATH"
  echo "  Encontrados:"
  echo "$HARDCODED_COLORS" | while IFS= read -r line; do
    echo "    Linea $line"
  done
  echo "  Solucion: Usar bg-primary, text-mv-green, border-mv-gray-200, etc."
  echo "  Referencia: /mv-design-system"
  echo ""
  WARNINGS=$((WARNINGS + 1))
fi

# 4. Verificar 'use client' innecesario
if echo "$CONTENT" | grep -q "^'use client'" 2>/dev/null; then
  # Si tiene 'use client' pero no usa hooks ni event handlers
  HAS_HOOKS=$(echo "$CONTENT" | grep -cE '(useState|useEffect|useReducer|useRef|useCallback|useMemo|useContext)\(' 2>/dev/null)
  HAS_EVENTS=$(echo "$CONTENT" | grep -cE '(onClick|onChange|onSubmit|onKeyDown|onFocus|onBlur)\s*[={]' 2>/dev/null)
  HAS_BROWSER=$(echo "$CONTENT" | grep -cE '\b(window|document|navigator|localStorage|sessionStorage)\b' 2>/dev/null)

  if [ "$HAS_HOOKS" -eq 0 ] && [ "$HAS_EVENTS" -eq 0 ] && [ "$HAS_BROWSER" -eq 0 ]; then
    echo "ADVERTENCIA: 'use client' puede ser innecesario"
    echo "  Archivo: $FILE_PATH"
    echo "  No se detectaron hooks, event handlers ni browser APIs."
    echo "  Solucion: Remover 'use client' para usar Server Components (mejor performance)"
    echo ""
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# 5. Verificar componentes muy largos (> 200 lineas)
LINE_COUNT=$(wc -l < "$FILE_PATH" 2>/dev/null)
if [ "$LINE_COUNT" -gt 200 ] 2>/dev/null; then
  echo "ADVERTENCIA: Componente con $LINE_COUNT lineas (recomendado: < 200)"
  echo "  Archivo: $FILE_PATH"
  echo "  Solucion: Extraer sub-componentes o hooks para mejorar legibilidad"
  echo ""
  WARNINGS=$((WARNINGS + 1))
fi

# 6. Verificar que usa font-heading o font-body
if echo "$CONTENT" | grep -qE '<h[1-6]' 2>/dev/null; then
  if ! echo "$CONTENT" | grep -q 'font-heading' 2>/dev/null; then
    echo "ADVERTENCIA: Headings deben usar font-heading (Inter)"
    echo "  Archivo: $FILE_PATH"
    echo "  Solucion: Agregar className=\"font-heading\" a elementos h1-h6"
    echo ""
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# Resultado
if [ $ERRORS -gt 0 ]; then
  echo "========================================="
  echo "Next.js Patterns: FAILED ($ERRORS errores, $WARNINGS advertencias)"
  exit 1
fi

if [ $WARNINGS -gt 0 ]; then
  echo "========================================="
  echo "Next.js Patterns: PASSED con $WARNINGS advertencias"
  echo "Las advertencias no bloquean, pero se recomienda corregirlas."
fi

exit 0
