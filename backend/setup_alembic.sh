#!/bin/bash

cd /opt/eaas/eaas-platform/backend

echo "Initializing Alembic..."
alembic init alembic

echo "Fixing alembic.ini..."
cat > alembic.ini <<EOF
[alembic]
script_location = alembic
sqlalchemy.url = postgresql://eaas_user:eaas_pass@localhost:5432/eaas_db
EOF

echo "Done. Now edit env.py manually."
