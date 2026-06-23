#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo"
  exit 1
fi

case "$1" in

status)
  systemctl status eaas-storage-watchdog.service --no-pager
  ;;

agent)
  python3 /opt/eaas/eaas-platform/control-plane/agent.py
  ;;

health)
  curl -s http://localhost:8000/health || echo "DOWN"
  df -h
  ;;

autonomy)
  echo "🧠 Running EAAS v2 core agent..."
  bash /opt/eaas/eaas-platform/core/eaas_core_agent.sh
  ;;

restart)
  systemctl restart eaas-storage-watchdog.service
  ;;

*)
  echo "Usage: eaasctl {status|health|autonomy|restart}"
  ;;

esac
