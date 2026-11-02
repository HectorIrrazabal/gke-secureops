from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health():
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_readiness():
    response = client.get("/readyz")
    assert response.status_code == 200
    assert response.json() == {"status": "ready"}


def test_version():
    response = client.get("/version")
    assert response.status_code == 200
    assert response.json()["version"]


def test_orders():
    response = client.get("/api/orders")
    assert response.status_code == 200

    data = response.json()

    assert data["version"]
    assert len(data["orders"]) == 3
    assert data["orders"][0]["product"] == "Laptop"


def test_unknown_endpoint():
    response = client.get("/not-found")
    assert response.status_code == 404
