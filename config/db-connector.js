// Credits of this code goes to the CS340 webapp setup guide
// Get an instance of mysql we can use in the app
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: 'classmysql.engr.oregonstate.edu',
    user: '',
    password: '',
    database: 'cs340_wuiv'
}).promise();

// Export it for use in our application
module.exports = pool;
