1.
SELECT COUNT(ProductID) AS "Number of Products" FROM Production.Product;

2.	
SELECT COUNT(ProductID) AS "Number of Products in A Category" 
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NOT NULL;

3.	
SELECT ProductSubcategoryID, COUNT(ProductID) AS " CountedProducts" 
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

4.
SELECT COUNT(ProductID) AS "Number of Products Not in A Category" 
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NULL;

5.
SELECT SUM(Quantity) AS 'Summary of Products' 
FROM Production.ProductInventory
GROUP BY ProductID;


6.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID =40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

7.
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID =40
GROUP BY ProductID, Shelf
HAVING SUM(Quantity) < 100;

8.
SELECT ProductID, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID;

9.
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID,Shelf;

10.
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
	FROM Production.ProductInventory
	WHERE Shelf <> 'N/A'
	GROUP BY ProductID, Shelf;

11.	
SELECT Color, Class, Count(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;

Joins:
12.	  
SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode;

13.
SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode
	WHERE c.Name NOT IN ('Germany', 'Canada');	

Using Northwnd Database: (Use aliases for all the Joins)
14.	
SELECT DISTINCT p.ProductID, p.ProductName
	FROM Orders o
	JOIN
	[Order Details] od
	ON o.OrderID =  od.OrderID
	JOIN 
	Products p
	ON od.ProductID = p.ProductID
	WHERE DATEDIFF(year, o.OrderDate, GETDATE())< 25;

15.	
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) as qty FROM 
	Orders o
	JOIN
	[Order Details] od
	ON o.OrderID =  od.OrderID
	WHERE o.ShipPostalCode IS NOT NULL
	GROUP BY ShipPostalCode
	ORDER BY qty DESC;

16.	
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) as qty FROM 
	Orders o
	JOIN
	[Order Details] od
	ON o.OrderID =  od.OrderID
	WHERE o.ShipPostalCode IS NOT NULL 
		AND DATEDIFF(year, o.OrderDate, GETDATE())< 25
	GROUP BY ShipPostalCode
	ORDER BY qty DESC;

17.
select City, count(customerID) as NumOfCustomer
from customers
group by City

18.
select City, count(customerID) as NumOfCustomer
from customers
group by City
having  count(customerID)>2



19.
SELECT DISTINCT c.CustomerID, c.CompanyName, c.ContactName FROM 
	Orders o
	INNER JOIN 
	Customers c
	ON o.CustomerID = c.CustomerID
	WHERE OrderDate > '1998-1-1';

20.
SELECT c.ContactName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerId = o.CustomerId
GROUP BY c.ContactName

21.
SELECT c.CustomerID, c.CompanyName, c.ContactName, 
SUM(od.Quantity) AS QTY FROM 
Customers c 
LEFT JOIN 
Orders o 
ON c.CustomerID = o.CustomerID
LEFT JOIN 
[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName, c.ContactName
ORDER BY QTY;

22
SELECT c.CustomerID,
SUM(od.Quantity) AS QTY FROM 
Customers c 
LEFT JOIN 
Orders o 
ON c.CustomerID = o.CustomerID
LEFT JOIN 
[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100
ORDER BY QTY;

23.
SELECT sup.CompanyName, ship.CompanyName
FROM Suppliers sup CROSS JOIN Shippers ship
Order By 2, 1

24.	
SELECT o.OrderDate, p.ProductName FROM 
Orders o
LEFT JOIN
[Order Details] od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName
ORDER BY o.OrderDate;

25.
(1)	
SELECT Title, LastName + ' ' + FirstName AS Name 
FROM Employees
ORDER BY Title;

(2)
SELECT e1.Title, e1.LastName + ' ' + e1.FirstName AS Name1, e2.LastName + ' ' + e2.FirstName AS Name2 
FROM Employees e1
JOIN 
Employees e2
ON e1.Title = e2.Title 
WHERE e1.FirstName <> e2.FirstName OR e1.LastName <>        e2.LastName
ORDER BY Title;

26.
SELECT T1.EmployeeId, T1.LastName, T1.FirstName,T2.ReportsTo, COUNT(T2.ReportsTo) AS Subordinate  
FROM Employees T1 JOIN Employees T2 ON T1.EmployeeId = T2.ReportsTo
WHERE T2.ReportsTo IS NOT NULL
GROUP BY T1.EmployeeId, T1.LastName, T1.FirstName,T2.ReportsTo
HAVING COUNT(T2.ReportsTo) > 2

27.
SELECT c.City, c.CompanyName, c.ContactName, 'Customer' as Type
FROM Customers c
UNION
SELECT s.City, s.CompanyName, s.ContactName, 'Supplier' as Type
FROM Suppliers s;


