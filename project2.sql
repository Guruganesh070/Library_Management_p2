-- Library Management System Project 2


-- Creating the Branch Table

DROP TABLE IF EXISTS branch;
CREATE TABLE branch 
					(
					branch_id varchar(10) PRIMARY KEY,
					manager_id	varchar(10),
					branch_address	varchar(50),
					contact_no int
					);

-- Creating the Employees Table

DROP TABLE IF EXISTS employees;
CREATE TABLE employees 
					(
					emp_id varchar(10) PRIMARY KEY,
					emp_name varchar (25),
					position varchar(10),
					salary int,
					branch_id varchar(10) --FK
					);


-- Creating the Books Table

DROP TABLE IF EXISTS books;
CREATE TABLE books 
				(
				isbn varchar(25) PRIMARY KEY,
				book_title varchar(60),
				category varchar(25),
				rental_price float,
				status varchar(5),
				author varchar(25),
				publisher varchar(30)
				);

-- Creating the Members Table

DROP TABLE IF EXISTS members;
CREATE TABLE members 
				(
				member_id varchar(10) PRIMARY KEY,
				member_name varchar(50),
				member_address varchar(50),
				reg_date date
				);


-- Creating the Issued Table

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status 
				(
				issued_id varchar(10) PRIMARY KEY,
				issued_member_id varchar(10), -- FK
				issued_book_name varchar(55),
				issued_date	date,
				issued_book_isbn varchar(20), --FK
				issued_emp_id varchar(10) --FK
				);


-- Creating the Return Table

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status 
				(
				return_id varchar(10) PRIMARY KEY,
				issued_id varchar(10), --FK
				return_book_name varchar(55),
				return_date	date,
				return_book_isbn varchar(25) --FK
				);


-- Foreign Key

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);


ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);



SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;


-- Project Task
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')


INSERT INTO books
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books
WHERE isbn = '978-1-60129-456-2';


-- Task 2: Update an Existing Member's Address


UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

SELECT * FROM members
ORDER BY member_id; 


-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS121';

SELECT * FROM issued_status;


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.


SELECT issued_emp_id, count(issued_book_isbn) as No_of_Books FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT (issued_book_isbn) > 1
ORDER BY 2 DESC;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS
SELECT
		b.isbn, 
		b.book_title,
		COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2
ORDER BY 3 DESC;


SELECT * FROM book_cnts;


-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category:


SELECT 
		b.category, 
		sum(b.rental_price) AS Tot_rent,
		COUNT(*) AS No_Rented
FROM books AS b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY category
ORDER BY 2 DESC;



-- Task 9: List Members Who Registered in the Last 180 Days:


SELECT member_id, member_name FROM members
WHERE CURRENT_DATE - reg_date >= 180;


-- Task 10: List Employees with Their Branch Manager's Name and their branch details:


SELECT 
		e1.*,
		e2.emp_name as Manager_name,
		b.manager_id, b.branch_address
FROM employees e1
JOIN
branch b
ON
e1.branch_id = b.branch_id
JOIN
employees e2
ON
b.manager_id = e2.emp_id;


 -- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
 -- Threshold chose as 7.

CREATE TABLE high_valued_books as 
(SELECT * FROM books
WHERE rental_price > 7);

SELECT * FROM high_valued_books;


-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
		* 
FROM issued_status iss
LEFT JOIN
return_status rs
ON
iss.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;


-- End of Project.




 














