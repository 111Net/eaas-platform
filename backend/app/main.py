from fastapi import FastAPI
from app.api.v1.routes import router

app = FastAPI(title="EAAS v10")

app.include_router(router, prefix="/api/v1")

@app.get("/")
def root():
    return {"status": "EAAS running"}
