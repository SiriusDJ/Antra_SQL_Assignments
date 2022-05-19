-- Homework3
use Northwind
go

--1
create view view_product_order_zhang as
select p.ProductName, sum(od.Quantity) as ToTalOrderQuantity
from Products as p join [Order Details] as od on od.ProductID = p.ProductID
group by p.ProductName

select *
from view_product_order_zhang


drop view view_product_order_zhang


--2
create proc sp_product_order_quantity_zhang
@id int,
@quantity int out
as 
begin
select @quantity = sum(od.Quantity)
from Products as p join [Order Details] as od on od.ProductID = p.ProductID
where p.ProductID = @id
end

-- test input number = 2
begin
declare @en int
exec sp_product_order_quantity_zhang 2,@en out
print @en
end

drop proc sp_product_order_quantity_zhang


--3
create proc sp_product_order_city_zhang
@name nvarchar(40)
as
begin
with cte as (
	select p.ProductName,c.City, sum(od.Quantity) as Quantity
	from Products as p join [Order Details] as od on od.ProductID = p.ProductID join Orders as o on o.OrderID = od.OrderID join Customers as c on c.CustomerID = o.CustomerID
	group by c.City, p.ProductName)
select top 5 City, Quantity
from cte
where ProductName = @name
order by Quantity desc
end

--test with name Alice Mutton
exec sp_product_order_city_zhang 'Alice Mutton'

drop proc sp_product_order_city_zhang


--4
create table city_zhang(
Id int primary key default 2,
City nvarchar(15) default 'Madison'
)
create table people_zhang(
Id int primary key,
Name nvarchar(30),
City_ID int foreign key references city_zhang(Id) on delete set null)

insert into city_zhang values(1, 'Seattle')
insert into city_zhang values(2, 'Green Bay')


insert into people_zhang values(1,'Aaron Rodgers',2)
insert into people_zhang values(2,'Russell Wilson',1) 
insert into people_zhang values(3,'Jody Nelson',2)

select * from people_zhang
select * from city_zhang

--after delete, insert (3, madison) into cities
create trigger t1
on city_zhang
after delete
as
begin
insert into city_zhang values(3, 'Madison')
end

--after delete, turn null city_id into madison's city id which is 3
create trigger t2
on city_zhang
after delete
as 
begin
update people_zhang
set City_ID = 3
where City_ID is Null
end

--delete city Seattle
delete from city_zhang
where City = 'Seattle'

select * from people_zhang
select * from city_zhang

--create view
create view Packers_zhang as 
select a.Name
from people_zhang as a join city_zhang as b on a.City_ID = b.ID
where b.City = 'Green Bay'

--show the people from Green Bay
select *
from Packers_zhang

drop trigger t1
drop trigger t2


drop table people_zhang
drop table city_zhang
drop view Packers_zhang


--5
create proc sp_birthday_employees_zhang
as
begin
select employees.FirstName + ' '+ Employees.LastName as FullName into birthday_employees_zhang
from Employees
where month(BirthDate) = 2
end

exec sp_birthday_employees_zhang
select * from birthday_employees_zhang

drop proc sp_birthday_employees_zhang
drop table birthday_employees_zhang

--6
-- Use Except back and forth for the two tables
-- If both results are empty, then two tables are identical in their data