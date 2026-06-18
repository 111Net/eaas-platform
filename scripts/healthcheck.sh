#!/bin/bash

echo "========== EAAS HEALTH =========="

hostname

uptime

echo ""
echo "Disk"
df -h

echo ""
echo "Memory"
free -h

echo ""
echo "Docker"
docker ps

echo ""
echo "Docker Usage"
docker system df

echo ""
echo "Internet"
ping -c 4 8.8.8.8

echo ""
echo "Backend"

curl http://localhost:8000

echo ""
echo "Frontend"

curl http://localhost:3000

echo ""
echo "Frontend Check"

if curl -s http://localhost:3000 > /dev/null
then
    echo "Frontend OK"
else
    echo "Frontend NOT RUNNING"
fi
