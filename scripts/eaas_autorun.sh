  #!/bin/bash

BASE_DIR=$(find /opt/eaas -name docker-compose.yml -exec dirname {} \; | head -n 1)
cd "$BASE_DIR"

LOG_FILE="/opt/eaas/logs/eaas_health.log"
mkdir -p /opt/eaas/logs

log() {
  echo "[$(date)] $1" | tee -a $LOG_FILE
}

log "================ EAAS AUTORUN START ================"

BOOTSTRAP() {
  log "Bootstrapping system..."
  docker compose down --remove-orphans >/dev/null 2>&1
  docker system prune -f >/dev/null 2>&1
  docker compose up -d --build
  sleep 10
}

CHECK_BACKEND() {
  curl -s http://localhost:8000/health >/dev/null
}

CHECK_FRONTEND() {
  curl -s http://localhost:3000 >/dev/null
}

CHECK_NGROK() {
  curl -s http://127.0.0.1:4040/api/tunnels >/dev/null
}

GET_NGROK_URL() {
  curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^"]*' | head -n 1
}

FIX_SERVICES() {
  echo "🔧 Self-healing triggered..."

  docker compose restart backend

  SERVICES=$(docker compose config --services)

  echo "$SERVICES" | grep frontend >/dev/null && \
    docker compose restart frontend || \
    echo "⚠️ frontend not managed in this stack"
}

START_NGROK() {
  if ! CHECK_NGROK; then
    log "Starting ngrok..."
  
  nohup ngrok http 8000 >/dev/null 2>&1 &
    sleep 5
  fi
}

HEALTH_CHECK() {
  FAIL=0

  CHECK_BACKEND || FAIL=1
  CHECK_FRONTEND || FAIL=1

  ss -tuln | grep 8000 >/dev/null || FAIL=1
  ss -tuln | grep 3000 >/dev/null || FAIL=1

  CHECK_NGROK || FAIL=1

  return $FAIL
}

BOOTSTRAP
START_NGROK

if ! HEALTH_CHECK; then
  log "System unhealthy → healing..."
  FIX_SERVICES
fi

NGROK_URL=$(GET_NGROK_URL)

log "================ RESULT ================"

if [ -n "$NGROK_URL" ]; then
  log "PUBLIC URL: $NGROK_URL"

  curl -s "$NGROK_URL/health" >/dev/null
  if [ $? -eq 0 ]; then
    log "STATUS: SYSTEM FULLY OPERATIONAL"
  else
    log "STATUS: EXTERNAL FAILURE"
  fi
else
  log "STATUS: NGROK FAILED"
fi

log "================ END =================="
