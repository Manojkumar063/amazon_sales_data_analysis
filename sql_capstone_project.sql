use amazon;
select * from amazon;
-- Adding a new column to store time of day categories.
-- Updating the column based on the transaction time, classifying it as 'Morning', 'Afternoon', or 'Evening'.
ALTER TABLE Amazon
ADD COLUMN timeofday VARCHAR(20);
UPDATE Amazon 
SET timeofday = CASE
    WHEN HOUR(STR_TO_DATE(Date, '%Y-%m-%d %H:%i:%s')) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(STR_TO_DATE(Date, '%Y-%m-%d %H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END;
-- Add a new column 'dayname' to the Amazon table to store the day of the week
-- Disable safe updates to allow the update operation
-- Update the 'dayname' column with the name of the day for each record
-- Convert the 'Date' column to a DATE format and use DAYNAME() to extract the day of the week
ALTER TABLE Amazon 
ADD COLUMN dayname VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;
UPDATE Amazon 
SET dayname = DAYNAME(STR_TO_DATE(Date, '%Y-%m-%d'));

--  Add a new column 'monthname' to the Amazon table to store the name of the month
--  Update the 'monthname' column with the name of the month for each record
-- Use MONTHNAME() to extract the month name from the 'Date' column
ALTER TABLE Amazon
ADD COLUMN monthname VARCHAR(10);
UPDATE Amazon
SET monthname = MONTHNAME(Date);
-- Rename the column 'Product line' to 'Product_Category' and update its data type
-- Rename the column 'customer type' to 'customer_type' and update its data type
ALTER TABLE amazon
CHANGE COLUMN `Product line` Product_Category VARCHAR(255);
ALTER TABLE amazon
CHANGE COLUMN `customer type` customer_type VARCHAR(255);
-- City Analysis:
-- 1. What is the count of distinct cities in the dataset?
select  count(distinct city) as city_count from amazon;
-- 2.For each branch, what is the corresponding city?
select Branch, City  from amazon;
-- product Analysis
-- 3. What is the count of distinct product lines in the dataset?
SELECT count(distinct Product_Category) AS DistinctProductLineCount FROM amazon;
-- 4.Which payment method occurs most frequently?
select max(payment) as mostpayments from amazon;
-- 5.Which product line has the highest sales?
select max(product_category) as  product_Category from amazon;
-- 6.How much revenue is generated each month?
SELECT monthname,SUM(Total) AS Monthly_Revenue FROM amazon GROUP BY monthname ORDER BY Monthname;
-- 7.In which month did the cost of goods sold reach its peak?
SELECT MonthName, SUM(cogs) AS Total_COGS FROM amazon GROUP BY MonthName ORDER BY  Total_COGS DESC LIMIT 1;
-- 8.Which product line generated the highest revenue?
select product_category , max(total) as highest_productcategory from amazon group by product_category order by highest_revenue desc limit 1;
-- 9.In which city was the highest revenue recorded?
SELECT city, max(total)  as heighest_revenue_city from amazon group by city order by heighest_revenue_city desc limit 1;
-- 10.Which product line incurred the highest Value Added Tax?
select Product_category, SUM(`Tax 5%`) AS Total_VAT from amazon group by Product_category order by Total_VAT desc limit 1;
-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select Product_category, AVG(Total) OVER() AS avg_sales, case  when Total > AVG(Total) OVER() then 'Good' else 'Bad'end as  Sales_Performance from amazon;
-- 12. Identify the branch that exceeded the average number of products sold.
select Branch, SUM(Quantity) as total_products_sold FROM amazon
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(total_products_sold) FROM (SELECT SUM(Quantity) AS total_products_sold FROM amazon GROUP BY Branch) AS avg_sales);
-- 13. Which product line is most frequently associated with each gender?
SELECT gender, product_Category, COUNT(*) as frequency from amazon GROUP BY gender, product_category

ORDER BY gender, frequency DESC;
-- 14.Calculate the average rating for each product line.
select product_category,avg(rating) averge_rating from amazon group by product_category order by averge_rating desc limit 1;
-- 15. Count the sales occurrences for each time of day on every weekday.
select DATE_FORMAT(date, '%w') AS weekday,  DATE_FORMAT(date, '%H') AS hour,  COUNT(*) as sales_count from amazon
group by weekday, hour
order by weekday, hour;
-- Customer Analysis:
-- 16.Identify the customer type contributing the highest revenue.
select customer_type, SUM(total) as total_revenue from amazon
group by customer_type
order by total_revenue DESC limit 1;
-- 17.Determine the city with the highest VAT percentage.
select city, max(`Tax 5%`) as highest_vat_percentage from amazon group by city order by highest_vat_percentage desc limit 1;
-- 18.Identify the customer type with the highest VAT payments.
select customer_type, SUM(`Tax 5%`) AS total_vat_payment from amazon
group by customer_type order by total_vat_payment desc limit 1;
-- 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as unique_coustomer_type_count from amazon;
-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct payment) as unique_payment from amazon;
-- 21.Which customer type occurs most frequently?
select customer_type, COUNT(*) AS occurrence_count from amazon
group by customer_type
order by occurrence_count desc limit 1;
-- 22. Identify the customer type with the highest purchase frequency.
select customer_type, COUNT(*) AS purchase_frequency from amazon group by customer_type
order by purchase_frequency desc
limit 1;
-- 23. Determine the predominant gender among customers.
select gender, COUNT(*) AS gender_count from amazon group by gender order by gender_count DESC limit 1;
-- 24. Examine the distribution of genders within each branch.
select branch, gender, COUNT(*) AS gender_count from amazon
group by branch, gender order by branch, gender_count DESC;
-- 25.Identify the time of day when customers provide the most ratings.
select EXTRACT(hour from time) as hour_of_day, COUNT(*) as rating_count from amazon group by hour_of_day order by rating_count desc limit 1;
-- 26.Determine the time of day with the highest customer ratings for each branch.alter
select branch, EXTRACT(HOUR FROM time) AS hour_of_day, COUNT(*) AS rating_count
from amazon group by branch, hour_of_day order by branch, rating_count DESC;
-- 27.Identify the day of the week with the highest average ratings.
select TO_CHAR(rating_timestamp, 'Day') as day_of_week,  avg(rating_value) as average_rating from amazon
group by day_of_week
order by average_rating desc limit 1;
-- 28. Determine the day of the week with the highest average ratings for each branch.
select branch, dayname , avg(rating) as average_rating from amazon 
group by branch, dayname order by branch, average_rating DESC;

select * from amazon





