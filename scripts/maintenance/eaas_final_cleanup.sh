#!/bin/bash

echo "🧹 EAAS FINAL CLEANUP STARTING..."

# Remove legacy paths
echo "[1] Checking legacy references..."
grep -R "/home/user/eaas-platform" /opt/eaas || echo "✔ No legacy paths found"

# Remove broken systemd state
echo "[2] Resetting systemd state..."
systemctl reset-failed eaas-platform 2>/dev/null
systemctl daemon-reexec

# Clean bash cache
echo "[3] Clearing shell cache..."
hash -r

# Verify CLI
echo "[4] Verifying eaasctl..."
which eaasctl
ls -l /usr/local/bin/eaasctl

echo "✅ CLEANUP COMPLETE"
