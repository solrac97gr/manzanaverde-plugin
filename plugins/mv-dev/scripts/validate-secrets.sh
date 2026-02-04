#!/bin/bash
# validate-secrets.sh
# Detecta secrets, API keys y credenciales expuestas en archivos de codigo.
# Se ejecuta como PostToolUse hook en cada Write/Edit de archivos .ts/.tsx/.js/.jsx
#
# Exit 0 = OK (no secrets detectados)
# Exit 1 = FAIL (secrets detectados)

FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
  echo "Error: No se proporciono ruta de archivo"
  exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

FOUND_SECRETS=0

# Patrones de secrets a detectar
check_pattern() {
  local pattern="$1"
  local description="$2"

  if grep -qiE "$pattern" "$FILE_PATH" 2>/dev/null; then
    # Verificar si la linea tiene @allow-secret comment
    matching_lines=$(grep -inE "$pattern" "$FILE_PATH" 2>/dev/null)
    while IFS= read -r line; do
      if ! echo "$line" | grep -q "@allow-secret"; then
        echo "SECRETO DETECTADO: $description"
        echo "  Archivo: $FILE_PATH"
        echo "  Linea: $line"
        echo ""
        FOUND_SECRETS=1
      fi
    done <<< "$matching_lines"
  fi
}

# API Keys
check_pattern "(sk_live_|sk_test_|pk_live_|pk_test_)[a-zA-Z0-9]{10,}" "Stripe API key"
check_pattern "AKIA[0-9A-Z]{16}" "AWS Access Key"
check_pattern "(ghp_|gho_|ghu_|ghs_|ghr_)[a-zA-Z0-9]{36,}" "GitHub Token"
check_pattern "xox[baprs]-[a-zA-Z0-9-]{10,}" "Slack Token"

# Passwords y connection strings
check_pattern "password\s*[:=]\s*['\"][^'\"]{8,}['\"]" "Password hardcodeado"
check_pattern "mysql://[^\\s'\"]+:[^\\s'\"]+@" "MySQL connection string con credenciales"
check_pattern "postgres(ql)?://[^\\s'\"]+:[^\\s'\"]+@" "PostgreSQL connection string con credenciales"
check_pattern "mongodb(\+srv)?://[^\\s'\"]+:[^\\s'\"]+@" "MongoDB connection string con credenciales"

# JWT y tokens genericos
check_pattern "eyJ[a-zA-Z0-9_-]{20,}\\.eyJ[a-zA-Z0-9_-]{20,}\\." "JWT token hardcodeado"
check_pattern "(api[_-]?key|apikey|api[_-]?secret)\s*[:=]\s*['\"][a-zA-Z0-9]{16,}['\"]" "API key generica"
check_pattern "(secret[_-]?key|secret)\s*[:=]\s*['\"][a-zA-Z0-9]{16,}['\"]" "Secret key generica"
check_pattern "(auth[_-]?token|access[_-]?token)\s*[:=]\s*['\"][a-zA-Z0-9]{16,}['\"]" "Auth token hardcodeado"

# Credenciales privadas
check_pattern "-----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----" "Private key"
check_pattern "-----BEGIN CERTIFICATE-----" "Certificate"

# Variables de entorno con valores
check_pattern "(NOTION_TOKEN|CONTEXT7_API_KEY|SUPABASE_ACCESS_TOKEN|VERCEL_TOKEN|RAILWAY_TOKEN|MV_STAGING_DB_PASSWORD)\s*=\s*['\"]?[a-zA-Z0-9]{8,}" "Variable de entorno sensible con valor"

if [ $FOUND_SECRETS -eq 1 ]; then
  echo "========================================="
  echo "BLOQUEADO: Se detectaron secrets en el codigo."
  echo ""
  echo "Soluciones:"
  echo "  1. Mover los valores a variables de entorno (.env.local)"
  echo "  2. Usar process.env.NOMBRE_VARIABLE en su lugar"
  echo "  3. Si es un falso positivo, agregar // @allow-secret al final de la linea"
  echo ""
  echo "NUNCA commitear secrets en el codigo."
  echo "========================================="
  exit 1
fi

exit 0
