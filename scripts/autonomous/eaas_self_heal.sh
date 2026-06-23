#!/bin/bash

echo "🧠 EAAS SELF-HEALING ENGINE"

# Restart watchdog if dead
systemctl is-active --quiet eaas-storage-watchdog.service || {
  echo "Restarting watchdog..."
  systemctl restart eaas-storage-watchdog.service
}

# Disk check
df -h | awk '$5+0 > 85 {print "⚠ Disk usage high:", $0}'

# Backend check
curl -s http://localhost:8000/health >/dev/null || {
  echo "⚠ Backend down - restarting EAAS"
  systemctl restart eaas-platform.service
}

echo "✅ Self-heal complete"
