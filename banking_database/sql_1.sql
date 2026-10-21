-- Retrieve the product name, unit price, and stock quantity of all products whose unit price is greater than ₹2,000. Display the most expensive products first.
select product_name,unit_price,stock_quantity 
from products 
where unit_price > 2000
order by unit_price desc;

select * from products;

-- Find all active customers who belong to either Chennai or Hyderabad. Display their first name, last name, city, and email.
select first_name,last_name,city,email 
from customers 
where (is_active = 1) and (city = "Chennai" or city = "Hyderabad");

-- Display the five highest-paid employees, including their first name, last name, department, and salary.
select first_name,last_name,department,salary
from employees
order by salary desc
limit 5;

-- 4. Calculate the following for all products that are not discontinued:
-- - Total number of products
-- - Average unit price
-- - Minimum unit price
-- - Maximum unit price
-- - Total stock quantity

select count(product_id) as total_products,avg(unit_price) as avg_unit_price ,min(unit_price) as minimum_unit_price,max(unit_price) as maximum_unit_price,sum(stock_quantity) as total_stock_quantity 
from products
where is_discontinued = 0;

-- Display each product's name, unit price, and category name. Show only products priced above ₹1,000.
select p.product_name , p.unit_price, c.category_name 
from categories c inner join products p on c.category_id = p.category_id
where p.unit_price > 1000;

-- Display the order ID, order date, customer full name, and order status for all orders placed by customers from Chennai.
select o.order_id,o.order_date, CONCAT(c.first_name,' ' , c.last_name) as customer_full_name ,o.status
from orders o inner join customers c on o.customer_id = c.customer_id
where c.city = "Chennai" ;


-- Display every customer and their order IDs, including customers who have never placed an order.

select c.customer_id ,o.order_id 
from customers c  left join orders o on o.customer_id = c.customer_id
order by customer_id;

-- Find the number of orders placed by each customer. Display the customer ID, customer full name, and total number of orders. Include only customers who have placed at least one order. Sort the results by the total number of orders in descending order.
select c.customer_id,concat(c.first_name,' ',c.last_name) as customer_full_name ,count(o.order_id) as total_orders
from customers c inner join orders o on c.customer_id = o.customer_id 
group by o.customer_id
order by total_orders desc;

-- Calculate the total value of the items in each order. Display the order ID and total order value, sorted from highest to lowest.
select * from order_items;
select order_id ,sum(quantity * unit_price) as total_order_value
from order_items
group by order_id
order by total_order_value desc;

-- 10. For each product category, calculate:
-- - Category name
-- - Number of products
-- - Average product price
-- - Total stock quantity
-- Display only categories having more than four products, and sort them by average product price from highest to lowest.

select c.category_name,count(p.product_name) as number_of_products , avg(unit_price) as Average_product_price , sum(stock_quantity)
from categories c inner join products p on c.category_id = p.category_id
group by p.category_id
having number_of_products > 4
order by Average_product_price desc