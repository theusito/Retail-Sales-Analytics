--turnover
SELECT B.Type_Description, SUM (net_value) AS [FATURAMENTO] FROM Sales A
INNER JOIN Sale_Type B
ON A.Sale_Type = B.Sale_Type
GROUP BY B.Type_Description
ORDER BY FATURAMENTO DESC

--most lucrative product
SELECT P.Product_Name, SUM(PROFIT) AS [LUCRO] FROM Sales S
INNER JOIN Product P
ON S.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY LUCRO DESC

--most lucrative category
SELECT P.Product_Segment, SUM(PROFIT) AS [LUCRO] FROM Sales S
INNER JOIN Product P
ON S.Product_ID = P.Product_ID
GROUP BY P.Product_Segment
ORDER BY LUCRO DESC


--most lucrative month
SELECT Sale_Month,Sale_Year, SUM(PROFIT) AS [LUCRO] FROM Sales
GROUP BY Sale_Month, Sale_Year
ORDER BY LUCRO DESC

--most lucrative year
SELECT Sale_Year, SUM(PROFIT) AS [LUCRO] FROM Sales
GROUP BY Sale_Year
ORDER BY LUCRO DESC

--most lucrative state
SELECT St.State, COUNT(Ticket) AS [TICKETS], SUM(Profit) AS [LUCRO] FROM Sales S
INNER JOIN Store St
ON S.Store_ID = St.Store_ID
GROUP BY St.State
ORDER BY LUCRO DESC

-- Sale by client type
SELECT C.Type_Description, COUNT (TICKET) AS [TICKETS] FROM Sales S
INNER JOIN Customer C
ON S.Customer_Type = C.Customer_Type
GROUP BY C.Type_Description
ORDER BY TICKETS DESC

-- channel type
SELECT Ss.Type_Description, COUNT (TICKET) AS [TICKETS] FROM Sales S
INNER JOIN Sale_Type Ss
ON S.Sale_Type = Ss.Sale_Type
GROUP BY Ss.Type_Description
ORDER BY TICKETS DESC