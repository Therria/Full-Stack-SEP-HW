USE Northwind
GO

--Q1
SELECT DISTINCT e.City
FROM dbo.Employees e JOIN dbo.Customers c ON e.City = c.City

--Q2
--a : Using subquery
SELECT DISTINCT c.City
FROM dbo.Customers c
WHERE c.City NOT IN (
SELECT DISTINCT e.City
FROM dbo.Employees e)

--b : Not using subquery
-- Method I: using FULL JOIN
SELECT DISTINCT c.City
FROM dbo.Employees e FULL JOIN dbo.Customers c ON e.City = c.City
WHERE e.City IS NULL

--Method II : using EXCEPT
SELECT DISTINCT c.City
FROM dbo.Customers c
EXCEPT
SELECT DISTINCT e.City
FROM dbo.Employees e

--Q3
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) [TotalOrderQuantity]
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY p.ProductID

--Q4
SELECT c.City, SUM(od.Quantity) [TotalProductsNum]
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
ORDER BY c.City

--Q5
--a : Using UNION
SELECT c.City, COUNT(c.CustomerID) [CustomerNum]
FROM dbo.Customers c
GROUP BY c.City
EXCEPT
(SELECT c.City, COUNT(c.CustomerID)
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) = 0
UNION
SELECT c.City, COUNT(c.CustomerID)
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) = 1
)

--b : Using subquery
SELECT c1.City, c1.CustomerNum
FROM (
SELECT c.City, COUNT(c.CustomerID) [CustomerNum]
FROM dbo.Customers c
GROUP BY c.City) c1
WHERE c1.CustomerNum >= 2

--Q6
SELECT c.City, COUNT(od.ProductID) [NumOfProduct]
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) >= 2 

--Q7
SELECT DISTINCT c.CustomerID, c.CompanyName, c.ContactName, c.City, o.ShipCity
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity

--Q8
WITH cityOrderMostCte
AS
( -- table1 for Customer city with max quantity for each product
SELECT t.ProductID, t.City
FROM (SELECT od.ProductID, c.City, RANK() OVER(PARTITION BY od.ProductID ORDER BY SUM(od.Quantity) DESC) RNK
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY od.ProductID, c.City) t
WHERE RNK = 1
)
SELECT pop.ProductID, pop.TotalSale, pop.AvgPrice, cte.City [CityWithMostOrders]
FROM cityOrderMostCte cte JOIN ( -- table2 for 5 most popular products 
SELECT TOP 5 od.ProductID, SUM(od.Quantity) [TotalSale], SUM(od.Quantity * od.UnitPrice) / SUM(od.Quantity) [AvgPrice]
FROM dbo.[Order Details] od
GROUP BY od.ProductID
ORDER BY SUM(od.Quantity) DESC) pop ON cte.ProductID = pop.ProductID
ORDER BY pop.TotalSale DESC 

--Q9
--a : Using subquery
SELECT e.City
FROM dbo.Employees e
WHERE e.City NOT IN (
SELECT c.City
FROM dbo.Customers c
)

--b : Not using subquery
SELECT e.City
FROM dbo.Employees e
EXCEPT
SELECT c.City
FROM dbo.Customers c

--Q10
SELECT t1.City, t1.OrderNum, t2.TotalQuantity
FROM ( -- the city from where the employee sold most orders
SELECT TOP 1 e.city, COUNT(o.OrderID) [OrderNum]
FROM dbo.Employees e JOIN dbo.Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City
) t1 JOIN ( -- the city of most total quantity of products ordered from
SELECT TOP 1 c.City, SUM(od.Quantity) [TotalQuantity]
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
) t2 ON t1.City = t2.City
-- Result set is empty -> the city does not exist

--Q11
-- Using UNION : table UNION table
