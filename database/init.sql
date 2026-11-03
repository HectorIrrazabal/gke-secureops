CREATE TABLE IF NOT EXISTS products (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    status VARCHAR(30) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);

INSERT INTO products (name, price)
VALUES
    ('Laptop', 899990.00),
    ('Keyboard', 39990.00),
    ('Monitor', 199990.00)
ON CONFLICT (name) DO NOTHING;

INSERT INTO orders (product_id, quantity, status)
SELECT id, 1, 'pending' FROM products WHERE name = 'Laptop'
AND NOT EXISTS (SELECT 1 FROM orders)
UNION ALL
SELECT id, 1, 'completed' FROM products WHERE name = 'Keyboard'
AND NOT EXISTS (SELECT 1 FROM orders)
UNION ALL
SELECT id, 1, 'processing' FROM products WHERE name = 'Monitor'
AND NOT EXISTS (SELECT 1 FROM orders);
