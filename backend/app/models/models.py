from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from datetime import datetime
from app.db.database import Base


# -------------------------
# PROVIDER (TENANT)
# -------------------------
class Provider(Base):
    __tablename__ = "providers"

    id = Column(Integer, primary_key=True, index=True)
    provider_code = Column(String, unique=True, index=True)
    company_name = Column(String)
    contact_person = Column(String)
    email = Column(String)
    phone = Column(String)
    service_type = Column(String)


# -------------------------
# CLIENT (SCOPED TO PROVIDER)
# -------------------------
class Client(Base):
    __tablename__ = "clients"

    id = Column(Integer, primary_key=True, index=True)
    client_code = Column(String, unique=True, index=True)
    full_name = Column(String)
    email = Column(String)
    phone = Column(String)
    device_type = Column(String)

    provider_code = Column(String, ForeignKey("providers.provider_code"))


# -------------------------
# DEVICE INVENTORY (SCOPED)
# -------------------------
class Device(Base):
    __tablename__ = "devices"

    id = Column(Integer, primary_key=True, index=True)
    device_code = Column(String, unique=True, index=True)
    device_type = Column(String)
    manufacturer = Column(String)
    connectivity = Column(String)


# -------------------------
# WALLET (LEDGER MODEL)
# -------------------------
class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(Integer, primary_key=True, index=True)
    user = Column(String, index=True)  # client_code or user reference
    provider_code = Column(String, index=True)

    balance = Column(Float, default=0)  # cached balance (NOT manually trusted)


# -------------------------
# TRANSACTIONS (IMMUTABLE LEDGER)
# -------------------------
class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    user = Column(String, index=True)
    provider_code = Column(String, index=True)

    type = Column(String)  # CREDIT / DEBIT
    amount = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)


# -------------------------
# ENERGY USAGE (METER DATA)
# -------------------------
class EnergyUsage(Base):
    __tablename__ = "energy_usage"

    id = Column(Integer, primary_key=True, index=True)
    user = Column(String, index=True)
    provider_code = Column(String, index=True)

    kwh = Column(Float)
    cost = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)
class LedgerAccount(Base):
    __tablename__ = "ledger_accounts"

    id = Column(Integer, primary_key=True, index=True)
    owner_id = Column(String, index=True, unique=True)
    balance_cached = Column(Float, default=0)
class LedgerEntry(Base):
    __tablename__ = "ledger_entries"

    id = Column(Integer, primary_key=True, index=True)

    owner_id = Column(String, index=True)
    entry_type = Column(String)  # CREDIT / DEBIT
    amount = Column(Float)

    reference = Column(String)  # energy / topup / admin
    timestamp = Column(DateTime, default=datetime.utcnow)
