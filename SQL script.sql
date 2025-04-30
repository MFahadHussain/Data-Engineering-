
-- USERS table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);

-- PRODUCTS table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

-- ORDERS table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ORDER_ITEMS table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER,
    price_each DECIMAL(10,2)
);



INSERT INTO users (name, email) VALUES
('Fahad Hussain', 'fahad@example.com'),
('Ali Khan', 'ali.khan@example.com'),
('Sara Ahmad', 'sara.ahmad@example.com'),
('Bilal Noor', 'bilal.noor@example.com'),
('Ayesha Siddiqui', 'ayesha.siddiqui@example.com');


INSERT INTO products (name, price) VALUES
('Laptop', 85000.00),
('Smartphone', 45000.00),
('Headphones', 3500.00),
('Office Chair', 12000.00),
('Gaming Mouse', 2500.00),
('Wireless Keyboard', 4000.00),
('Smartwatch', 15000.00),
('Bluetooth Speaker', 7000.00);

-- Orders placed by users
INSERT INTO orders (user_id, order_date) VALUES
(1, '2024-12-01 10:00:00'),
(2, '2024-12-03 14:30:00'),
(3, '2024-12-05 18:45:00'),
(1, '2025-01-10 11:15:00'),
(4, '2025-01-12 16:20:00'),
(5, '2025-02-01 09:10:00');


-- Products bought in each order
INSERT INTO order_items (order_id, product_id, quantity, price_each) VALUES
(1, 1, 1, 85000.00), -- Fahad bought 1 Laptop
(1, 3, 2, 3500.00),  -- Fahad also bought 2 Headphones
(2, 2, 1, 45000.00), -- Ali bought 1 Smartphone
(3, 5, 1, 2500.00),  -- Sara bought 1 Gaming Mouse
(4, 4, 1, 12000.00), -- Fahad (second order) bought 1 Office Chair
(4, 6, 1, 4000.00),  -- and 1 Wireless Keyboard
(5, 7, 1, 15000.00), -- Bilal bought 1 Smartwatch
(6, 8, 1, 7000.00);  -- Ayesha bought 1 Bluetooth Speaker


SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;




SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity * oi.price_each) AS revenue
FROM
    orders o
JOIN
    order_items oi ON o.id = oi.order_id
GROUP BY
    month
ORDER BY
    month;
    
  
/*. b) Top 5 Customers by Revenue */  
  
SELECT
    u.name,
    u.email,
    SUM(oi.quantity * oi.price_each) AS total_spent
FROM
    users u
JOIN
    orders o ON u.id = o.user_id
JOIN
    order_items oi ON o.id = oi.order_id
GROUP BY
    u.id
ORDER BY
    total_spent DESC
LIMIT 5;



/*. ✅ Explanation:

Joining users -> orders -> order_items.

Summing total purchase value.

Sorting and limiting to top 5. */  



/*. c) Products Sold Per Month (Window Function) */  

SELECT
    p.name,
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity) OVER (PARTITION BY p.id, DATE_TRUNC('month', o.order_date)) AS monthly_quantity
FROM
    products p
JOIN
    order_items oi ON p.id = oi.product_id
JOIN
    orders o ON oi.order_id = o.id;



-- Faster search for orders by user
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Faster join on order_items
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Faster search on products
CREATE INDEX idx_order_items_product_id ON order_items(product_id);



WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.quantity * oi.price_each) AS revenue
    FROM
        orders o
    JOIN
        order_items oi ON o.id = oi.order_id
    GROUP BY
        month
)
SELECT *
FROM monthly_sales
WHERE revenue > 10000;


SELECT
    date_format('month', o.order_date) AS month,
    SUM(oi.quantity * oi.price_each) / COUNT(DISTINCT o.id) AS avg_order_value
FROM
    orders o
JOIN
    order_items oi ON o.id = oi.order_id
GROUP BY
    month
ORDER BY
    month;
    
    
SELECT
    p.name,
    SUM(oi.quantity) AS total_units_sold
FROM
    products p
JOIN
    order_items oi ON p.id = oi.product_id
GROUP BY
    p.id
ORDER BY
    total_units_sold DESC
LIMIT 10;



/* c) 🧑‍💼 Customer Retention Rate (Advanced)
Let’s say:

First order = New Customer

Repeat orders = Retained Customer */

WITH user_orders AS (
    SELECT
        user_id,
        COUNT(*) AS total_orders
    FROM
        orders
    GROUP BY
        user_id
)
SELECT
    COUNT(CASE WHEN total_orders = 1 THEN 1 END) AS new_customers,
    COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS retained_customers
FROM
    user_orders;


WITH revenue_per_month AS (
    SELECT
        date_format('month', o.order_date) AS month,
        SUM(oi.quantity * oi.price_each) AS revenue
    FROM
        orders o
    JOIN
        order_items oi ON o.id = oi.order_id
    GROUP BY
        month
)
SELECT
    month,
    revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS growth
FROM
    revenue_per_month;


SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(oi.quantity * oi.price_each) AS revenue
FROM
    orders o
JOIN
    order_items oi ON o.id = oi.order_id
GROUP BY
    YEAR(order_date), MONTH(order_date)
ORDER BY
    year, month;


SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.price_each) AS revenue
FROM
    orders o
JOIN
    order_items oi ON o.id = oi.order_id
WHERE
    o.order_date IS NOT NULL
GROUP BY
    month
ORDER BY
    month;


UPDATE orders
SET order_date = NOW()
WHERE order_date IS NULL;



