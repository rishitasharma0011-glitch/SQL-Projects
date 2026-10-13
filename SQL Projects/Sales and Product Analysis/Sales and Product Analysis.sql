-- PROJECT 1: SALES & PRODUCT ANALYSIS
-- Database creation
CREATE DATABASE IF NOT EXISTS MiniSalesDB;
USE MiniSalesDB;
-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Price DECIMAL(10,2) NOT NULL);
-- Create Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    SaleDate DATE NOT NULL,
    SalesPerson VARCHAR(50) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID));
    -- Insert data into Products
INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Laptop', 'Electronics', 55000),
(2, 'Mouse', 'Electronics', 800),
(3, 'Keyboard', 'Electronics', 1500),
(4, 'Chair', 'Furniture', 4500),
(5, 'Desk', 'Furniture', 9000),
(6, 'Notebook', 'Stationery', 120);
-- Insert data into Sales
INSERT INTO Sales(SaleID, ProductID, Quantity, SaleDate, SalesPerson)
VALUES
(101, 1, 2, '2026-01-05', 'Amit'),
(102, 2, 10, '2026-01-06', 'Neha'),
(103, 4, 5, '2026-01-08', 'Amit'),
(104, 5, 3, '2026-01-10', 'Ravi'),
(105, 3, 6, '2026-01-12', 'Neha'),
(106, 1, 1, '2026-01-15', 'Ravi'),
(107, 6, 25, '2026-01-18', 'Amit'),
(108, 4, 2, '2026-01-20', 'Neha'),
(109, 2, 15, '2026-01-22', 'Ravi'),
(110, 5, 4, '2026-01-25', 'Amit');

-- Q1. Display all products.
SELECT *
FROM Products;
-- Q2. Display product name and price only.
SELECT ProductName, Price
FROM Products;
-- Q3. Find products costing more than 5000.

SELECT *
FROM Products
WHERE Price > 5000;
-- Q4. Display products from the Electronics category.
SELECT *
FROM Products
WHERE Category = 'Electronics';
-- Q5. Display products from highest to lowest price.
SELECT *
FROM Products
ORDER BY Price DESC;
-- Q6. Find the maximum product price.
SELECT MAX(Price) AS MaxPrice
FROM Products;
-- Q7. Find the average product price.
SELECT AVG(Price) AS AveragePrice
FROM Products;
-- Q8. Count the number of products.
SELECT COUNT(*) AS ProductCount
FROM Products;
-- Q9. Find the total quantity sold.
SELECT SUM(Quantity) AS TotalQuantity
FROM Sales;


-- Q10. Display distinct salespersons.

SELECT DISTINCT SalesPerson
FROM Sales;
-- Q11. Show total quantity sold by each salesperson.
SELECT
    SalesPerson,
    SUM(Quantity) AS TotalQty
FROM Sales
GROUP BY SalesPerson;
-- Q12. Show total quantity sold for each product.
SELECT
    p.ProductName,
    SUM(s.Quantity) AS TotalQty
FROM Products p
JOIN Sales s
    ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName;
-- Q13. Show the number of sales made by each salesperson.
SELECT
    SalesPerson,
    COUNT(*) AS NumberOfSales
FROM Sales
GROUP BY SalesPerson;
-- Q14. Show average quantity sold by each salesperson.
SELECT
    SalesPerson,
    AVG(Quantity) AS AverageQty
FROM Sales
GROUP BY SalesPerson;
-- Q15. Show salespersons whose total quantity sold is greater than 15.
SELECT
    SalesPerson,
    SUM(Quantity) AS TotalQty
FROM Sales
GROUP BY SalesPerson
HAVING SUM(Quantity) > 15;
-- Method 1: GROUP BY, ORDER BY and LIMIT
SELECT
    SalesPerson,
    SUM(Quantity) AS TotalQty
FROM Sales
GROUP BY SalesPerson
ORDER BY TotalQty DESC
LIMIT 1;
-- Method 2: Subquery
-- Returns all salespersons tied for the highest total quantity.
SELECT SalesPerson, TotalQty
FROM (SELECT
        SalesPerson,
        SUM(Quantity) AS TotalQty
    FROM Sales
    GROUP BY SalesPerson) AS SalesSummary
WHERE TotalQty = (SELECT MAX(TotalQty)
    FROM (SELECT SUM(Quantity) AS TotalQty
        FROM Sales
        GROUP BY SalesPerson) AS Totals);