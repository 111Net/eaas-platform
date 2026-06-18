from fastapi import FastAPI
from app.api.v1.routes import router
import psutil
import time

app = FastAPI(title="EAAS Platform")

app.include_router(router, prefix="/api/v1")


@app.get("/")
def home():
    return {
        "product": "EAAS Platform",
        "status": "live",
        "mode": "investor_demo",
        "entry": "/demo",
        "docs": "/docs"
    }


@app.get("/health")
def health():
    return {
        "status": "ok",
        "system": "EAAS running"
    }


@app.get("/demo")
def investor_demo():
    return {
        "product": "EAAS Energy-as-a-Service Platform",
        "status": "LIVE",
        "mode": "investor_demo",

        "vision":
        "Distributed energy + IoT + billing automation for Africa",

        "entry_points": {
            "api": "/docs",
            "health": "/health",
            "metrics": "/metrics"
        },

        "investment_highlights": [
            "Smart metering",
            "Billing automation",
            "IoT monitoring",
            "Subscription revenue model"
        ]
    }


@app.get("/metrics")
def metrics():
    return {
        "cpu_percent": psutil.cpu_percent(),
        "memory_percent": psutil.virtual_memory().percent,
        "disk_percent": psutil.disk_usage('/').percent,
        "timestamp": int(time.time())
    }
