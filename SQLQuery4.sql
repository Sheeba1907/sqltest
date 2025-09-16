CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Category VARCHAR(30),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO Sales(SaleID, CustomerName, Product, Category, Quantity, Price, SaleDate) 
VALUES
(1, 'Alice', 'Laptop', 'Electronics', 1, 60000, '2023-01-05'),
(2, 'Bob', 'Smartphone', 'Electronics', 2, 30000, '2023-01-08'),
(3, 'Carol', 'Shirt', 'Clothing', 3, 1500, '2023-01-10'),
(4, 'David', 'Refrigerator', 'Appliances', 1, 35000, '2023-01-12'),
(5, 'Eve', 'Jeans', 'Clothing', 2, 2000, '2023-01-15'),
(6, 'Frank', 'Microwave', 'Appliances', 1, 8000, '2023-01-20'),
(7, 'Grace', 'Shoes', 'Clothing', 1, 2500, '2023-01-22'),
(8, 'Hank', 'Headphones', 'Electronics', 2, 4000, '2023-01-25');

--Find sales where total amount (Quantity * Price) is greater than 5000.
select *, quantity * price as total_amount
from Sales
where quantity * price > 5000;

--Show sales from category Clothing or Electronics.
select * from Sales 
where category = 'Clothing' or category = 'Electronics';

--Find sales made between '2023-01-10' and '2023-01-20'.
select * from Sales 
where saleDate between '2023-01-10' and '2023-01-20';

--Display all sales where Quantity IS NOT NULL.
select * from Sales 
where quantity is not null;

--Concatenate CustomerName and Product into one column.
select CustomerName + Product as Billname
from Sales;

--Assign a row number to sales ordered by SaleDate.
select saleId, customerName, Price, saleDate,
row_number() over (order by saleDate desc) as R_no
from Sales;

--Rank sales by total amount (Quantity * Price) descending.
select saleId, customerName, Quantity, price, quantity*price as total_amount,
rank() over (order by quantity*price desc) as rk_order
from Sales;

--Rank sales by total amount using DENSE_RANK().
select saleId, customerName, Quantity, price, quantity*price as total_amount,
dense_rank() over (order by quantity*price desc) as drk_order
from Sales;

--Divide sales into 3 groups using NTILE(3) based on total amount.
select saleId, customerName, Quantity, price, quantity*price as total_amount,
NTILE(3) over (order by quantity*price) as groups
from Sales;

--Find total revenue (SUM(Quantity * Price)) per category.
select category, sum(Quantity * Price) as total_revenue
from Sales
group by category;

--Find average sale value per category.
select category, avg(Quantity * Price) as average_sale
from Sales
group by category;

--Count number of sales in Electronics.
select category, count(*) as total_no_sales
from Sales
where category = 'Electronics'
group by category;

--Show each sale with the previous sale’s amount using LAG().
select *, quantity * price as total_sale,
lag(quantity * price, 1,0) over (order by SaleDate) as previous_sale
from Sales;

--Show each sale with the next sale’s amount using LEAD().
select *, quantity * price as total_sale,
lead(quantity * price, 1,0) over (order by SaleDate) as next_sale
from Sales;

--Find the first sale made per category using FIRST_VALUE(SaleDate).
select *, quantity * price as total_sale,
first_value(quantity * price) over (partition by category order by saleDate) as first_sale
from Sales;

--Find the most recent sale per category using LAST_VALUE(SaleDate).
select Category, SaleID, Product, quantity * price as total_sale,
last_value(quantity * price) over (partition by category order by saleDate rows 
                                    between unbounded preceding and unbounded
                                    following) as last_sale
from Sales;

--Find customers whose sale amount is above the average sale value.
select customerName, quantity * price as total_sale
from Sales 
where quantity * price > (select avg(quantity * price) from Sales);

--Show the top 2 highest-value sales per category using ROW_NUMBER.
select * from(select customerName, category, quantity * price as total_sale,
            row_number() over (partition by category order by quantity * price desc) 
            as highest_value_sales
from Sales) t
where highest_value_sales <= 2;

--Write a procedure to return all sales for a given Category (pass category as parameter).
create procedure return_sales
@category varchar(30)
as
begin
select *, quantity * price as total_sale
from Sales
where category = @category
end;

exec return_sales
@category = 'Electronics';

drop procedure return_total_revenue;

--Create a procedure to calculate the total revenue for a specific CustomerName.
create procedure return_total_revenue
@customerName varchar(30)
as
begin
select customerName, sum(quantity * price) as total_revenue
from Sales
where customerName = @customerName
group by customerName
end;

exec return_total_revenue
@customerName = 'Hank';

drop procedure update_price;

--Write a procedure to update the Price of a product by a given percentage.
create procedure update_price
@product varchar(30),
@percent decimal(5, 2)
as
begin
update sales
set price = price + (price * @percent / 100)
where product = @product
end;

exec update_price
@product = 'Laptop',
@percent = 10;

select price from Sales;

--Find customers whose sales are above the average sale amount.
select customerName, quantity * price as total_sale
from Sales 
where quantity * price > (select avg(quantity * price) from Sales);

--Find customers who bought products that no one else bought.
select customerName, product as no_one_bought
from Sales s1
where not exists(select 1 from Sales s2
                where s2.product = s1.product and s2.saleId != s1.saleId);

/*Create a view vw_TotalSales that shows CustomerName, Category, and TotalAmount 
(Quantity * Price).*/
create view vw_TotalSales as
select customerName, category, Quantity * Price as TotalAmount
from Sales;

select * from vw_TotalSales;

--Create a view that shows only sales from the current year.
create view vw_current_year as
select *
from Sales
where year(saleDate) = year(getDate());

select * from vw_current_year;

--Create a view that gives the total revenue per category.
create view vw_total_revenue as
select category, sum(quantity * price) as total_revenue
from Sales
group by category;

select * from vw_total_revenue;

--Use a CTE to calculate each sale’s TotalAmount, then select only those > 5000.
with cte_total_amount as (select saleId, product, Quantity * Price as TotalAmount
from Sales) 
select * from cte_total_amount where TotalAmount > 5000;