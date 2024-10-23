select * from production.products
create proc uspProductList
AS 
BEGIN 
select product_name,list_price from production.products
order by product_name
end
 uspProductList
use BikeStores;
go
exec sp_databases;

ALTER proc uspProductList
as begin 
select product_name,model_year,list_price from
production.products order by list_price desc
end

exec sp_rename 'uspProductList','uspMyProductList'

/*input parameter
output parameter*/

create proc uspFindProducts(@modelyear as int)
as 
begin 
select * from production.products where model_year=@modelyear
end

uspFindProducts @modelyear=2019

-- example 4 with multiple parameter 
create proc uspFindProductsbyRange (@minprice decimal, @maxprice decimal)
as 
begin
select * from production.products where
list_price>=@minprice and list_price<=@maxprice
end

uspFindProductsbyRange 100,3000

-- using named parameter

uspFindProductsbyRange
@maxprice = 12000,
@minprice = 5000

--optional parameter
create proc uspFindProductsByName
(@minprice as decimal =2000,@maxprice  decimal , @name as varchar(max))
as 
begin
select *from production.products where list_price>=@minprice and 
list_price<=@maxprice and
product_name like '%' +@name+'%'
end

uspFindProductsByName @maxprice=5000,@name='sun'

-- out parameter
create proc uspFindProductCountByModelYear(@modelyear int,@productCount int out)
as 
begin
select product_name,list_Price from production.products
where model_year=@modelyear
select @productCount=@@ROWCOUNT
end

declare @count int;
exec uspFindProductCountByModelYear @modelyear = 2016,@productCount=@count out
select @count as 'Number of products Found';
--can 
create proc usp_GetAllCustomers
as
begin
select* from sales.customers
end

usp_GetAllCustomers

create proc usp_GetCustomersOrders @customerId int
as
begin
select * from sales.orders
where customer_id=@customerId
end
usp_GetCustomersOrders 1


create proc usp_GetCustomerData(@customerId int)
as
begin
exec usp_GetAllCustomers;
exec usp_GetCustomersOrders @customerId;
end

exec usp_GetCustomerData 1
----ASSIGNMENT 1---------------------------------
/*You need to create a stored procedure that retrieves a list of all customers who have purchased a specific product.
consider below tables Customers, Orders,Order_items and Products
Create a stored procedure,it should return a list of all customers who have purchased the specified product, 
including customer details like CustomerID, CustomerName, and PurchaseDate.
The procedure should take a ProductID as an input parameter.*/
 CREATE PROCEDURE GetCustomersByProductID @ProductID INT
AS
BEGIN
SELECT 
 C.customer_id as CustomerID,concat(c.first_name,'',c.last_name) as customername,
 o.order_date AS PurchaseDate
 FROM sales.customers C
 INNER JOIN 
 sales.orders o
 on c.customer_id=o.customer_id
 inner join
 sales.order_items oi ON C.customer_id = oi.order_id
INNER JOIN 
production.products p ON oi.product_id=p.product_id
  where p.product_id=@ProductID
END;
exec GetCustomersByProductID 20

-- ASSIGNMENT 2-------------------------------
/*CREATE TABLE Department with the below columns ID,Name
populate with test data
 CREATE TABLE Employee with the below columns
ID,Name,Gender,DOB,DeptId populate with test data
a) Create a procedure to update the Employee details in the Employee table based on the Employee id.
b) Create a Procedure to get the employee information bypassing the employee gender and department id from the Employee table
c) Create a Procedure to get the Count of Employee based on Gender(input)*/

 CREATE TABLE Department (
 ID INT PRIMARY KEY,
 Name VARCHAR(100)
);

INSERT INTO Department (ID, Name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

CREATE TABLE Employee (
 ID INT PRIMARY KEY,
 Name VARCHAR(100),
 Gender VARCHAR(10),
 DOB DATE,
 DeptId INT,
 FOREIGN KEY (DeptId) REFERENCES Department(ID)
);

INSERT INTO Employee (ID, Name, Gender, DOB, DeptId) VALUES
(1, 'Ram', 'Male', '1999-05-15', 2),
(2, 'Vanshika', 'Female', '1995-10-20', 1),
(3, 'Ramesh', 'Male', '2000-08-10', 3),
(4, 'Shreya', 'Female', '2001-07-25', 2);
Select * from Employee

CREATE PROC UpdateEmployeeDetails(
 @ID INT, @Name VARCHAR(100), @Gender VARCHAR(10),@DOB DATE,@DeptId INT
)
as
begin
 UPDATE Employee
 SET Name = @Name,Gender = @Gender,DOB = @DOB, DeptId = @DeptId
    WHERE ID = @ID;
END;

exec UpdateEmployeeDetails @ID=1, @Name=Varun, @Gender ='Male',@DOB =' 1998-06-16',@DeptId = 1
GO

CREATE PROC GetEmployeeByGenderAndDept
 @Gender VARCHAR(10),
 @DeptId INT
AS
BEGIN
    SELECT * FROM Employee
    WHERE Gender = @Gender
      AND DeptId = @DeptId;
END;

GetEmployeeByGenderAndDept  @Gender= 'Male',@DeptId =1

CREATE PROC GetEmployeeCountByGender
@Gender VARCHAR(10)
AS
BEGIN
 SELECT COUNT(*) AS EmployeeCount FROM Employee
 WHERE Gender = @Gender;
END;
GetEmployeeCountByGender @Gender='female'


create proc usp_getAllProduct
with encryption
as
begin
select * from production.products
end

exec usp_getAllProduct

--select * from syscomments usp_getAllProduct

----user define function
-- scaler valued fuction 
create function GetAllProducts()
returns int
as
begin
return (select count(*) from production.products)
end
print dbo.GetAllProducts()

--table valued function
--inline table valued fuction ==> single statement

create function GetProductById(@productId int)
returns table
as
return (select*from production.products where product_id=@productId);
select * from GetProductById(4)

--multi statement table valued function has more than one statement
create function ILTVF_GetEmployee() 
returns table 
as 
return (select ID,Name from employee)

create function MSTVF_GetEmployee()
Returns @temptable table (ID int,Name varchar(50),DOB Date)
As
begin
insert into @temptable
select ID,Name,Cast(DOB as Date) from employee
return 
end
select * from employee
select * from MSTVF_GetEmployee()
update ILTVF_GetEmployee() Set Name='Geeta' where ID=2
update MSTVF_GetEmployee() Set Name='' where ID=2

--ASSIGNMENT 3------------------------------------
--Create a user Defined function to calculate the TotalPrice based on productid and Quantity Products Table
CREATE FUNCTION CalculateTotalPrice
( @ProductId INT, @Quantity INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Price DECIMAL(10, 2);
    DECLARE @TotalPrice DECIMAL(10, 2)
    SELECT @price=list_price FROM sales.order_items wHERE product_id = @ProductId;
    SET @TotalPrice = @Price * @Quantity;
    RETURN @TotalPrice;
END;

SELECT dbo.CalculateTotalPrice(3, 3) AS TotalPrice;

--ASSIGNMENT 4------------------------------------------
--create a function that returns all orders for a specific customer, including details such as OrderID, OrderDate, and the total amount of each order.

CREATE FUNCTION GetCustomerOrders
( @CustomerID INT)
RETURNS TABLE
AS
RETURN
(
 SELECT  O.order_id, O.order_date,
  SUM(OI.Quantity * OI.list_price) AS TotalAmount
  FROM sales.orders O
  JOIN sales.order_items OI ON O.order_id = OI.order_id
  WHERE O.customer_id = @CustomerID
  GROUP BY O.order_id, O.order_date
);
SELECT * FROM dbo.GetCustomerOrders(7);

--ASSIGNMENT 5---------------------------------------
--create a Multistatement table valued function that calculates the total sales for each product, considering quantity and price.

CREATE FUNCTION GetTotalSalesByProduct()
RETURNS @TotalSalesTable TABLE
( ProductID INT,ProductName VARCHAR(90),TotalSales DECIMAL(18, 2)
)
AS
BEGIN
 INSERT INTO @TotalSalesTable (ProductID, ProductName, TotalSales)
 SELECT P.product_id,P.product_name,
 SUM(SOI.Quantity * SOI.list_price) AS TotalSales
 FROM production.products P
 JOIN sales.order_items SOI ON P.product_id = SOI.product_id
 GROUP BY P.product_id, P.product_name;
RETURN;
END;


SELECT * FROM dbo.GetTotalSalesByProduct();

--ASSIGNMENT 6------------------------------------------------------------
--create a  multi-statement table-valued function that lists all customers along with the total amount they have spent on orders.

CREATE FUNCTION GetCustomerTotalSpent()
RETURNS @CustomerSpendingTable TABLE
(CustomerID INT,CustomerName VARCHAR(100),TotalSpent DECIMAL(18, 2))
AS
BEGIN
INSERT INTO @CustomerSpendingTable (CustomerID, CustomerName, TotalSpent)
SELECT 
  C.customer_id,
 C.first_name+' '+C.last_name as customer_name,
  
 ISNULL(SUM(SOI.Quantity * SOI.list_price), 0) AS TotalSpent
 FROM sales.customers C
 LEFT JOIN sales.orders O ON C.customer_id = O.customer_id
 LEFT JOIN sales.order_items SOI ON O.order_id = SOI.order_id
 GROUP BY C.customer_id, C.first_name,C.last_name;
RETURN;
END;

SELECT * FROM dbo.GetCustomerTotalSpent();
