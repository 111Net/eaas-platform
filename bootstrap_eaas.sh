#!/bin/bash

set -e

echo "====================================="
echo " EAAS MVP Bootstrap & Verification"
echo "====================================="

ROOT="/opt/eaas/eaas-platform"
FRONTEND="$ROOT/frontend"

echo ""
echo "[1/7] Checking folders..."

mkdir -p "$FRONTEND"

echo "OK"

echo ""
echo "[2/7] Creating PWA files..."

cat > "$FRONTEND/manifest.json" <<EOF
{
  "name": "EAAS Energy Platform",
  "short_name": "EAAS",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0f172a",
  "theme_color": "#0ea5e9"
}
EOF

cat > "$FRONTEND/service-worker.js" <<EOF
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("fetch", e => e.respondWith(fetch(e.request)));
EOF

echo "PWA files created"

echo ""
echo "[3/7] Checking frontend..."

if [ ! -f "$FRONTEND/index.html" ]; then
cat > "$FRONTEND/index.html" <<EOF
<!DOCTYPE html>
<html>
<head>
<title>EAAS Energy Platform</title>
<link rel="manifest" href="manifest.json">
<script>
if ("serviceWorker" in navigator) {
 navigator.serviceWorker.register("service-worker.js");
}
</script>
</head>
<body>
<h1>⚡ EAAS Energy Platform</h1>
<p>Frontend running successfully.</p>
</body>
</html>
EOF
fi

echo "Frontend verified"

echo ""
echo "[4/7] Starting frontend..."

pkill -f "http.server 3000" 2>/dev/null || true

cd "$FRONTEND"

nohup python3 -m http.server 3000 > frontend.log 2>&1 &

sleep 3

echo "Frontend started"

echo ""
echo "[5/7] Verifying frontend..."

if curl -s http://localhost:3000 >/dev/null; then
    echo "Frontend OK"
else
    echo "Frontend FAILED"
fi

echo ""
echo "[6/7] Checking backend..."

if curl -s http://localhost:8000 >/dev/null; then
    echo "Backend OK"
else
    echo "Backend NOT RUNNING"
fi

echo ""
echo "[7/7] Creating desktop launcher..."

mkdir -p ~/Desktop

cat > ~/Desktop/EAAS-MVP.desktop <<EOF
[Desktop Entry]
Name=EAAS MVP
Comment=Energy as a Service Platform
Exec=xdg-open http://localhost:3000
Icon=web-browser
Terminal=false
Type=Application
Categories=Network;
EOF

chmod +x ~/Desktop/EAAS-MVP.desktop

echo ""
echo "====================================="
echo "EAAS Setup Complete"
echo "====================================="
echo ""
echo "Open:"
echo "http://localhost:3000"
echo ""
echo "Desktop icon:"
echo "~/Desktop/EAAS-MVP.desktop"
echo ""
