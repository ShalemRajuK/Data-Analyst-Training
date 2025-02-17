-- select statements

select * from Parks_and_Recreation.employee_demographics;

select first_name,age from employee_demographics;

# mysql follows PEMDAS (paranthesis, exponential, multiplication, Division, addition, subtraction)

select first_name,last_name,age,(2024-age) as "birth_year " from employee_demographics;

select distinct gender from employee_demographics;

select distinct first_name,gender from employee_demographics;

-- where and Logical Operators

select * from employee_salary where salary >= 50000;

select * from employee_demographics where gender!='female';

-- logical operators AND, OR, NOT

select * from employee_demographics where gender!='female' and birth_date>'1985-01-01';

SELECT * FROM employee_demographics WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;

-- like 

select * from employee_demographics where first_name like "%er%";

select * from employee_demographics where birth_date like "1989%";

select * from employee_demographics where first_name like "A__%%";

-- Group BY

select gender, AVG(age) from employee_demographics group by gender;

select gender, AVG(age),max(age),min(age),count(age) from employee_demographics group by gender;

select occupation,avg(salary) from employee_salary group by occupation;

-- ORDER BY

select * from employee_demographics order by first_name;

select * from employee_demographics order by gender, age DESC;

-- Having

select gender,avg(age) from employee_demographics group by gender having avg(age)>40;

select occupation,Avg(salary) from employee_salary where occupation like "%manager%"group by occupation having avg(salary)>70000;

-- limit + Aliasing

select * from employee_demographics limit 3;

select * from employee_demographics order by age Desc limit 3;

select * from employee_demographics order by age Desc limit 2,1;

select * from employee_demographics order by age Desc limit 2,2;

-- Aliasing

select gender,avg(age) as avg_age from employee_demographics group by gender having avg_age > 40;

-- joins

select dem.employee_id,age,occupation from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id;
    
-- Outer joins    

select * from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id;

select * from employee_demographics as dem
left join employee_salary as sal
	on dem.employee_id = sal.employee_id;
    
-- self join

select * from employee_salary emp1 join employee_salary emp2
	on emp1.employee_id =emp2.employee_id;

select * from employee_salary emp1 join employee_salary emp2
	on emp1.employee_id +1=emp2.employee_id;
    
select * from employee_salary emp1 join employee_salary emp2
	on emp1.employee_id +1=emp2.employee_id;    
    
-- joining multiple tables together

select * 
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id=sal.employee_id
inner join parks_departments pd
	on sal.dept_id=pd.department_id;
    
    -- unions
select first_name,last_name from employee_demographics 
union
select first_name, last_name from employee_salary;

select first_name,last_name from employee_demographics 
union all
select first_name, last_name from employee_salary;

select first_name,last_name, 'oldman' as label from employee_demographics where age >40 and gender= 'male'
union
select first_name,last_name, 'oldlady' as label from employee_demographics where age >40 and gender= 'female'
union
select first_name, last_name, 'highly paid emp' as label from employee_salary where salary >70000
order by first_name,last_name;

-- case statements

select first_name,last_name,age,
case
 when age <=30 then 'young'
 when age between 31 and 50 then 'OLD'
end as age_bracket
 from employee_demographics;
 
 -- solve: pay increase and bonus if <50000=5% if>50000=7% if finance  =10% bonus
 
 select first_name,last_name,salary,
case
 when salary < 50000 then salary + (salary*0.05)
 when salary > 50000 then salary + (salary*0.07)
end as new_salary,
case
	when dept_id=6 then salary + (salary*0.10)
end
 from employee_salary;

-- string functions

select Length('skyfall');

select first_name,length(first_name)
from employee_demographics
order by 2;

select upper('sky');
select lower('Sky');
select upper(last_name),lower(first_name) from employee_demographics;

select rtrim ('   sky   ');
select ltrim ('   sky   ');

select first_name, substring(first_name,3,2) from employee_demographics;

select first_name, replace(first_name,'a','z') from employee_demographics;

select first_name, locate('an',first_name) from employee_demographics;

SELECT first_name, last_name, CONCAT(first_name, ' ', last_name) AS full_name 
FROM employee_demographics;

-- subqueries

select * from employee_demographics 
where employee_id IN 
	(select employee_id
		from employee_salary
        where dept_id=1);

select first_name, salary, (select avg(salary)
from employee_salary)
from employee_salary;


select gender, avg(age), max(age), min(age),count(age)
from employee_demographics
group by gender;

select * 
from
(select gender, avg(age), max(age), min(age),count(age)
from employee_demographics
group by gender);


-- window functions
-- diff between group by and window functions
-- 1. writing with group by
select gender, avg(salary)
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id
group by gender;
-- 2. writing with window functions
select gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id
;

select dem.first_name,gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id;

select dem.first_name,gender,salary, sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id;

-- row number
select dem.employee_id, dem.first_name,gender,salary, row_number() over()
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id;


select dem.employee_id, dem.first_name,gender,salary, row_number() over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id;

-- rank
select dem.employee_id, dem.first_name,gender,salary, row_number() over( partition by gender order by salary desc) as row_num,
rank()over( partition by gender order by salary desc) as rank_num
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id;

-- dense rank
select dem.employee_id, dem.first_name,gender,salary,
row_number() over( partition by gender order by salary desc) as row_num,
rank()over( partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) dense_rank_num
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id;

-- cte common table expressions

WITH cte_example AS
(
select gender,avg(salary), max(salary), min(salary), count(salary)
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id
group by gender
)
select * from cte_example;


WITH cte_example AS
(
select gender,avg(salary) avg_sal, max(salary) max_sal, min(salary) min_sal, count(salary) count_sal
from employee_demographics dem
join employee_salary sal
on dem.employee_id=sal.employee_id
group by gender
)
select avg(max_sal) from cte_example;


WITH cte_example AS
(
select employee_id,gender,birth_date
from employee_demographics dem
where birth_date > '1985-01-01'
),
cte_example2 as
(
select employee_id,salary
from employee_salary
where salary > 50000
)
select * from cte_example
join  cte_example2
on cte_example.employee_id=cte_example2.employee_id;

-- temp tables

create temporary table temp_table
(
first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(50)
);

insert into temp_table 
values('Alex','freberg','Lord of the Rings: The Two Towers');

select * from temp_table;

create temporary table salary_over_50k
select * from employee_salary where salary > 50000;

select * from salary_over_50k;

-- stored procedures

create procedure large_salaries()
select * from employee_salary
where salary >= 50000;

call large_salaries();

DELIMITER $$
create procedure large_salaries2()
BEGIN	
    select * from employee_salary
	where salary >= 50000;
	create procedure large_salaries()
	select * from employee_salary
	where salary >= 50000;
END $$
DELIMITER ;

call large_salaries2();


-- triggers and events

delimiter $$
create trigger employee_insert
	after insert on employee_salary
    for each row 
begin
	 insert into employee_demographics(employee_id,first_name,last_name)
     values (new.employee_id,new.first_name,new.last_name);
end $$
delimiter ;

insert into employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
values (13,'jean-ralphio','saperstein','exntertainement 720 ceo',1000000, null);

select * from employee_demographics;

-- events

select * from employee_demographics;

delimiter $$
create event delete_retriees
on schedule every 30 second
do
begin
	select * 
    from employee_demographics
    where age >=60;
end $$
delimiter ;

show variables like 'event%';