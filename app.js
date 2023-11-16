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
    GET ROUTES
*/
app.get('/', function(req, res)
    {  
        let query1 = "SELECT * FROM Libraries;";               // Define our query

        db.pool.query(query1, function(error, rows, fields){    // Execute the query

            res.render('index', {data: rows});                  // Render the index.hbs file, and also send the renderer
        })                                                      // an object where 'data' is equal to the 'rows' we
    });                                                         // received back from the query

app.get('/books', (req, res) => {
        // render your contact.handlebars
        let query1;                                 // Define our query

        // If there is no query string, we just perform a basic SELECT
        if (req.query.title === undefined && req.query.authorName === undefined && 
            req.query.genre === undefined)
        {
            query1 = "SELECT * FROM Books;";   // Basic select
        }

        // If there is a query title, return desired results for search
        else if (req.query.title !== undefined)
        {
            query1 = `SELECT * FROM Books WHERE title = "${req.query.title}"`
        }

        // If there is a query authorName, return desired results for search
        else if (req.query.authorName !== undefined)
        {
            query1 = `SELECT * FROM Books WHERE authorName = "${req.query.authorName}"`
        }

        // If there is a query genre, return desired results for search
        else if (req.query.genre !== undefined)
        {
            query1 = `SELECT * FROM Books WHERE genre = "${req.query.genre}"`
        }

        db.pool.query(query1, function(error, rows, fields){    // Execute the query

            res.render('books', {data: rows});                  // Render the books.hbs file, and also send the renderer
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
    POST ROUTES
*/

app.post('/add-book-form', function(req, res){
    // Capture the incoming data and parse it back to a JS object
    let data = req.body;

    // Capture NULL values
    let year = parseInt(data['input-year']);
    if (isNaN(year))
    {
        year = 'NULL'
    }
    
    // Create the query and run it on the database
    insert_query = `INSERT INTO Books (title, authorName, genre, year, publisher) VALUES ('${data['input-title']}', '${data['input-authorName']}', '${data['input-genre']}', '${year}', '${data['input-publisher']}')`;
    if (`${data['input-title']}` === '' || `${data['input-authorName']}` === '' || `${data['input-year']}` === '' ||`${data['input-publisher']}` === ''){
        console.log("Required Parameter(s) blank.")
        res.sendStatus(400);
    }

    else{
        db.pool.query(insert_query, function(error, rows, fields){

            // Check to see if there was an error
            if (error) {
    
                // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                console.log(error)
                res.sendStatus(400);
            }
    
            // If there was no error, we redirect back to our root route, which automatically runs the SELECT * FROM bsg_people and
            // presents it on the screen
            else
            {
                res.redirect('/books');
            }
        })
    }
    
})
    

/*
    DELETE ROUTES
*/

app.delete('/deleteBook/', function(req,res,next){
    let data = req.body;
    let bookID = parseInt(data.bookID);
    let deleteBooks = `DELETE FROM Books WHERE bookID = ?`;  
    
          // Run the 1st query
          db.pool.query(deleteBooks, [bookID], function(error, rows, fields){
              if (error) {
  
              // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
              console.log(error);
              res.sendStatus(400);
              }
            }
        )
    }
);

// app.js





/*
    LISTENER
*/
app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});