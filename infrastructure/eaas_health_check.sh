#!/bin/bash

echo "===================================="
echo " EAAS SYSTEM HEALTH CHECK STARTING"
echo "===================================="

FAIL=0

check() {
  if [ $? -ne 0 ]; then
    echo "❌ $1 FAILED"
    FAIL=1
  else
    echo "✅ $1 OK"
  fi
}

echo ""
echo "1. 🔍 Docker Status"
docker info >/dev/null 2>&1
check "Docker Engine"

echo ""
echo "2. 📦 Running Containers"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "3. ⚙️ Backend Health (FastAPI)"
curl -s http://localhost:8000/health >/dev/null
check "Backend /health endpoint"

echo ""
echo "4. 🌐 Backend Root Route"
curl -s http://localhost:8000/ >/dev/null
check "Backend root endpoint"

echo ""
echo "5. 🎨 Frontend Check (adjust port if needed)"
curl -s http://localhost:3000 >/dev/null
check "Frontend service"

echo ""
echo "6. 🔌 Port Binding Check"
ss -tuln | grep 8000 >/dev/null
check "Backend port 8000 listening"

echo ""
echo "7. 🐳 Docker Compose Health (if available)"
docker compose ps >/dev/null 2>&1
check "Docker Compose"

echo ""
echo "8. 🌍 Ngrok Tunnel Check"
curl -s http://127.0.0.1:4040/api/tunnels >/dev/null
check "Ngrok local API"

echo ""
echo "9. 🔗 Ngrok Public URL Test"
NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^"]*' | head -n 1)

if [ -z "$NGROK_URL" ]; then
  echo "❌ Ngrok public URL NOT found"
  FAIL=1
else
  echo "🌍 Ngrok URL: $NGROK_URL"
  curl -s "$NGROK_URL/health" >/dev/null
  if [ $? -ne 0 ]; then
    echo "❌ Ngrok upstream FAILED"
    FAIL=1
  else
    echo "✅ Ngrok tunnel working"
  fi
fi

echo ""
echo "===================================="

if [ $FAIL -eq 0 ]; then
  echo "🎉 EAAS SYSTEM IS HEALTHY"
  exit 0
else
  echo "🚨 SYSTEM HAS FAILURES"
  exit 1
fi
