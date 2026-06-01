SELECT TOP 100 *
FROM base_dados;

--Store
CREATE TABLE Store (
    Store_ID INT IDENTITY(1,1) PRIMARY KEY,
    Store_Name VARCHAR(100),
	City VARCHAR(100),
	State VARCHAR(100),
);

INSERT INTO Store 
(Store_Name, City, State)

SELECT DISTINCT 
Store_Name, City, State 
FROM base_dados_portfolio_dados

SELECT * FROM Store

--Payment_Type
CREATE TABLE Payment_Type (
    Payment_Type INT IDENTITY(1,1) PRIMARY KEY,
    Payment_Description VARCHAR(100),
);

INSERT INTO Payment_Type 
(Payment_Description)

SELECT DISTINCT 
Payment_Description
FROM base_dados_portfolio_dados

SELECT * FROM Payment_Type

--Sale_Type
CREATE TABLE Sale_Type (
    Sale_Type INT IDENTITY(1,1) PRIMARY KEY,
    Type_Description VARCHAR(100),
);

INSERT INTO Sale_Type 
(Type_Description)

SELECT DISTINCT 
sales_channel
FROM base_dados_portfolio_dados

SELECT * FROM Sale_Type

--Product
CREATE TABLE Product (
    Product_ID INT IDENTITY(1,1) PRIMARY KEY,
    Product_Name VARCHAR(100),
	Product_Segment VARCHAR(50),
	Product_Type VARCHAR(50),
	Product_Supplier VARCHAR(100),
	Unit_Cost DECIMAL(10,2),
	Unit_Price DECIMAL(10,2),
);

SET IDENTITY_INSERT Product off

INSERT INTO Product 
(Product_ID,Product_Name, Product_Segment, Product_Type, Product_Supplier, Unit_Cost, Unit_Price )

SELECT DISTINCT 
Product_ID,
Product_Name, Segment, Product_Type, Supplier, Unit_Cost, Unit_Price
FROM base_dados_portfolio_dados

SELECT * FROM Product

-- Customer
CREATE TABLE Customer (
    Client_Type INT IDENTITY(1,1) PRIMARY KEY,
    Type_Description VARCHAR(100),
);

INSERT INTO Customer 
(Type_Description)

SELECT DISTINCT customer_type
FROM base_dados_portfolio_dados

SELECT * FROM Customer

exec sp_rename 'Customer.Client_Type', 'Customer_Type', 'COLUMN';

--SALES
CREATE TABLE Sales (
	TICKET INT IDENTITY (1,1) PRIMARY KEY,
	Product_ID INT,
	Store_ID INT,
	Customer_Type INT,
	Payment_Type INT,
	Sale_Type INT,
	Quantity INT,
	Unit_Cost DECIMAL(10,2),
	Unit_Price DECIMAL(10,2),
	Gross_Value DECIMAL(10,2),
	Discount_Percentage DECIMAL(10,2),
	Discount_Value DECIMAL(10,2),
	Net_value DECIMAL(10,2),
	Profit DECIMAL(10,2),
	Margin_Percentage DECIMAL(10,2)
	)

INSERT INTO Sales 
(	TICKET, Product_ID, Store_ID, Customer_Type, Payment_Type, Sale_Type, Quantity, Unit_Cost, Unit_Price, 
	Gross_Value, Discount_Percentage, Discount_Value, Net_value, Profit, Margin_Percentage)

SELECT	A.Ticket_ID, P.Product_ID, S.Store_ID, C.Client_Type, Pt.Payment_Type, St.Sale_Type, A.Quantity,
		A.Unit_Cost, A.Unit_Price, A.Gross_Value,
		CASE 
			WHEN A.Gross_Value = 0 THEN 0
			ELSE ROUND (
			(A.DISCOUNT_VALUE / A.GROSS_VALUE) * 100,
				2
				)
		END AS Discount_Percentage, 
		A.Discount_Value,
		A.Net_value,
		ROUND(
			A.Net_value - (A.Quantity * A.Unity_Cost), 
				2
			) AS Profit,
		CASE
			WHEN A.Net_Value = 0 THEN 0
			ELSE ROUND(
				(
					(
						A.Net_Value - (A.Quantity * A.Unit_Cost)
					) / A.Net_Value
				) * 100,
				2
			)
		END AS Margin_Percentage
FROM BASE_DADOS A
INNER JOIN Product P
ON A.Product_Id = P.Product_ID
INNER JOIN Store S
ON A.Store_Name = S.Store_Name
INNER JOIN Customer C
ON A.Customer_type = C.Type_Description
INNER JOIN Payment_Type Pt
ON A.Payment_Method = Pt.Payment_Description
INNER JOIN Sale_Type St
ON A.Sales_Chanel = St.Type_Description


--
Ajuste em valores de centavos 

SELECT TOP 100
    Unit_Cost,
    Unit_Cost / 100.0 AS Novo_Unit_Cost,

    Unit_Price,
    Unit_Price / 100.0 AS Novo_Unit_Price,

    Gross_Value,
    Gross_Value / 100.0 AS Novo_Gross_Value,

    Discount_Value,
    Discount_Value / 100.0 AS Novo_Discount_Value,

    Net_Value,
    Net_Value / 100.0 AS Novo_Net_Value

FROM BASE_DADOS;

SELECT TOP 100
    Unit_Cost,
    Unit_Cost / 100.0 AS Novo_Unit_Cost,

    Unit_Price,
    Unit_Price / 100.0 AS Novo_Unit_Price,

    Gross_Value,
    Gross_Value / 100.0 AS Novo_Gross_Value,

    Discount_Value,
    Discount_Value / 100.0 AS Novo_Discount_Value,

    Net_Value,
    Net_Value / 100.0 AS Novo_Net_Value

FROM BASE_DADOS;

UPDATE BASE_DADOS
SET

    Unit_Cost = Unit_Cost / 100.0,

    Unit_Price = Unit_Price / 100.0,

    Gross_Value = Gross_Value / 100.0,

    Discount_Value = Discount_Value / 100.0,

    Net_Value = Net_Value / 100.0;
	
	
-- AJUSTE DE SALES POR CONTA DE GRANULARIDADE

DROP TABLE Sales

CREATE TABLE Sales (
	Sale_ID INT IDENTITY (1,1) PRIMARY KEY,
	Ticket INT,
	Product_ID INT,
	Store_ID INT,
	Customer_Type INT,
	Payment_Type INT,
	Sale_Type INT,
	Quantity INT,
	Unit_Cost DECIMAL(10,2),
	Unit_Price DECIMAL(10,2),
	Gross_Value DECIMAL(10,2),
	Discount_Percentage DECIMAL(10,2),
	Discount_Value DECIMAL(10,2),
	Net_value DECIMAL(10,2),
	Profit DECIMAL(10,2),
	Margin_Percentage DECIMAL(10,2)
	)
	
--SALES
CREATE TABLE Sales (
	Sale_ID INT IDENTITY (1,1) PRIMARY KEY,
	Ticket INT,
	Product_ID INT,
	Store_ID INT,
	Customer_Type INT,
	Payment_Type INT,
	Sale_Type INT,
	Quantity INT,
	Unit_Cost DECIMAL(10,2),
	Unit_Price DECIMAL(10,2),
	Gross_Value DECIMAL(10,2),
	Discount_Percentage DECIMAL(10,2),
	Discount_Value DECIMAL(10,2),
	Net_value DECIMAL(10,2),
	Profit DECIMAL(10,2),
	Margin_Percentage DECIMAL(10,2)
	)

SET IDENTITY_INSERT Sales on

INSERT INTO Sales 
(	TICKET, Product_ID, Store_ID, Customer_Type, Payment_Type, Sale_Type, Quantity, Unit_Cost, Unit_Price, 
	Gross_Value, Discount_Percentage, Discount_Value, Net_value, Profit, Margin_Percentage)

SELECT
	CAST(REPLACE(A.Ticket_ID, 'TKT', '') AS INT) AS TICKET,
	P.Product_ID, S.Store_ID, C.Customer_Type, Pt.Payment_Type, St.Sale_Type, A.Quantity,
		A.Unit_Cost, A.Unit_Price, A.Gross_Value,
		CASE 
			WHEN A.Gross_Value = 0 THEN 0
			ELSE ROUND (
			(A.DISCOUNT_VALUE / A.GROSS_VALUE) * 100,
				2
				)
		END AS Discount_Percentage, 
		A.Discount_Value,
		A.Net_value,
		ROUND(
			A.Net_value - (A.Quantity * A.unit_cost), 
				2
			) AS Profit,
		CASE
			WHEN A.Net_Value = 0 THEN 0
			ELSE ROUND(
				(
					(
						A.Net_Value - (A.Quantity * A.Unit_Cost)
					) / A.Net_Value
				) * 100,
				2
			)
		END AS Margin_Percentage
FROM BASE_DADOS A
INNER JOIN Product P
ON A.Product_Id = P.Product_ID
INNER JOIN Store S
ON A.Store_Name = S.Store_Name
INNER JOIN Customer C
ON A.Customer_type = C.Type_Description
INNER JOIN Payment_Type Pt
ON A.Payment_Method = Pt.Payment_Description
INNER JOIN Sale_Type St
ON A.sales_channel = St.Type_Description

SELECT TOP 100 * FROM Sales

--ajuste para conter datas
CREATE TABLE Sales (
	Sale_ID INT IDENTITY (1,1) PRIMARY KEY,
	Ticket INT,
	Sale_Date DATETIME,
	Sale_Year INT,
	Sale_Month TINYINT,
	Product_ID INT,
	Store_ID INT,
	Customer_Type INT,
	Payment_Type INT,
	Sale_Type INT,
	Quantity INT,
	Unit_Cost DECIMAL(10,2),
	Unit_Price DECIMAL(10,2),
	Gross_Value DECIMAL(10,2),
	Discount_Percentage DECIMAL(10,2),
	Discount_Value DECIMAL(10,2),
	Net_value DECIMAL(10,2),
	Profit DECIMAL(10,2),
	Margin_Percentage DECIMAL(10,2)
	)

SET IDENTITY_INSERT Sales on

INSERT INTO Sales 
(	TICKET, Sale_Date, Sale_Year,Sale_Month, Product_ID, Store_ID, Customer_Type, Payment_Type, Sale_Type, Quantity, Unit_Cost, Unit_Price, 
	Gross_Value, Discount_Percentage, Discount_Value, Net_value, Profit, Margin_Percentage)

SELECT
	CAST(REPLACE(A.Ticket_ID, 'TKT', '') AS INT) AS TICKET,
	A.sale_date,A.year, A.month,
	P.Product_ID, S.Store_ID, C.Customer_Type, Pt.Payment_Type, St.Sale_Type, A.Quantity,
		A.Unit_Cost, A.Unit_Price, A.Gross_Value,
		CASE 
			WHEN A.Gross_Value = 0 THEN 0
			ELSE ROUND (
			(A.DISCOUNT_VALUE / A.GROSS_VALUE) * 100,
				2
				)
		END AS Discount_Percentage, 
		A.Discount_Value,
		A.Net_value,
		ROUND(
			A.Net_value - (A.Quantity * A.unit_cost), 
				2
			) AS Profit,
		CASE
			WHEN A.Net_Value = 0 THEN 0
			ELSE ROUND(
				(
					(
						A.Net_Value - (A.Quantity * A.Unit_Cost)
					) / A.Net_Value
				) * 100,
				2
			)
		END AS Margin_Percentage
FROM BASE_DADOS A
INNER JOIN Product P
ON A.Product_Id = P.Product_ID
INNER JOIN Store S
ON A.Store_Name = S.Store_Name
INNER JOIN Customer C
ON A.Customer_type = C.Type_Description
INNER JOIN Payment_Type Pt
ON A.Payment_Method = Pt.Payment_Description
INNER JOIN Sale_Type St
ON A.sales_channel = St.Type_Description