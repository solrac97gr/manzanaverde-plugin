#!/bin/bash
# validate-api-patterns.sh
# Valida que archivos de backend Express sigan los patrones de MV.
# Se ejecuta como PostToolUse hook en Write/Edit de routes/controllers/services.
#
# Exit 0 = OK
# Exit 1 = FAIL

FILE_PATH="$1"

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

WARNINGS=0
ERRORS=0

CONTENT=$(cat "$FILE_PATH" 2>/dev/null)

# 1. Verificar formato de respuesta estandar MV en controllers
if echo "$FILE_PATH" | grep -qiE '(controller|route)' 2>/dev/null; then

  # Verificar que usa res.json con formato MV
  if echo "$CONTENT" | grep -qE 'res\.(json|send)\(' 2>/dev/null; then
    if ! echo "$CONTENT" | grep -qE 'success:\s*(true|false)' 2>/dev/null; then
      echo "ADVERTENCIA: Responses deben usar formato MV: { success, data, error }"
      echo "  Archivo: $FILE_PATH"
      echo "  Solucion: res.json({ success: true, data: result })"
      echo ""
      WARNINGS=$((WARNINGS + 1))
    fi
  fi

  # Verificar try/catch en funciones async
  ASYNC_COUNT=$(echo "$CONTENT" | grep -cE 'async\s+(function|\()' 2>/dev/null)
  TRY_COUNT=$(echo "$CONTENT" | grep -cE '\btry\s*{' 2>/dev/null)

  if [ "$ASYNC_COUNT" -gt 0 ] && [ "$TRY_COUNT" -eq 0 ]; then
    echo "ADVERTENCIA: Funciones async en controllers deben tener try/catch"
    echo "  Archivo: $FILE_PATH"
    echo "  Se encontraron $ASYNC_COUNT funciones async sin try/catch"
    echo "  Solucion: Envolver la logica en try/catch con manejo de ZodError y error generico"
    echo ""
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# 2. Verificar SQL injection (string concatenation en queries)
if echo "$CONTENT" | grep -qE "(execute|query)\s*\(" 2>/dev/null; then
  # Buscar template literals con variables en queries SQL
  SQL_CONCAT=$(echo "$CONTENT" | grep -nE "(execute|query)\s*\(\s*\`[^\`]*\\\$\{" 2>/dev/null | head -5)
  if [ -n "$SQL_CONCAT" ]; then
    echo "ERROR: Posible SQL injection detectado - string concatenation en queries"
    echo "  Archivo: $FILE_PATH"
    echo "  Encontrado:"
    echo "$SQL_CONCAT" | while IFS= read -r line; do
      echo "    $line"
    done
    echo "  Solucion: Usar queries parametrizados con placeholders ?"
    echo "  Ejemplo: db.execute('SELECT * FROM table WHERE id = ?', [id])"
    echo ""
    ERRORS=$((ERRORS + 1))
  fi
fi

# 3. Verificar queries sin LIMIT
if echo "$CONTENT" | grep -qiE 'SELECT.*FROM' 2>/dev/null; then
  SELECT_QUERIES=$(echo "$CONTENT" | grep -niE 'SELECT.*FROM' 2>/dev/null)
  while IFS= read -r query_line; do
    if ! echo "$query_line" | grep -qi 'LIMIT\|COUNT\(\*\)\|COUNT(1)' 2>/dev/null; then
      echo "ADVERTENCIA: Query SELECT sin LIMIT detectado"
      echo "  Archivo: $FILE_PATH"
      echo "  Linea: $query_line"
      echo "  Solucion: Agregar LIMIT al query (maximo 100)"
      echo ""
      WARNINGS=$((WARNINGS + 1))
    fi
  done <<< "$SELECT_QUERIES"
fi

# 4. Verificar operaciones destructivas de BD
DESTRUCTIVE=$(echo "$CONTENT" | grep -niE '\b(DELETE\s+FROM|DROP\s+TABLE|TRUNCATE|ALTER\s+TABLE)\b' 2>/dev/null | head -5)
if [ -n "$DESTRUCTIVE" ]; then
  echo "ERROR: Operaciones destructivas de BD detectadas"
  echo "  Archivo: $FILE_PATH"
  echo "$DESTRUCTIVE" | while IFS= read -r line; do
    echo "    $line"
  done
  echo "  NUNCA ejecutar DELETE, DROP, TRUNCATE o ALTER desde el codigo."
  echo ""
  ERRORS=$((ERRORS + 1))
fi

# 5. Verificar validacion con Zod en rutas POST/PATCH/PUT
if echo "$FILE_PATH" | grep -qiE 'route' 2>/dev/null; then
  if echo "$CONTENT" | grep -qE '\.(post|patch|put)\(' 2>/dev/null; then
    if ! echo "$CONTENT" | grep -qE '(zod|z\.|Schema|schema|\.parse\()' 2>/dev/null; then
      echo "ADVERTENCIA: Rutas POST/PATCH/PUT deben validar input con Zod"
      echo "  Archivo: $FILE_PATH"
      echo "  Solucion: import { z } from 'zod'; y validar req.body con schema.parse()"
      echo ""
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
fi

# 6. Verificar middleware de auth en rutas protegidas
if echo "$FILE_PATH" | grep -qiE 'route' 2>/dev/null; then
  if echo "$CONTENT" | grep -qE '\.(get|post|patch|put|delete)\(' 2>/dev/null; then
    if ! echo "$CONTENT" | grep -qE '(requireAuth|authenticate|isAuthenticated|authMiddleware)' 2>/dev/null; then
      # Solo advertir si no es una ruta de health check o auth
      if ! echo "$FILE_PATH" | grep -qiE '(health|auth|public)' 2>/dev/null; then
        echo "ADVERTENCIA: Rutas protegidas deben usar middleware de autenticacion"
        echo "  Archivo: $FILE_PATH"
        echo "  Solucion: router.get('/ruta', requireAuth, controller.handler)"
        echo ""
        WARNINGS=$((WARNINGS + 1))
      fi
    fi
  fi
fi

# 7. Verificar acceso a tablas bloqueadas
BLOCKED_TABLES="user_credentials|payment_methods|stripe_tokens|admin_sessions"
BLOCKED_ACCESS=$(echo "$CONTENT" | grep -niE "\b($BLOCKED_TABLES)\b" 2>/dev/null | head -5)
if [ -n "$BLOCKED_ACCESS" ]; then
  echo "ERROR: Acceso a tabla bloqueada detectado"
  echo "  Archivo: $FILE_PATH"
  echo "$BLOCKED_ACCESS" | while IFS= read -r line; do
    echo "    $line"
  done
  echo "  Estas tablas contienen datos sensibles y no deben accederse directamente."
  echo ""
  ERRORS=$((ERRORS + 1))
fi

# Resultado
if [ $ERRORS -gt 0 ]; then
  echo "========================================="
  echo "API Patterns: FAILED ($ERRORS errores, $WARNINGS advertencias)"
  echo "Los errores deben corregirse antes de continuar."
  exit 1
fi

if [ $WARNINGS -gt 0 ]; then
  echo "========================================="
  echo "API Patterns: PASSED con $WARNINGS advertencias"
  echo "Las advertencias no bloquean, pero se recomienda corregirlas."
fi

exit 0
