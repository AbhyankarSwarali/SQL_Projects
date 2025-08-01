create database retail_sales_analysis;
use retail_sales_analysis;
 
create table retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int ,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

select * from retail_sales;

-- DATA CLEANING
select * from retail_sales 
where 
	transactions_id is null 
    or sale_date is null 
    or sale_time is null 
    or customer_id is null 
    or gender is null 
    or age is null 
    or category is null 
    or quantiy is null
	or price_per_unit is null 
    or cogs is null 
    or total_sale is null;

alter table retail_sales change quantiy quantity int;

-- if there exists any null values you can either delete it or replace it.

-- DATA EXPLORATION

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How many unique customers we have?
select count(customer_id) from retail_sales;
select count(distinct customer_id) from retail_sales;

-- How many unique categories we have?
select distinct category from retail_sales;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND SOLUTIONS
-- Ques.1: Write an SQL query to retrieve all columns for sales made on '2022-11-05'. 
select * from retail_sales where sale_date = '2022-11-05';

-- Ques.2: Write an SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than or equal to 4 in the month of November 2022.
select * from retail_sales where category='Clothing' 
and year(sale_date) = '2022' and month(sale_date) = 11 
and quantiy >= 4;

-- Ques:3 Write an SQL query to calculate the total sales as total_sale for each category
select category, sum(total_sale) as total_sales from retail_sales group by category;

-- Ques:4 Write an SQL query to find the average age of customers who purchased items from 'Beauty' category
select round(avg(age), 2) as avg_age from retail_sales where category='Beauty';

-- Ques:5 Write an SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;

-- Ques:6 Write an SQL query to find total number of transactio_ids madby each gender in each category
select category, gender, count(*) as total_transactions from retail_sales group by category, gender order by category;

-- Ques:7 Write an SQL query to calculate average sale for each month. Find out best selling month in yeach year.
SELECT Year, Month, avg_sale FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS Year, 
        EXTRACT(MONTH FROM sale_date) AS Month, 
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        )
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1;

-- Ques:8 Write an SQL query to find the top 5 customers based on the highest total_sales
select distinct customer_id, sum(total_sale) as total_sales from retail_sales group by customer_id order by total_sales desc limit 5;

-- Ques:9 Write an SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as distinct_customers from retail_sales group by category;

-- Ques:10 Write an SQL query to create each shift and numebr of orders (Morning <12. Afternoon between 12 & 7. Evening >17)
with hourly_sales
as (
select *, case when extract(hour from sale_time) < 12 then 'Morning'
			   when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
               else 'Evening'
		  end as shift
from retail_sales
) select shift, count(*) as total_orders from hourly_sales group by shift;


-- END OF PROJECT