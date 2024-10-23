create database day2;
use day2;

---7) Create a trigger to updates the Stock (quantity) table whenever new order placed in orders tables:-
-- Creating Stock table
create table Stock (
ProductID int primary key,
Quantity int not null
);

-- Inserting test stock data
insert into Stock (ProductID, Quantity)
values 
(1, 100),   
(2, 50);    

-- Creating OrderItems table
create table OrderItems (
OrderItemID int identity primary key,
OrderID int not null,
ProductID int not null,
Quantity int not null
);

-- Inserting test order items
insert into OrderItems (OrderID, ProductID, Quantity)
values
(1001, 1, 10),  
(1002, 2, 5);   


-- Create the trigger to update stock when a new order is inserted
create trigger trgUpdateStockOnNewOrder
on OrderItems
after insert
as
begin
update s set s.Quantity = s.Quantity - i.Quantity
from Stock s
inner join inserted i on s.ProductID = i.ProductID;
end;

-- Insert testing order to trigger the stock update
insert into OrderItems (OrderID, ProductID, Quantity)
values (1003, 1, 20);  

-- Check the updated stock quantities
select * from Stock;



----8) Creating a Trigger to Prevent Deletion of a Customer if They Have Existing Orders:
-- Assuming you have a Customer table
create table Customer (
customer_id int primary key,
customer_name varchar(100)
);

-- Creating Orders table
create table Orders (
order_id int primary key,
customer_id int,
order_date date,
foreign key (customer_id) references Customer(customer_id)
);

-- Inserting test data
insert into Customer (customer_id, customer_name)
values (1, 'Ravi'), (2, 'Priya');

insert into Orders (order_id, customer_id, order_date)
values (1001, 1, '2024-10-01');

-- Create the trigger to prevent deletion of customers with existing orders
create trigger trgPreventCustomerDeletion
on Customer
instead of delete
as
begin
declare @Count int;    
select @Count = count(*)
from Orders o
join deleted d on o.customer_id = d.customer_id;
if @Count > 0
begin
raiserror('Customer has existing orders and cannot be deleted.', 16, 1);
rollback transaction;
end
else
begin
delete from Customer
where customer_id in (select customer_id from deleted);
end
end;


-- Test the trigger: try to delete a customer with an order
delete from Customer where customer_id = 1;  



----9) Creating Employee and Employee_Audit Tables with a Trigger to Log Changes:
--a) Creating Employee and Employee_Audit Tables with Sample Data:-
-- Create the Employee table
create table Employee (
EmployeeID int identity primary key,
Name varchar(100),
Gender char(1),
DOB date,
DepartmentID int
);

-- Create the Employee_Audit table to log changes
create table Employee_Audit (
AuditID int identity primary key,
EmployeeID int,
Name varchar(100),
Gender char(1),
DOB date,
DepartmentID int,
ChangeType varchar(50),  
ChangeDate datetime default getdate()  
);

-- Insert some test data into Employee table
insert into Employee (Name, Gender, DOB, DepartmentID)
values ('Sanjay', 'M', '2000-05-15', 1),('Sita', 'F', '2001-07-22', 2);


----b) Creating a Trigger to Log Changes to the Employee Table:
-- Create the trigger to log changes in the Employee table
create trigger trgEmployeeChanges
on Employee
for insert, update, delete
as
begin
if exists (select * from inserted)
begin
insert into Employee_Audit (EmployeeID, Name, Gender, DOB, DepartmentID, ChangeType)
select EmployeeID, Name, Gender, DOB, DepartmentID, 'INSERT/UPDATE'
from inserted;
end
if exists (select * from deleted)
begin
insert into Employee_Audit (EmployeeID, Name, Gender, DOB, DepartmentID, ChangeType)
select EmployeeID, Name, Gender, DOB, DepartmentID, 'DELETE'
from deleted;
end
end;

-- Test the trigger with an UPDATE
update Employee
set Name = 'Rahul Kumar'
where EmployeeID = 1;

-- Test the trigger with a DELETE
delete from Employee where EmployeeID = 2;

-- Check the Employee_Audit log
select * from Employee_Audit;


---- 10) Create Room Table with columns: RoomID, RoomType, Availability. 
/* Create Bookings Table with columns: BookingID, RoomID, CustomerName, CheckInDate, CheckOutDate. 
   Insert some test data into both tables. 
   Ensure both tables have an entity relationship. 
   Write a transaction that books a room for a customer, ensuring the room is marked as unavailable.*/

-- Creating Room table
create table Room (
RoomID int identity primary key,
RoomType varchar(50),
Availability bit 
);

-- Inserting test data into Room table
insert into Room (RoomType, Availability)
values 
('Single', 1),  
('Double', 1),  
('Suite', 1);   

-- Creating Booking table
create table Booking (
BookingID int identity primary key,
RoomID int foreign key references Room(RoomID),
CustomerName varchar(100),
CheckInDate date,
CheckOutDate date
);

-- Inserting test data into Booking table
insert into Booking (RoomID, CustomerName, CheckInDate, CheckOutDate)
values 
(1, 'Madhuri', '2024-10-25', '2024-10-28'),
(2, 'Prijith', '2024-11-01', '2024-11-05');

-- Transaction to book a room for a customer and mark the room as unavailable
begin transaction
declare @RoomID int = 3, @CustomerName varchar(100) = 'Alex Johnson', 
@CheckInDate date = '2024-11-10', @CheckOutDate date = '2024-11-15';
if exists (select 1 from Room where RoomID = @RoomID and Availability = 1)
begin
insert into Booking (RoomID, CustomerName, CheckInDate, CheckOutDate)
values (@RoomID, @CustomerName, @CheckInDate, @CheckOutDate);
update Room
set Availability = 0
where RoomID = @RoomID;
commit transaction;
print 'Booking successful and room marked as unavailable.';
end
else
begin
rollback transaction;
print 'Room is not available.';
end;