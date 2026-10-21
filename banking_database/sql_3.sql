use banking_database;

-- ASSIGNMENT 1 

-- Display all records from the branches table.
select * from branches;
-- Show the first name, last name and city of every customer.
select first_name,last_name,city from customers;
-- List the distinct cities in which customers live.
select distinct(city) from customers;

-- Find customers whose first name starts with the letter ‘A’ and who live in either Hyderabad or Mumbai.
select * from customers where first_name like 'A%' and city in ('Hyderabad' ,'Mumbai');

-- For Active accounts, display the total, average (rounded to 2 decimals), minimum and maximum balance.
select sum(balance) as total , round(avg(balance),2) as average , min(balance) as minimum_balance , max(balance) as maximum_balance 
from accounts
where status = 'Active';

-- Show the number of customers in each state, but only for states having more than 5 customers. 
-- List the state with the most customers first.
select count(customer_id) as no_of_customers , state
from customers
group by state
having no_of_customers > 5
order by no_of_customers desc;

-- Display account number, customer full name and account type name for every account (join three tables).
select a.account_number,concat(c.first_name,' ',c.last_name) as customer_name, at.type_name as acc_type_name 
from customers c inner join accounts a on c.customer_id = a.customer_id inner join account_types at on at.type_id = a.type_id;

-- Find the customers who do not have any account
select concat(c.first_name,' ',c.last_name) as customer_name, c.customer_id
from customers c left join accounts a on c.customer_id = a.customer_id 
WHERE a.customer_id IS NULL;

-- Find the accounts whose balance is higher than the average balance of all accounts. Show account number and balance.
Select account_number, balance from accounts where balance > (select avg(balance) from accounts);


-- (DML) Insert a new branch (branch_id 13) of your choice.
--  Then insert a new employee (employee_id 49) working in that branch as a ‘Branch Manager’ reporting to employee 1. 
--  Finally, increase that employee’s salary by 5,000 and verify all three changes with SELECT statements.

insert into branches values 
(13,'Vijayawada Central','vijayawada','Andhra Pradesh',current_date());
insert into employees values (49,'Sahithi','Gudivada',13,'Branch Manager',55000,current_date(),1);
update employees
set salary = salary + 5000
where employee_id = 49;
select * from branches where branch_id = 13;
select * from employees where employee_id = 49;


-- ASSIGNMENT 2 

-- Show the account number and balance of the top 10 accounts with the highest balance.
select account_number,balance
from accounts
order by balance desc
limit 10;

-- List all Withdrawal transactions with an amount between 50,000 and 100,000.
select *
from transactions
where txn_type = 'Withdrawal' and amount between 50000 and 100000;

-- Find the customers who do not have an email address on record.
select * from customers;
select *
from customers
where email is null;

-- Display each customer’s full name, their city in uppercase, and the domain of their email address. Exclude customers with no email.
select concat(first_name,' ',last_name) as customer_name , upper(city) as city, email
from customers
where email like '@__________%' and  email is not null;

-- Find the job titles whose average monthly salary is greater than 45,000. Show the average rounded to the nearest whole number.
select job_title,round(avg(salary)) as avg_salary
from employees
group by job_title
having avg_salary > 45000;


-- Show every branch with the number of employees working there, sorted from highest to lowest.
select * from branches;
select b.branch_name ,count(e.employee_id) as no_of_employees 
from employees e inner join branches b on e.branch_id = b.branch_id
group by e.branch_id
order by no_of_employees desc;

-- Display each employee’s full name next to their manager’s full name. Employees without a manager should still appear.


-- (a) Using an IN subquery, list the customers (id and full name) who have at least one loan with the status ‘Defaulted’.
select * from cards;
select customer_id ,concat(first_name,' ',last_name) as customer_name 
from customers 
where customer_id in (
select customer_id 
from loans 
where status = "Defaulted"
);

-- Using EXISTS, list the customers who have at least one Blocked card.
select c.customer_id 
from customers c
where EXISTS (
select a.customer_id 
from accounts a inner join cards ca on a.account_id = ca.account_id 
where a.customer_id = c.customer_id and ca.status = "Blocked"
);


-- (a) Give a 10% salary increase to all Tellers working in branches located in Hyderabad
select * from employees;
update employees
set salary = salary*10/100
where employee_id IN (
select employee_id
from employees 
where job_title = "Teller"
);

-- Delete all cards whose status is ‘Expired’. Verify each change with a SELECT.
select * from cards;
delete from cards where status = 'Expired';


-- ASSIGNMENT - 3

-- Show the first name, job title, monthly salary and annual salary (alias it annual_salary) of all 
-- Loan Officers and Relationship Managers earning more than 50,000 per month.
select first_name,job_title,salary as monthly_salary ,(salary)*12 as annual_salary
from employees
where job_title in ("Loan Officer","Relationship Manager");


-- Show the account number, open date and status of accounts opened during the year 2023 whose status is not ‘Active’.
-- Sort by open date (latest first) and display only the first 5 rows.
select * from accounts;
select account_number,open_date ,status
from accounts
where status = 'Dormant' and open_date >= '2023-01-01' and open_date < '2024-01-01'
order by open_date desc
limit 5; 

-- Find the total number of customers and the number of customers who have an email address.
 -- Explain in one line why the two numbers differ
 select count(customer_id) as no_of_customers,count(email) as no_of_customers_which_have_email_address
 from customers;
 -- explnation the count is differ because there are customer show doesnt have email id


-- Calculate each customer’s current age in years using their date of birth, and list customers who are above 60 years old.
select * from customers;
select year(current_date()) - year(date_of_birth) as current_age , c.*
from customers c
having current_age > 60;

-- Show the number of transactions and the total transaction amount for each month of the year 2024.
select * from transactions;
select count(transaction_id) as no_of_transactions,sum(amount) as total_transaction,month(txn_date) as months
from transactions
group by months;


-- Display customer id, full name, email and phone, replacing missing emails with ‘No Email’ 
-- and missing phone numbers with ‘Not Provided’. 
-- Show only customers who are missing at least one of the two.
select customer_id,concat(first_name,' ' ,last_name) as customer_name, coalesce(email ,'No Email') ,coalesce(phone,'Not Provided')
from customers
where email is null or phone is null;


-- List customers who have taken a loan, showing customer name, loan type name, principal amount and loan status.
select concat(c.first_name,' ',c.last_name) as customer_name , lt.loan_type_name,l.principal_amount,l.status
from customers c inner join loans l on c.customer_id = l.customer_id inner join loan_types lt on lt.loan_type_id = l.loan_type_id;


-- Produce a single combined list of all cities that appear in either the customers table or the branches table, without duplicates. 
-- Then explain how the result would change if you used UNION ALL.
select city
from branches
union
select city
from customers;

select city
from branches
union all
select city
from customers;
-- Explnation : when we perform union all it appears citiy names as many times as it recorded which cause duplicates in union all while union we get cities without duplicates

-- Find the accounts that have never had a transaction using NOT EXISTS.
select a.account_id 
from accounts a
where not exists (
select t.account_id
from transactions t
where a.account_id = t.account_id
);


-- (a) Add a column kyc_status VARCHAR(10) DEFAULT 'Pending' to the customers table.
alter table customers
add column kyc_satus varchar(10) default 'Pending'; 
describe customers;

-- (b)  Update kyc_status to ‘Verified’ for all customers who have at least one Active account.
update customers 
set  kyc_status = 'verfied'
where customer_id in(
select c.customer_id
from customers c inner join accounts a on a.customer_id = c.customer_id
);

-- (c)Create a new table high_value_customers from a query 
-- that returns customers whose total balance across all accounts exceeds 500,000.

create table high_value_customers as
select c.*,sum(a.balance) as total_balance
from customers c inner join accounts a on a.customer_id = c.customer_id
group by customer_id
having total_balance > 5000000;
select * from  high_value_customers;

-- ASSIGNMENT 4

-- List all Credit cards with a credit limit of 200,000 or more, showing card id, account id and credit limit, highest limit first.
select card_id,account_id,credit_limit
from cards
where card_type = 'credit'  and credit_limit >= 200000
order by credit_limit desc;

-- Find all Active loans with a principal amount above 2,000,000 and an interest rate below 10%.
select *
from loans
where status = 'Active' and principal_amount > 2000000 and interest_rate <  10;


-- List customers born after 1st January 1990 who do not live in Hyderabad, Mumbai or Delhi.
select * 
from customers 
where date_of_birth > 1990-01-01 and city not in ('Delhi','Hyderabad','Mumbai');


-- For each combination of transaction type and channel, show the number of transactions and the total amount.
select * from transactions;
select txn_type,channel,count(*) as combination,sum(amount) as total_amount
from transactions
group by txn_type,channel;


-- For loans with a term of 60 months or more, show loan id, principal, interest rate, the principal expressed in lakhs rounded up (CEIL), 
-- and an estimated monthly EMI rounded to 2 decimals using: principal × (1 + rate/100 × term/12) ÷ term.
select * from loans;
select loan_id,interest_rate,ceil(principal_amount) as principal_amount,(principal_amount *(1 + interest_rate/100 * term_months/12) / term_months) as EMI
from loans
where term_months >= 60;

-- Using a correlated subquery, list the employees who earn more than the average salary of their own branch.
select *
from employees e1
where e1.salary > (
select avg(e2.salary) as avg_salary
from employees e2 
where e1.branch_id = e2.branch_id
);

-- 

