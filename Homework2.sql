USE AdventureWorks2019
GO

--Q1
SELECT COUNT(*) [ProductNum]
FROM Production.Product pp

--Q2
SELECT COUNT(pp.ProductSubcategoryID) [ProductNumInSubcategory]
FROM Production.Product pp

--Q3
SELECT pp.ProductSubcategoryID , COUNT(PP.ProductSubcategoryID) [CountedProducts]
FROM Production.Product pp
WHERE pp.ProductSubcategoryID IS NOT NULL
GROUP BY pp.ProductSubcategoryID 

--Q4
SELECT COUNT(*) [NumOfNoSubcategory]
FROM Production.Product pp
WHERE pp.ProductSubcategoryID IS NULL

--Q5
SELECT SUM(pv.Quantity) [ProductTotalQuantity]
FROM Production.ProductInventory pv

--Q6 
SELECT pv.ProductID, SUM(pv.Quantity) [TheSum]
FROM Production.ProductInventory pv
WHERE pv.LocationID = 40
GROUP BY pv.ProductID
HAVING SUM(pv.Quantity) < 100

--Q7 
SELECT pv.Shelf, pv.ProductID, SUM(pv.Quantity) [TheSum]
FROM Production.ProductInventory pv
WHERE pv.LocationID = 40
GROUP BY pv.Shelf, pv.ProductID
HAVING SUM(pv.Quantity) < 100

--Q8
SELECT AVG(pv.Quantity) [TheAvg]
FROM Production.ProductInventory pv
WHERE pv.LocationID = 10

--Q9 
SELECT pv.ProductID, pv.Shelf, AVG(pv.Quantity) [TheAvg]
FROM Production.ProductInventory pv
GROUP BY pv.ProductID, pv.Shelf

--Q10
SELECT pv.ProductID, pv.Shelf, AVG(pv.Quantity) [TheAvg]
FROM Production.ProductInventory pv
WHERE pv.Shelf != 'N/A'
GROUP BY pv.ProductID, pv.Shelf

--Q11
--My understanding: TheCount -> The number of products
SELECT pp.Color, pp.Class, COUNT(pp.ProductID) [TheCount], AVG(pp.ListPrice) [TheAvg]
FROM Production.Product pp
WHERE pp.Color IS NOT NULL AND pp.Class IS NOT NULL
GROUP BY PP.Color, PP.Class

--Q12
SELECT pc.Name [Country], ps.Name [Province]
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode   

--Q13
SELECT pc.Name [Country], ps.Name [Province]
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode
WHERE pc.Name IN ('Germany', 'Canada')
ORDER BY pc.Name -- add order by command to make it look nice

-- Q14-Q27
USE Northwind
GO

--Q14
--No need to display all the info of products, I choose only productID, productName
--In last 25 years: 2022 - 25 = 1997, 1997 is not included
SELECT DISTINCT p.ProductID , p.ProductName
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) > 1997 

--Q15
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) [SoldCount]
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL  -- exclude null postal code
GROUP BY o.ShipPostalCode
ORDER BY SoldCount DESC

--Q16
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) [SoldCount]
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND YEAR(o.OrderDate) > 1997
GROUP BY o.ShipPostalCode
ORDER BY SoldCount DESC

--Q17
SELECT c.City, COUNT(c.CustomerID) [CustomerNum]
FROM dbo.Customers c
GROUP BY c.City

--Q18
SELECT c.City, COUNT(c.CustomerID) [CustomerNum]
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2

--Q19 
--Two interpretation of "Customer name" : CompanyName OR ContactName
--customer name = CompanyName 
SELECT DISTINCT c.ContactName
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > 1998-01-01 

--customer name = ContactName
SELECT DISTINCT c.CompanyName
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > 1998-01-01 

--Q20
--Two interpretation of "the most recent order date"
--the most recent order date -> one same date
SELECT c.CompanyName, c.ContactName, o.OrderDate [MostRecentOrderDate]
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate IN (
SELECT MAX(o.OrderDate)
FROM dbo.Orders o)

--the most recent order dates -> each customer's most recent order date
SELECT c.CompanyName, c.ContactName, MAX(o.OrderDate) [MostRecentOrderDates]
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName, c.ContactName
--ORDER BY MostRecentOrderDates DESC

--Q21
SELECT c.CompanyName, c.ContactName, SUM(od.Quantity) [NumOfProduct]
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName, c.ContactName
ORDER BY CompanyName

--Q22
SELECT o.CustomerID, SUM(od.Quantity) [NumOfProduct]
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
GROUP BY o.CustomerID
HAVING SUM(od.Quantity) > 100

--Q23
SELECT DISTINCT su.CompanyName [SupplierCompanyName], sh.CompanyName [ShippingCompanyName] 
FROM dbo.Suppliers su JOIN dbo.Products p ON su.SupplierID = p.SupplierID 
JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID 
JOIN dbo.Orders o ON od.OrderID = o.OrderID 
JOIN dbo.Shippers sh ON o.ShipVia = sh.ShipperID

--Q24
SELECT o.OrderDate, p.ProductName
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON od.OrderID = o.OrderID
ORDER BY o.OrderDate

--Q25
SELECT e1.EmployeeID , e1.FirstName + ' ' + e1.LastName [Emp1NAme], e2.EmployeeID, e2.FirstName + ' ' + e2.LastName [Emp2Name], e1.Title
FROM dbo.Employees e1 JOIN dbo.Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeID != e2.EmployeeID

--Q26
SELECT m.ManagerEmpID, e.FirstName + ' ' + e.LastName [ManagerName], m.NumOfEmpInCharge
FROM (
SELECT e.ReportsTo [ManagerEmpID], COUNT(e.EmployeeID) [NumOfEmpInCharge]
FROM dbo.Employees e
GROUP BY e.ReportsTo) m JOIN dbo.Employees e ON m.ManagerEmpID = e.EmployeeID
WHERE m.NumOfEmpInCharge > 2

--Q27
--Using UNION
SELECT c.City, c.CompanyName [Name], c.ContactName, 'Customer' [Type]
FROM dbo.Customers c
UNION ALL
SELECT s.City, s.CompanyName, s.ContactName, 'Supplier'
FROM dbo.Suppliers s
ORDER BY City