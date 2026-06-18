#!/bin/bash

BASE="/opt/eaas"

echo "===================================="
echo "   EAAS FULL SYSTEM VERIFICATION"
echo "===================================="

FAIL=0

check() {
  if [ $? -ne 0 ]; then
    echo "❌ $1"
    FAIL=1
  else
    echo "✅ $1"
  fi
}

echo ""
echo "1. 🐳 Docker Engine"
docker info >/dev/null 2>&1
check "Docker is running"

echo ""
echo "2. 📦 Docker Compose Stack"
cd $BASE
docker compose ps

echo ""
echo "3. ⚙️ Backend Container Health"
docker compose ps | grep backend >/dev/null
check "Backend container exists"

echo ""
echo "4. ⚙️ Frontend Container Health"
docker compose ps | grep frontend >/dev/null
check "Frontend container exists"

echo ""
echo "5. 🌐 Backend HTTP (inside VM)"
curl -s http://localhost:8000/health >/dev/null
check "Backend /health reachable"

echo ""
echo "6. 🌐 Frontend HTTP (inside VM)"
curl -s http://localhost:3000 >/dev/null
check "Frontend reachable"

echo ""
echo "7. 🔌 Port Binding Check"
ss -tuln | grep 8000 >/dev/null
check "Port 8000 open"

ss -tuln | grep 3000 >/dev/null
check "Port 3000 open"

echo ""
echo "8. 🧠 FastAPI Import Stability Check"
docker compose logs backend --tail=20 | grep -i "error" >/dev/null
if [ $? -eq 0 ]; then
  echo "❌ Backend errors found in logs"
  FAIL=1
else
  echo "✅ Backend logs clean"
fi

echo ""
echo "9. 🌍 Ngrok Status"
curl -s http://127.0.0.1:4040/api/tunnels >/dev/null
if [ $? -eq 0 ]; then
  echo "✅ Ngrok API reachable"

  NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^"]*' | head -n 1)

  if [ -z "$NGROK_URL" ]; then
    echo "❌ No public ngrok URL found"
    FAIL=1
  else
    echo "🌍 Ngrok URL: $NGROK_URL"

    curl -s "$NGROK_URL/health" >/dev/null
    if [ $? -ne 0 ]; then
      echo "❌ Ngrok upstream failing"
      FAIL=1
    else
      echo "✅ Ngrok tunnel working"
    fi
  fi
else
  echo "❌ Ngrok not running"
  FAIL=1
fi

echo ""
echo "===================================="

if [ $FAIL -eq 0 ]; then
  echo "🎉 EAAS SYSTEM IS HEALTHY"
else
  echo "🚨 EAAS SYSTEM HAS ISSUES"
fi
