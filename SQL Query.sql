SELECT *
FROM pg_stat_activity;

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'walmart'
	AND leader_pid IS NULL;
-----------------------------------------------
Analysis List
1.Product Analysis
Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

2.Sales Analysis
This analysis aims to answer the question of the sales trends of product. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.

3.Customer Analysis
This analysis aims to uncover the different customers segments, purchase trends and the profitability of each customer segment.;

-----------------------------------------------
--Data Wrangling, This was done on python, fixing data types and data types;
SELECT column_name FROM information_schema.columns WHERE table_name = 'sales_data';
-----------------------------------------------
--Feature Engineering
--Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.;

SELECT
	"Time",
	CASE
		WHEN "Time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN "Time" BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales_data
SET time_of_day = (
	CASE
		WHEN "Time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN "Time" BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
END
);

--
SELECT
	"Date",
	TO_CHAR("Date"::date,'day') AS day_name
FROM sales_data;

SELECT
	"Date",
	TO_CHAR("Date"::date,'month') AS month_name
FROM sales_data;


ALTER TABLE sales_data ADD COLUMN day_name VARCHAR(20);
ALTER TABLE sales_data ADD COLUMN month_name VARCHAR(20);

UPDATE sales_data
SET day_name = (
	TO_CHAR("Date"::date,'day')
);

UPDATE sales_data
SET month_name = (
	TO_CHAR("Date"::date,'month')
);


SELECT * FROM sales_data;
-----------------------------------------------	
--Generic Question
--1.How many unique cities does the data have?

SELECT  DISTINCT "City","Branch"
FROM sales_data;

--2.In which city is each branch?

SELECT  
DISTINCT "City",
"Branch"
FROM sales_data;

---------------------------------------------
--PRODUCT

--1.How many unique product lines does the data have?

SELECT
DISTINCT "Product line"
FROM sales_data;

SELECT
COUNT(DISTINCT "Product line")
FROM sales_data;

--2.What is the most common payment method?

SELECT
DISTINCT "Payment"
FROM sales_data;

SELECT
	SUM("Quantity") AS qty,
	"Payment"
FROM sales_data
GROUP BY "Payment"
ORDER BY qty DESC;

--What is the most selling product line?

SELECT
	COUNT("Product line") as pd,
	"Product line"
FROM sales_data
GROUP BY "Product line"
ORDER BY pd DESC;
--What is the total revenue by month?
SELECT * FROM sales_data;

SELECT
	SUM("gross income") AS gi,
	month_name
FROM sales_data
GROUP BY month_name;

SELECT 
DISTINCT month_name
FROM sales_data;

--What month had the largest COGS?
SELECT 
	SUM("cogs") as cg,
	month_name
FROM sales_data
GROUP BY month_name
ORDER BY cg DESC;
	
--What product line had the largest revenue?
SELECT SUM("gross income") AS gi,
"Product line"
FROM sales_data
GROUP BY "Product line"
ORDER BY gi DESC;
	
--What is the city with the largest revenue?

SELECT
	SUM("gross income") AS gi,
	"City"
FROM sales_data
GROUP BY "City"
ORDER BY gi DESC;

--What product line had the largest VAT?
SELECT * FROM sales_data;

SELECT 
	SUM("Tax 5%") AS VAT,
	"Product line"
FROM sales_data
GROUP BY "Product line"
ORDER BY VAT DESC;

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT * FROM sales_data;

SELECT
	"Product line",
	AVG("Quantity") AS qnty,
	CASE
		WHEN AVG("Quantity") > (SELECT AVG("Quantity") FROM sales_data) THEN 'Good'
		ELSE 'BAD'
	END AS remark
FROM sales_data
GROUP BY ("Product line");


--Which branch sold more products than average product sold?

SELECT * FROM sales_data;

SELECT
	"Branch",
	CASE
	WHEN AVG("Quantity") > (SELECT AVG("Quantity") FROM sales_data) THEN 'More'
	ELSE 'Less'
	END AS remark
FROM sales_data
GROUP BY "Branch";

SELECT 
	"Branch", 
    SUM("Quantity") AS qnty
FROM sales_data
GROUP BY "Branch"
HAVING SUM("Quantity") > (SELECT AVG("Quantity") FROM sales_data);

SELECT AVG("Quantity") as qnty FROM sales_data;


--What is the most common product line by gender?

SELECT * FROM sales_data;

SELECT
	"Gender",
	"Product line",
	COUNT("Gender") AS gt
FROM sales_data
GROUP BY "Gender", "Product line";


--What is the average rating of each product line?


SELECT
	"Product line",
	AVG("Rating") AS Rating
FROM sales_data
GROUP BY "Product line";

----------------------------
--Sales
--Number of sales made in each time of the day per weekday

SELECT * FROM sales_data;

SELECT
	"Date"
,	TO_CHAR("Date"::date,'day') AS day_name
FROM sales_data;


SELECT
	time_of_day
,	day_name
,	SUM("gross income") AS gi
FROM sales_data
GROUP BY time_of_day,day_name
ORDER BY time_of_day DESC;
	 

--Which of the customer types brings the most revenue?

SELECT
	"Customer type"
,	SUM("gross income") AS gi
FROM sales_data
GROUP BY "Customer type"
ORDER BY gi DESC;

--Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
	"City",
    ROUND(AVG("Tax 5%"), 2) AS avg_tax_pct
FROM sales_data
GROUP BY "City"
ORDER BY avg_tax_pct DESC;

SELECT
    "City",
    ROUND(AVG("Tax 5%"), 2) AS avg_tax_pct
FROM sales_data
GROUP BY "City"
ORDER BY avg_tax_pct DESC;

SELECT
    "City",
    ROUND(CAST(AVG("Tax 5%") AS numeric), 2) AS avg_tax_pct
FROM sales_data
GROUP BY "City"
ORDER BY avg_tax_pct DESC;

--Which customer type pays the most in VAT?;

--------------------------------
--Customer
--How many unique customer types does the data have?
--How many unique payment methods does the data have?
--What is the most common customer type?
--Which customer type buys the most?
--What is the gender of most of the customers?
--What is the gender distribution per branch?
--Which time of the day do customers give most ratings?
--Which time of the day do customers give most ratings per branch?
--Which day fo the week has the best avg ratings?
--Which day of the week has the best average ratings per branch?;

