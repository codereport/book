#!/bin/bash
# Development server with auto-reload
# Usage: ./dev.sh
#
# This script runs the HTTP server and file watcher together.
# For best results in your terminal, run:
#   ./dev.sh
# Or separately:
#   make serve   (Terminal 1)
#   make watch   (Terminal 2)

set -e
cd "$(dirname "$0")"

# Build first
echo "Building..."
make -s html

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Dev server: http://localhost:8000         ║"
echo "║  Watching: src/ templates/ assets/         ║"
echo "║  Press Ctrl+C to stop                      ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Start server in background
python3 -m http.server 8000 -d build 2>&1 | sed 's/^/[server] /' &
SERVER_PID=$!

# Cleanup on exit
cleanup() {
    echo ""
    echo "Shutting down..."
    kill $SERVER_PID 2>/dev/null
    wait $SERVER_PID 2>/dev/null
    exit 0
}
trap cleanup INT TERM

# Watch loop
while true; do
    # Wait for file change (fswatch -1 exits after first event)
    fswatch -1 -r -l 2 src templates assets >/dev/null 2>&1
    
    echo "[$(date +%H:%M:%S)] Change detected, rebuilding..."
    if make -s html; then
        echo "[$(date +%H:%M:%S)] Done. Refresh your browser."
    else
        echo "[$(date +%H:%M:%S)] Build failed!"
    fi
    echo ""
done
