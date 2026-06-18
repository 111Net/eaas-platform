#!/bin/bash

echo "🔧 EAAS Self-Healing System Starting..."

# Restart containers
docker compose down
docker compose up -d --build

# Wait for DB
sleep 10

# Health check
curl -s http://localhost:8000/ > /dev/null

if [ $? -eq 0 ]; then
  echo "✅ EAAS Backend Healthy"
else
  echo "❌ EAAS failed - restarting again"
  docker restart infrastructure-backend-1
fi
