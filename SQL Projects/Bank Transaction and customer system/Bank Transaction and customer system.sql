-- PROJECT 3: BANK TRANSACTION & CUSTOMER SYSTEM
CREATE DATABASE IF NOT EXISTS MiniBankDB;
USE MiniBankDB;
-- 1. Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(60) NOT NULL,
    City VARCHAR(40) NOT NULL);
-- 2. Accounts table
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountType VARCHAR(20)
        CHECK (AccountType IN ('Savings', 'Current')),
    Balance DECIMAL(12,2)
        CHECK (Balance >= 0),

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID));
-- 3. Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(10)
        CHECK (TransactionType IN ('Deposit', 'Withdraw')),
    Amount DECIMAL(12,2)
        CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (AccountID)
        REFERENCES Accounts(AccountID));
-- 4. TransactionAudit table
CREATE TABLE TransactionAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT,
    AccountID INT,
    ActionName VARCHAR(30),
    ActionDate DATETIME DEFAULT CURRENT_TIMESTAMP);
    -- Insert customers
INSERT INTO Customers
    (CustomerID, CustomerName, City)
VALUES
    (1, 'Aman', 'Chandigarh'),
    (2, 'Neha', 'Mohali'),
    (3, 'Ravi', 'Kharar'),
    (4, 'Simran', 'Delhi'),
    (5, 'Karan', 'Panchkula');
-- Insert accounts
INSERT INTO Accounts
    (AccountID, CustomerID, AccountType, Balance)
VALUES
    (1001, 1, 'Savings', 50000),
    (1002, 2, 'Savings', 75000),
    (1003, 3, 'Current', 40000),
    (1004, 4, 'Savings', 90000),
    (1005, 5, 'Current', 30000);
-- Insert transactions
INSERT INTO Transactions
    (TransactionID, AccountID, TransactionType, Amount)
VALUES
    (1, 1001, 'Deposit', 10000),
    (2, 1001, 'Withdraw', 5000),
    (3, 1002, 'Deposit', 15000),
    (4, 1002, 'Withdraw', 3000),
    (5, 1003, 'Deposit', 20000),
    (6, 1004, 'Deposit', 25000),
    (7, 1004, 'Withdraw', 7000),
    (8, 1005, 'Deposit', 12000);
    DELIMITER //

CREATE TRIGGER trg_TransactionAudit
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO TransactionAudit
        (TransactionID, AccountID, ActionName)
    VALUES
        (NEW.TransactionID, NEW.AccountID, 'INSERTED');
END //

DELIMITER ;
INSERT INTO Transactions
    (TransactionID, AccountID, TransactionType, Amount)
VALUES
    (9, 1001, 'Deposit', 2000);
-- Check the audit log

SELECT * FROM TransactionAudit;
-- Q1. Show each account with a row number
-- ordered by highest balance first.

SELECT
    AccountID,
    Balance,
    ROW_NUMBER() OVER (
        ORDER BY Balance DESC
    ) AS RowNo
FROM Accounts;


-- Q2. Rank accounts by balance.
SELECT
    AccountID,
    Balance,
    RANK() OVER (
        ORDER BY Balance DESC
    ) AS BalanceRank
FROM Accounts;
-- Q3. Show a running total of balances
-- ordered by AccountID.
SELECT
    AccountID,
    Balance,
    SUM(Balance) OVER (
        ORDER BY AccountID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Accounts;
-- Q4. Show the overall average balance
-- alongside every account.
SELECT
    AccountID,
    Balance,
    AVG(Balance) OVER () AS OverallAverage
FROM Accounts;


-- Q5. Rank accounts within each account type.
SELECT
    AccountID,
    AccountType,
    Balance,
    RANK() OVER (
        PARTITION BY AccountType
        ORDER BY Balance DESC
    ) AS TypeRank
FROM Accounts;
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance + 1000
WHERE AccountID = 1001;

COMMIT;
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 5000
WHERE AccountID = 1002;

ROLLBACK;
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance + 2000
WHERE AccountID = 1003;

SAVEPOINT SavePoint1;

UPDATE Accounts
SET Balance = Balance - 10000
WHERE AccountID = 1003;

ROLLBACK TO SAVEPOINT SavePoint1;

COMMIT;
-- Q1. Find accounts with a balance above the average.

SELECT *
FROM Accounts
WHERE Balance > (
    SELECT AVG(Balance)
    FROM Accounts
);


-- Q2. Find account(s) with the maximum balance.

SELECT *
FROM Accounts
WHERE Balance = (
    SELECT MAX(Balance)
    FROM Accounts
);


-- Q3. Find customers who own an account
-- with a balance above 60,000.

SELECT *
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Accounts
    WHERE Balance > 60000
);


-- Q4. Find the second-highest distinct balance.

SELECT MAX(Balance) AS SecondHighest
FROM Accounts
WHERE Balance < (
    SELECT MAX(Balance)
    FROM Accounts
);


-- Q5. Find accounts belonging to customers
-- from Chandigarh.

SELECT *
FROM Accounts
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Customers
    WHERE City = 'Chandigarh'
);
-- Q1. Total deposited amount by account.

SELECT
    AccountID,
    SUM(Amount) AS TotalDeposits
FROM Transactions
WHERE TransactionType = 'Deposit'
GROUP BY AccountID;


-- Q2. Total withdrawn amount by account.

SELECT
    AccountID,
    SUM(Amount) AS TotalWithdrawals
FROM Transactions
WHERE TransactionType = 'Withdraw'
GROUP BY AccountID;


-- Q3. Customer, account type and balance report.

SELECT
    c.CustomerName,
    a.AccountID,
    a.AccountType,
    a.Balance
FROM Customers c
JOIN Accounts a
    ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC;
SELECT
    c.CustomerName,
    a.AccountID,
    a.AccountType,
    a.Balance,

    RANK() OVER (
        PARTITION BY a.AccountType
        ORDER BY a.Balance DESC
    ) AS TypeRank,

    CASE
        WHEN a.Balance > AVG(a.Balance) OVER ()
            THEN 'Above Average'
        ELSE 'Below/Equal Average'
    END AS BalanceStatus

FROM Customers c
JOIN Accounts a
    ON c.CustomerID = a.CustomerID;