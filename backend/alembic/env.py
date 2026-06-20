from app.models import Base
from app.db.database import DATABASE_URL
from sqlalchemy import engine_from_config, pool
from alembic import context

target_metadata = Base.metadata