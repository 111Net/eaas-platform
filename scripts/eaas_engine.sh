#!/bin/bash

echo "=========================================="
echo " EAAS AUTONOMOUS ARCHITECTURE ENGINE"
echo "=========================================="

LOG="/opt/eaas/logs/eaas_engine.log"
mkdir -p /opt/eaas/logs

log() {
  echo "[$(date)] $1" | tee -a $LOG
}

# ----------------------------
# 1. DISCOVER ARCHITECTURE
# ----------------------------
DISCOVER() {
  log "Discovering EAAS architecture..."

  COMPOSE_DIR=$(find /opt/eaas -name docker-compose.yml -exec dirname {} \; | head -n 1)

  if [ -z "$COMPOSE_DIR" ]; then
    log "CRITICAL: No docker-compose.yml found"
    exit 1
  fi

  cd "$COMPOSE_DIR"
  log "Using compose directory: $COMPOSE_DIR"

  SERVICES=$(docker compose config --services)
  log "Detected services: $SERVICES"
}

# ----------------------------
# 2. BOOT SYSTEM
# ----------------------------
BOOT() {
  log "Bootstrapping system..."

  docker compose down --remove-orphans >/dev/null 2>&1
  docker system prune -f >/dev/null 2>&1
  docker compose up -d --build

  sleep 10
}

# ----------------------------
# 3. HEALTH CHECKS
# ----------------------------
CHECK_BACKEND() {
  curl -s http://localhost:8000/health >/dev/null
}

CHECK_FRONTEND() {
  curl -s http://localhost:3000 >/dev/null
}

CHECK_PORTS() {
  ss -tuln | grep 8000 >/dev/null
  ss -tuln | grep 3000 >/dev/null
}

CHECK_NGROK() {
  curl -s http://127.0.0.1:4040/api/tunnels >/dev/null
}

GET_NGROK_URL() {
  curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^"]*' | head -n 1
}

# ----------------------------
# 4. SELF-HEAL ENGINE
# ----------------------------
HEAL() {
  log "Self-healing triggered..."

  docker compose restart backend

  echo "$SERVICES" | grep frontend >/dev/null
  if [ $? -eq 0 ]; then
    docker compose restart frontend
  else
    log "Frontend not part of this architecture"
  fi
}

# ----------------------------
# 5. MAIN EXECUTION FLOW
# ----------------------------
DISCOVER
BOOT

log "Running health checks..."

FAIL=0

CHECK_BACKEND || FAIL=1
CHECK_PORTS || FAIL=1
CHECK_NGROK || FAIL=1

if [ $FAIL -ne 0 ]; then
  HEAL
  sleep 5
fi

NGROK_URL=$(GET_NGROK_URL)

log "================ RESULT ================"

if [ -n "$NGROK_URL" ]; then
  log "PUBLIC URL: $NGROK_URL"

  curl -s "$NGROK_URL/health" >/dev/null
  if [ $? -eq 0 ]; then
    log "STATUS: EAAS FULLY AUTONOMOUS & OPERATIONAL"
  else
    log "STATUS: EXTERNAL FAILURE DETECTED"
  fi
else
  log "STATUS: NGROK NOT AVAILABLE"
fi

log "========================================"
