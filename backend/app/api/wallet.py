rom fastapi import APIRouter

router = APIRouter()

WALLETS = {}
TRANSACTIONS = []

@router.post("/wallet/create")
def create_wallet(user: str):
 

