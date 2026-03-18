/*
    SETUP
*/
const express = require('express');
const app = express();
const PORT = 7541;

const db = require('./db-connector');

// Serve static files (HTML, CSS, JS)
app.use(express.static('.'));

// Parse form data
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

/*
    ROUTES
*/

// Home page
app.get('/', function(req, res) {
    res.sendFile(__dirname + '/index.html');
});

// Database test route
app.get('/test-db', async function(req, res) {
    try {
        const query = 'SELECT "MySQL and Node is working!" as message';
        const [rows] = await db.query(query);
        res.send('<h1>MySQL Results:</h1>' + JSON.stringify(rows));
    } catch (error) {
        console.error("Database error:", error);
        res.status(500).send("Database connection failed");
    }
});

// RESET route
app.post('/reset', async function(req, res) {
    try {
        const query = "CALL sp_reset_database();";
        await db.query(query);
        console.log("Database reset successful");
        res.redirect('/');
    } catch (error) {
        console.error("Reset error:", error);
        res.status(500).send("Reset failed: " + error.message);
    }
});

// =====================================================
// DEMO DELETE ROUTE
// =====================================================
app.get('/delete-demo', async function(req, res) {
    try {
        console.log('Deleting product ID=1 for demo...');
        // Use stored procedure instead of direct SQL
        await db.query('CALL sp_delete_product(?)', [1]);
        res.send(`
            <h1>Product Deleted!</h1>
            <p>Product ID=1 has been deleted to demonstrate RESET.</p>
            <p>The sp_delete_product stored procedure was used.</p>
            <p><a href="/products.html">View Products</a> | <a href="/">Home</a></p>
        `);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).send("Error deleting product: " + error.message);
    }
});

// =====================================================
// PRODUCTS API
// =====================================================
app.get('/api/products', async function(req, res) {
    try {
        const query = 'SELECT product_ID, product_name, platform, genre, price, quality, quantity FROM product ORDER BY product_ID';
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to fetch products" });
    }
});

app.post('/api/products', async function(req, res) {
    try {
        const { product_name, platform, genre, price, quality, quantity } = req.body;
        
        console.log('Inserting product:', product_name);
        
        await db.query('CALL sp_insert_product(?, ?, ?, ?, ?, ?)', 
            [product_name, platform, genre, price, quality, quantity]);
        
        res.json({ message: 'Product added successfully' });
    } catch (error) {
        console.error("Error inserting product:", error);
        res.status(500).json({ error: "Failed to add product: " + error.message });
    }
});

app.put('/api/products/:id', async function(req, res) {
    try {
        const productId = req.params.id;
        const { product_name, platform, genre, price, quality, quantity } = req.body;
        
        console.log('Updating product ID:', productId);
        
        await db.query('CALL sp_update_product(?, ?, ?, ?, ?, ?, ?)', 
            [productId, product_name, platform, genre, price, quality, quantity]);
        
        res.json({ message: 'Product updated successfully' });
    } catch (error) {
        console.error("Error updating product:", error);
        res.status(500).json({ error: "Failed to update product: " + error.message });
    }
});

app.delete('/api/products/:id', async function(req, res) {
    try {
        const productId = req.params.id;
        
        // Call the stored procedure
        await db.query('CALL sp_delete_product(?)', [productId]);
        
        res.json({ message: 'Product deleted successfully' });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to delete product: " + error.message });
    }
});

// =====================================================
// CUSTOMERS API
// =====================================================
app.get('/api/customers', async function(req, res) {
    try {
        const query = 'SELECT customer_ID, first_name, last_name, email, phone, reward_balance FROM customer ORDER BY customer_ID';
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to fetch customers" });
    }
});

app.post('/api/customers', async function(req, res) {
    try {
        const { first_name, last_name, email, phone } = req.body;
        
        console.log('Inserting customer:', first_name, last_name);
        
        await db.query('CALL sp_insert_customer(?, ?, ?, ?)', 
            [first_name, last_name, email, phone]);
        
        res.json({ message: 'Customer added successfully' });
    } catch (error) {
        console.error("Error inserting customer:", error);
        res.status(500).json({ error: "Failed to add customer: " + error.message });
    }
});

app.put('/api/customers/:id', async function(req, res) {
    try {
        const customerId = req.params.id;
        const { first_name, last_name, email, phone } = req.body;
        
        console.log('Updating customer ID:', customerId);
        
        await db.query('CALL sp_update_customer(?, ?, ?, ?, ?)', 
            [customerId, first_name, last_name, email, phone]);
        
        res.json({ message: 'Customer updated successfully' });
    } catch (error) {
        console.error("Error updating customer:", error);
        res.status(500).json({ error: "Failed to update customer: " + error.message });
    }
});

app.delete('/api/customers/:id', async function(req, res) {
    try {
        const customerId = req.params.id;
        
        // Call the stored procedure
        await db.query('CALL sp_delete_customer(?)', [customerId]);
        
        res.json({ message: 'Customer deleted successfully' });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to delete customer: " + error.message });
    }
});

// =====================================================
// EMPLOYEES API
// =====================================================
app.get('/api/employees', async function(req, res) {
    try {
        const query = 'SELECT employee_ID, first_name, last_name, role FROM employee ORDER BY employee_ID';
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to fetch employees" });
    }
});

app.post('/api/employees', async function(req, res) {
    try {
        const { first_name, last_name, role } = req.body;
        
        console.log('Inserting employee:', first_name, last_name);
        
        await db.query('CALL sp_insert_employee(?, ?, ?)', 
            [first_name, last_name, role]);
        
        res.json({ message: 'Employee added successfully' });
    } catch (error) {
        console.error("Error inserting employee:", error);
        res.status(500).json({ error: "Failed to add employee: " + error.message });
    }
});

app.put('/api/employees/:id', async function(req, res) {
    try {
        const employeeId = req.params.id;
        const { first_name, last_name, role } = req.body;
        
        console.log('Updating employee ID:', employeeId);
        
        await db.query('CALL sp_update_employee(?, ?, ?, ?)', 
            [employeeId, first_name, last_name, role]);
        
        res.json({ message: 'Employee updated successfully' });
    } catch (error) {
        console.error("Error updating employee:", error);
        res.status(500).json({ error: "Failed to update employee: " + error.message });
    }
});

app.delete('/api/employees/:id', async function(req, res) {
    try {
        const employeeId = req.params.id;
        
        // Call the stored procedure
        await db.query('CALL sp_delete_employee(?)', [employeeId]);
        
        res.json({ message: 'Employee deleted successfully' });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to delete employee: " + error.message });
    }
});

// =====================================================
// SALES API
// =====================================================
app.get('/api/sales', async function(req, res) {
    try {
        const query = `
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
            LEFT JOIN customer c ON s.customer_ID = c.customer_ID
            ORDER BY s.sale_ID
        `;
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to fetch sales" });
    }
});

app.post('/api/sales', async function(req, res) {
    try {
        const { sale_date, total_price, customer_id, employee_id, rewards_earned, rewards_redeemed } = req.body;
        
        console.log('Inserting sale for employee ID:', employee_id);
        
        await db.query('CALL sp_insert_sale(?, ?, ?, ?, ?, ?)', 
            [sale_date, total_price, customer_id, employee_id, rewards_earned, rewards_redeemed]);
        
        res.json({ message: 'Sale recorded successfully' });
    } catch (error) {
        console.error("Error inserting sale:", error);
        res.status(500).json({ error: "Failed to record sale: " + error.message });
    }
});

app.delete('/api/sales/:id', async function(req, res) {
    try {
        const saleId = req.params.id;
        
        // Call the stored procedure
        await db.query('CALL sp_delete_sale(?)', [saleId]);
        
        res.json({ message: 'Sale and associated items deleted successfully' });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to delete sale: " + error.message });
    }
});

// =====================================================
// PRODUCT_SALES API
// =====================================================
app.get('/api/product-sales', async function(req, res) {
    try {
        const query = `
            SELECT 
                ps.sale_item_ID, 
                ps.sale_ID, 
                ps.product_ID,
                p.product_name,
                p.platform,
                ps.quantity, 
                ps.unit_price,
                (ps.quantity * ps.unit_price) AS line_total
            FROM product_sale ps
            INNER JOIN product p ON ps.product_ID = p.product_ID
            ORDER BY ps.sale_item_ID
        `;
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to fetch product sales" });
    }
});

app.post('/api/product-sales', async function(req, res) {
    try {
        const { sale_id, product_id, quantity, unit_price } = req.body;
        
        console.log('Adding product to sale ID:', sale_id);
        
        await db.query('CALL sp_insert_product_sale(?, ?, ?, ?)', 
            [sale_id, product_id, quantity, unit_price]);
        
        res.json({ message: 'Product added to sale successfully' });
    } catch (error) {
        console.error("Error inserting product sale:", error);
        res.status(500).json({ error: "Failed to add product to sale: " + error.message });
    }
});

app.put('/api/product-sales/:id', async function(req, res) {
    try {
        const saleItemId = req.params.id;
        const { product_id, quantity, unit_price } = req.body;
        
        console.log('Updating product sale item ID:', saleItemId);
        
        await db.query('CALL sp_update_product_sale(?, ?, ?, ?)', 
            [saleItemId, product_id, quantity, unit_price]);
        
        res.json({ message: 'Product sale item updated successfully' });
    } catch (error) {
        console.error("Error updating product sale:", error);
        res.status(500).json({ error: "Failed to update product sale item: " + error.message });
    }
});

app.delete('/api/product-sales/:id', async function(req, res) {
    try {
        const saleItemId = req.params.id;
        
        // Call the stored procedure
        await db.query('CALL sp_delete_product_sale(?)', [saleItemId]);
        
        res.json({ message: 'Product sale item deleted successfully' });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Failed to delete product sale item: " + error.message });
    }
});

/*
    LISTENER
*/
app.listen(PORT, function() {
    console.log('Express started on http://classwork.engr.oregonstate.edu:' + PORT);
    console.log('Press Ctrl-C to terminate.');
});
