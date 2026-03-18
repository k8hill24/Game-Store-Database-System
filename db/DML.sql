-- Author: Kaitlyn Hill and Ivan Wu
-- Date: March 2026
-- File: DML.sql
-- Originality Statement: The SQL queries and sample data in this file are original work created for the CS340 Game Store Database project.



-- product queries
-- =====================================================

-- Get all product values
SELECT product_ID, product_name, platform, genre, price, quality, quantity 
FROM product;

-- Get a single product by ID
SELECT product_ID, product_name, platform, genre, price, quality, quantity 
FROM product 
WHERE product_ID = :product_id_selected;

-- Add a new product
INSERT INTO product (product_name, platform, genre, price, quality, quantity)
VALUES (:product_name_input, :platform_input, :genre_input, :price_input, :quality_input, :quantity_input);

-- Update a product
UPDATE product 
SET product_name = :product_name_input, 
    platform = :platform_input, 
    genre = :genre_input, 
    price = :price_input, 
    quality = :quality_input, 
    quantity = :quantity_input
WHERE product_ID = :product_id_selected;

-- Delete a product
DELETE FROM product WHERE product_ID = :product_id_selected;


-- customer queries
-- =====================================================

-- Get all customers values
SELECT customer_ID, first_name, last_name, email, phone, reward_balance 
FROM customer;

-- Get a single customer by ID
SELECT customer_ID, first_name, last_name, email, phone, reward_balance 
FROM customer 
WHERE customer_ID = :customer_id_selected;

-- Add a new customer
INSERT INTO customer (first_name, last_name, email, phone, reward_balance)
VALUES (:first_name_input, :last_name_input, :email_input, :phone_input, 0);

-- Update a customer
UPDATE customer 
SET first_name = :first_name_input, 
    last_name = :last_name_input, 
    email = :email_input, 
    phone = :phone_input
WHERE customer_ID = :customer_id_selected;

-- Delete a customer
DELETE FROM customer WHERE customer_ID = :customer_id_selected;


-- employee queries
-- =====================================================

-- Get all employees values
SELECT employee_ID, first_name, last_name, role 
FROM employee;

-- Get a single employee by ID
SELECT employee_ID, first_name, last_name, role 
FROM employee 
WHERE employee_ID = :employee_id_selected;

-- Insert
INSERT INTO employee (first_name, last_name, role)
VALUES (:first_name_input, :last_name_input, :role_input);

-- Update
UPDATE employee 
SET first_name = :first_name_input, 
    last_name = :last_name_input, 
    role = :role_input
WHERE employee_ID = :employee_id_selected;

-- Delete an employee
DELETE FROM employee WHERE employee_ID = :employee_id_selected;


-- sale queries
-- =====================================================

-- Get all sales values
SELECT 
    s.sale_ID, 
    s.sale_date, 
    s.total_price, 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CASE 
        WHEN c.customer_ID IS NULL THEN 'Walk-in Customer'
        ELSE CONCAT(c.first_name, ' ', c.last_name)
    END AS customer_name,
    s.rewards_earned, 
    s.rewards_redeemed
FROM sale s
INNER JOIN employee e ON s.employee_ID = e.employee_ID
LEFT JOIN customer c ON s.customer_ID = c.customer_ID;

-- Get a single sale by ID
SELECT 
    s.sale_ID, 
    s.sale_date, 
    s.total_price, 
    s.customer_ID,
    s.employee_ID,
    s.rewards_earned, 
    s.rewards_redeemed
FROM sale s
WHERE s.sale_ID = :sale_id_selected;

-- Add a new sale with customer (includes rewards)
INSERT INTO sale (sale_date, total_price, customer_ID, employee_ID, rewards_earned, rewards_redeemed)
VALUES (:sale_date_input, :total_price_input, :customer_id_input, :employee_id_input, :rewards_earned_calculated, :rewards_redeemed_input);

-- Add a new sale without customer (no rewards)
INSERT INTO sale (sale_date, total_price, customer_ID, employee_ID, rewards_earned, rewards_redeemed)
VALUES (:sale_date_input, :total_price_input, NULL, :employee_id_input, NULL, NULL);

-- Update a sale
UPDATE sale 
SET sale_date = :sale_date_input, 
    total_price = :total_price_input, 
    customer_ID = :customer_id_input, 
    employee_ID = :employee_id_input,
    rewards_earned = :rewards_earned_calculated,
    rewards_redeemed = :rewards_redeemed_input
WHERE sale_ID = :sale_id_selected;

-- Delete a sale (will also delete associated product_sale items due to ON DELETE CASCADE)
DELETE FROM sale WHERE sale_ID = :sale_id_selected;

-- Get dropdown data for employees (for sale form)
SELECT employee_ID, CONCAT(first_name, ' ', last_name) AS employee_name 
FROM employee;

-- Get dropdown data for customers (for sale form)
SELECT customer_ID, CONCAT(first_name, ' ', last_name) AS customer_name 
FROM customer;


-- product_sale queries
-- =====================================================

-- Get all product_sale records with product information
SELECT 
    ps.sale_item_ID, 
    ps.sale_ID, 
    ps.product_ID,
    p.product_name,
    ps.quantity, 
    ps.unit_price,
    (ps.quantity * ps.unit_price) AS line_total
FROM product_sale ps
INNER JOIN product p ON ps.product_ID = p.product_ID;

-- Get product_sale items for a specific sale
SELECT 
    ps.sale_item_ID, 
    ps.product_ID,
    p.product_name,
    ps.quantity, 
    ps.unit_price,
    (ps.quantity * ps.unit_price) AS line_total
FROM product_sale ps
INNER JOIN product p ON ps.product_ID = p.product_ID
WHERE ps.sale_ID = :sale_id_selected;

-- Add a product to a sale
INSERT INTO product_sale (sale_ID, product_ID, quantity, unit_price)
VALUES (:sale_id_input, :product_id_input, :quantity_input, :unit_price_input);

-- Update a product_sale item
UPDATE product_sale 
SET product_ID = :product_id_input, 
    quantity = :quantity_input, 
    unit_price = :unit_price_input
WHERE sale_item_ID = :sale_item_id_selected;

-- Delete a product from a sale
DELETE FROM product_sale WHERE sale_item_ID = :sale_item_id_selected;

-- Get dropdown data for products (for product_sale form)
SELECT product_ID, product_name, price 
FROM product;

-- Get dropdown data for sales (for product_sale form)
SELECT sale_ID, sale_date 
FROM sale;

