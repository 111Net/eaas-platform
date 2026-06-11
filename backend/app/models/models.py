from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from datetime import datetime
from app.db.database import Base

class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(Integer, primary_key=True, index=True)
    user = Column(String, unique=True, index=True)
    balance = Column(Float, default=0)


class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    user = Column(String, index=True)
    type = Column(String)  # CREDIT / DEBIT
    amount = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)


class EnergyUsage(Base):
    __tablename__ = "energy_usage"

    id = Column(Integer, primary_key=True, index=True)
    user = Column(String)
    kwh = Column(Float)
    cost = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)
