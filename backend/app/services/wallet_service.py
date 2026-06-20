from sqlalchemy.orm import Session
from datetime import datetime
from app.models.wallet import Wallet
from app.models.ledger import LedgerEntry
import uuid

def get_wallet(db: Session, user_id: str):
    return db.query(Wallet).filter(Wallet.user_id == user_id).first()


def create_wallet_if_not_exists(db: Session, user_id: str):
    wallet = get_wallet(db, user_id)
    if wallet:
        return wallet

    wallet = Wallet(user_id=user_id, balance=0)
    db.add(wallet)
    db.commit()
    db.refresh(wallet)
    return wallet


def credit_wallet(db: Session, user_id: str, amount: float, description: str = ""):
    wallet = create_wallet_if_not_exists(db, user_id)

    wallet.balance += amount

    entry = LedgerEntry(
        user_id=user_id,
        wallet_id=wallet.id,
        type="credit",
        amount=amount,
        balance_after=wallet.balance,
        description=description,
        reference=str(uuid.uuid4())
    )

    db.add(entry)
    db.commit()
    db.refresh(wallet)

    return wallet


def debit_wallet(db: Session, user_id: str, amount: float, description: str = ""):
    wallet = create_wallet_if_not_exists(db, user_id)

    if wallet.balance < amount:
        raise Exception("Insufficient balance")

    wallet.balance -= amount

    entry = LedgerEntry(
        user_id=user_id,
        wallet_id=wallet.id,
        type="debit",
        amount=amount,
        balance_after=wallet.balance,
        description=description,
        reference=str(uuid.uuid4())
    )

    db.add(entry)
    db.commit()
    db.refresh(wallet)

    return wallet
