#!/bin/bash

DATE=$(date +%F-%H-%M)

mkdir -p /opt/eaas/backups/$DATE

tar czf 
/opt/eaas/backups/$DATE/eaas-platform.tar.gz 
/opt/eaas/eaas-platform

echo "Backup Completed: $DATE"

