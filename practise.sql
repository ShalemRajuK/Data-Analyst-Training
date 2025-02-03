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

select * from employee_demographics order by gender, age DESc;




