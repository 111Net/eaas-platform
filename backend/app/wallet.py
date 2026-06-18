
from fastapi import APIRouter

router = APIRouter()

WALLETS = {}
TRANSACTIONS = []

@router.post("/wallet/create")
def create_wallet(user: str):
    
from fastapi import FastAPI
from app.api.wallet import router as wallet_router

app = FastAPI()

app.include_router(
    wallet_router,
    prefix="/api/v1",
    tags=["Wallet"]
)
