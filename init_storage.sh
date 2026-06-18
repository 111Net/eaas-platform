#!/bin/bash

set -e

DISK="/dev/sdc"
PART="${DISK}1"
MOUNT="/data"

echo "=================================="
echo " EAAS STORAGE AUTO-INITIALIZER"
echo "=================================="

echo "[1] Checking disk..."
lsblk $DISK

# Check if partition exists
if lsblk $PART >/dev/null 2>&1; then
    echo "[2] Partition already exists"
else
    echo "[2] Creating partition..."

    sudo parted -s $DISK mklabel gpt
    sudo parted -s $DISK mkpart primary ext4 0% 100%

    sleep 2
    sudo partprobe

    echo "[2] Partition created"
fi

# Format only if not formatted
if blkid $PART >/dev/null 2>&1; then
    echo "[3] Filesystem already exists"
else
    echo "[3] Formatting disk..."
    mkfs.ext4 $PART
fi

# Create mount point
mkdir -p $MOUNT

# Get UUID
UUID=$(blkid -s UUID -o value $PART)

echo "[4] Mounting disk..."
mount $PART $MOUNT || true

# Backup fstab
cp /etc/fstab /etc/fstab.bak

# Add to fstab if not exists
if grep -q "$UUID" /etc/fstab; then
    echo "[5] fstab already configured"
else
    echo "UUID=$UUID $MOUNT ext4 defaults 0 2" >> /etc/fstab
    echo "[5] fstab updated"
fi

echo "=================================="
echo " STORAGE SETUP COMPLETE"
echo " MOUNT: $MOUNT"
echo " UUID: $UUID"
echo "=================================="

df -h | grep $MOUNT || true
