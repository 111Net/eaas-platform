#!/bin/bash

while true; do
    echo "🧠 EAAS Watchdog running health check..."

    # Check backend
    curl -s http://localhost:8000/health > /dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Backend down — restarting..."
        systemctl restart eaas-platform.service
    else
        echo "✔ Backend healthy"
    fi

    # Check disk usage
    USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$USAGE" -gt 85 ]; then
        echo "⚠️ Disk usage critical: ${USAGE}%"
    fi

    sleep 15
done
