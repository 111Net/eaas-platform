from fastapi import APIRouter
from app.db.database import SessionLocal
from app.models.models import LedgerAccount, LedgerEntry

router = APIRouter()

def get_account(db, user):
    acc = db.query(LedgerAccount).filter_by(owner_id=user).first()
    if not acc:
        acc = LedgerAccount(owner_id=user, balance_cached=0)
        db.add(acc)
        db.commit()
        db.refresh(acc)
    return acc


@router.post("/wallet/topup")
def topup(user: str, amount: float):
    db = SessionLocal()
    acc = get_account(db, user)

    acc.balance_cached += amount

    db.add(LedgerEntry(
        owner_id=user,
        entry_type="CREDIT",
        amount=amount,
        reference="topup"
    ))

    db.commit()
    return {"user": user, "balance": acc.balance_cached}


@router.post("/wallet/charge")
def charge(user: str, amount: float):
    db = SessionLocal()
    acc = get_account(db, user)

    acc.balance_cached -= amount

    db.add(LedgerEntry(
        owner_id=user,
        entry_type="DEBIT",
        amount=amount,
        reference="energy_usage"
    ))

    db.commit()
    return {"user": user, "balance": acc.balance_cached}
