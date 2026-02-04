#!/bin/bash
# validate-pre-commit.sh
# Validaciones pre-commit: lint, formateo y deteccion de secrets.
# Puede usarse como git pre-commit hook o ejecutarse manualmente.
#
# Exit 0 = OK
# Exit 1 = FAIL

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ERRORS=0

echo "Pre-commit checks..."
echo ""

# 1. Secrets scan
echo "[1/4] Scanning for secrets..."
for file in $(git diff --cached --name-only --diff-filter=ACM 2>/dev/null | grep -E '\.(ts|tsx|js|jsx)$'); do
  if [ -f "$file" ]; then
    if ! "$SCRIPT_DIR/validate-secrets.sh" "$file" 2>/dev/null; then
      ERRORS=1
    fi
  fi
done

if [ $ERRORS -eq 0 ]; then
  echo "  OK - No secrets detectados"
else
  echo "  FAIL - Secrets detectados (ver arriba)"
fi
echo ""

# 2. ESLint
echo "[2/4] Running ESLint..."
if command -v npx &> /dev/null && [ -f "node_modules/.bin/eslint" ]; then
  if npx eslint . --max-warnings=0 --quiet 2>/dev/null; then
    echo "  OK - Sin errores de lint"
  else
    echo "  FAIL - Errores de lint encontrados"
    ERRORS=1
  fi
else
  echo "  SKIP - ESLint no instalado"
fi
echo ""

# 3. Prettier
echo "[3/4] Checking formatting..."
if command -v npx &> /dev/null && [ -f "node_modules/.bin/prettier" ]; then
  if npx prettier --check "**/*.{ts,tsx,js,jsx,json,css,md}" --ignore-unknown 2>/dev/null; then
    echo "  OK - Formato correcto"
  else
    echo "  WARN - Archivos sin formatear (ejecuta: npx prettier --write .)"
  fi
else
  echo "  SKIP - Prettier no instalado"
fi
echo ""

# 4. Check for console.log in non-test files
echo "[4/4] Checking for console.log..."
CONSOLE_LOGS=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null | grep -E '\.(ts|tsx|js|jsx)$' | grep -v '\.test\.' | grep -v '\.spec\.' | while read file; do
  if [ -f "$file" ]; then
    grep -n 'console\.log' "$file" 2>/dev/null | while read line; do
      echo "  $file:$line"
    done
  fi
done)

if [ -n "$CONSOLE_LOGS" ]; then
  echo "  WARN - console.log encontrados (remover antes de merge):"
  echo "$CONSOLE_LOGS"
else
  echo "  OK - Sin console.log"
fi
echo ""

# Resultado final
echo "========================================="
if [ $ERRORS -eq 0 ]; then
  echo "Pre-commit: PASSED"
  exit 0
else
  echo "Pre-commit: FAILED"
  echo "Corrige los errores antes de continuar."
  exit 1
fi
