use AdventureWorks2019
go

--1
select cr.name as Country, sp.name as Province
from Person.CountryRegion as cr join Person.StateProvince as sp on cr.CountryRegionCode = sp.CountryRegionCode

--2
select cr.name as Country, sp.name as Province
from Person.CountryRegion as cr join Person.StateProvince as sp on cr.CountryRegionCode = sp.CountryRegionCode
where cr.name in ('Canada','Germany')
order by cr.Name


--Use Northwind
use Northwind
go

--3
select distinct p.ProductName
from Orders as o join [Order Details] as od on od.OrderID = o.OrderID
join Products as p on p.ProductID = od.ProductID
where datediff(year, getdate(), o.OrderDate) < 25

--4 
select top 5 sum(od.Quantity) as OrderNumbers, o.ShipPostalCode
from orders as o join [Order Details] as od on od.OrderID = o.OrderID
where o.ShipPostalCode is not null and datediff(year, getdate(), o.OrderDate) < 25.
group by o.ShipPostalCode
order by sum(od.Quantity) desc

--5
select c.City, count(c.CustomerID) as num_of_customers
from Customers as c
group by c.City

--6
select c.City, count(c.CustomerID) as num_of_customers
from Customers as c
group by c.City
having count(*)>2

--7
select c.CompanyName, sum(isnull(od.Quantity,0)) as count_of_products
from Customers as c left join Orders as o on o.CustomerID = c.CustomerID
join [Order Details] as od on od.OrderID = o.OrderID
group by c.CompanyName

--8
select c.CustomerID, sum(od.Quantity) as CountOfProducts
from Customers as c join Orders as o on o.CustomerID = c.CustomerID
join [Order Details] as od on od.OrderID = o.OrderID
group by c.CustomerID
having sum(od.Quantity) > 100
order by CountOfProducts

--9
select s.CompanyName as SupplierCompany, sh.CompanyName as ShipperCompany
from Suppliers as s cross join Shippers as sh
order by SupplierCompany

--10
select o.OrderDate, p.ProductName
from Orders as o join [Order Details] as od on od.OrderID = o.OrderID join Products as p on p.ProductID = od.ProductID
order by o.OrderDate

--11
select e.FirstName + ' ' + e.LastName as Name1, f.FirstName +' ' + f.LastName as Name2
from Employees as e join Employees as f on e.Title = f.title
where e.EmployeeID != f.EmployeeID

--12
with cte as 
(select f.EmployeeID, count(*) as report_num
from Employees as e join Employees as f on e.ReportsTo = f.EmployeeID
group by f.EmployeeID
having count(*) >2)
select g.FirstName + ' ' + g.LastName as ManagerName
from Employees as g join cte on cte.EmployeeID = g.EmployeeID

--13
select s.City, s.CompanyName as Name, s.CompanyName, 'Suppliers' as Type
from Suppliers as s
Union
select c.City, c.CompanyName as Name, c.ContactName, 'Customers' as Type
from Customers as c
order by city

--14
select distinct c.city 
from Customers as c join Employees as e on c.City = e.City

--15
--use subquery
select distinct c.City
from Customers as c
where c.city not in (
	select City
	from Employees
)

--do not use subquery
select distinct city from Customers
except
select city from Employees

--16
select p.ProductName, sum(od.Quantity) as TotoalOrderQuantities
from Products as p left join [Order Details] as od on od.ProductID = p.ProductID join Orders as o on o.OrderID = od.OrderID
group by p.ProductName
order by p.ProductName

--17
--union
select City, count(CustomerID) as customer_num
from Customers
group by City
except
(select City, count(CustomerID)
from Customers
group by City
having count(CustomerID) = 0
union 
select City, count(CustomerID)
from Customers
group by City
having count(CustomerID) = 1)

--subquery
select distinct c.city
from Customers c
where exists (
	select s.city
	from Customers s
	where c.city = s.city and c.CustomerID != s.customerID)

--18
select c.City, count(distinct od.ProductID) as ProductKinds
from Customers as c join Orders as o on o.CustomerID = c.CustomerID join [Order Details] as od on od.OrderID = o.OrderID
group by c.City
having count(distinct od.ProductID) >= 2

--19

with cte as (
	select top 5 p.ProductName, sum(od.Quantity) as Quantity, round(sum(od.quantity * od.UnitPrice)/sum(od.quantity),2) as average_price
	from Products as p join [Order Details] as od on od.ProductID = p.ProductID
	group by p.ProductName
	order by sum(od.Quantity) desc),

cte2 as (
	select p.ProductName, c.City, sum(od.Quantity) as Quantity
	from Products as p join [Order Details] as od on od.ProductID = p.ProductID join Orders as o on o.OrderID = od.OrderID join Customers as c on c.CustomerID = o.CustomerID
	group by c.City, p.ProductName),

	
cte3 as (select ProductName, City, rank() over(partition by ProductName order by Quantity desc) as rnk
from cte2)

select a.productName, a.average_price, b.City, a.Quantity
from cte as a join cte3 as b on a.ProductName = b.ProductName
where b.rnk = 1
order by a.Quantity desc

--20 There is no such city
select top 1 c.City, sum(od.Quantity) as total_quantity
from Orders as o join Customers as c on c.CustomerID = o.CustomerID join [Order Details] as od on od.OrderID  = o.OrderID
group by c.City
intersect
select top 1 e.City, count(o.OrderID) as order_num
from employees as e join orders as o on o.EmployeeID = e.EmployeeID
group by e.City

--21
-- Use Union