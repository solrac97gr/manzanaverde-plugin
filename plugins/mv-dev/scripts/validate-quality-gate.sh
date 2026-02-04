#!/bin/bash
# validate-quality-gate.sh
# Quality gate: cobertura minima y build exitoso.
# Ejecutar antes de merge a develop/main.
#
# Exit 0 = OK
# Exit 1 = FAIL

ERRORS=0
MIN_COVERAGE=80

echo "Quality Gate checks..."
echo ""

# 1. Run tests with coverage
echo "[1/3] Running tests with coverage..."
if [ -f "package.json" ]; then
  if grep -q '"test"' package.json 2>/dev/null; then
    COVERAGE_OUTPUT=$(npm test -- --coverage --silent 2>&1)
    TEST_EXIT=$?

    if [ $TEST_EXIT -ne 0 ]; then
      echo "  FAIL - Tests fallaron"
      echo "$COVERAGE_OUTPUT" | tail -20
      ERRORS=1
    else
      echo "  OK - Tests pasan"

      # Parse coverage percentage
      COVERAGE=$(echo "$COVERAGE_OUTPUT" | grep -E "All files" | awk '{print $4}' | sed 's/%//' | head -1)

      if [ -n "$COVERAGE" ]; then
        COVERAGE_INT=${COVERAGE%.*}
        if [ "$COVERAGE_INT" -ge "$MIN_COVERAGE" ] 2>/dev/null; then
          echo "  OK - Cobertura: ${COVERAGE}% (minimo: ${MIN_COVERAGE}%)"
        else
          echo "  FAIL - Cobertura insuficiente: ${COVERAGE}% (minimo: ${MIN_COVERAGE}%)"
          ERRORS=1
        fi
      else
        echo "  WARN - No se pudo determinar la cobertura"
      fi
    fi
  else
    echo "  SKIP - No hay script de test"
  fi
else
  echo "  SKIP - No hay package.json"
fi
echo ""

# 2. Build
echo "[2/3] Running build..."
if [ -f "package.json" ]; then
  if grep -q '"build"' package.json 2>/dev/null; then
    if npm run build 2>&1 | tail -5; then
      echo "  OK - Build exitoso"
    else
      echo "  FAIL - Build fallo"
      ERRORS=1
    fi
  else
    echo "  SKIP - No hay script de build"
  fi
else
  echo "  SKIP - No hay package.json"
fi
echo ""

# 3. Final secrets check on all staged files
echo "[3/3] Final secrets scan..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SECRET_FOUND=0
for file in $(find . \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) -not -path "*/node_modules/*" -not -path "*/dist/*" -not -path "*/.next/*" 2>/dev/null); do
  if ! "$SCRIPT_DIR/validate-secrets.sh" "$file" 2>/dev/null; then
    SECRET_FOUND=1
  fi
done

if [ $SECRET_FOUND -eq 0 ]; then
  echo "  OK - No secrets detectados"
else
  echo "  FAIL - Secrets detectados"
  ERRORS=1
fi
echo ""

# Resultado final
echo "========================================="
if [ $ERRORS -eq 0 ]; then
  echo "Quality Gate: PASSED"
  echo "El codigo esta listo para merge."
  exit 0
else
  echo "Quality Gate: FAILED"
  echo "Corrige los errores antes de mergear."
  exit 1
fi
