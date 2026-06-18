#!/bin/bash

echo "=== EAAS SYSTEM REPAIR ==="

echo "[1] Cleaning apt cache..."
sudo apt clean || true
sudo rm -rf /var/cache/apt/archives/*

echo "[2] Killing stuck servers..."
fuser -k 3000/tcp || true
fuser -k 8000/tcp || true

echo "[3] Restarting backend..."
cd /opt/eaas/eaas-platform/infrastructure
docker compose up -d || true

echo "[4] Starting frontend..."
cd /opt/eaas/eaas-platform/frontend/pwa
nohup python3 -m http.server 3000 > /dev/null 2>&1 &

echo "[5] Done"
echo "Frontend: http://localhost:3000"
echo "Backend: http://localhost:8000"
