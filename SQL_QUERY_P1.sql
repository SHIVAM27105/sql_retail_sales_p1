-- START OF SQL_PROJECT_P1

-- TABLE CREATION

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
    transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM sales;

-- DELETING NULL VALUED ROWS
 
 DELETE FROM sales WHERE
 transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL;

 -- PRELIMINARY QUESTIONS...

 --How many total sales have been there?
 SELECT COUNT(*) AS TOTALSALES FROM sales;
 -- ANSWER=1987

 --HOW MANY UNIQUE CUSTOMERS ARE THERE?
 SELECT COUNT(DISTINCT customer_id) AS CUSTOMERS FROM sales;
 -- ANSWER=155
 
-- HOW MANY UNIQUE CATEGORIES ARE THERE?
 SELECT DISTINCT category AS CATEGORIES FROM sales;
 

 -- KEY BUSINESS PROBLEMS AND ANSWERS/DATA ANALYSIS...
 

 -- Write a SQL query to retrieve all columns for sales made on '2022-11-05.
 SELECT * FROM sales WHERE sale_date = '2022-11-05' ORDER BY sale_time ASC;

 -- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
 SELECT * FROM sales WHERE category = 'Clothing' AND TO_CHAR(sale_date,'YYYY') = '2022' AND quantiy >=4;

 -- Write a SQL query to calculate the total sales (total_sale) for each category
 SELECT category, SUM(total_sale) AS NET_SALE, COUNT(*) AS TOTAL_ORDERS FROM sales GROUP BY 1;

 -- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 SELECT ROUND(AVG(age),2) AS AVG_BEAUTY_AGE FROM sales WHERE category = 'Beauty';

 -- Write a SQL query to find all transactions where the total_sale is greater than 1000.
 SELECT * FROM sales WHERE total_sale > 1000 ORDER BY total_sale ASC;

 -- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
 SELECT gender, category, COUNT(*) FROM sales GROUP BY gender, category ORDER BY 2;

 -- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
 SELECT YEAR,MONTH,AVG_SALES FROM (
 SELECT 
 EXTRACT(YEAR FROM sale_date) as YEAR,
 EXTRACT(MONTH FROM sale_date) as MONTH,
 AVG(total_sale) AS AVG_SALES,
 RANK() OVER(PARTITION BY  EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
 FROM sales 
 GROUP BY 1,2
 ) AS T1
 WHERE RANK=1;
 -- ORDER BY 1,3 DESC;

 -- Write a SQL query to find the top 5 customers based on the highest total sales.
 SELECT customer_id, SUM(total_sale) AS TOTAL_SALES FROM sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5;

 -- Write a SQL query to find the number of unique customers who purchased items from each category.
 SELECT category, COUNT(DISTINCT customer_id) FROM sales GROUP BY 1 ORDER BY 2 ASC;

 -- Write a SQL query to create each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening >17)

 WITH hourly_sale AS(
 SELECT *,
 CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE'EVENING'
END AS shift
FROM sales
)
SELECT shift, COUNT(*) AS TOTAL_ORDERS FROM hourly_sale GROUP BY 1 ORDER BY 2;


-- END OF PROJECT