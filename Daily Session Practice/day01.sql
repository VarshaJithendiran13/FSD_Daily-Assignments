--DAY 01 - Stored Procedure

CREATE PROCEDURE DisplayMessage
AS
BEGIN
PRINT 'welcome to Session Day 1!'
END

-- EXECUTE DisplayMessage 

EXEC DisplayMessage
 
-- DisplayMessage



Select * from production.products

create proc ProductList
AS
BEGIN
select Product_name,list_price from production.products
order by product_name
END

drop procedure ProductList

exec ProductList

sp_help ProductList


USE BikeStores;
GO
EXEC sp_databases;



--Alter procedure
ALTER PROC ProductList
AS
BEGIN
select Product_name,model_year,list_price from
production.products order by list_price desc
END

ProductList


exec sp_rename 'ProductList', 'MyProductList'

-- parameter in Stored Procedure
/*input paramater
output parameter
*/

CREATE PROC FindProducts(@modelyear as int)
AS
BEGIN
SELECT * from production.products where model_year=@modelyear
END

FindProducts 2020


-- Example 4 with multiple parameter
CREATE PROC FindProdcutsbyRange(@minPrice decimal,@maxPrice decimal)
AS
BEGIN
SELECT * from production.products where 
list_price>=@minPrice AND 
list_price<=@maxPrice
END;

FindProdcutsbyRange 100,3000

--using named Parameter

FindProdcutsbyRange 
@maxPrice=12000,
@minPrice=5000

--optional parameter
CREATE PROC FindProductsByName
(@minPrice as decimal =2000,@maxPrice decimal,@name as varchar(max))
AS
BEGIN
select * from production.products where list_price>=@minPrice and 
list_price<=@maxPrice
and 
product_name like '%'+@name+'%'
END

FindProductsByName 100,1000,'Sun'

FindProductsByName @maxPrice=3000,@name='Trek'


-- out Parameter

CREATE PROCEDURE FindProductCountByModelYear
(@modelyear int,
@productCount int OUTPUT
)
AS
BEGIN
select Product_name,list_Price 
from production.products 
WHERE 
model_year=@modelyear

select @productCount=@@ROWCOUNT
END


DECLARE @count int;

EXEC  FindProductCountByModelYear @modelyear=2016,@productCount=@count OUT;;

select @count as 'Number of Products Found';

--can one stored procedure call another stored procedure


CREATE PROC GetAllCustomers
WITH ENCRYPTION
AS
BEGIN
select * from sales.customers
END

drop procedure GetAllCustomers
sp_help 'GetAllCustomers'

usp_GetAllCustomers


CREATE PROC	GetCusotmerOrders
@customerId INT
AS
BEGIN
SELECT *  FROM sales.orders 
WHERE
customer_id=@customerId 
END

GetCusotmerOrders  1



ALTER PROC GetCustomerData
(@cusomterId INT)
WITH RECOMPILE
AS
BEGIN
EXEC GetAllCustomers;
EXEC GetCusotmerOrders @cusomterId;
END

exec GetCustomerData 1

create procedure getAllCustomers
as
begin
select * from sales.customers
end
exec getAllCustomers

CREATE PROCEDURE getCustomersByProduct
    @ProductID INT
AS
BEGIN
    SELECT 
        c.customer_id, 
        c.first_Name, 
        o.order_date
    FROM 
        sales.customers c
    JOIN 
        sales.orders o ON c.customer_id = o.customer_id
    JOIN 
       sales.order_items  od ON o.order_id = od.order_id
    WHERE 
        od.product_id = @ProductID;
END


exec getCustomersByProduct 4


select * from sales.orders
select * from sales.order_items

select * from production.products


Create proc GetAllProduct
WITH ENCRYPTION
AS
BEGIN
select * from production.products
END

exec GetAllProduct

sp_help 'GetAllProduct'
sp_help 'getCustomersByProduct'
select * from SYSCOMments where ID=OBJECT_ID('GetAllProduct')

select * from SYSCOMments where ID=OBJECT_ID('getCustomersByProduct')


