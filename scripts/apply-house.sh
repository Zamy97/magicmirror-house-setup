#!/usr/bin/env bash
# Apply shared config template + house env + custom.css onto ~/MagicMirror
set -euo pipefail

HOUSE="${1:-}"
SETUP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MM_HOME="${MAGICMIRROR_HOME:-$HOME/MagicMirror}"
HOUSES_DIR="$SETUP_ROOT/config/houses"
TEMPLATE="$SETUP_ROOT/config/config.js.template"
CSS_SRC="$SETUP_ROOT/css/custom.css"

usage() {
  echo "Usage: $0 <house-id>"
  echo "  house-id matches config/houses/<house-id>.env (without .env)"
  echo "Examples:  $0 example   |   $0 smith"
  exit 1
}

[[ -n "$HOUSE" ]] || usage

ENV_FILE="$HOUSES_DIR/${HOUSE}.env"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: missing house env: $ENV_FILE"
  echo "Copy config/houses/example.env → config/houses/${HOUSE}.env and edit it."
  exit 1
fi

if [[ ! -d "$MM_HOME" ]]; then
  echo "ERROR: MagicMirror not found at $MM_HOME"
  echo "Run ./scripts/bootstrap.sh ${HOUSE} first, or set MAGICMIRROR_HOME."
  exit 1
fi

mkdir -p "$MM_HOME/config" "$MM_HOME/css"
cp "$ENV_FILE" "$MM_HOME/config/config.env"
cp "$TEMPLATE" "$MM_HOME/config/config.js"
cp "$CSS_SRC" "$MM_HOME/css/custom.css"

echo "Applied house '${HOUSE}' →"
echo "  $MM_HOME/config/config.env"
echo "  $MM_HOME/config/config.js"
echo "  $MM_HOME/css/custom.css"
echo
echo "Restart: pm2 restart magicmirror"
