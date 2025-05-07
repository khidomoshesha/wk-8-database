-- Drop the database if it already exists to start fresh (optional, use with caution)
-- DROP DATABASE IF EXISTS LibraryDB;

-- Create the database
CREATE DATABASE IF NOT EXISTS LibraryDB;

-- Use the LibraryDB database
USE LibraryDB;

-- -----------------------------------------------------
-- Table `Authors`
-- Stores information about book authors
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Authors (
    AuthorID INT AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    BirthDate DATE NULL,
    Nationality VARCHAR(50) NULL,
    Biography TEXT NULL,
    PRIMARY KEY (AuthorID)
) ENGINE = InnoDB;

-- Comments for Authors Table:
-- AuthorID: Unique identifier for each author.
-- FirstName, LastName: Name of the author.
-- BirthDate, Nationality, Biography: Additional optional information about the author.

-- -----------------------------------------------------
-- Table `Publishers`
-- Stores information about book publishers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Publishers (
    PublisherID INT AUTO_INCREMENT,
    PublisherName VARCHAR(150) NOT NULL,
    Address VARCHAR(255) NULL,
    PhoneNumber VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    Website VARCHAR(255) NULL,
    PRIMARY KEY (PublisherID),
    UNIQUE INDEX `idx_PublisherName_UNIQUE` (PublisherName ASC) VISIBLE
) ENGINE = InnoDB;

-- Comments for Publishers Table:
-- PublisherID: Unique identifier for each publisher.
-- PublisherName: Name of the publishing company, must be unique.
-- Address, PhoneNumber, Email, Website: Contact and location information.

-- -----------------------------------------------------
-- Table `Genres`
-- Stores book genres or categories
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Genres (
    GenreID INT AUTO_INCREMENT,
    GenreName VARCHAR(50) NOT NULL,
    Description TEXT NULL,
    PRIMARY KEY (GenreID),
    UNIQUE INDEX `idx_GenreName_UNIQUE` (GenreName ASC) VISIBLE
) ENGINE = InnoDB;

-- Comments for Genres Table:
-- GenreID: Unique identifier for each genre.
-- GenreName: Name of the genre (e.g., "Science Fiction", "Mystery", "History"), must be unique.
-- Description: Optional detailed description of the genre.

-- -----------------------------------------------------
-- Table `Books`
-- Stores information about book titles (the abstract concept of a book)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Books (
    BookID INT AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(20) NOT NULL, -- International Standard Book Number
    PublicationYear YEAR NULL,
    Edition VARCHAR(50) NULL,
    PublisherID INT NULL, -- Foreign Key to Publishers table
    Summary TEXT NULL,
    CoverImageURL VARCHAR(255) NULL,
    PRIMARY KEY (BookID),
    UNIQUE INDEX `idx_ISBN_UNIQUE` (ISBN ASC) VISIBLE, -- ISBN should be unique
    CONSTRAINT `fk_Books_Publishers`
        FOREIGN KEY (PublisherID)
        REFERENCES Publishers (PublisherID)
        ON DELETE SET NULL -- If a publisher is deleted, set PublisherID in Books to NULL
        ON UPDATE CASCADE -- If PublisherID in Publishers changes, update it here
) ENGINE = InnoDB;

-- Comments for Books Table:
-- BookID: Unique identifier for each distinct book title.
-- Title: Title of the book.
-- ISBN: Unique identifier for the book edition.
-- PublicationYear, Edition: Information about the specific version of the book.
-- PublisherID: Links to the Publishers table (1-M relationship: One Publisher has Many Books).
-- Summary, CoverImageURL: Additional details about the book.

-- -----------------------------------------------------
-- Table `BookAuthors` (Linking Table for Books and Authors - M-M relationship)
-- Associates authors with books, as a book can have multiple authors
-- and an author can write multiple books.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BookAuthors (
    BookID INT NOT NULL,
    AuthorID INT NOT NULL,
    PRIMARY KEY (BookID, AuthorID), -- Composite primary key
    CONSTRAINT `fk_BookAuthors_Books`
        FOREIGN KEY (BookID)
        REFERENCES Books (BookID)
        ON DELETE CASCADE -- If a book is deleted, its author associations are deleted
        ON UPDATE CASCADE,
    CONSTRAINT `fk_BookAuthors_Authors`
        FOREIGN KEY (AuthorID)
        REFERENCES Authors (AuthorID)
        ON DELETE CASCADE -- If an author is deleted, their book associations are deleted
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Comments for BookAuthors Table:
-- This table resolves the Many-to-Many relationship between Books and Authors.
-- BookID: Foreign key referencing the Books table.
-- AuthorID: Foreign key referencing the Authors table.

-- -----------------------------------------------------
-- Table `BookGenres` (Linking Table for Books and Genres - M-M relationship)
-- Associates genres with books, as a book can belong to multiple genres.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BookGenres (
    BookID INT NOT NULL,
    GenreID INT NOT NULL,
    PRIMARY KEY (BookID, GenreID), -- Composite primary key
    CONSTRAINT `fk_BookGenres_Books`
        FOREIGN KEY (BookID)
        REFERENCES Books (BookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_BookGenres_Genres`
        FOREIGN KEY (GenreID)
        REFERENCES Genres (GenreID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Comments for BookGenres Table:
-- This table resolves the Many-to-Many relationship between Books and Genres.

-- -----------------------------------------------------
-- Table `BookCopies`
-- Stores information about individual physical copies of books
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BookCopies (
    CopyID INT AUTO_INCREMENT,
    BookID INT NOT NULL, -- Foreign Key to Books table (the title this copy belongs to)
    AcquisitionDate DATE NULL,
    CopyStatus VARCHAR(50) NOT NULL DEFAULT 'Available', -- e.g., Available, Loaned, Damaged, Lost
    LocationInLibrary VARCHAR(100) NULL, -- e.g., Shelf A-3, Section 2
    PRIMARY KEY (CopyID),
    CONSTRAINT `fk_BookCopies_Books`
        FOREIGN KEY (BookID)
        REFERENCES Books (BookID)
        ON DELETE CASCADE -- If the main book record is deleted, all its copies are deleted
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Comments for BookCopies Table:
-- CopyID: Unique identifier for each physical copy of a book.
-- BookID: Links to the Books table (1-M: One Book title can have Many Copies).
-- AcquisitionDate: When the library acquired this specific copy.
-- CopyStatus: Current status of this physical copy.
-- LocationInLibrary: Where the copy is physically located.

-- -----------------------------------------------------
-- Table `Members`
-- Stores information about library members
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Members (
    MemberID INT AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    Address VARCHAR(255) NOT NULL,
    RegistrationDate DATE NOT NULL DEFAULT (CURDATE()),
    MembershipExpiryDate DATE NULL,
    MemberType VARCHAR(50) DEFAULT 'Standard', -- e.g., Standard, Student, Premium
    PRIMARY KEY (MemberID),
    UNIQUE INDEX `idx_Email_UNIQUE` (Email ASC) VISIBLE
) ENGINE = InnoDB;

-- Comments for Members Table:
-- MemberID: Unique identifier for each library member.
-- Email: Member's email, must be unique.
-- RegistrationDate: When the member joined the library.
-- MembershipExpiryDate: When their membership expires (if applicable).

-- -----------------------------------------------------
-- Table `Loans`
-- Stores information about books loaned to members
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Loans (
    LoanID INT AUTO_INCREMENT,
    CopyID INT NOT NULL, -- Foreign Key to the specific BookCopy being loaned
    MemberID INT NOT NULL, -- Foreign Key to Members table
    LoanDate DATE NOT NULL DEFAULT (CURDATE()),
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL, -- Date the book was actually returned
    FineAmount DECIMAL(5, 2) DEFAULT 0.00, -- Any fine incurred for late return
    LoanStatus VARCHAR(20) DEFAULT 'Active', -- e.g., Active, Returned, Overdue
    PRIMARY KEY (LoanID),
    CONSTRAINT `fk_Loans_BookCopies`
        FOREIGN KEY (CopyID)
        REFERENCES BookCopies (CopyID)
        ON DELETE RESTRICT -- Prevent deleting a book copy if it has active or past loan records
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Loans_Members`
        FOREIGN KEY (MemberID)
        REFERENCES Members (MemberID)
        ON DELETE RESTRICT -- Prevent deleting a member if they have active or past loan records
        ON UPDATE CASCADE,
    INDEX `idx_LoanStatus` (LoanStatus ASC) -- Index for faster queries on loan status
) ENGINE = InnoDB;

-- Comments for Loans Table:
-- LoanID: Unique identifier for each loan transaction.
-- CopyID: Identifies the specific physical copy of the book that was loaned.
-- MemberID: Identifies the member who borrowed the book.
-- LoanDate: Date the book was borrowed.
-- DueDate: Date the book is expected to be returned.
-- ReturnDate: Actual date the book was returned. NULL if not yet returned.
-- FineAmount: Fines for overdue books.
-- LoanStatus: Current status of the loan.
-- Business Rule: A trigger or application logic would typically update BookCopies.CopyStatus to 'Loaned' when a loan is created
-- and back to 'Available' when ReturnDate is set. Also, calculate DueDate based on LoanDate + library policy.

-- -----------------------------------------------------
-- Example: Add some sample data (Optional, for testing)
-- -----------------------------------------------------
/*
-- Sample Genres
INSERT INTO Genres (GenreName, Description) VALUES
('Science Fiction', 'Fiction based on imagined future scientific or technological advances.'),
('Mystery', 'Fiction involving a puzzling crime or event.'),
('Fantasy', 'Fiction set in an imaginary universe, often involving magic.'),
('Historical Fiction', 'Fiction set in the past.');

-- Sample Authors
INSERT INTO Authors (FirstName, LastName, BirthDate, Nationality) VALUES
('George', 'Orwell', '1903-06-25', 'British'),
('Agatha', 'Christie', '1890-09-15', 'British'),
('J.R.R.', 'Tolkien', '1892-01-03', 'British'),
('Jane', 'Austen', '1775-12-16', 'British');

-- Sample Publishers
INSERT INTO Publishers (PublisherName, Address, Email) VALUES
('Penguin Books', '17 Strand, London, UK', 'contact@penguin.co.uk'),
('HarperCollins', '195 Broadway, New York, NY', 'info@harpercollins.com');

-- Sample Books
INSERT INTO Books (Title, ISBN, PublicationYear, PublisherID, Summary) VALUES
('Nineteen Eighty-Four', '978-0451524935', 1949, 1, 'A dystopian novel set in Airstrip One.'),
('Murder on the Orient Express', '978-0007119318', 1934, 2, 'Hercule Poirot investigates a murder on a luxury train.'),
('The Hobbit', '978-0547928227', 1937, 1, 'The prelude to The Lord of the Rings.');

-- Associate Authors with Books (BookAuthors)
-- Assuming BookIDs are 1 (1984), 2 (Orient Express), 3 (Hobbit)
-- Assuming AuthorIDs are 1 (Orwell), 2 (Christie), 3 (Tolkien)
INSERT INTO BookAuthors (BookID, AuthorID) VALUES (1, 1), (2, 2), (3, 3);

-- Associate Genres with Books (BookGenres)
-- Assuming GenreIDs are 1 (Sci-Fi), 2 (Mystery), 3 (Fantasy)
INSERT INTO BookGenres (BookID, GenreID) VALUES (1, 1), (2, 2), (3, 3);

-- Sample Book Copies
-- Assuming BookIDs are 1, 2, 3 as above
INSERT INTO BookCopies (BookID, AcquisitionDate, CopyStatus, LocationInLibrary) VALUES
(1, '2022-01-15', 'Available', 'SF-A1'),
(1, '2022-01-15', 'Available', 'SF-A2'),
(2, '2021-11-20', 'Available', 'MYS-B1'),
(3, '2023-03-10', 'Loaned', 'FAN-C1'); -- One copy of The Hobbit is already loaned

-- Sample Members
INSERT INTO Members (FirstName, LastName, Email, Address, RegistrationDate, MembershipExpiryDate) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '123 Library Lane', '2023-01-01', '2025-01-01'),
('Bob', 'Johnson', 'bob.johnson@example.com', '456 Bookworm Blvd', '2023-05-10', '2025-05-10');

-- Sample Loans
-- Assuming CopyIDs are 1, 2, 3, 4 (first copy of The Hobbit is CopyID 4)
-- Assuming MemberIDs are 1 (Alice), 2 (Bob)
-- Let's say Bob loaned the 4th copy (The Hobbit)
INSERT INTO Loans (CopyID, MemberID, LoanDate, DueDate, LoanStatus) VALUES
(4, 2, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 9 DAY, 'Active');

-- Update the status of the loaned copy in BookCopies table (ideally a trigger would do this)
UPDATE BookCopies SET CopyStatus = 'Loaned' WHERE CopyID = 4;

-- Example Query: Find all books written by a specific author
SELECT b.Title, b.ISBN, p.PublisherName
FROM Books b
JOIN BookAuthors ba ON b.BookID = ba.BookID
JOIN Authors a ON ba.AuthorID = a.AuthorID
LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID
WHERE a.FirstName = 'George' AND a.LastName = 'Orwell';

-- Example Query: Find all active loans with member and book details
SELECT
    m.FirstName AS MemberFirstName,
    m.LastName AS MemberLastName,
    b.Title AS BookTitle,
    bc.CopyID,
    l.LoanDate,
    l.DueDate
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
JOIN BookCopies bc ON l.CopyID = bc.CopyID
JOIN Books b ON bc.BookID = b.BookID
WHERE l.LoanStatus = 'Active';
*/

-- End of library_management_schema.sql