USE PortfolioProject
GO

SELECT TOP 10 *
FROM superstore;

----------------------------------------
-- 1.Remove the time from Ship Date and Order Date

ALTER TABLE superstore 
Add OrderDateOnly Date, ShipDateOnly Date; 

UPDATE superstore  
SET OrderDateOnly = CONVERT(Date, orderdate),
	ShipDateOnly = CONVERT(Date, shipdate);

SELECT TOP 10 *
FROM superstore; 

-- 2. What are the Total Sale and Profit of each year

--The year are grouped by order date so we can see the profit by using GROUP BY. After that we see that there's a steady 
--increase in profit over the years, despite a fall in sales in 2015
SELECT
	YEAR(OrderDateOnly) as Year,
	SUM (Sales) as TotalSales,
	SUM (Profit) as TotalProfit
FROM superstore
GROUP BY YEAR(Orderdateonly)
ORDER BY year

-- 3. What are the Total Sale and Profit per quarter

-- Sales and profit of each quarter per year
SELECT 
  YEAR(OrderDateOnly) AS year, 
  CASE 
    WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN 'Q1'
    WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN 'Q2'
    WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN 'Q3'
    ELSE 'Q4'
  END AS quarter,
  SUM(sales) AS total_sales,
  SUM(profit) AS total_profit
FROM superstore
GROUP BY  
YEAR(OrderDateOnly), 
  CASE 
    WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN 'Q1'
    WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN 'Q2'
    WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN 'Q3'
    ELSE 'Q4'
  END
ORDER BY year, quarter;



/*The data above shows that the period of October, November and December are our best selling months 
and our months where we bring in the most profit. 
Just by seeing this table, we can develop operation strategies pretty nicely as there is a clear buildup like 
a stock market rally from January to December then it dumps around the first 3 months. Let’s get into the regions. */

--4. What region generate the most profit?

SELECT Region, SUM(sales) AS TotalSales, SUM(profit) AS TotalProfit
FROM superstore
GROUP BY Region
ORDER BY TotalProfit DESC

-- Profit margin
SELECT Region, (SUM(Profit)/SUM(Sales)*100) AS ProfitMargin
FROM superstore
GROUP BY Region
ORDER BY ProfitMargin DESC

-- 5. What state and city brings in the highest sales and profits ?

-- state
SELECT TOP 10 
	State, SUM(sales) AS TotalSales, SUM(profit) AS TotalProfit, (SUM(Profit)/SUM(Sales)*100) AS ProfitMargin
FROM superstore
GROUP BY State
ORDER BY TotalProfit DESC

/*The decision was to include profit margins to see this under a different lens. 
The data shows the top 10 most profitable states. Besides we can see the total sales and profit margins. 
Profit margins are important and it allows us to mostly think long-term as an investor to see potential big markets. 
In terms of profits, California, New York and Washington are our most profitable markets and most present ones 
especially in terms of sales. Which, are so high that it would take so much for the profit margins to be higher. 
However the profits are great and the total sales show that we have the best part of our business share at 
those points so we need to boost our resources and customer service in those top states. */

-- city
SELECT TOP 10 
	City, SUM(sales) AS TotalSales, SUM(profit) AS TotalProfit, (SUM(Profit)/SUM(Sales)*100) AS ProfitMargin
FROM superstore
GROUP BY City
ORDER BY TotalProfit DESC

/* The top 3 cities that we should focus on are New York City, Los Angeles and Seattle.*/

-- 6. The relationship between discount and sales and the total discount per category
SELECT Discount, AVG(Sales) AS Avg_Sales
FROM superstore
GROUP BY Discount
ORDER BY Discount;

/* Then graph the table in excel, showing no correlation
They almost have no linear relationship. This noted by the correlation coefficient of -0.3 and the shape of the graph. 
However we can at least observe that at a 50% discount, our average sales are the highest it can be. 
Maybe it is a psychology technique or it’s just the right product category that is discounted.
*/

--Total discount per product category
SELECT Category, SUM(discount) AS total_discount
FROM superstore
GROUP BY CATEGORY
ORDER BY total_discount DESC;

/* So Office supplies are the most discounted items followed by Furniture and Technology. 
We will later dive in into how much profit and sales each generate. 
Before that, let’s zoom in the category section to see exactly what type of products are the most discounted.
*/

SELECT category, subcategory, ROUND(SUM(discount),2) AS total_discount
FROM superstore
GROUP BY category, subcategory
ORDER BY total_discount DESC;

/* Binders, Phones and Furnishings are the most discounted items. 
But the gap between binders and the others are drastic. 
We should check the sales and profits for the binders and other items on the list. 
But first let’s move on to the categories per state.*/

-- 7. What category generates the highest sales and profits in each region and state ?
SELECT category, SUM(sales) AS total_sales, SUM(profit) AS total_profit, 
	ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;

/* Out of the 3, it is clear that Technology and Office Supplies are the best in terms of profits. 
Plus they seem like a good investment because of their profit margins. 
Furnitures are still making profits but do not convert well in overall. 
Let’s observe the highest total sales and total profits per Category in each region*/

SELECT region, category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY region, category
ORDER BY total_profit DESC;

/* These are best categories in terms of total profits in each region. 
The West is in top 3 twice with Office Supplies and Technology and the East with Technology. 
Among the total profits, the company is operating at a loss in Central Region with Furniture. */

SELECT TOP 20
	state, category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY state, category
ORDER BY total_profit DESC;

-- 8. What subcategory generates the highest sales and profits in each region and state ?
SELECT SubCategory, SUM(sales) as total_sales, SUM(profit) as total_profit, 
		ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin
FROM superstore
GROUP BY SubCategory
ORDER BY total_profit DESC;

/*Our biggest profit comes from Copiers, Phones, Accessories, and Papers. The profit margin on Copiers and Papers 
are especially high, and we can focus on product on these subcategories to generate better profits. 
Our losses came from Supplies, Bookcases, and Tables and so as their profit margins.*/

SELECT TOP 15
	Region, SubCategory, SUM(sales) as total_sales, SUM(profit) as total_profit
FROM superstore
GROUP BY region, SubCategory
ORDER BY total_profit DESC;

/* Copiers has highest profit from West and East Region */

SELECT TOP 15
	State, SubCategory, SUM(sales) as total_sales, SUM(profit) as total_profit
FROM superstore
GROUP BY state, SubCategory
ORDER BY total_profit DESC;

/*Machines, Phones, and Binders generate the most profit in New York state. 
Followed by Accessories and Binders in California and Michigan. */

-- 9. What segments that makes most of our profits and sales
SELECT Segment, SUM(sales) as total_sales, SUM(profit) as total_profits
FROM superstore
GROUP BY Segment
ORDER BY total_profits DESC;

/*The consumer segment brings in the most profit, followed by Corporate then Home Office*/

-- 10. How many customer do we have in total, and how much per region and state
SELECT COUNT(DISTINCT customerid) as total_customers
FROM superstore;

/* We have 793 customers between 2014 and 2017 in total */

SELECT region, COUNT(DISTINCT customerid) as total_customers 
FROM superstore
GROUP BY Region
ORDER BY total_customers DESC;

/* Because the customers moved around between regions, the number would not add up to 793. 
The West region have the biggest number of customer in total. */

SELECT State, COUNT(DISTINCT customerid) as total_customers 
FROM superstore
GROUP BY State
ORDER BY total_customers DESC;

/* Even though West region has the most customers, California 
is the leading states in number of customers, followed by New York and Texas.*/ 

-- 12. Average shipping time
SELECT AVG(DATEDIFF(DAY, OrderDateOnly, ShipDateOnly)) AS avg_shipping_time
FROM superstore;

/* the average shipping time is 3 days for all orders */

SELECT ShipMode, AVG(DATEDIFF(DAY, OrderDateOnly, ShipDateOnly)) AS avg_shipping_time
FROM superstore
GROUP BY ShipMode
ORDER BY avg_shipping_time;

SELECT name AS data_base FROM sys.databases; -- check for data base
SELECT @@SERVERNAME AS ServerName; -- check for server name