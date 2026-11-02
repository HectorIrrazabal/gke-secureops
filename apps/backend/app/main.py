import os

from fastapi import FastAPI

app = FastAPI(
    title="GKE SecureOps API",
    description="Backend de demostracion para Kubernetes",
    version="1.0.0",
)

APP_VERSION = os.getenv("APP_VERSION", "1.0.0")

ORDERS = [
    {"id": 1, "product": "Laptop", "status": "pending"},
    {"id": 2, "product": "Keyboard", "status": "completed"},
    {"id": 3, "product": "Monitor", "status": "processing"},
]


@app.get("/healthz")
def health():
    return {"status": "healthy"}


@app.get("/readyz")
def readiness():
    return {"status": "ready"}


@app.get("/version")
def version():
    return {"version": APP_VERSION}


@app.get("/api/orders")
def get_orders():
    return {
        "version": APP_VERSION,
        "orders": ORDERS,
    }
