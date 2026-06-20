from sqlalchemy import Column, Integer, String, Float, DateTime
from datetime import datetime
from app.models.base.base import Base


class LedgerAccount(Base):
    __tablename__ = "ledger_accounts"

    id = Column(Integer, primary_key=True, index=True)
    owner_id = Column(String, unique=True, index=True)
    balance_cached = Column(Float, default=0)


class LedgerEntry(Base):
    __tablename__ = "ledger_entries"

    id = Column(Integer, primary_key=True, index=True)

    owner_id = Column(String, index=True)
    entry_type = Column(String)  # CREDIT / DEBIT
    amount = Column(Float)

    reference = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)