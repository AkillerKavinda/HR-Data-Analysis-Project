Create database HrProject;

Use HrProject;

-- Changing the name of the table to hr 

alter table `human resources` rename to hr;

select * from hr;

-- Changing the column name of the id

alter table hr
change column ï»¿id emp_id varchar(20) null;

select * from hr;

-- Checking the datatypes 

describe hr;

-- Changing the birthdate from text to a date (Year, Month, Day)

select birthdate from hr;

set sql_safe_updates = 0;

update hr
set birthdate = case 
	when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else null
end;

set sql_safe_updates = 1;

select birthdate from hr;

-- Change the data type of the birthdate column 

alter table hr
modify column birthdate date;

-- Changing the hiredate from text to a date and changing the data type to date

update hr
set hire_date = case 
	when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    else null
end;

select hire_date from hr;

alter table hr
modify column hire_date date;

-- Extracting the date from termdate and changing the data type to date

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d%H:%i:%s UTC'))
where termdate is not null and termdate != '';

select termdate from hr;

alter table hr 
modify column termdate date;

describe hr;

-- Adding an age column to our table

 alter table hr
 add column age int;
 
 select * from hr;
 
 update hr
 set age = timestampdiff(year, birthdate, curdate());
 
 select * from hr;
 
 -- Checking for the employees with the min and max age values
 
 select min(age) as YoungestAge, max(age) as OldestAge
 from hr;
 
 select count(*)
 from hr
 where age <=18;