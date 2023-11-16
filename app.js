/*
    SETUP
*/
// app.js

// Express
var express = require('express');   // We are using the express library for the web server
var app     = express();            // We need to instantiate an express object to interact with the server in our code

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use(express.static('public'))

PORT        = 6137;                 // Set a port number at the top so it's easy to change in the future

// Database
var db = require('./db-connector')

const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({extname: ".hbs"}));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs');                 // Tell express to use the handlebars engine whenever it encounters a *.hbs file.


/*
    ROUTES
*/
app.get('/', function(req, res)
    {  
        let query1 = "SELECT * FROM Libraries;";               // Define our query

        db.pool.query(query1, function(error, rows, fields){    // Execute the query

            res.render('index', {data: rows});                  // Render the index.hbs file, and also send the renderer
        })                                                      // an object where 'data' is equal to the 'rows' we
    });                                                         // received back from the query

app.get('/boots', (req, res) => {
        // render your contact.handlebars
        let query2 = "SELECT * FROM Books;";               // Define our query

        db.pool.query(query2, function(error, rows, fields){    // Execute the query

            res.render('boots', {data: rows});                  // Render the boots.hbs file, and also send the renderer
        })
    });

app.get('/librarians', (req, res) => {
        // render your contact.handlebars
        let query3 = "SELECT * FROM Librarians;";               // Define our query

        db.pool.query(query3, function(error, rows, fields){    // Execute the query

            res.render('librarians', {data: rows});                  // Render the librarians.hbs file, and also send the renderer
        })
    });

app.get('/readers', (req, res) => {
        // render your contact.handlebars
        let query4 = "SELECT * FROM Readers;";               // Define our query

        db.pool.query(query4, function(error, rows, fields){    // Execute the query

            res.render('readers', {data: rows});                  // Render the readers.hbs file, and also send the renderer
        })
    });

app.get('/transactions', (req, res) => {
        // render your contact.handlebars
        let query5 = "SELECT * FROM Transactions;";               // Define our query

        db.pool.query(query5, function(error, rows, fields){    // Execute the query

            res.render('transactions', {data: rows});                  // Render the readers.hbs file, and also send the renderer
        })
    });

app.get('/copies', (req, res) => {
        // render your contact.handlebars
        let query6 = "SELECT * FROM Copies;";               // Define our query

        db.pool.query(query6, function(error, rows, fields){    // Execute the query

            res.render('copies', {data: rows});                  // Render the readers.hbs file, and also send the renderer
        })
    });

app.get('/details', (req, res) => {
        // render your contact.handlebars
        let query7 = "SELECT * FROM TransactionDetails;";               // Define our query

        db.pool.query(query7, function(error, rows, fields){    // Execute the query

            res.render('details', {data: rows});                  // Render the readers.hbs file, and also send the renderer
        })
    });

app.get('/codes', (req, res) => {
        // render your contact.handlebars
        let query8 = "SELECT * FROM StatusCodes;";               // Define our query

        db.pool.query(query8, function(error, rows, fields){    // Execute the query

            res.render('codes', {data: rows});                  // Render the readers.hbs file, and also send the renderer
        })
    });

/*
    LISTENER
*/
app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});