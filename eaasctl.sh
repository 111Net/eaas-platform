#!/bin/bash

BASE="/opt/eaas/eaas-platform"
LOG="$BASE/eaas.log"

echo "===================================="
echo " EAAS CONTROL LAYER"
echo "===================================="

cd $BASE || exit 1

start_stack() {
    echo "[1] Starting Docker stack..."

    cd $BASE/infrastructure

    # kill port conflicts safely
    fuser -k 8000/tcp 2>/dev/null || true
    fuser -k 5432/tcp 2>/dev/null || true

    docker compose down --remove-orphans >/dev/null 2>&1

    docker compose up -d --build >> $LOG 2>&1

    echo "[OK] Stack started"
}

check_health() {
    echo "[2] Checking backend..."

    for i in {1..10}; do
        curl -s http://localhost:8000/health >/dev/null && break
        sleep 2
    done

    curl -s http://localhost:8000/docs >/dev/null && echo "✔ Backend OK"
}

start_pwa() {
    echo "[3] Starting PWA..."

    cd $BASE/frontend/pwa
    nohup python3 -m http.server 3000 >/dev/null 2>&1 &
    echo "[OK] PWA running at http://localhost:3000"
}

demo_mode() {
    echo "[4] Investor Demo Mode"

    echo "Opening system..."
    xdg-open http://localhost:3000 >/dev/null 2>&1 || true
    xdg-open http://localhost:8000/docs >/dev/null 2>&1 || true
}

case "$1" in
    start)
        start_stack
        check_health
        start_pwa
        ;;
    restart)
        $0 start
        ;;
    stop)
        cd $BASE/infrastructure && docker compose down
        pkill -f "http.server 3000" || true
        ;;
    status)
        docker ps
        curl -s http://localhost:8000/health || echo "backend down"
        ;;
    demo)
        start_stack
        check_health
        start_pwa
        demo_mode
        ;;
    *)
        echo "Usage: eaasctl start|stop|restart|status|demo"
        ;;
esac
