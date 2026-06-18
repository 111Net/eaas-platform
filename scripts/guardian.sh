#!/bin/bash

LOGFILE="/opt/eaas/logs/guardian.log"

echo "===================================" >> $LOGFILE
echo "EAAS Guardian Started $(date)" >> $LOGFILE

echo "Updating Ubuntu..." >> $LOGFILE

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

echo "Checking Disk..." >> $LOGFILE
df -h >> $LOGFILE

echo "Checking Memory..." >> $LOGFILE
free -h >> $LOGFILE

echo "Checking Docker..." >> $LOGFILE
docker ps >> $LOGFILE

echo "Checking Docker Compose..." >> $LOGFILE

cd /opt/eaas/eaas-platform/infrastructure

docker compose ps >> $LOGFILE

echo "Updating Git Repository..." >> $LOGFILE

cd /opt/eaas/eaas-platform

git pull >> $LOGFILE 2>&1

echo "Updating Backend..." >> $LOGFILE

cd backend

pip install -r requirements.txt --upgrade

echo "Updating Frontend..." >> $LOGFILE

cd ../frontend

npm install
npm audit fix

echo "Restarting Containers..." >> $LOGFILE

cd ../infrastructure

docker compose down
docker compose build
docker compose up -d

echo "Guardian Finished $(date)" >> $LOGFILE

