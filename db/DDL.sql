-- Author: Kaitlyn Hill and Ivan Wu
-- Date: March 2026
-- File: DDL.sql
-- Originality Statement: The SQL schema and table definitions in this file are original work created for the CS340 Game Store Database project.


DROP PROCEDURE IF EXISTS sp_reset_database;

DELIMITER //

CREATE PROCEDURE sp_reset_database()
BEGIN

    -- Deletes all tables --
    -- =====================================================

    DROP TABLE IF EXISTS product_sale;
    DROP TABLE IF EXISTS sale;
    DROP TABLE IF EXISTS product;
    DROP TABLE IF EXISTS customer;
    DROP TABLE IF EXISTS employee;

    -- Table Creations --
    -- =====================================================

    CREATE TABLE product (
        product_ID INT NOT NULL UNIQUE AUTO_INCREMENT,
        product_name VARCHAR(200) NOT NULL,
        platform ENUM('Playstation', 'Xbox', 'Nintendo', 'PC', 'Board Game', 'Card Game', 'Other') NOT NULL,
        genre ENUM('Action', 'Adventure', 'RPG', 'Shooter', 'Sports', 'Simulation', 'Puzzle', 'Horror', 'Fighting', 'Racing', 'Sandbox', 'Survival', 'Strategy', 'Party', 'Other') NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        quality ENUM('Unsellable', 'Poor', 'Average', 'Excellent', 'Near Mint') NOT NULL,
        quantity INT NOT NULL DEFAULT 0,
        PRIMARY KEY (product_ID)
    );

    CREATE TABLE customer (
        customer_ID INT NOT NULL UNIQUE AUTO_INCREMENT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        email VARCHAR(100),
        phone VARCHAR(10),
        reward_balance DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (reward_balance <= 300),

        CONSTRAINT unq_email UNIQUE (email),
        CONSTRAINT unq_phone UNIQUE (phone),
        CONSTRAINT email_or_phone CHECK (email IS NOT NULL OR phone IS NOT NULL),

        PRIMARY KEY (customer_ID)
    );

    CREATE TABLE employee (
        employee_ID INT NOT NULL UNIQUE AUTO_INCREMENT,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        role ENUM('Cashier', 'Stocker', 'Manager', 'Supervisor', 'Other'),
        PRIMARY KEY (employee_ID)
    );

    CREATE TABLE sale (
        sale_ID INT NOT NULL UNIQUE AUTO_INCREMENT,
        sale_date DATETIME NOT NULL,
        total_price DECIMAL(10,2) NOT NULL,
        customer_ID INT,
        employee_ID INT NOT NULL,
        rewards_earned DECIMAL(10,2),
        rewards_redeemed DECIMAL(10,2),

        CONSTRAINT chk_rewards_earned CHECK (
            (customer_ID IS NULL AND rewards_earned IS NULL) OR
            (customer_ID IS NOT NULL AND rewards_earned IS NOT NULL)
        ),

        CONSTRAINT chk_rewards_redeemed CHECK (
            (customer_ID IS NULL AND rewards_redeemed IS NULL) OR
            (customer_ID IS NOT NULL AND rewards_redeemed IS NOT NULL)
        ),

        PRIMARY KEY (sale_ID),
        FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID),
        FOREIGN KEY (employee_ID) REFERENCES employee(employee_ID)
    );

    CREATE TABLE product_sale (
        sale_item_ID INT NOT NULL UNIQUE AUTO_INCREMENT,
        sale_ID INT NOT NULL,
        product_ID INT NOT NULL,
        quantity INT NOT NULL,
        unit_price DECIMAL(10,2) NOT NULL,

        PRIMARY KEY (sale_item_ID),
        FOREIGN KEY (sale_ID) REFERENCES sale(sale_ID) ON DELETE CASCADE,
        FOREIGN KEY (product_ID) REFERENCES product(product_ID) ON DELETE RESTRICT
    );

    -- Table Data --
    -- =====================================================

    INSERT INTO product (product_name, platform, genre, price, quality, quantity)
    VALUES
    ('The Last of Us Part II', 'Playstation', 'Action', 30, 'Excellent', 9),
    ('The Last of Us Part II', 'Playstation', 'Action', 15, 'Poor', 18),
    ('The Elder Scrolls V: Skyrim', 'Playstation', 'RPG', 25, 'Near Mint', 20),
    ('Minecraft', 'Playstation', 'Sandbox', 20, 'Average', 12),
    ('Resident Evil Village', 'Playstation', 'Horror', 18, 'Poor', 18),
    ('Tomb Raider: Legacy of Atlantis', 'Xbox', 'Adventure', 23, 'Near Mint', 6),
    ('Halo Infinite', 'Xbox', 'Shooter', 40, 'Excellent', 11),
    ('Forza Horizon 5', 'Xbox', 'Racing', 30, 'Average', 18),
    ('FIFA 23', 'Xbox', 'Sports', 20, 'Average', 12),
    ('Mario Kart 8 Deluxe', 'Nintendo', 'Racing', 50, 'Near Mint', 2),
    ('Mario Party 9', 'Nintendo', 'Party', 40, 'Excellent', 17),
    ('Street Fighter 6', 'Nintendo', 'Fighting', 45, 'Near Mint', 12),
    ('The Sims 4', 'PC', 'Simulation', 30, 'Excellent', 4),
    ('Portal 2', 'PC', 'Puzzle', 15, 'Near Mint', 15),
    ('Subnautica', 'PC', 'Survival', 20, 'Average', 7),
    ('Catan', 'Board Game', 'Strategy', 35, 'Average', 2),
    ('Catan', 'Board Game', 'Strategy', 0, 'Unsellable', 1),
    ('Catan', 'Board Game', 'Strategy', 45, 'Excellent', 2),
    ('7 Wonders', 'Board Game', 'Strategy', 40, 'Excellent', 19),
    ('Monopoly', 'Board Game', 'Party', 15, 'Poor', 15),
    ('UNO', 'Card Game', 'Party', 5, 'Poor', 16),
    ('Exploding Kittens', 'Card Game', 'Party', 15, 'Near Mint', 7),
    ('Nintendo Switch Pro Controller', 'Nintendo', 'Other', 60, 'Near Mint', 11),
    ('Nintendo Switch Pro Controller', 'Nintendo', 'Other', 40, 'Average', 15),
    ('Xbox Wireless Controller', 'Xbox', 'Other', 65, 'Near Mint', 0);

    INSERT INTO customer (first_name, last_name, email, phone, reward_balance)
    VALUES
    ('Tom', 'Hanks', 'Tomh@yahoo.com', NULL, 300),
    ('Emma', 'Watson', NULL, 3057096482, 28.70),
    ('Robert', 'Pattinson', 'RobPat1234@gmail.com', 6317694595, 9.20),
    ('Amelia', 'Earhart', 'AmeliaFlies@gmail.com', 5056441324, 58.00),
    ('Freddie', 'Mercury', 'Freddddy@hotmail.com', NULL, 144.60);

    INSERT INTO employee (first_name, last_name, role)
    VALUES
    ('Simone', 'Biles', 'Supervisor'),
    ('Johnny', 'Depp', 'Stocker'),
    ('Steve', 'Harvey', 'Cashier'),
    ('Dolly', 'Parton', 'Manager');

    INSERT INTO sale (sale_ID, sale_date, total_price, customer_ID, employee_ID, rewards_earned, rewards_redeemed)
    VALUES
    (1, '2026-01-25 11:18', '48', NULL, 3, NULL, NULL),
    (2, '2026-01-25 12:47', 100.00, 3, 3, 10.00, 0.00),
    (3, '2026-01-25 22:29', 220.00, 2, 1, 22.00, 0.00),
    (4, '2026-01-25 14:44', 30.00, NULL, 3, NULL, NULL),
    (5, '2026-01-25 15:51', 180.00, 1, 1, 18.00, 162.00);

    INSERT INTO product_sale (sale_ID, product_ID, quantity, unit_price)
    VALUES
    (1, 1, 1, 30),
    (1, 4, 1, 18),
    (2, 16, 1, 35),
    (2, 18, 1, 45),
    (2, 15, 1, 20),
    (3, 23, 3, 60),
    (3, 24, 1, 40),
    (4, 13, 2, 30),
    (5, 10, 1, 50),
    (5, 11, 1, 40),
    (5, 12, 2, 45);

END //

DELIMITER ;
