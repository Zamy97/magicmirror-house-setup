#!/usr/bin/env bash
# Pull MagicMirror + modules, re-apply house config/CSS, restart PM2.
set -euo pipefail

HOUSE="${1:-}"
SETUP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MM_HOME="${MAGICMIRROR_HOME:-$HOME/MagicMirror}"
MODULES_FILE="$SETUP_ROOT/modules.txt"

[[ -n "$HOUSE" ]] || { echo "Usage: $0 <house-id>"; exit 1; }

git -C "$SETUP_ROOT" pull --ff-only || true
git -C "$MM_HOME" pull --ff-only || true

while IFS= read -r line || [[ -n "$line" ]]; do
  line="$(echo "$line" | sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue
  url="$(echo "$line" | awk '{print $1}')"
  need_npm="$(echo "$line" | awk '{print $2}')"
  name="$(basename "$url" .git)"
  dest="$MM_HOME/modules/$name"
  [[ -d "$dest/.git" ]] || continue
  echo "Updating $name"
  git -C "$dest" pull --ff-only || true
  if [[ "$need_npm" == "npm" ]]; then
    (cd "$dest" && npm install --no-audit --no-fund)
  fi
done < "$MODULES_FILE"

"$SETUP_ROOT/scripts/apply-house.sh" "$HOUSE"
pm2 restart magicmirror || true
echo "Done."
