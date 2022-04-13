USE AdventureWorks2019
GO

-- Q1
SELECT pp.ProductID, pp.Name, pp.Color, pp.ListPrice
FROM Production.Product as pp

--Q2
SELECT pp.ProductID, pp.Name, pp.Color, pp.ListPrice
FROM Production.Product as pp
WHERE pp.ListPrice != 0

--Q3
SELECT pp.ProductID, pp.Name, pp.Color, pp.ListPrice
FROM Production.Product as pp
WHERE pp.Color IS NULL

--Q4
SELECT pp.ProductID, pp.Name, pp.Color, pp.ListPrice
FROM Production.Product as pp
WHERE pp.Color IS NOT NULL

--Q5
SELECT pp.ProductID, pp.Name, pp.Color, pp.ListPrice
FROM Production.Product as pp
WHERE pp.Color IS NOT NULL AND ListPrice > 0

--Q6
SELECT 'NAME: ' + pp.Name + ' -- ' + 'COLOR: ' +  pp.Color [NAME_COLOR]
FROM Production.Product as pp
WHERE pp.Color IS NOT NULL

--Q7
 -- Method I : Using LIKE
SELECT 'NAME: ' + pp.Name + ' -- ' + 'COLOR: ' +  pp.Color [NAME_COLOR]
FROM Production.Product as pp
WHERE pp.Name LIKE  '%Crankarm' OR pp.Name LIKE 'Chainring%'
ORDER BY pp.ProductID

 -- Method II : Using BETWEEN
SELECT 'NAME: ' + pp.Name + ' -- ' + 'COLOR: ' +  pp.Color [NAME_COLOR]
FROM Production.Product as pp
WHERE pp.ProductID BETWEEN 317 AND 322

--Q8
SELECT pp.ProductID, pp.Name
FROM Production.Product as pp
WHERE pp.ProductID BETWEEN 400 AND 500

--Q9
 -- Method I : Using IN
SELECT pp.ProductID, pp.Name, pp.Color
FROM Production.Product as pp
WHERE pp.Color IN ('Black', 'Blue')

 -- Method II : Using LIKE
SELECT pp.ProductID, pp.Name, pp.Color
FROM Production.Product as pp
WHERE pp.Color LIKE 'B%'

--Q10
SELECT *
FROM Production.Product as pp
WHERE pp.Name LIKE 'S%'

--Q11
SELECT pp.Name, pp.ListPrice
FROM Production.Product as pp
WHERE pp.Name LIKE 'S%'
ORDER BY pp.Name ASC

--Q12
SELECT pp.Name, pp.ListPrice
FROM Production.Product as pp
WHERE pp.Name LIKE 'S%' OR pp.Name LIKE 'A%'
ORDER BY pp.Name

--Q13
SELECT pp.Name
FROM Production.Product as pp
WHERE pp.Name LIKE 'SPO[^K]%'
ORDER BY pp.Name

--Q14
SELECT DISTINCT pp.Color
FROM Production.Product AS pp
ORDER BY pp.Color DESC

--Q15
SELECT DISTINCT pp.ProductSubcategoryID, pp.Color
FROM Production.Product AS pp
WHERE pp.ProductSubcategoryID IS NOT NULL AND pp.Color IS NOT NULL