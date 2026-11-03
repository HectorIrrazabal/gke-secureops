import os

import pytest
from fastapi.testclient import TestClient

from app.main import app

pytestmark = pytest.mark.skipif(
    os.getenv("RUN_DB_INTEGRATION_TESTS") != "1",
    reason="Requires PostgreSQL integration test environment",
)

client = TestClient(app)


def test_postgresql_orders():
    response = client.get("/api/orders")

    assert response.status_code == 200

    orders = response.json()["orders"]

    assert len(orders) == 3
    assert any(order["product"] == "Laptop" for order in orders)
    assert any(order["product"] == "Keyboard" for order in orders)


def test_create_update_delete_order():
    response = client.post(
        "/api/orders",
        json={"product_id": 1, "quantity": 2},
    )

    assert response.status_code == 201

    created = response.json()
    order_id = created["id"]

    assert created["quantity"] == 2
    assert created["status"] == "pending"

    try:
        response = client.patch(
            f"/api/orders/{order_id}",
            json={"status": "completed"},
        )

        assert response.status_code == 200
        assert response.json()["status"] == "completed"

        response = client.get("/api/orders")

        assert response.status_code == 200
        assert any(
            order["id"] == order_id
            and order["status"] == "completed"
            for order in response.json()["orders"]
        )

    finally:
        deleted = client.delete(f"/api/orders/{order_id}")

    assert deleted.status_code == 200
    assert deleted.json()["id"] == order_id

    response = client.get("/api/orders")

    assert all(
        order["id"] != order_id
        for order in response.json()["orders"]
    )


def test_invalid_product():
    response = client.post(
        "/api/orders",
        json={"product_id": 999999, "quantity": 1},
    )

    assert response.status_code == 404
    assert response.json()["detail"] == "Product not found"
