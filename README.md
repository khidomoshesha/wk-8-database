# wk-8-database
# Project Title: Library Management System (LibraryDB)

## Description
This project implements a relational database using MySQL to manage the core operations of a library. The system allows for cataloging books, managing information about authors, publishers, and genres, registering library members, and tracking the loan status of individual book copies. The primary goal is to provide an organized and efficient way to handle the library's collection and its circulation to members.

The database schema includes the following key tables:
- `Authors`: Stores information about book authors.
- `Publishers`: Stores details of publishing companies.
- `Genres`: Stores different book genres or categories.
- `Books`: Contains information about book titles (e.g., ISBN, title, publication year).
- `BookAuthors`: A linking table to manage the many-to-many relationship between books and authors.
- `BookGenres`: A linking table for the many-to-many relationship between books and genres.
- `BookCopies`: Tracks individual physical copies of each book title, including their status (e.g., available, loaned).
- `Members`: Stores information about registered library members.
- `Loans`: Records details of books loaned out to members, including loan dates, due dates, and return status.

## How to Run/Setup the Project (Import SQL)

1.  **MySQL Installation**: Ensure MySQL Server is installed and operational on your system.
2.  **Access MySQL**: Use the MySQL command-line client or a GUI tool such as MySQL Workbench, DBeaver, or phpMyAdmin.
3.  **Database Creation (if not in script)**: The provided `.sql` file includes `CREATE DATABASE LibraryDB; USE LibraryDB;`. If creating manually beforehand:
    ```sql
    CREATE DATABASE LibraryDB;
    USE LibraryDB;
    ```
4.  **Execute the SQL Script**:
    * Save the SQL code as `library_management_schema.sql`.
    * **Using MySQL Command Line**:
        ```bash
        mysql -u your_username -p < library_management_schema.sql
        ```
        (Replace `your_username` with your actual MySQL username. You will be prompted for your password.)
    * **Using a GUI Tool (e.g., MySQL Workbench)**:
        1.  Connect to your MySQL server instance.
        2.  Open the `library_management_schema.sql` file (e.g., `File > Open SQL Script...`).
        3.  Execute the entire script.

5.  **Verify Installation**:
    Once the script has been executed, connect to the `LibraryDB` database and run commands like:
    ```sql
    USE LibraryDB;
    SHOW TABLES;
    -- To check a specific table's structure:
    DESCRIBE Books;
    -- If sample data was uncommented and run:
    -- SELECT * FROM Authors;
    ```

## ERD (Entity Relationship Diagram)

A visual ERD is crucial for understanding the database structure and relationships.

*(Embed an image of your ERD here or provide a direct link to it within your repository.)*

**Link to ERD Image:** [e.g., `library_erd.png`]

**Textual Representation of Key Relationships:**
* `Authors` (M) --< `BookAuthors` >-- (M) `Books`
* `Genres` (M) --< `BookGenres` >-- (M) `Books`
* `Publishers` (1) --< (M) `Books`
* `Books` (1) --< (M) `BookCopies`
* `Members` (1) --< (M) `Loans`
* `BookCopies` (1) --< (M) `Loans`

## SQL File
The complete, well-commented SQL script for creating the database schema is:
* `library_management_schema.sql`