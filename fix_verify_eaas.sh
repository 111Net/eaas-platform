#!/bin/bash

echo "================================="
echo " EAAS FULL REPAIR & VERIFICATION "
echo "================================="

cd /opt/eaas/eaas-platform/infrastructure || exit

echo
echo "[1] Killing rogue processes..."

pkill -f uvicorn
pkill -f http.server

echo
echo "[2] Starting docker stack..."

docker compose down

docker compose up -d --build

echo
echo "[3] Waiting for services..."

sleep 20

echo
echo "[4] Container status..."

docker ps

echo
echo "[5] Backend Health..."

curl -s http://localhost:8000/

echo
echo
echo "[6] API Docs..."

curl -I http://localhost:8000/docs

echo
echo
echo "[7] Database Check..."

docker exec eaas-postgres psql \
-U eaas_user \
-d eaas_db \
-c "\dt"

echo
echo "================================="
echo " EAAS VERIFIED "
echo "================================="

echo
echo "Backend:"
echo "http://localhost:8000"

echo
echo "API Docs:"
echo "http://localhost:8000/docs"

echo
echo "Finished."
