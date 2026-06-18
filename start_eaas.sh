#!/bin/bash

cd /opt/eaas/eaas-platform/infrastructure

docker compose up -d

xdg-open http://localhost:8000
