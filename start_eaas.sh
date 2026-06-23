#!/bin/bash

cd /opt/eaas/eaas-platform

echo "🚀 Starting EAAS Platform..."

# backend (example fix — replace with real backend later)
python3 -m http.server 3000
