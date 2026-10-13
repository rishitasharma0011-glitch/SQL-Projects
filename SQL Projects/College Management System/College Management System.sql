-- PROJECT 2: COLLEGE MANAGEMENT SYSTEM
CREATE DATABASE IF NOT EXISTS MiniCollegeDB;
USE MiniCollegeDB;
-- 1. Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE);
-- 2. Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(60) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Age INT CHECK (Age >= 17 AND Age <= 60),
    DepartmentID INT NOT NULL,
    City VARCHAR(40) DEFAULT 'Chandigarh',
    FOREIGN KEY (DepartmentID)
	REFERENCES Departments(DepartmentID));

-- 3. Courses table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(60) NOT NULL,
    Credits INT CHECK (Credits BETWEEN 1 AND 6),
    DepartmentID INT NOT NULL,
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID));

-- 4. Enrollments table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Marks INT CHECK (Marks BETWEEN 0 AND 100),

    FOREIGN KEY (StudentID)
        REFERENCES Students(StudentID),
FOREIGN KEY (CourseID)
        REFERENCES Courses(CourseID));
        -- Insert departments

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'Computer Science'),
(2, 'Management'),
(3, 'Commerce');
-- Insert students
INSERT INTO Students
    (StudentID, StudentName, Email, Age, DepartmentID, City)
VALUES
(101, 'Aman', 'aman@mail.com', 21, 1, 'Chandigarh'),
(102, 'Neha', 'neha@mail.com', 22, 1, 'Mohali'),
(103, 'Ravi', 'ravi@mail.com', 20, 2, 'Kharar'),
(104, 'Simran', 'simran@mail.com', 23, 3, 'Chandigarh'),
(105, 'Karan', 'karan@mail.com', 21, 2, 'Delhi');
-- Insert courses
INSERT INTO Courses
    (CourseID, CourseName, Credits, DepartmentID)
VALUES
(201, 'SQL Server', 4, 1),
(202, 'Python', 4, 1),
(203, 'Marketing', 3, 2),
(204, 'Financial Accounting', 4, 3),
(205, 'Business Analytics', 4, 2);

-- Insert enrollments and marks

INSERT INTO Enrollments
    (EnrollmentID, StudentID, CourseID, Marks)
VALUES
(1, 101, 201, 88),
(2, 101, 202, 91),
(3, 102, 201, 79),
(4, 103, 203, 84),
(5, 103, 205, 90),
(6, 104, 204, 87),
(7, 105, 203, 76),
(8, 105, 205, 81);

-- Test 1: Duplicate primary key
INSERT INTO Students
    (StudentID, StudentName, Email, Age, DepartmentID, City)
VALUES
(101, 'Test Student', 'test1@mail.com', 22, 1, 'Delhi');
-- Test 2: Duplicate email
INSERT INTO Students
    (StudentID, StudentName, Email, Age, DepartmentID, City)
VALUES
(106, 'Test Student', 'aman@mail.com', 22, 1, 'Delhi');

-- Test 3: Age violates CHECK constraint
INSERT INTO Students
    (StudentID, StudentName, Email, Age, DepartmentID, City)
VALUES
(107, 'Test Student', 'test3@mail.com', 15, 1, 'Delhi');
-- Test 4: DepartmentID does not exist
INSERT INTO Students
    (StudentID, StudentName, Email, Age, DepartmentID, City)
VALUES
(108, 'Test Student', 'test4@mail.com', 22, 99, 'Delhi');
-- Test 5: Credits exceed the allowed range
INSERT INTO Courses
    (CourseID, CourseName, Credits, DepartmentID)
VALUES
(206, 'Advanced SQL', 10, 1);

-- Q1. Display each student with their department name.
SELECT
    s.StudentName,
    d.DepartmentName
FROM Students s
INNER JOIN Departments d
    ON s.DepartmentID = d.DepartmentID;


-- Q2. Display each course with its department name.

SELECT
    c.CourseName,
    d.DepartmentName
FROM Courses c
INNER JOIN Departments d
    ON c.DepartmentID = d.DepartmentID;


-- Q3. Display student name, course name and marks.
SELECT
    s.StudentName,
    c.CourseName,
    e.Marks
FROM Students s
INNER JOIN Enrollments e
    ON s.StudentID = e.StudentID
INNER JOIN Courses c
    ON e.CourseID = c.CourseID;
-- Q4. Display all departments and their students.
SELECT
    d.DepartmentName,
    s.StudentName
FROM Departments d
LEFT JOIN Students s
    ON d.DepartmentID = s.DepartmentID;
-- Q5. Display all students, even if they have no enrollment.

SELECT
    s.StudentName,
    e.CourseID,
    e.Marks
FROM Students s
LEFT JOIN Enrollments e
    ON s.StudentID = e.StudentID;


-- Q6. Find students who scored more than 85.
SELECT
    s.StudentName,
    c.CourseName,
    e.Marks
FROM Students s
INNER JOIN Enrollments e
    ON s.StudentID = e.StudentID
INNER JOIN Courses c
    ON e.CourseID = c.CourseID
WHERE e.Marks > 85;
-- Q7. Find the number of students in each department.
SELECT
    d.DepartmentName,
    COUNT(s.StudentID) AS StudentCount
FROM Departments d
LEFT JOIN Students s
    ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;
-- Q8. Display students from the Management department.
SELECT
    s.StudentName
FROM Students s
INNER JOIN Departments d
    ON s.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Management';
-- Q9. Display each student's average marks.
SELECT
    s.StudentName,
    AVG(e.Marks) AS AverageMarks
FROM Students s
INNER JOIN Enrollments e
    ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.StudentName;
-- Q10. Display students whose average marks exceed 80.
SELECT
    s.StudentName,
    AVG(e.Marks) AS AverageMarks
FROM Students s
INNER JOIN Enrollments e
    ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.StudentName
HAVING AVG(e.Marks) > 80;
SELECT
    d.DepartmentName,
    s.StudentName,
    c.CourseName,
    e.Marks
FROM Departments d
INNER JOIN Students s
    ON d.DepartmentID = s.DepartmentID
INNER JOIN Enrollments e
    ON s.StudentID = e.StudentID
INNER JOIN Courses c
    ON e.CourseID = c.CourseID
ORDER BY e.Marks DESC;