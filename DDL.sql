SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- All entities DELETE ON CASCADE except Books, Libraries, Readers, and StatusCodes.
-- Readers ON DELETE CASCADE was removed to prevent Reader data loss on Library deletion.

-- Creates a Table for Books (primary key - bookID)
CREATE OR REPLACE TABLE Books (
    bookID int NOT NULL UNIQUE AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    authorName varchar(255) NOT NULL,
    genre varchar(255),
    year int(4) NOT NULL,
    publisher varchar(255) NOT NULL,
    PRIMARY KEY (bookID)
);

-- Creates a Table for Libraries (primary key - libraryID)
CREATE OR REPLACE TABLE Libraries (
    libraryID int NOT NULL UNIQUE AUTO_INCREMENT,
    libraryName varchar(255) NOT NULL,
    location varchar(255) NOT NULL,
    PRIMARY KEY (libraryID)
);

-- Creates a Table for Status Codes (primary key - statusCodeID)
-- Defined on initialization and should not be changed much.
CREATE OR REPLACE TABLE StatusCodes (
    statusCodeID varchar(255) NOT NULL UNIQUE,
    description varchar(255) NOT NULL,
    PRIMARY KEY (statusCodeID)
);

-- Creates a Table for Librarians 
-- (primary key - librarianID)
-- (foreign key - libraryID, Librarians linked by Library)
CREATE OR REPLACE TABLE Librarians (
    librarianID int NOT NULL UNIQUE AUTO_INCREMENT,
    libraryID int NOT NULL,
    librarianName varchar(255) NOT NULL,
    age int NOT NULL,
    email varchar(255) NOT NULL,
    PRIMARY KEY (librarianID),
    FOREIGN KEY (libraryID) REFERENCES Libraries(libraryID) ON DELETE CASCADE
);

-- Creates a Table for Readers 
-- (primary key - readerID)
-- (foreign key - faveLibraryID [libraryID], Readers linked by favorite Library, can be NULL)
CREATE OR REPLACE TABLE Readers (
    readerID int NOT NULL UNIQUE AUTO_INCREMENT,
    readerName varchar(255) NOT NULL,
    age int NOT NULL,
    email varchar(255) NOT NULL,
    location varchar(255) NOT NULL,
    faveLibraryID int,
    owesFees BOOL NOT NULL,
    totalFeesDue decimal(18,2), 
    PRIMARY KEY (readerID),
    FOREIGN KEY (faveLibraryID) REFERENCES Libraries(libraryID)
);

-- Creates a Table for Transactions done by Readers 
-- (primary key - transactionID)
-- (foreign key - readerID, Readers linked to each Transaction)
CREATE OR REPLACE TABLE Transactions (
    transactionID int NOT NULL UNIQUE AUTO_INCREMENT,
    readerID int NOT NULL,
    date DATE NOT NULL,
    feesDue decimal(18,2),
    PRIMARY KEY (transactionID),
    FOREIGN KEY (readerID) REFERENCES Readers(readerID) ON DELETE CASCADE
);

-- Creates a Table for Copies of books 
-- (primary key - copyID)
-- (foreign key - bookID, libraryID, statusCodeID, Books have copies at Libraries which have a Status.)
CREATE OR REPLACE TABLE Copies (
    copyID int NOT NULL UNIQUE AUTO_INCREMENT,
    bookID int NOT NULL,
    libraryID int NOT NULL,
    statusCodeID varchar(255) NOT NULL,
    PRIMARY KEY (copyID),
    FOREIGN KEY (bookID) REFERENCES Books(bookID) ON DELETE CASCADE,
    FOREIGN KEY (libraryID) REFERENCES Libraries(libraryID) ON DELETE CASCADE,
    FOREIGN KEY (statusCodeID) REFERENCES StatusCodes(statusCodeID) ON DELETE CASCADE
);

-- Creates a Table for TransactionDetails of a Transaction 
-- (primary key - transactionDetailsID)
-- (foreign key - transactionID, copyID)
--  Each transaction is saved only with a reference to its details to avoid unneccessary duplication of Copy details.
CREATE OR REPLACE TABLE TransactionDetails (
    transactionDetailsID int NOT NULL UNIQUE AUTO_INCREMENT,
    transactionID int NOT NULL,
    copyID int NOT NULL,
    transactionType varchar(255) NOT NULL,
    returnedLate BOOL NOT NULL,
    daysLate int,
    bookFee decimal(18,2),
    PRIMARY KEY (transactionDetailsID),
    FOREIGN KEY (transactionID) REFERENCES Transactions(transactionID) ON DELETE CASCADE,
    FOREIGN KEY (copyID) REFERENCES Copies(copyID) ON DELETE CASCADE
);

-- Initial INSERT Statements into the Books Table.
INSERT INTO Books (title, authorName, genre, year, publisher)
VALUES ("The Catcher in the Rye", "J.D. Salinger", "Fiction", 1951, "Little, Brown and Company"),
("The Great Gatsby", "F. Scott Fitzgerald", "Tragedy", 1925, "Charles Scribner's Sons"),
("JT's Reference for Optimal Pokemon", "Jeff Tran", NULL, 2023, "JT & Co.");

-- Initial INSERT Statements into the Libraries Table.
INSERT INTO Libraries (libraryName, location)
VALUES ("Cupertino Library", "Cupertino"),
("West Fresno Branch Library", "Fresno"),
("Oxnard Public Library - Main Library", "Oxnard");

-- Initial INSERT Statements into the Status Codes Table.
-- These will remain unchanged from here. No changes should be made later.
INSERT INTO StatusCodes (statusCodeID, description)
VALUES ("S", "In Storage"),
("R", "Ready/In System"),
("H", "On Hold"),
("C", "Checked Out");

-- Initial INSERT into Librarians Table, Linked to Libraries.
INSERT INTO Librarians (libraryID, librarianName, age, email)
VALUES ((select libraryID from Libraries where location = "Fresno"), "Joe Gally", 37, "jg77@gmail.com"),
((select libraryID from Libraries where location = "Cupertino"), "Sally Yip", 56, "sally_yip@gmail.com"),
((select libraryID from Libraries where location = "Oxnard"), "Darla Jones", 29, "djones11@yahoo.com");

-- Initial INSERT into Readers Table with possible Favorite Library and any fees due.
INSERT INTO Readers (readerName, age, email, location, faveLibraryID, owesFees, totalFeesDue)
VALUES ("Richard Trago", 62, "rtrago@gmail.com", "Fresno", (select libraryID from Libraries where location = "Fresno"), FALSE, NULL),
("Heem Kareem", 19, "hkmeme@aol.com", "Glendale", NULL, FALSE, NULL),
("Jenny Dip", 40, "jipndip@gmail.com", "Oxnard", (select libraryID from Libraries where location = "Cupertino"), TRUE, 7.75);

-- Initial Insert into Transactions Table for Transactions done by Readers.
INSERT INTO Transactions (readerID, date, feesDue)
VALUES ((select readerID from Readers where readerName = "Jenny Dip"), "2023-10-22", 1.50),
((select readerID from Readers where location = "Glendale"), "2023-10-22", NULL),
((select readerID from Readers where readerName = "Heem Kareem"), "2023-10-24", 0);

-- Initial INSERT into the Copies Table for Copies of books at various Libraries and their current Status Codes.
INSERT INTO Copies (bookID, libraryID, statusCodeID)
VALUES ((select bookID from Books where title = "The Great Gatsby"), (select libraryID from Libraries where location = "Oxnard"), "H"),
((select bookID from Books where title = "The Great Gatsby"), (select libraryID from Libraries where location = "Fresno"), "R"),
((select bookID from Books where title = "The Catcher in the Rye"), (select libraryID from Libraries where location = "Oxnard"), "R"),
((select bookID from Books where title = "JT's Reference for Optimal Pokemon"), (select libraryID from Libraries where location = "Oxnard"), "C");

/*
Need to reformat these inserts to use joins? or rearrange table to make easier to use via normalization.
*/

-- Initial INSERT into Transaction Details for each Transaction added previously.
INSERT INTO TransactionDetails (transactionID, copyID, transactionType, returnedLate, daysLate, bookFee)
VALUES (1, 1, "Return", TRUE, 6, 0.25),
(2, 3, "Checkout", FALSE, NULL, 0.25),
(2, 4, "Checkout", FALSE, NULL, 0.10),
(3, 4, "Return", FALSE, 0, 0.10);


SET FOREIGN_KEY_CHECKS=1;
COMMIT;