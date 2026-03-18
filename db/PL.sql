-- Author: Kaitlyn Hill and Ivan Wu
-- Date: March 2026
-- File: PL.sql
-- Originality Statement: The stored procedures in this file are original work created for the CS340 Game Store Database project.


DROP PROCEDURE IF EXISTS sp_delete_product;
DELIMITER //
CREATE PROCEDURE sp_delete_product(IN p_product_id INT)
BEGIN
    DELETE FROM product_sale WHERE product_ID = p_product_id;
    DELETE FROM product WHERE product_ID = p_product_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_delete_customer;
DELIMITER //
CREATE PROCEDURE sp_delete_customer(IN p_customer_id INT)
BEGIN
    DELETE FROM customer WHERE customer_ID = p_customer_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_delete_employee;
DELIMITER //
CREATE PROCEDURE sp_delete_employee(IN p_employee_id INT)
BEGIN
    DELETE FROM employee WHERE employee_ID = p_employee_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_delete_sale;
DELIMITER //
CREATE PROCEDURE sp_delete_sale(IN p_sale_id INT)
BEGIN
    DELETE FROM product_sale WHERE sale_ID = p_sale_id;
    DELETE FROM sale WHERE sale_ID = p_sale_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_delete_product_sale;
DELIMITER //
CREATE PROCEDURE sp_delete_product_sale(IN p_sale_item_id INT)
BEGIN
    DELETE FROM product_sale WHERE sale_item_ID = p_sale_item_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_insert_product;
DELIMITER //
CREATE PROCEDURE sp_insert_product(
    IN p_name VARCHAR(200),
    IN p_platform VARCHAR(50),
    IN p_genre VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_quality VARCHAR(50),
    IN p_quantity INT
)
BEGIN
    INSERT INTO product (product_name, platform, genre, price, quality, quantity)
    VALUES (p_name, p_platform, p_genre, p_price, p_quality, p_quantity);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_insert_customer;
DELIMITER //
CREATE PROCEDURE sp_insert_customer(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(10)
)
BEGIN
    INSERT INTO customer (first_name, last_name, email, phone, reward_balance)
    VALUES (p_first_name, p_last_name, p_email, p_phone, 0);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_insert_employee;
DELIMITER //
CREATE PROCEDURE sp_insert_employee(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_role VARCHAR(50)
)
BEGIN
    INSERT INTO employee (first_name, last_name, role)
    VALUES (p_first_name, p_last_name, p_role);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_insert_sale;
DELIMITER //
CREATE PROCEDURE sp_insert_sale(
    IN p_sale_date DATETIME,
    IN p_total_price DECIMAL(10,2),
    IN p_customer_id INT,
    IN p_employee_id INT,
    IN p_rewards_earned DECIMAL(10,2),
    IN p_rewards_redeemed DECIMAL(10,2)
)
BEGIN
    INSERT INTO sale (sale_date, total_price, customer_ID, employee_ID, rewards_earned, rewards_redeemed)
    VALUES (p_sale_date, p_total_price, p_customer_id, p_employee_id, p_rewards_earned, p_rewards_redeemed);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_insert_product_sale;
DELIMITER //
CREATE PROCEDURE sp_insert_product_sale(
    IN p_sale_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO product_sale (sale_ID, product_ID, quantity, unit_price)
    VALUES (p_sale_id, p_product_id, p_quantity, p_unit_price);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_product;
DELIMITER //
CREATE PROCEDURE sp_update_product(
    IN p_id INT,
    IN p_name VARCHAR(200),
    IN p_platform VARCHAR(50),
    IN p_genre VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_quality VARCHAR(50),
    IN p_quantity INT
)
BEGIN
    UPDATE product
    SET product_name = p_name,
        platform = p_platform,
        genre = p_genre,
        price = p_price,
        quality = p_quality,
        quantity = p_quantity
    WHERE product_ID = p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_customer;
DELIMITER //
CREATE PROCEDURE sp_update_customer(
    IN p_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(10)
)
BEGIN
    UPDATE customer
    SET first_name = p_first_name,
        last_name = p_last_name,
        email = p_email,
        phone = p_phone
    WHERE customer_ID = p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_employee;
DELIMITER //
CREATE PROCEDURE sp_update_employee(
    IN p_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_role VARCHAR(50)
)
BEGIN
    UPDATE employee
    SET first_name = p_first_name,
        last_name = p_last_name,
        role = p_role
    WHERE employee_ID = p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_product_sale;
DELIMITER //
CREATE PROCEDURE sp_update_product_sale(
    IN p_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    UPDATE product_sale
    SET product_ID = p_product_id,
        quantity = p_quantity,
        unit_price = p_unit_price
    WHERE sale_item_ID = p_id;
END //
DELIMITER ;
