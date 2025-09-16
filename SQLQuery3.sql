CREATE DATABASE Sales;

USE Sales;

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Dept NVARCHAR(20),
    Salary INT NULL,
    JoinDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID NVARCHAR(10),
    Region NVARCHAR(20),
    Amount INT,
    OrderDate DATE
);

INSERT INTO Employees (EmpID, Name, Dept, Salary, JoinDate)
VALUES
(1, 'Alice', 'HR', 5000, '2021-01-10'),
(2, 'Bob', 'IT', 7000, '2020-07-15'),
(3, 'Carol', 'IT', 6000, '2022-03-01'),
(4, 'David', 'Sales', 5500, '2021-11-20'),
(5, 'Eva', 'HR', NULL, '2023-05-05');

INSERT INTO Orders (OrderID, CustomerID, Region, Amount, OrderDate)
VALUES
(101, 'C1', 'East', 200, '2023-01-10'),
(102, 'C2', 'West', 150, '2023-01-12'),
(103, 'C1', 'East', 300, '2023-02-01'),
(104, 'C3', 'West', 400, '2023-02-15'),
(105, 'C4', 'East', 250, '2023-03-01');

--Find the total number of employees.
select count(*) as total from Employees;

--Get the highest salary from the Employees table.
select max(Salary) as highest_salary from Employees;

--Get the lowest salary from the Employees table.
select min(Salary) as highest_salary from Employees;

--Count how many orders were placed in the East region.
select count(*) as orders_tot from orders where Region = 'East';

--Find the average order amount.
select avg(Amount) as average from Orders;

--List the total salary per department.
select sum(Salary) as total_per_department, dept from Employees 
group by dept;

/*Show the number of employees per department, but only those departments that 
have more than 1 employee.*/
select count(*) as total_emp, dept from Employees
group by dept
having count(*) > 1;

--Find the total sales per region, sorted by sales amount in descending order.
select sum(Amount) as total_sales, region from Orders 
group by region
order by total_sales desc;

--Get the average salary of employees who joined after 2021-01-01.
select avg(salary) as avg_salary from Employees 
where JoinDate > '2021-01-01';

--Find departments where the average salary is greater than 6000.
select dept as good_dept from Employees
group by dept
having avg(salary) > 6000;

/*Show each region’s maximum order amount, but only include regions where the total 
sales exceed 500.*/
select max(amount) as max_order_amt, region
from Orders
group by region
having sum(amount) > 500;

--List the top 2 highest-earning employees.
select top 2 EmpID, Name, salary as highest_earning
from Employees
order by highest_earning desc;

/*Find the employee count, minimum salary, maximum salary, and average salary 
for each department.*/
select dept, count(empId) as employee_count, min(salary) as minimum_salary, 
       max(salary) as maximum_salary, avg(salary) as average_salary from employees
group by dept;

--For each customer, find their total number of orders and total sales amount.
select customerid, count(orderId) as total_orders, sum(amount) as total_amount 
from orders
group by customerid;

--For each employee, show their salary along with the average salary of their department.
select Name, 
       dept, 
       salary,
       avg(salary) over (partition by Name) as dept_avg_salary
from Employees;

--For each order, show the running total of sales per region.
select orderId,
       Region,
       orderDate,
       Amount,
       sum(amount) over (partition by region
       order by orderDate
       rows between unbounded preceding and current row) as total_sales
from Orders;

