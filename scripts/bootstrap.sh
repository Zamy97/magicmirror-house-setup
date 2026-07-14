#!/usr/bin/env bash
# One-shot MagicMirror house bring-up for Raspberry Pi (Debian/Ubuntu/Raspberry Pi OS).
set -euo pipefail

HOUSE="${1:-}"
SETUP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MM_HOME="${MAGICMIRROR_HOME:-$HOME/MagicMirror}"
MM_REPO="${MAGICMIRROR_REPO:-https://github.com/MagicMirrorOrg/MagicMirror.git}"
NODE_MAJOR="${NODE_MAJOR:-20}"
MODULES_FILE="$SETUP_ROOT/modules.txt"

usage() {
  echo "Usage: $0 <house-id>"
  echo
  echo "Steps:"
  echo "  1) Install Node.js ${NODE_MAJOR}.x (if missing)"
  echo "  2) Clone MagicMirror → $MM_HOME"
  echo "  3) npm install MagicMirror"
  echo "  4) Clone modules from modules.txt (+ npm where marked)"
  echo "  5) Apply config/css for <house-id>"
  echo "  6) Install PM2 and start MagicMirror"
  echo
  echo "Prep: copy config/houses/example.env → config/houses/<house-id>.env and edit coords."
  exit 1
}

[[ -n "$HOUSE" ]] || usage

if [[ ! -f "$SETUP_ROOT/config/houses/${HOUSE}.env" ]]; then
  echo "ERROR: missing $SETUP_ROOT/config/houses/${HOUSE}.env"
  echo "cp config/houses/example.env config/houses/${HOUSE}.env  # then edit"
  exit 1
fi

need_cmd() { command -v "$1" >/dev/null 2>&1; }

echo "==> [1/6] Node.js"
if need_cmd node && node -v | grep -qE 'v(1[8-9]|[2-9][0-9])'; then
  echo "    node $(node -v) OK"
else
  if need_cmd apt-get; then
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
    sudo apt-get install -y nodejs
  else
    echo "ERROR: Node ${NODE_MAJOR}+ required. Install Node then re-run."
    exit 1
  fi
fi
echo "    npm $(npm -v)"

echo "==> [2/6] MagicMirror"
if [[ -d "$MM_HOME/.git" ]]; then
  echo "    exists: $MM_HOME (pulling)"
  git -C "$MM_HOME" pull --ff-only || true
else
  git clone --depth 1 "$MM_REPO" "$MM_HOME"
fi

echo "==> [3/6] MagicMirror npm install"
(
  cd "$MM_HOME"
  npm install --no-audit --no-fund
)

echo "==> [4/6] Modules"
mkdir -p "$MM_HOME/modules"
# strip comments / blanks
while IFS= read -r line || [[ -n "$line" ]]; do
  # trim
  line="$(echo "$line" | sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue
  url="$(echo "$line" | awk '{print $1}')"
  need_npm="$(echo "$line" | awk '{print $2}')"
  name="$(basename "$url" .git)"
  dest="$MM_HOME/modules/$name"
  if [[ -d "$dest/.git" ]]; then
    echo "    update $name"
    git -C "$dest" pull --ff-only || true
  else
    echo "    clone  $name"
    git clone --depth 1 "$url" "$dest"
  fi
  if [[ "$need_npm" == "npm" ]]; then
    echo "    npm    $name"
    (cd "$dest" && npm install --no-audit --no-fund)
  fi
done < "$MODULES_FILE"

echo "==> [5/6] Apply house config + CSS"
"$SETUP_ROOT/scripts/apply-house.sh" "$HOUSE"

echo "==> [6/6] PM2"
if ! need_cmd pm2; then
  sudo npm install -g pm2
fi

# Stop previous if any
pm2 delete magicmirror >/dev/null 2>&1 || true
pm2 start "$SETUP_ROOT/ecosystem.config.cjs"
pm2 save

echo
echo "============================================"
echo " House '${HOUSE}' MagicMirror is starting."
echo " MM path: $MM_HOME"
echo
echo " Useful:"
echo "   pm2 status"
echo "   pm2 logs magicmirror"
echo "   pm2 restart magicmirror"
echo "   ./scripts/apply-house.sh ${HOUSE}   # after CSS/config edits"
echo
echo " Autostart on boot (run the command PM2 prints):"
echo "   pm2 startup"
echo "============================================"
