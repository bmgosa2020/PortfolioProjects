# Data Cleaning
select *
from albums;

# Creating back-up table to preserve original data

create table albums_staging
like albums;

select *
from albums_staging;

insert albums_staging
select *
from albums;

# Using CTE to check for duplicate values

select *,
ROW_NUMBER() OVER(
partition by year, artist, album, label, sales, certification) as row_num
from albums_staging;

with duplicate_cte as 
(
select *,
ROW_NUMBER() OVER(
partition by year, artist, album, label, sales, certification) as row_num
from albums_staging
)
select *
from duplicate_cte
where row_num > 1;

# No duplicates were found, no delete needed

# changing certification column to integer and renaming
update albums_staging
set certification = substring_index(certification, ' ', 1)
where certification LIKE '%Platinum%';

alter table albums_staging
modify certification INT;

alter table albums_staging
change certification Platinum_Certifications int;


