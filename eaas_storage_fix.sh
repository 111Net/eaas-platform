#!/bin/bash

echo "================================="
echo " EAAS STORAGE AUTO-RECOVERY"
echo "================================="

set -e

echo "[1] Detecting largest available disk..."

DISK=$(lsblk -b -dn -o NAME,SIZE | awk '$2>50000000000 {print "/dev/"$1}' | sort -k2 -nr | head -n1)

echo "Selected disk: $DISK"

if [ -z "$DISK" ]; then
  echo "No valid disk found!"
  exit 1
fi

echo "[2] Cleaning old partitions..."
wipefs -a $DISK || true
sgdisk --zap-all $DISK || true

echo "[3] Creating GPT..."
parted $DISK --script mklabel gpt
parted $DISK --script mkpart primary ext4 0% 100%

PART="${DISK}1"

echo "[4] Waiting for partition..."
sleep 3

echo "[5] Formatting..."
mkfs.ext4 -F $PART

echo "[6] Mounting..."
mkdir -p /data
mount $PART /data

echo "[7] Adding to fstab..."
UUID=$(blkid -s UUID -o value $PART)
echo "UUID=$UUID /data ext4 defaults 0 2" >> /etc/fstab

echo "[8] Verification..."
df -h | grep data || echo "Mount failed!"

echo "================================="
echo " EAAS STORAGE READY"
echo "================================="
