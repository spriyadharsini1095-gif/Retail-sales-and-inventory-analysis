create database retail_analysis;
use retail_analysis;
select* from brands;
show tables;
RENAME TABLE `stores-retail sales and inventory analysis`   TO stores;
RENAME TABLE `brands-retail sales and inventory analysis`   TO brands;
RENAME TABLE `categories-retail sales and inventory analysis` TO categories;
RENAME TABLE `customer-retail sales and inventory analysis` TO customers;
RENAME TABLE `products-retail sales and inventory analysis` TO products;
RENAME TABLE `staffs-retail sales and inventory analysis`   TO staffs;
RENAME TABLE `orders-retail sales and inventory analysis`   TO orders;
RENAME TABLE `order_items-retail sales and inventory analysis` TO order_items;
RENAME TABLE `stocks-retail sales and inventory analysis`   TO stocks;
select * from stores;
select * from orders;
##Overall Total Revenue
select count(distinct o. Order_id) as total_orders,sum(oi.Quantity) as total_items_sold,
round(sum(oi.List_price*oi.Quantity*(1-replace(oi.Discount,'%','')/100)),2) as total_revenue,
round(avg(oi.List_price*oi.Quantity*(1-replace(oi.Discount,'%','')/100)),2) as avg_order_value from 
orders o join order_items oi on o.Order_id=oi.order_id where o.Order_status=4;
SELECT DISTINCT Discount FROM order_items LIMIT 10;
##Total Sales by Year
select year(o.Order_date) as year,count(distinct o.Order_id) as total_orders,
sum(oi.Quantity)as items_sold,round(sum(oi.List_price*oi.Quantity*(1-replace(oi.Discount,'%','')/100)),2) as total_revenue 
from orders O join order_items oi on o.Order_id=oi.Order_id 
where o.Order_status=4 group by year order by year;
##Total Sales by Month
select year(o.Order_date) as year,monthname(o.Order_date) as month ,count(distinct o.Order_id) as total_orders,
sum(oi.Quantity)as items_sold,round(sum(oi.List_price*oi.Quantity*(1-replace(oi.Discount,'%','')/100)),2) as total_revenue 
from orders O join order_items oi on o.Order_id=oi.Order_id 
where o.Order_status=4 group by year ,month,month(o.Order_date) order by year,month(o.Order_date);
##Total Discount Given
select round(sum(oi.List_price*oi.Quantity),2) as gross_revenue,
round(sum(oi.List_price*oi.Quantity *replace(oi.Discount,'%','')/100),2) as total_discount,
round(sum(oi.List_price*oi.Quantity*(1-replace (oi.Discount,'%','')/100)),2) as net_revenue,
round(avg(replace(oi.Discount,'%','')),1)as avg_discount_pct from orders o join order_items oi on
o.Order_id=oi.Order_id where o.order_status=4;
##Top 10 Best Selling Products
select p.Product_id,p.Product_name,b.Brand_name,c.Category_name, 
count(o.Order_id) as total_orders,sum(oi.quantity) as total_quantity_sold,
round(sum(oi.List_price*oi.Quantity*(1-replace(oi.Discount,'%','')/100)),2) as total_revenue
from Order_items oi join products p on p.Product_id=oi.Product_id
join brands b on p.Brand_id=b.Brand_id
join categories c on c.Category_id=p.Category_id
join orders o on o.Order_id=oi.Order_id
where o.Order_status=4
group by p.Product_id,b.Brand_name,p.Product_name,c.Category_name
order by total_revenue desc limit 10;
##Top Products by Category
select c.Category_name,p.Product_name,sum(oi.Quantity) as quantity_sold,
round(sum(oi.List_price*oi.Quantity*(1-replace (oi.Discount,'%','')/100)),2) as revenue
from order_items oi join orders o on o.Order_id=oi.Order_id
join products p on p.Product_id=oi.Product_id
join categories c on c.category_id=p.category_id
where o.Order_status=4 group by c.Category_name,p.Product_name
order by c.Category_name,Revenue desc;
##Top Products by Brand
select b.Brand_name,p.Product_name,sum(oi.Quantity) as quantity_sold,
round(sum(oi.List_price*oi.Quantity*(1-replace(oi.Discount,'%','')/100)),2) as revenue
from order_items oi join orders o on o.Order_id=oi.Order_id
 join products p on p.Product_id=oi.Product_id
 join brands b on p.Brand_id=b.Brand_id
 where o.Order_status=4
 group by b.Brand_name,p.Product_name
 order by b.Brand_name,revenue desc;
 ## Least Selling Products
SELECT p.product_name, b.brand_name,c.category_name,
    COUNT(oi.order_id)  AS times_ordered,
    SUM(oi.quantity)  AS qty_sold,
    ROUND(SUM(oi.list_price * oi.quantity * 
          (1 -replace(oi.Discount,'%','')/100)),2) AS revenue
FROM order_items oi
JOIN orders o     ON oi.order_id   = o.order_id
JOIN products p   ON oi.product_id = p.product_id
JOIN brands b     ON p.brand_id    = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY p.product_name, b.brand_name, c.category_name
ORDER BY qty_sold ASC
LIMIT 10;
##Products Never Ordered
select p.Product_id,p.Product_name,b.Brand_name,c.category_name,p.List_price from products P
join brands b on b.Brand_id=p.Brand_id
join categories c on p.Category_id=c.Category_id
where p.Product_id  not IN (select distinct product_id from order_items)
order by p.List_price desc;
##Revenue Per Store
select s.Store_id,s.Store_name,s.City,s.State, count(distinct o.Order_id) as total_orders,
sum(oi.Quantity) as items_sold,round(sum(oi.List_price*oi.quantity*(1-replace(oi.Discount,'%','')/100)),2)
as total_revenue from stores s join orders o on o.Store_id=s.Store_id
join order_items oi on o.Order_id=oi.Order_id where o.Order_status=4
group by s.store_id ,s.Store_name,s.city,s.state order by total_revenue desc;
##Store Revenue by Year
SELECT s.store_name,YEAR(o.order_date) AS year,COUNT(DISTINCT o.order_id) AS orders,
ROUND(SUM(oi.list_price * oi.quantity *(1-replace(oi.Discount,'%','')/100)),2) as total_revenue
FROM stores s JOIN orders o ON s.store_id  = o.store_id
JOIN order_items oi ON o.order_id  = oi.order_id
WHERE o.order_status = 4
GROUP BY s.store_name, year
ORDER BY s.store_name, year;
##Store Market Share %
select s.store_name,s.state,round(sum(oi.list_price*oi.quantity*(1-replace(oi.discount,'%','')/100)),2)
as total_revenue,ROUND(SUM(oi.list_price * oi.quantity * (1 - oi.discount)) * 100 /SUM(SUM(oi.list_price  * oi.quantity * 
(1 - oi.discount))) OVER(), 2) AS market_share_pct
FROM stores s JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4 GROUP BY s.store_name, s.state
ORDER BY total_revenue DESC;
##Top Category Per Store
SELECT 
    s.store_name,
    c.category_name,
    SUM(oi.quantity)             AS qty_sold,
    ROUND(SUM(oi.list_price * oi.quantity * 
          (1-replace(oi.discount,'%','')/100)),2) AS revenue
FROM stores s
JOIN orders o       ON s.store_id  = o.store_id
JOIN order_items oi ON o.order_id  = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
JOIN categories c   ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY s.store_name, c.category_name
ORDER BY s.store_name, revenue DESC;
##Order Status Summary Per Store
select s.store_name,
sum(case when o.order_status=4 then 1 else 0 end) as completed,
sum(case when o.order_status=1 then 1 else 0 end) as pending,
sum(case when o.order_status=2 then 1 else 0 end) as processing,
sum(case when o.order_status=3 then 1 else 0 end) as rejected,
count(o.order_id) as total_orders from stores s join orders o on  s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY total_orders DESC;
##Complete Summary Dashboard
SELECT s.store_name,
    CASE s.state
        WHEN 'CA' THEN 'West'
        WHEN 'NY' THEN 'East'
        WHEN 'TX' THEN 'South'
    END AS region,s.city,s.state,COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,SUM(oi.quantity) AS items_sold,
    ROUND(SUM(oi.list_price * oi.quantity), 2)AS gross_revenue,
    ROUND(SUM(oi.list_price * oi.quantity *REPLACE(oi.discount,'%','')/100), 2)AS discount_given,
    ROUND(SUM(oi.list_price * oi.quantity *(1 - REPLACE(oi.discount,'%','')/100)), 2) AS net_revenue,
    ROUND(AVG(REPLACE(oi.discount,'%','')), 1) AS avg_discount_pct
FROM stores s JOIN orders o  ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY s.store_name, region, s.city, s.state
ORDER BY net_revenue DESC;
##Repeat Customers
SELECT 
    c.Customer_id,
    CONCAT(c.First_name,' ',c.Last_name) AS customer_name,
    c.City,
    c.State,
    COUNT(DISTINCT o.Order_id)           AS total_orders,
    CASE 
        WHEN COUNT(DISTINCT o.Order_id) = 1 
             THEN 'One-time'
        WHEN COUNT(DISTINCT o.Order_id) = 2 
             THEN 'Returning'
        WHEN COUNT(DISTINCT o.Order_id) >= 3 
             THEN 'Loyal'
    END                                  AS customer_type
FROM customers c
right JOIN orders o 
    ON c.Customer_id = o.Customer_id
WHERE o.Order_status = 4
GROUP BY c.Customer_id,
         customer_name,
         c.City,
         c.State
HAVING COUNT(DISTINCT o.Order_id) >=1
ORDER BY total_orders DESC;
SELECT 
    c.Customer_id,
    o.Order_id,
    o.Order_status
FROM customers c
JOIN orders o ON c.Customer_id = o.Customer_id
LIMIT 10;
    SELECT 
    Customer_id,
    COUNT(Order_id) AS order_count
FROM orders
WHERE Order_status = 4
GROUP BY Customer_id
ORDER BY order_count DESC
LIMIT 10;
## Top 10 Highest Spenders
select c.customer_id,concat(c.first_name,'',c.last_name) as customer_name,
c.city,c.state,count(distinct o.order_id) as total_orders,sum(oi.Quantity) as items_bought,
round(sum(oi.list_price*oi.quantity*(1-replace(discount,'%','')/100)),2) as total_spent
from customers c join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id where o.order_status=4
group by c.customer_id,customer_name,c.city,c.state order by total_spent desc
limit 10; 
## Spending Tier Breakdown
select 
case
when total_spent>=5000 then 'VIP (5k+)'
when total_spent>=2000 then  'high(2k-5k)'
when total_spent>=1000 then 'mid(1k-2k)'
else 'basic(<1k)'
end as spending_tier,
count(*) as total_customers,round(avg(total_spent),2) as avg_spent,
round(sum(total_spent),2) as tier_revenue 
from (select c.customer_id,
round(sum(oi.list_price * oi.quantity * (1 - CAST(replace(oi.discount,'%','') AS DECIMAL(10,2))/100)), 2) as total_spent
from
customers c join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
where o.order_status=4 group by c.customer_id) as totals
group by spending_tier order by avg_spent desc;
## Total Stock Overview by Store
SELECT 
    st.store_name, st.city, st.state,
    COUNT(DISTINCT sk.product_id) AS unique_products,
    SUM(sk.quantity) AS total_units,
    ROUND(SUM(sk.quantity * CAST(REPLACE(p.list_price, '$', '') AS DECIMAL(10,2))), 2) AS inventory_value
FROM stores st
JOIN stocks sk  ON st.store_id   = sk.store_id
JOIN products p ON sk.product_id = p.product_id
GROUP BY st.store_id, st.store_name, st.city, st.state
ORDER BY inventory_value DESC;
##Stock by Product Category
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id)  AS total_products,
    SUM(sk.quantity)              AS total_units,
    ROUND(AVG(sk.quantity), 1)    AS avg_stock_per_product,
    ROUND(SUM(sk.quantity * CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2))), 2) AS category_inventory_value
FROM stocks sk
JOIN products p   ON sk.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_units DESC;     
##Low Stock & Out-of-Stock Alert
select p.product_name,b.brand_name,st.store_name,sk.quantity,
case
when sk.quantity=0 then "out of stock"
when sk.quantity<=3 then "critical"
when sk.quantity<=10 then "low stock"
end as stock_status
from stocks sk
join products p on sk.product_id=p.product_id
join stores st on sk.store_id=st.store_id
join brands b on p.brand_id=b.brand_id
where sk.quantity<=10
order by sk.quantity asc ,st.store_name;
##top 10 high value products
SELECT 
    p.product_name,
    b.brand_name,
    SUM(sk.quantity) AS total_units,
    CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2)) AS unit_price,
    ROUND(SUM(sk.quantity * CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2))), 2) AS total_value,
    ROUND(
        SUM(sk.quantity * CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2))) * 100.0 /
        SUM(SUM(sk.quantity * CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2)))) OVER ()
    , 2) AS value_pct
FROM stocks sk
JOIN products p ON sk.product_id = p.product_id
JOIN brands b   ON p.brand_id    = b.brand_id
GROUP BY p.product_id, p.product_name, p.list_price, b.brand_name
ORDER BY total_value DESC
LIMIT 10;
## View 1 — Customer Sales Summary
CREATE VIEW vw_customer_sales_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    c.city, c.state,
    COUNT(DISTINCT o.order_id)           AS total_orders,
    ROUND(SUM(oi.quantity * 
        CAST(REPLACE(oi.list_price,'$','') AS DECIMAL(10,2)) * 
        (1 - CAST(REPLACE(oi.discount,'%','') AS DECIMAL(10,2))/100)),2) AS total_spent,
    CASE
        WHEN SUM(oi.quantity * CAST(REPLACE(oi.list_price,'$','') AS DECIMAL(10,2)) * 
             (1 - CAST(REPLACE(oi.discount,'%','') AS DECIMAL(10,2))/100)) >= 5000 THEN 'VIP (5k+)'
        WHEN SUM(oi.quantity * CAST(REPLACE(oi.list_price,'$','') AS DECIMAL(10,2)) * 
             (1 - CAST(REPLACE(oi.discount,'%','') AS DECIMAL(10,2))/100)) >= 2000 THEN 'High (2k-5k)'
        WHEN SUM(oi.quantity * CAST(REPLACE(oi.list_price,'$','') AS DECIMAL(10,2)) * 
             (1 - CAST(REPLACE(oi.discount,'%','') AS DECIMAL(10,2))/100)) >= 1000 THEN 'Mid (1k-2k)'
        ELSE 'Basic (<1k)'
    END AS spending_tier
FROM customers c
JOIN orders o      ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id   = oi.order_id
WHERE o.order_status = 4
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.state;vw_customer_sales_summary
use retail_analysis;
##View 2 — Store Inventory Overview
CREATE VIEW vw_store_inventory AS
SELECT 
    st.store_id,
    st.store_name, st.city, st.state,
    p.product_id, p.product_name,
    b.brand_name,
    c.category_name,
    sk.quantity,
    CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2))  AS unit_price,
    ROUND(sk.quantity * 
        CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2)),2) AS stock_value,
    CASE
        WHEN sk.quantity = 0  THEN 'Out of Stock'
        WHEN sk.quantity <= 3 THEN 'Critical'
        WHEN sk.quantity <= 10 THEN 'Low Stock'
        ELSE 'Adequate'
    END AS stock_status
FROM stocks sk
JOIN stores st    ON sk.store_id   = st.store_id
JOIN products p   ON sk.product_id = p.product_id
JOIN brands b     ON p.brand_id    = b.brand_id
JOIN categories c ON p.category_id = c.category_id;
##View 3 — Product Sales Performance
CREATE VIEW vw_product_performance AS
SELECT 
    p.product_id, p.product_name,
    b.brand_name, c.category_name,
    CAST(REPLACE(p.list_price,'$','') AS DECIMAL(10,2)) AS list_price,
    COUNT(DISTINCT o.order_id)   AS total_orders,
    SUM(oi.quantity)             AS total_units_sold,
    ROUND(SUM(oi.quantity * 
        CAST(REPLACE(oi.list_price,'$','') AS DECIMAL(10,2)) * 
        (1 - CAST(REPLACE(oi.discount,'%','') AS DECIMAL(10,2))/100)),2) AS total_revenue
FROM order_items oi
JOIN orders o     ON oi.order_id   = o.order_id
JOIN products p   ON oi.product_id = p.product_id
JOIN brands b     ON p.brand_id    = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY p.product_id, p.product_name, b.brand_name, c.category_name, p.list_price;
##View 4 — Monthly Revenue Trend
CREATE VIEW vw_monthly_revenue AS
SELECT 
    YEAR(o.order_date)                    AS order_year,
    MONTH(o.order_date)                   AS order_month,
    DATE_FORMAT(o.order_date,'%Y-%m')     AS 'year_month',
    st.store_name,
    COUNT(DISTINCT o.order_id)            AS total_orders,
    SUM(oi.quantity)                      AS total_units,
    ROUND(SUM(oi.quantity * 
        CAST(REPLACE(oi.list_price,'$','') AS DECIMAL(10,2)) * 
        (1 - CAST(REPLACE(oi.discount,'%','') AS DECIMAL(10,2))/100)),2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id  = oi.order_id
JOIN stores st      ON o.store_id  = st.store_id
WHERE o.order_status = 4
GROUP BY YEAR(o.order_date), MONTH(o.order_date), 
         DATE_FORMAT(o.order_date,'%Y-%m'), st.store_name;
SELECT * FROM vw_store_inventory WHERE stock_status = 'Critical';
