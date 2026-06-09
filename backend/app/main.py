from fastapi import FastAPI
from app.api.v1.routes import router

app = FastAPI(title="EAAS SaaS v10")

app.include_router(router, prefix="/api/v1")

@app.get("/")
def health():
    return {"status": "EAAS PRODUCTION READY"}
