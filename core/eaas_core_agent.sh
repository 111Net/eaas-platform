#!/bin/bash

EAAS="/opt/eaas/eaas-platform"

echo "🧠 EAAS v2 CORE AGENT RUNNING"

# 1. Health check
HEALTH=$(curl -s http://localhost:8000/health)

if [[ -z "$HEALTH" ]]; then
    echo "⚠ Backend down → restarting stack"
    systemctl restart eaas-storage-watchdog.service
fi

# 2. Docker check
if ! systemctl is-active --quiet docker; then
    echo "⚠ Docker down → attempting restart"
    systemctl restart docker
fi

# 3. Disk protection
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -gt 85 ]; then
    echo "⚠ Disk critical ($USAGE%) → cleanup trigger"
    find /tmp -type f -mtime +2 -delete
fi

# 4. EAAS self-repair hooks
bash $EAAS/scripts/monitor.sh 2>/dev/null

echo "✅ EAAS v2 cycle complete"
