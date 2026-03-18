# Game Store Database Web Application

## Overview  
This project is a full-stack database-driven web application developed for managing a small brick-and-mortar game store. It demonstrates database design, implementation, and integration with a user-friendly web interface.

The application supports full CRUD (Create, Read, Update, Delete) functionality across multiple entities, including products, customers, employees, sales, and product-sale relationships.

---

## Technologies Used  
- Node.js with Express  
- MySQL / MariaDB  
- HTML and CSS  
- JavaScript  

---

## Features  
- View and browse records for all entities  
- Add new records through forms  
- Update existing records  
- Delete records with confirmation  
- Many-to-many relationship handling via the product_sale table  
- Input validation to prevent invalid data  

---

## Database Design  
The database consists of the following core entities:  
- Product  
- Customer  
- Employee  
- Sale  
- Product_Sale (intersection table for products and sales)

The schema was designed to maintain data integrity and support relational constraints, including handling many-to-many relationships.

---

## Project Structure  
- app.js – Main server file  
- db/ – SQL files (DDL, DML, stored procedures)  
- config/ – Database connection template  
- views/ – HTML pages for each entity  
- public/ – CSS styling  
- report/ – Final project report and documentation  

---

## Setup Instructions (Local)  
1. Install Node.js and MySQL/MariaDB  
2. Create a database and run the SQL scripts in the db/ folder  
3. Configure your database connection using db-connector.js  
4. Run the application:  

   npm install  
   npm start  

5. Open your browser and navigate to http://localhost:PORT  

---

## Notes on Deployment  
This project was originally deployed on an Oregon State University class server. The hosting environment and database were temporary and are no longer active.

This repository preserves the full source code, SQL schema, and documentation. The application can be run locally by configuring a database connection.

---

## Contributors  
- Kaitlyn Hill
- Ivan Wu
