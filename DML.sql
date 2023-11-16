-- Search Queries (Valid Only)

-- search books         by title and author
SELECT * FROM Books         
WHERE title = 'The Catcher in the Rye' AND authorName = 'J.D. Salinger';

-- search readers       by location
SELECT * FROM Readers        
WHERE location = 'Fresno';

-- search books         by library
SELECT Books.title, Books.authorName, Books.genre
FROM Copies
JOIN Libraries ON Copies.libraryID = Libraries.libraryID
JOIN Books ON Copies.bookID = Books.bookID
WHERE Libraries.location = 'Oxnard';

-- search transactions  by reader name
SELECT Transactions.*, Readers.readerName
FROM Transactions
JOIN Readers ON Transactions.readerID = Readers.readerID
WHERE Readers.readerName = 'Jenny Dip';




-- Update Queries

-- Update user location         by name
UPDATE Readers
SET location = 'Cupertino'
WHERE readerName = 'Jenny Dip';

-- Update Librarian's Email     by name
UPDATE Librarians
SET email = 'gallyj@gmail.com'
WHERE librarianName = 'Joe Gally';

-- Update Book Genre            by title
UPDATE Books
SET genre = 'Encyclopedia'
WHERE title = "JT's Reference for Optimal Pokemon";

-- Update Reader Fees           by name
UPDATE Readers
SET owesFees = 1 AND totalFeesDue = 3.00
WHERE readerName = 'Heem Kareem';


-- Delete Queries

-- Delete book      by name
DELETE FROM Books
WHERE title = 'The Great Gatsby';

-- Delete reader    by name
DELETE FROM Readers
WHERE readerName = 'Heem Kareem';

-- Delete Librarian by id
DELETE FROM Librarians
WHERE librarianID = 2;

-- Delete copy      by id
DELETE FROM Copies
WHERE copyID = 3;


-- Insert Queries

-- Insert Books
INSERT INTO Books (title, authorName, genre, year, publisher)
VALUES ("1984", "George Orwell", "Fiction", 1949, "Secker & Warburg"),
("Prelude to Foundation", "Isaac Asimov", "Science Fiction", 1988, "Doubleday"),
("Dune", "Frank Herbert", "Science Fiction", 1965, "Chilton Books");

-- Insert Libraries
INSERT INTO Libraries (libraryName, location)
VALUES ("Milpitas Library", "Milpitas"),
("Fremont Library", "Fremont");

-- Insert Librarians
INSERT INTO Librarians (libraryID, librarianName, age, email)
VALUES ((select libraryID from Libraries where location = "Milpitas"), "Joseph Joestar", 81, "toprunner@gmail.com"),
((select libraryID from Libraries where location = "Fremont"), "Walter White", 52, "heisenberg@gmail.com"),
((select libraryID from Libraries where location = "Milpitas"), "Paul Atreides", 21, "k_haderach@outlook.com");

-- Insert Book Copies
INSERT INTO Copies (bookID, libraryID, statusCodeID)
VALUES ((select bookID from Books where title = "Dune"), (select libraryID from Libraries where location = "Milpitas"), "S"),
((select bookID from Books where title = "Prelude to Foundation"), (select libraryID from Libraries where location = "Fresno"), "R"),
((select bookID from Books where title = "1984"), (select libraryID from Libraries where location = "Fremont"), "R");
