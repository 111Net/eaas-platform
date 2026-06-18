#!/bin/bash

touch /opt/eaas/scripts/backup.sh
touch /opt/eaas/scripts/healthcheck.sh
touch /opt/eaas/scripts/update.sh
touch /opt/eaas/scripts/rollback.sh
touch /opt/eaas/scripts/monitor.sh

chmod +x /opt/eaas/scripts/*.sh

echo "EAAS Guardian files created"
