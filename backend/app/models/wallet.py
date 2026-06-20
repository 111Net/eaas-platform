from sqlalchemy import Column, String, Numeric, DateTime
from sqlalchemy.dialects.postgresql import UUID
import uuid
from app.db.database import Base
from datetime import datetime

class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(String, nullable=False, unique=True)
    balance = Column(Numeric, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
