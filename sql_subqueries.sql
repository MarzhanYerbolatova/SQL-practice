#subqueries

# Find the employyes who's salary is more that the avg salary 
-- avg salary
-- filter the employees 

select *
from employee
where salary > (select avg(salary) from salary);

# Scalar subquery - returns one row and one column

select * 
from employee e
join (select avg(salary) from salary) avg_sal
on e.salary > avg_sal.sal;

# Multiple Row subquery
-- multiple columns and multiple rows
-- one column and multiple rows

# employees with the highest salary in each department

select *
from employee
where (dept_name, salary) in (select dept_name, max(salary)
                              from employee
                              group by dept_name);

# a department that does not have any employees

select *
from department 
where dept_name not in (select distinct dept_name from employee);

# correlated subquery 

-- the employyes in each department who earn more than the avg salary in that dept

select *
from employee e1
where salary > ( select avg(salary)
                 from employee e2
                 where e1.dept_name = e2.dept_name);
                 
-- a department that does not have any employees

select *
from department d
where not exists ( select 1 from employee e
                   where e.dept_name = d.dept_name);
                   
                   
# Nested subquery
-- stores that had better sales that the avg sales across all stores

-- 1) total sales for each store
-- 2) avg sales
-- 3) compare 1 and 2

select *
from (select store_name, sum(price) as total_sales
     from sales
	 group by store_name) sales
join (select avg(total_sales) as sales
     from (select store_name, sum(price) as total_sales
     from sales
	 group by store_name) x) avg_sales
on sales.total_sales > avg_sales.sales;


with sales as
    (select store_name, sum(price) as total_sales
     from sales
	 group by store_name)
select *
from sales
join (select avg(total_sales) as sales
     from sales x) avg_sales
     on sales.total_sales > avg_sales.sales;

#  subquery in Select clause

-- all emp details and add remarks to those emp who eram more than avg pay

select * , 
	(case when salary > (select avg(salary) from employee) 
     then 'Higer tgan average'
     else null 
     end) as remarks
from employee;

select * , 
	(case when salary > avg_sal.sal 
     then 'Higer tgan average'
     else null 
     end) as remarks
from employee
cross join (select avg(salary) sal from employee) avg_sal;



 #  subquery in Having clause
-- the stores that sold more units than the avg units sold

select store_name,sum(quantity)
from sales 
group by store_name
having sum(quantity) >  (select avg(quantity) from sales);

-- subquery in INSERT, UPDATE, DELETE

#INSERT

-- Insert data to employee history table, do not insert duplicate records

insert into emp_history
select e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
from employee e
join department d on e.dept_name = d.dept_name
where not exists ( select 1 from emp_history eh
                   where eh.emp_id = e.epm_id);


#UPDATE

-- Give 10 % increment to all employee in Banglore loc based on the maximum salary 
-- earned by an emp in each dept.

update employee e
set salary = (select max(salary) + (max(salary) * 0.1)
              from employee_history eh
              where eh.dept_name = e.dept_name)
where e.dept_name in (select dept_name 
                      from department
                      where location = 'Banglore')
and e.emp_id in (select emp_id from empployee_history);

#DELETE

-- Delete dept that does not have emp

delete 
from department d
where dept_name in (select dept_name 
                    from department d
                    where not exists (select 1 
                                      from employee e
                                      where e.dept_name = d.dept_name);






