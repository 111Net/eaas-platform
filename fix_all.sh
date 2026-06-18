#!/bin/bash

echo "=============================="
echo " EAAS FULL AUTO FIX SYSTEM"
echo "=============================="

BASE="/opt/eaas/eaas-platform/infrastructure"

echo "[1] Stopping all containers..."
docker stop $(docker ps -q) 2>/dev/null || true

echo "[2] Removing stuck containers..."
docker rm $(docker ps -aq) 2>/dev/null || true

echo "[3] Fixing port conflicts..."
fuser -k 8000/tcp 2>/dev/null || true

echo "[4] Fixing docker-compose duplicate restart keys..."
sed -i '/restart:/d' $BASE/docker-compose.yml
echo "restart: unless-stopped" >> $BASE/docker-compose.yml

echo "[5] Restarting clean stack..."
cd $BASE
docker compose down -v 2>/dev/null || true
docker compose up -d --build

echo "[6] Waiting for backend..."
sleep 8

echo "[7] Health check..."
curl -s http://localhost:8000/ || echo "Backend not ready"

echo "=============================="
echo " FIX COMPLETE"
echo "=============================="
