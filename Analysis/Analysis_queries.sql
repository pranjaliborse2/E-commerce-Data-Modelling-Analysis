
create view monthly_transections AS
Select round(sum(f.total_price),2) as monthly_cost, count(f.invoice_no) as monthly_transections, c.country, d.month
from fact_sales as f 
Left join dim_customer as c
on f.customer_id = c.customer_id 
Left join dim_date as d
on f.date_id = d.transection_date
group by country, d.month

create view yearly_transections as 
select round(sum(f.total_price),2) as annual_cost, count(f.invoice_no) as total_annual_transections, c.country, d.year
from fact_Sales as f
left join dim_customer as c
on f.customer_id = c.customer_id 
Left join dim_date as d
on f.date_id = d.transection_date
group by country, d.year

create view Product_Sales AS
select sum(quantity) as total_quanity_sold, count(*) as total_transections_product, f.product_id, p.description, round(sum(f.total_price),2) as total_cost
from (select * from fact_sales where quantity > 0) as f
left join dim_product as p
on f.product_id = p.product_id
group by f.product_id, p.description
order by total_quanity_sold desc

create view returned_products as 
select count(*) as frequency_of_return, p.description
from (select product_id from fact_Sales where quantity = -1) as f
left join dim_product as p
on f.product_id = p.product_id
group by f.product_id, p.description
order by frequency_of_return desc

ALTER TABLE fact_sales
ADD COLUMN is_weekend BOOLEAN;
Update fact_sales as f
SET is_weekend = d.weekday IN ('Saturday', 'Sunday')
FROM dim_date as d
WHERE f.date_id = d.transection_date;

create table aggregated_transections AS
Select round(sum(f.total_price),2) as transection_cost, MIN(f.date_id) as date, f.invoice_no, f.customer_id AS customer, 
count(f.product_id) as no_of_products, (avg(CASE WHEN f.is_weekend THEN 1 ELSE 0 END)::int) AS weekend_orders, STRING_AGG(DISTINCT d.weekday, ', ')
from fact_sales as f
left join dim_date as d
on d.transection_date = f.date_id
group by f.invoice_no, f.customer_id

create view weekly_transections as
select count(a.invoice_no)/count(distinct a.date) as avg_no_of_transections, round(avg(a.transection_cost),2) as avg_sales, a.weekend_orders, c.country
from aggregated_transections as a                                                                                                                                                                                                                                                                                             
left join dim_customer as c
on c.customer_id = a.customer
group by c.country, a.weekend_orders
order by c.country

create view above_avg_transections as
select * from fact_sales
where total_price > (select avg(total_price) from fact_sales)

-- Product focused analysis

WITH product_freq AS (
  SELECT 
    f.customer_id,
    f.product_id,
	p.description,
    COUNT(f.product_id) AS times_purchased,
    ROW_NUMBER() OVER (PARTITION BY f.customer_id ORDER BY COUNT(f.product_id) DESC) AS product_rank
  FROM fact_sales as f
  left join dim_product as p
  on f.product_id = p.product_id
  GROUP BY f.customer_id, f.product_id, p.description
)
SELECT * FROM product_freq WHERE product_rank = 1;

Create View Product_seasonality as 
SELECT 
    p.description,
    d.month,
    SUM(f.quantity) AS monthly_units_sold
FROM fact_sales as f
JOIN dim_product as p ON f.product_id = p.product_id
JOIN dim_date as d ON f.date_id = d.transection_date
GROUP BY p.description, d.month
ORDER BY p.description, d.month;

-- Customer segmentation analysis

Create view Customer_frequency AS 
  SELECT 
    customer_id,
    MAX(d.transection_date) AS last_purchase_date,
    COUNT(DISTINCT f.invoice_no) AS frequency,
    round(SUM(f.total_price),2) AS monetary_value
  FROM fact_sales f
  JOIN dim_date d ON f.date_id = d.transection_date
  GROUP BY f.customer_id