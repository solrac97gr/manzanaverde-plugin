#!/bin/bash
# validate-flutter-patterns.sh
# Valida patrones de Flutter y estandares de MV en archivos Dart
# Se ejecuta automaticamente despues de Write/Edit en archivos .dart

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Uso: validate-flutter-patterns.sh <ruta-al-archivo>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  exit 0
fi

WARNINGS=()
ERRORS=()
BASENAME=$(basename "$FILE")

# =============================================================================
# VALIDACION 1: Colores hardcodeados (ERROR CRITICO)
# =============================================================================

# Detectar Color(0xFF...) hardcodeados (excepto en archivos de tema)
if [[ "$FILE" != *"app_colors.dart"* ]] && [[ "$FILE" != *"app_theme.dart"* ]]; then
  HARDCODED_COLORS=$(grep -n "Color(0x" "$FILE" 2>/dev/null)
  if [ -n "$HARDCODED_COLORS" ]; then
    while IFS= read -r line; do
      ERRORS+=("❌ Color hex hardcodeado en $BASENAME: $line")
      ERRORS+=("   → Usar AppColors.* en lugar de Color(0x...)")
    done <<< "$HARDCODED_COLORS"
  fi
fi

# Detectar Colors.green, Colors.red, etc. genericos de Material
MATERIAL_COLORS=$(grep -n "Colors\.\(green\|red\|blue\|orange\|yellow\|purple\|pink\|teal\|cyan\|indigo\|brown\|grey\|blueGrey\)\b" "$FILE" 2>/dev/null)
if [ -n "$MATERIAL_COLORS" ]; then
  while IFS= read -r line; do
    WARNINGS+=("⚠️  Color generico de Material en $BASENAME: $line")
    WARNINGS+=("   → Verificar si debe ser un token de AppColors.*")
  done <<< "$MATERIAL_COLORS"
fi

# =============================================================================
# VALIDACION 2: FontSize hardcodeados (ADVERTENCIA)
# =============================================================================

if [[ "$FILE" != *"app_typography.dart"* ]]; then
  HARDCODED_FONT=$(grep -n "fontSize: [0-9]" "$FILE" 2>/dev/null)
  if [ -n "$HARDCODED_FONT" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  fontSize hardcodeado en $BASENAME: $line")
      WARNINGS+=("   → Usar AppTypography.* (ej: AppTypography.bodyMedium)")
    done <<< "$HARDCODED_FONT"
  fi
fi

# =============================================================================
# VALIDACION 3: Spacing con numeros magicos (ADVERTENCIA)
# =============================================================================

if [[ "$FILE" != *"app_spacing.dart"* ]]; then
  # Detectar EdgeInsets con numeros que no son 0
  MAGIC_SPACING=$(grep -n "EdgeInsets\.all([1-9]\|EdgeInsets\.symmetric([a-z]*: [1-9]\|EdgeInsets\.only([a-z]*: [1-9]" "$FILE" 2>/dev/null | grep -v "AppSpacing\." | grep -v "// OK")
  if [ -n "$MAGIC_SPACING" ]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  Spacing con numero magico en $BASENAME: $line")
      WARNINGS+=("   → Preferir AppSpacing.* (ej: AppSpacing.lg = 16.0)")
    done <<< "$MAGIC_SPACING"
  fi
fi

# =============================================================================
# VALIDACION 4: Logica de negocio en widgets (ERROR CRITICO)
# =============================================================================

# Detectar llamadas al API/HTTP directamente en build() o en widgets
API_IN_WIDGET=$(grep -n "http\.\|dio\.\|apiClient\.\|Repository\(\)" "$FILE" 2>/dev/null)
if [ -n "$API_IN_WIDGET" ]; then
  # Solo alertar si el archivo no es un repository o service
  if [[ "$FILE" != *"_repository.dart"* ]] && [[ "$FILE" != *"_service.dart"* ]] && [[ "$FILE" != *"_datasource.dart"* ]]; then
    while IFS= read -r line; do
      WARNINGS+=("⚠️  Posible llamada a API en widget en $BASENAME: $line")
      WARNINGS+=("   → Las llamadas al API deben ir en Repository o Service, no en widgets")
    done <<< "$API_IN_WIDGET"
  fi
fi

# =============================================================================
# VALIDACION 5: print() en codigo (ADVERTENCIA)
# =============================================================================

PRINT_STATEMENTS=$(grep -n "^\s*print(" "$FILE" 2>/dev/null)
if [ -n "$PRINT_STATEMENTS" ]; then
  while IFS= read -r line; do
    WARNINGS+=("⚠️  print() en $BASENAME: $line")
    WARNINGS+=("   → Usar el logger configurado del proyecto o debugPrint() en desarrollo")
  done <<< "$PRINT_STATEMENTS"
fi

# =============================================================================
# VALIDACION 6: Textos de UI en ingles (ADVERTENCIA)
# =============================================================================

# Detectar Text() con strings en ingles obvios (solo patrones claros)
ENGLISH_TEXT=$(grep -n "Text('" "$FILE" 2>/dev/null | grep -iE "'(Error|Loading|Submit|Cancel|Save|Delete|Confirm|Success|Failed|Warning|Please|Enter|Select)\b" | head -5)
if [ -n "$ENGLISH_TEXT" ]; then
  while IFS= read -r line; do
    WARNINGS+=("⚠️  Texto de UI posiblemente en ingles en $BASENAME: $line")
    WARNINGS+=("   → Los textos de UI de MV deben estar en espanol")
  done <<< "$ENGLISH_TEXT"
fi

# =============================================================================
# VALIDACION 7: Falta de const en constructores (INFO)
# =============================================================================

# Solo para StatelessWidgets simples - detectar casos obvios
MISSING_CONST=$(grep -n "return Padding(" "$FILE" 2>/dev/null | grep -v "const Padding(" | head -3)
if [ -n "$MISSING_CONST" ]; then
  # Solo mostrar como informacion, no bloquear
  : # Silencioso por ahora
fi

# =============================================================================
# VALIDACION 8: Archivos de tema importados directamente (ADVERTENCIA)
# =============================================================================

# Verificar que se importan los tokens de MV y no se usan valores directos
if [[ "$FILE" == *"_screen.dart"* ]] || [[ "$FILE" == *"_widget.dart"* ]] || [[ "$FILE" == *"_card.dart"* ]]; then
  HAS_APP_COLORS=$(grep -c "AppColors\." "$FILE" 2>/dev/null || echo "0")
  HAS_HARDCODED=$(grep -c "Color(0x\|Colors\." "$FILE" 2>/dev/null || echo "0")

  if [ "$HAS_HARDCODED" -gt 0 ] && [ "$HAS_APP_COLORS" -eq 0 ]; then
    ERRORS+=("❌ $BASENAME usa colores pero no importa AppColors")
    ERRORS+=("   → Agregar: import '../theme/app_colors.dart';")
  fi
fi

# =============================================================================
# RESULTADO FINAL
# =============================================================================

TOTAL_ERRORS=${#ERRORS[@]}
TOTAL_WARNINGS=${#WARNINGS[@]}

if [ "$TOTAL_ERRORS" -eq 0 ] && [ "$TOTAL_WARNINGS" -eq 0 ]; then
  echo "✅ Flutter patterns OK: $BASENAME"
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Validacion Flutter - Manzana Verde"
echo "  Archivo: $BASENAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$TOTAL_ERRORS" -gt 0 ]; then
  echo ""
  echo "ERRORES CRITICOS ($TOTAL_ERRORS):"
  for error in "${ERRORS[@]}"; do
    echo "  $error"
  done
fi

if [ "$TOTAL_WARNINGS" -gt 0 ]; then
  echo ""
  echo "ADVERTENCIAS ($TOTAL_WARNINGS):"
  for warning in "${WARNINGS[@]}"; do
    echo "  $warning"
  done
fi

echo ""
echo "Referencias:"
echo "  Design tokens:  /mv-dev:flutter-visual-style"
echo "  Arquitectura:   /mv-dev:flutter-architecture"
echo "  Marca:          /mv-dev:flutter-brand-identity"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Solo fallar con exit 1 si hay errores criticos
if [ "$TOTAL_ERRORS" -gt 0 ]; then
  exit 1
fi

exit 0
