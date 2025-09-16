# HR-Data-Analysis-Project

Cleaning and analyzing employee data from 2000–2020 using **MySQL**, and creating **Power BI dashboards** to visualize trends in age, gender, race, location, job roles, and turnover.

## Files
- [`hr-dataset.csv`](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/blob/main/hr-dataset.csv) – Original dataset  
- [`data-cleaning.sql`](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/blob/main/data-cleaning.sql) – SQL queries for cleaning the dataset  
- [`data-analysis.sql`](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/blob/main/data-analysis.sql) – SQL queries for analysis  
- [`Analysis-Results/`](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/tree/main/Analysis-Results) – Query output files  
- [`hr-dashboard.pbix`](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/blob/main/hr-dashboard.pbix) – Power BI dashboard  

## Overview
This project helps understand workforce trends and turnover patterns over 20 years.

## Power BI Dashboard

### Page 1: Overview & Key Metrics  
![Dashboard Page 1](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/blob/main/Dashboard-Images/dashboard-page-1.png?raw=true)

This page highlights overall employee distribution, age groups, and gender breakdown.

### Page 2: Turnover & Tenure Insights  
![Dashboard Page 2](https://github.com/AkillerKavinda/HR-Data-Analysis-Project/blob/main/Dashboard-Images/dashboard-page-2.png?raw=true)

This page focuses on turnover rates by department, tenure averages, and employment trends over time.

## Key Questions  
The analysis addresses the following questions:  

1. What is the gender breakdown of employees in the company?  
2. What is the race/ethnicity breakdown of employees in the company?  
3. What is the age distribution of employees in the company?  
4. How many employees work at headquarters versus remote locations?  
5. What is the average length of employment for employees who have been terminated?  
6. How does the gender distribution vary across departments and job titles?  
7. What is the distribution of job titles across the company?  
8. Which department has the highest turnover rate?  
9. What is the distribution of employees across locations by state?  
10. How has the company's employee count changed over time based on hire and term dates?  
11. What is the tenure distribution for each department?

## Data Cleaning

The HR dataset was cleaned and prepared for analysis using MySQL:

- Renamed table `human resources` → `hr` and column `ï»¿id` → `emp_id`.  
- Converted `birthdate`, `hire_date`, and `termdate` from text to `DATE` format, handling multiple formats.  
- Added `age` column and calculated employee age.  
- Verified data types and checked for missing or inconsistent values.  

These steps ensured a clean, structured dataset ready for analysis.

## SQL Analysis

### 1. What is the gender breakdown of employees in the company?

```sql
SELECT gender, COUNT(*) AS count
FROM hr 
WHERE age > 18 AND termdate = ''
GROUP BY gender;
```

### 2. What is the race/ethnicity breakdown of employees in the company?

```sql
SELECT race, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = ''
GROUP BY race
ORDER BY count DESC;
```

### 3. What is the age distribution of employees in the company?

```sql
SELECT MIN(age) AS youngest, MAX(age) AS oldest
FROM hr
WHERE age > 18 AND termdate = '';
```

```sql
SELECT
  CASE
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  gender,
  COUNT(*) AS count
FROM hr 
WHERE age > 18 AND termdate = ''
GROUP BY age_group, gender
ORDER BY age_group;
```

### 4. How many employees work at headquarters versus remote locations?

```sql
SELECT location, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = ''
GROUP BY location;
```

### 5. What is the average length of employment for employees who have been terminated?

```sql
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date)/365), 0) AS avg_employment_length
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '' AND age >= 18;
```

### 6. How does the gender distribution vary across departments and job titles?

```sql
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = ''
GROUP BY department, gender
ORDER BY department;
```

### 7. What is the distribution of job titles across the company?

```sql
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = ''
GROUP BY jobtitle
ORDER BY jobtitle DESC;
```

### 8. Which department has the highest turnover rate?

```sql
SELECT department, COUNT(*) AS turnover_rate
FROM hr
WHERE age > 18 AND termdate IS NOT NULL
GROUP BY department
ORDER BY turnover_rate DESC;
```

```sql
SELECT 
  department, 
  total_count,
  terminated_count,
  terminated_count / total_count AS termination_rate
FROM (
  SELECT department, 
         COUNT(*) AS total_count,
         SUM(CASE WHEN termdate <> '' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
  FROM hr
  WHERE age > 18 
  GROUP BY department
) AS a
ORDER BY termination_rate DESC;
```

### 9. What is the distribution of employees across locations by state?

```sql
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate <> ''
GROUP BY location_state 
ORDER BY count DESC;
```

### 10. How has the company's employee count changed over time based on hire and term dates?

```sql
SELECT DISTINCT YEAR(hire_date) AS year, COUNT(*)
FROM hr
GROUP BY year
ORDER BY year;
```

```sql
SELECT
  year, 
  hires, 
  terminations,
  hires - terminations AS net_change,
  (hires - terminations) / hires * 100 AS net_change_percent
FROM (
  SELECT YEAR(hire_date) AS year,
         COUNT(*) AS hires,
         SUM(CASE WHEN termdate <> '' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
  FROM hr 
  WHERE age > 18 
  GROUP BY YEAR(hire_date)
) AS a
ORDER BY year ASC;
```

### 11. What is the tenure distribution for each department?

```sql
SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date)/365), 0) AS avg_tenure
FROM hr
WHERE age > 18 AND termdate <> ''
GROUP BY department;
```

## Summary of Findings

1. The gender breakdown shows a balanced workforce: ~8.9K male, ~8K female, and 481 non-conforming employees.

2. The race/ethnicity breakdown is predominantly White, followed by Two or More Races, and Black or Afriacan American. 

3. Most employees are aged between 35 - 44. 

4. Around 13K employees work at headquarters, while 4K are based in remote locations.

5. The average length of employment for terminated employees is approximately 8 years.

6. Gender distribution across departments is fairly balanced overall but generally there are more males then females.

7. The company has a wide range of job titles, but a few roles dominate the structure.  
   - Most common titles include:  
     - Research Assistant II (608)  
     - Business Analyst (552)  
     - Human Resources Analyst II (477)  
     - Research Assistant I (408)  
     - Account Executive (386)  
   → These roles represent the largest employee groups, while many other titles appear in smaller numbers.

8. The auditing department has the highest turnover rate.

9. Most of the employees are located in the Ohio state (3108) followed by Pennysilvenia (174), and Illinois (135) while Wisconsin has the least (57).

10. The company's net change percent has increased over the years. 

11. Average tenure varies slightly across departments.  
    - Engineering, Services, Sales, Support, R&D, and Business Development all average **11 years**.  
    - Product Management, HR, Auditing, Training, Accounting, and Marketing average **10 years**.  
    - Legal has the shortest average tenure at **9 years**.  
    → Most departments show strong retention, with Engineering and Services leading in tenure.
