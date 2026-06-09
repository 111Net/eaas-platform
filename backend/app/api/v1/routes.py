from fastapi import APIRouter

router = APIRouter()

DB = {}

@router.post("/auth/register")
def register(user: str):
    DB[user] = {"balance": 10000}
    return {"user": user, "status": "created"}

@router.post("/wallet/charge")
def charge(user: str, amount: float):
    DB[user]["balance"] -= amount
    return DB[user]

@router.get("/wallet/{user}")
def get_wallet(user: str):
    return DB.get(user, {"error": "not found"})
