create database Company;

use company;

create table Departments(
DeptId int primary key,
DeptName varchar(100) unique not null,
Location varchar(50));

create table Employees(
EmpId int primary key,
Name varchar(100) not null,
Email varchar(100) unique,
Salary decimal(10,2) check(Salary>0),
DeptId int foreign key references Departments(DeptId));

alter table Employees add HireDate date;
alter table Employees alter column Name varchar(150);
alter table Employees drop column HireDate;

--exec sp_help employees; --  for checking table description--

insert into departments(deptid, deptname, location) 
values(1, 'HR', 'New York'),
(2, 'IT', 'Chicago'),
(3, 'Finance', 'Boston')

insert into employees(empid, name, email, salary, deptid) 
values(101, 'Alice', 'alice@example.com', 50000, 1),
(102, 'Bob', 'bob@example.com', 60000, 2),
(103, 'Charlie', 'charlie@example.com', 55000, 2),
(104, 'Diana', 'diana@example.com', 60000, 3)

select * from employees;

select name, salary from employees where salary>55000;

update employees set salary = 60000 where empid = 102;
update employees set salary = 55000 where empid = 103;

update employees set salary = salary * 1.10 where deptid = 2;