import os
from pathlib import Path
import importlib.util

BASE_DIR = Path(__file__).resolve().parents[1] / "backend"
  # backend/
APP_DIR = BASE_DIR / "app"

print("\n=== EAAS RECOVERY CHECK (FIXED ROOT) ===\n")

def check(path, label):
    full = BASE_DIR / path
    if full.exists():
        print(f"[OK] {label} -> {path}")
    else:
        print(f"[MISSING] {label} -> {path}")

# CORE FILES
check("app/db/database.py", "Database")
check("alembic.ini", "Alembic config")
check("alembic/env.py", "Alembic env")

print("\n--- MODEL STRUCTURE ---")

check("app/models", "Models folder")
check("app/models/__init__.py", "__init__.py")
check("app/models/domain", "Domain models")
check("app/models/ledger", "Ledger models")
check("app/models/base", "Base folder")

print("\n--- IMPORT TEST ---")

try:
    spec = importlib.util.spec_from_file_location(
        "database",
        APP_DIR / "db/database.py"
    )
    db = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(db)
    print("[OK] database.py imports successfully")
except Exception as e:
    print("[FAIL] database import:", e)

print("\n=== DONE ===\n")
