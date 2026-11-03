import os

import psycopg
from psycopg.rows import dict_row
from fastapi import FastAPI, HTTPException

app = FastAPI(
    title="GKE SecureOps API",
    description="Order management API backed by PostgreSQL",
    version="1.1.0",
)

APP_VERSION = os.getenv("APP_VERSION", "1.1.0")


def get_db_connection():
    return psycopg.connect(
        host=os.getenv("POSTGRES_HOST", "secureops-postgres"),
        port=int(os.getenv("POSTGRES_PORT", "5432")),
        dbname=os.getenv("POSTGRES_DB", "secureops"),
        user=os.getenv("POSTGRES_USER", "secureops"),
        password=os.environ["POSTGRES_PASSWORD"],
        connect_timeout=5,
        row_factory=dict_row,
    )


def fetch_orders():
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    o.id,
                    p.name AS product,
                    o.quantity,
                    o.status
                FROM orders o
                JOIN products p ON p.id = o.product_id
                ORDER BY o.id
            """)
            return cursor.fetchall()


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
    try:
        orders = fetch_orders()
    except (psycopg.Error, OSError, KeyError, ValueError):
        raise HTTPException(
            status_code=503,
            detail="Database temporarily unavailable",
        )

    return {
        "version": APP_VERSION,
        "orders": orders,
    }

from typing import Literal
from pydantic import BaseModel, Field


class OrderCreate(BaseModel):
    product_id: int = Field(gt=0)
    quantity: int = Field(default=1, gt=0)


class OrderUpdate(BaseModel):
    status: Literal["pending", "processing", "completed", "cancelled"]


@app.post("/api/orders", status_code=201)
def create_order(order: OrderCreate):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO orders (product_id, quantity, status)
                    VALUES (%s, %s, 'pending')
                    RETURNING id, product_id, quantity, status
                    """,
                    (order.product_id, order.quantity),
                )
                result = cursor.fetchone()
            conn.commit()
            return result

    except psycopg.errors.ForeignKeyViolation:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )
    except (psycopg.Error, OSError, KeyError, ValueError):
        raise HTTPException(
            status_code=503,
            detail="Database temporarily unavailable",
        )


@app.patch("/api/orders/{order_id}")
def update_order(order_id: int, order: OrderUpdate):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    UPDATE orders
                    SET status = %s
                    WHERE id = %s
                    RETURNING id, product_id, quantity, status
                    """,
                    (order.status, order_id),
                )
                result = cursor.fetchone()

            if result is None:
                raise HTTPException(
                    status_code=404,
                    detail="Order not found",
                )

            conn.commit()
            return result

    except HTTPException:
        raise
    except (psycopg.Error, OSError, KeyError, ValueError):
        raise HTTPException(
            status_code=503,
            detail="Database temporarily unavailable",
        )


@app.delete("/api/orders/{order_id}")
def delete_order(order_id: int):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM orders WHERE id = %s RETURNING id",
                    (order_id,),
                )
                result = cursor.fetchone()

            if result is None:
                raise HTTPException(
                    status_code=404,
                    detail="Order not found",
                )

            conn.commit()
            return {
                "message": "Order deleted",
                "id": order_id,
            }

    except HTTPException:
        raise
    except (psycopg.Error, OSError, KeyError, ValueError):
        raise HTTPException(
            status_code=503,
            detail="Database temporarily unavailable",
        )
