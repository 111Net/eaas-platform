from sqlalchemy import Column, String, Numeric, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
import uuid
from app.db.database import Base
from datetime import datetime

class LedgerEntry(Base):
    __tablename__ = "ledger_entries"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(String, nullable=False)
    wallet_id = Column(UUID(as_uuid=True), ForeignKey("wallets.id"))
    type = Column(String)
    amount = Column(Numeric)
    balance_after = Column(Numeric)
    description = Column(String)
    reference = Column(String, unique=True)
    created_at = Column(DateTime, default=datetime.utcnow)
