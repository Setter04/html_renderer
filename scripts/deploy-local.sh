#!/bin/bash
# deploy-local.sh
# Startet einen lokalen HTTP-Server für den AISSIST Prototype Renderer.
# Voraussetzung: Python 3

set -e

PORT=8080
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "AISSIST Prototype Renderer — Lokales Deployment"
echo "------------------------------------------------"
echo "Server startet in: $ROOT_DIR"
echo "Renderer:          http://localhost:$PORT/assets/aissist-prototype-renderer.html"
echo ""
echo "Feature laden:     http://localhost:$PORT/assets/aissist-prototype-renderer.html?feature=<id>"
echo "  → Renderer sucht: features/<id>.yaml"
echo ""
echo "Mit STRG+C beenden."
echo "------------------------------------------------"

cd "$ROOT_DIR"
python3 -m http.server $PORT
