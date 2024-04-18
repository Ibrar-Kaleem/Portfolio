
-- Question 1: Combine 2 tables : Write a SQL query for a report that provides the following information for each 
-- person in the Person table, regardless if there is an address for each of those people:
-- FirstName, LastName, City, State 
 
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

CREATE TABLE Address (
    AddressID INT PRIMARY KEY,
    PersonID INT,
    City VARCHAR(50),
    State VARCHAR(50),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

INSERT INTO Person (PersonID, FirstName, LastName) VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Johnson'),
(4, 'Bob', 'Brown'),
(5, 'Emily', 'Davis');

INSERT INTO Address (AddressID, PersonID, City, State) VALUES
(1, 1, 'New York', 'NY'),
(2, 2, 'Los Angeles', 'CA'),
(3, 4, 'Chicago', 'IL'),
(4, 5, NULL, 'TX');

INSERT INTO Person (PersonID, FirstName, LastName) VALUES
(6, 'Michael', 'Johnson'),
(7, 'Sarah', 'Williams'),
(8, 'David', 'Martinez'),
(9, 'Jessica', 'Brown'),
(10, 'Daniel', 'Garcia');

INSERT INTO Address (AddressID, PersonID, City, State) VALUES
(5, 3, 'Seattle', 'WA'),
(6, 6, 'Boston', 'MA'),
(7, 7, NULL, 'FL'),
(8, 8, 'San Francisco', 'CA'),
(9, 9, 'Houston', 'TX'),
(10, 10, 'Philadelphia', 'PA');

-- Answer

Select p.FirstName,p.LastName,a.City,a.State
from Person as p
left join Address as a on p.PersonID=a.PersonID

--Q Write and sql query having highest, second highest,where salary more than manager salary and nth highest salary in salary table

CREATE TABLE Salary (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(100),
    Salary DECIMAL(10,2),
    ManagerID INT
);

INSERT INTO Salary (ID, Name, Department, Salary, ManagerID) VALUES
(1, 'John Smith', 'Sales', 50000.00, NULL),
(2, 'Alice Johnson', 'Marketing', 60000.00, 1),
(3, 'Bob Brown', 'Sales', 55000.00, 1),
(4, 'Emily Davis', 'HR', 52000.00, 2),
(5, 'Michael Wilson', 'IT', 65000.00, 3),
(6, 'Sarah Martinez', 'Finance', 62000.00, 4),
(7, 'David Garcia', 'IT', 70000.00, 5),
(8, 'Jessica Thompson', 'HR', 53000.00, 4),
(9, 'Daniel Lee', 'Finance', 64000.00, 6),
(10, 'Laura Rodriguez', 'Marketing', 58000.00, 1),
(11, 'James Hernandez', 'IT', 69000.00, 5),
(12, 'Olivia Lopez', 'Finance', 61000.00, 6),
(13, 'William Perez', 'Sales', 57000.00, 1),
(14, 'Ava Gonzalez', 'Marketing', 59000.00, 1),
(15, 'Ethan Torres', 'HR', 54000.00, 2);

Select * from Salary;

-- highest, second highest,where salary more than manager salary, maximum salary in a department ( using sub query)

-- Max salary
Select *
from Salary
where Salary = (select max(Salary) from Salary)

-- second highest salary
select *
from Salary
where Salary= (select max(Salary) as second_highest_salary from Salary where Salary <> (select max(Salary) from Salary))

-- Salary more than manager salary

Select s1.ID,s1.Name,s1.Department,s1.Salary,s1.ManagerID,s2.Name,s2.Department,s2.Salary
from Salary as s1
join Salary as s2 on s1.ManagerID=s2.ID
where s1.Salary>s2.Salary

-- Max salary in a department

select Department, max(Salary) as max_salary_per_dept
from Salary
group by Department


-- highest, second highest,where salary more than manager salary, maximum salary in a department ( using CTE and Window function)

-- Highest
with CTE as (
Select *, DENSE_RANK() over (order by salary desc) as Salary_rank
from Salary)

Select *
from CTE
where Salary_rank= 1

-- 2nd Highest
with CTE as (
Select *, DENSE_RANK() over (order by salary desc) as Salary_rank
from Salary)

Select *
from CTE
where Salary_rank= 2

-- max salary per department

With CTE2 as (
select *, DENSE_RANK() over ( partition by Department order by salary Asc) as salary_rnk_per_dept 
from Salary)

Select *
from CTE2
where salary_rnk_per_dept=1




