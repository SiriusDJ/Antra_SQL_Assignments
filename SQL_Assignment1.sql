USE AdventureWorks2019
GO

-- Q1
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

--Q2
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice = 0

--Q3
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL

--Q4
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL and ListPrice>0

--Q5
SELECT Name + ' ' + Color as NameColor
FROM Production.Product
WHERE Color IS NOT NULL

--Q6
SELECT 'NAME: ' + pp.Name + ' -- ' + 'COLOR: ' +  pp.Color [NAME_COLOR]
FROM Production.Product as pp
WHERE pp.Color IS NOT NULL

--Q7
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500


--Q8
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')

--Q9
SELECT *
FROM Production.Product
WHERE Name LIKE 'S%'


--Q10
Select Name, ListPrice
FROM Production.Product
WHERE Name like 'S%' or Name like 'A%'
ORDER BY Name

--Q11
SELECT Name
FROM Production.Product
WHERE Name LIKE 'SPO[^K]%'
ORDER BY Name

--Q12
SELECT DISTINCT ISNULL(ProductSubcategoryID, -1) as ProductSubcatoryID, ISNULL(Color, -1) as Color
FROM Production.Product
