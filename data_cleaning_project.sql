-- Data Cleaning

select *
from layoffs;

create table layoffs_staging
like layoffs;

select * 
from layoffs_staging;

insert layoffs_staging
select * 
from layoffs;

select *,
row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,'date') as row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * 
from duplicate_cte 
where row_num > 1;


select * 
from layoffs_staging
where company = 'Oyster';




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from  layoffs_staging2;


Insert into layoffs_staging2
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging;  


delete
from  layoffs_staging2
where row_num>1;

select * 
from  layoffs_staging2
where row_num>1;

-- standardizing data

select  distinct(Trim(company))
from  layoffs_staging2;

select  company, Trim(company)
from  layoffs_staging2;

update layoffs_staging2
set company = Trim(company);

select * from
layoffs_staging2;

select  distinct(industry)
from  layoffs_staging2
order by 1;

select distinct(location)
from layoffs_staging2
order by 1;

select distinct(country)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like 'united states%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select distinct(country)
from layoffs_staging2
order by 1;

select `date` from layoffs_staging2;

select date, 
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2	
set date = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` DATE;

select * from layoffs_staging2;

-- working with blanks and null

select * from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;


select distinct industry
from layoffs_staging2
where industry is NULL 
or industry = '';

select * 
from layoffs_staging2
where industry is NULL 
or industry = '';

update layoffs_staging2
set industry = null
where industry = '';


select * from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;


delete from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

select * 
from layoffs_staging2;

alter table
layoffs_staging2 drop column row_num;


-- Exploratary Data Analysis

select * 
from layoffs_staging2;

select  max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off=1
order by total_laid_off desc;

select * 
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`), Max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by Year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from rolling_total;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company,Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by company asc;

select company,Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by 3 desc;


with company_year (company,years,total_laid_off) as
(
select company,Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
)
select * , 
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
order by ranking asc;

with company_year (company,years,total_laid_off) as
(
select company,Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
),company_year_rank as
(select * , 
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * 
from company_year_rank
where ranking<=5;

