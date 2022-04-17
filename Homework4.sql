USE Northwind
GO

--Q1
CREATE VIEW view_product_order_li
AS
SELECT p.ProductID,p.ProductName, SUM(od.Quantity) [TotalQuantity]
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID,p.ProductName

--for testing : display view table
SELECT *
FROM view_product_order_li
order by ProductID

--Q2
CREATE PROC sp_product_order_quantity_li
@id INT,
@quantity INT OUT
AS
BEGIN
SELECT @quantity = TotalQuantity
FROM view_product_order_li
WHERE @id = ProductID
END

--for testing : get total quantity of productId = 3
BEGIN
DECLARE @quan INT
EXEC sp_product_order_quantity_li 3, @quan out
PRINT @quan
END

-- Drop view created from Q1
DROP VIEW view_product_order_li

-- Drop sp
DROP PROC sp_product_order_quantity_li

--Q3
CREATE PROC sp_product_order_city_li
@name NVARCHAR(40)
AS
BEGIN
SELECT TOP 5 ct.City, ct.TotalQuantity
FROM (
SELECT c.City, p.ProductName, SUM(od.Quantity) [TotalQuantity]
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID 
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID 
JOIN dbo.Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = @name
GROUP BY c.City, p.ProductName) ct
ORDER BY ct.TotalQuantity DESC
END

--for testing : input City = 'Chai'
EXEC sp_product_order_city_li 'Chai'

--Drop sp
DROP PROC sp_product_order_city_li

--Q4
--Step1 : Creating tables and insert values
CREATE TABLE city_li(
Id INT PRIMARY KEY IDENTITY(1, 1),
City VARCHAR(20) NOT NULL
)

INSERT INTO city_li VALUES('Seattle')
INSERT INTO city_li VALUES('Green Bay')

CREATE TABLE people_li(
Id INT PRIMARY KEY IDENTITY(1, 1),
Name VARCHAR(40) NOT NULL,
City INT FOREIGN KEY REFERENCES city_li(Id) ON DELETE SET NULL
)

INSERT INTO people_li VALUES('Aaron Rodgers', 2)
INSERT INTO people_li VALUES('Russell Wilson', 1)
INSERT INTO people_li VALUES('Jody Nelson', 2)

--Step 2 : create trigger for replacement when DELETE
-- OR if this replacement is just a onr time thing : not using trigger -> just move the trigger statement between BEGIN and END below DELETE command
CREATE TRIGGER trgdelete 
ON city_li
AFTER DELETE AS
BEGIN
INSERT INTO city_li VALUES('Madision')
UPDATE p
SET City = c.Id
FROM people_li p, city_li c
WHERE p.City IS NULL AND c.City = 'Madision'
END

DELETE FROM city_li
WHERE City = 'Seattle'

-- Create View
CREATE VIEW Packers_li
AS
SELECT p.Id, p.Name
FROM people_li p JOIN city_li c ON p.City = c.Id
WHERE c.City = 'Green Bay'

--for testing : display view table
SELECT *
FROM Packers_li

--Drop view created from Q5
DROP VIEW Packers_li

--Drop tables
DROP TABLE people_li
DROP TABLE city_li

--Drop trigger
IF OBJECT_ID ('trgdelete', 'TR') IS NOT NULL
	DROP TRIGGER trgdelete

--Q5
CREATE PROC sp_birthday_employees_li
AS
BEGIN
SELECT * INTO birthday_employees_li
FROM dbo.Employees e
WHERE MONTH(e.BirthDate) = 2
END

--for testing : display birthday_employees_li table
EXEC sp_birthday_employees_li

SELECT *
FROM birthday_employees_li

-- drop table
DROP PROC sp_birthday_employees_li
DROP TABLE birthday_employees_li


--Q6
-- Using SET perations: UNION, EXCEPT, INTERSECT
-- UNION two tables then COUNT(*) from union table and either two given table. If the numbers of row are the same, then they have same data.
-- EXCEPT two tables twice with exchanged order(t1 EXCEPT t2, t2 EXCEPT t1). If there is no rows in both result sets, then they have same data.
-- INTERSECT two tables then COUNT(*) from intersect table and either two given table. If the numbers of row are the same, then they have same data.
