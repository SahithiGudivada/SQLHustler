-- Category-wise sales performance
-- Using categories, products, and order_items, display each category's name, total distinct products sold, total quantity sold, and total sales revenue.
-- - Include only categories where the total quantity sold is greater than 10.
-- - Sort by total sales revenue in descending order.
use sql_playground;
select * from categories;
select * from products;
select * from  order_items;

select c.category_name,count(distinct(oi.product_id)) as total_distinct_products_sold , sum(oi.quantity) as total_quantity_sold , sum(oi.quantity * oi.unit_price) as total_sales_revenue
from categories c inner join products p on c.category_id = p.category_id inner join order_items oi on oi.product_id = p.product_id
group by c.category_id 
having total_quantity_sold > 10
order by total_sales_revenue desc;

-- Q2. Customer order analysis
-- Display every customer's ID, full name, city, and total number of orders, including customers who have never placed an order.
-- - Display customers with the highest number of orders first.
-- - Show customers with zero orders as well.

select c.customer_id , concat(c.first_name,' ' , c.last_name) as full_name,c.city,count(o.order_id) as total_number_of_orders 
from customers c left join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by total_number_of_orders desc;

-- Order status by customer city
-- Display each customer's city and the number of orders in each order status, such as pending, paid, shipped, delivered, and cancelled.
-- - Show only city-and-status combinations having at least 3 orders.
-- - Sort by city and then by order count in descending order.

select c.city ,count(o.status) as no_of_order_status,o.status
from customers c inner join orders o on o.customer_id = c.customer_id
group by c.city,o.status
having no_of_order_status >=3
order by c.city,no_of_order_status desc;

-- Calculate the value of every order
-- Display the order ID, order date, customer full name, sales employee's full name, order status, and total order value.
-- - Calculate the order value using SUM(quantity * unit_price).
-- - Include orders that do not have an assigned employee.
-- - Sort by total order value in descending order.

select * from orders;
select * from customers;
select * from employees;
select * from order_items where order_id = 3;


select oi.order_id,o.order_date,concat(c.first_name,' ',c.last_name) as customer_name,concat(e.first_name,' ' ,e.last_name) as emp_name, 
	   o.status,sum(oi.quantity * unit_price) as total_value 
from customers c inner join orders o on o.customer_id = c.customer_id 
				 left join employees e on e.employee_id = o.employee_id
                 inner join order_items oi on oi.order_id = o.order_id
group by oi.order_id
order by total_value desc;
			
            
-- Payment method analysis
-- Using the payments table, display each payment method and payment status along with the number of payments and total payment amount.
-- - Group the results by both payment method and payment status.
-- - Sort by total payment amount in descending order.

select payment_method,payment_status,count(payment_id) as no_of_payments , sum(amount) as total_payment_amount
from payments
group by payment_method,payment_status
order by total_payment_amount desc;

-- Products that have never been ordered
-- Display the product ID, product name, category name, and unit price of products that have never appeared in order_items.

use sql_playground;
select * from product_reviews;

select p.product_id,p.product_name,oi.unit_price 
from products p left join order_items oi on p.product_id = oi.product_id
where oi.product_id is null;

--  Category-wise customer review analysis
-- Display every category's name, number of distinct products, number of reviews, and average review rating.
-- - Include categories even if their products have no reviews.
-- - Sort by average review rating from highest to lowest, placing categories with no reviews last.product_reviews
select * from product_reviews where product_id in (30,31,32,33);
select * from products where category_id = 7;
select * from categories;

select c.category_name ,count((p.product_id)) as  no_of_products , count(pr.review_id) as no_of_reviews, avg(pr.rating) as avg_review_rating
from categories c inner join products p on c.category_id = p.category_id left join product_reviews pr on p.product_id = pr.product_id 
group by p.category_id 
order by avg_review_rating desc;

-- Employee sales performance
-- Display every employee's ID, full name, department, number of orders handled, and total sales value.
-- - Include employees who have not handled any orders.
-- - Calculate sales value from the quantities and unit prices in order_items.
-- - Show employees with the highest sales first.

select * from employees;(4,5,6,9)
select * from order_items;
select * from orders where employee_id = 9;

select e.employee_id,concat(e.first_name,' ' ,e.last_name) as emp_name,count(distinct(o.order_id)) as no_of_orders , sum(oi.quantity*oi.unit_price) as total_sales_value
from employees e left join orders o on e.employee_id = o.employee_id left join order_items oi on oi.order_id = o.order_id
group by e.employee_id
order by total_sales_value desc;

-- High-value customers
-- Display each customer's ID, full name, city, total number of orders, and total order value across all their orders.
-- - Show only customers whose total order value exceeds ₹10,000.
-- - Sort by total order value in descending order.

select * from customers;
select  * from orders where customer_id = 2;-- 85,126
select * from order_items where order_id in (85,126);--26488

select c.customer_id,concat(c.first_name,' ' ,c.last_name) as customer_name, count(o.order_id) as total_no_of_orders,sum(oi.quantity*oi.unit_price) as total_order_value
from customers c inner join orders o on c.customer_id = o.customer_id inner join order_items oi on o.order_id = oi.order_id
group by o.customer_id
having total_order_value > 10000
order by total_order_value desc;

-- Employee-manager hierarchy
-- Display every employee's full name, department, salary, and manager's full name.
-- - Include top-level employees who do not have a manager.
-- - Sort by manager's name and then employee salary in descending order.








