#World Life Expectancy Project (Data Cleaning)

select*
from world_life_expectancy
;
#Finding Duplicates and removing duplicates 
select country,year, concat(Country,year), count( concat(country,year))
from world_life_expectancy
group by country, year, concat(country, year)
having count( concat(country,year)) >1
;

select*
from(
select row_id,concat(Country,year),
row_number()over(partition by concat(country,year) order by concat(country,year)) as row_num
from world_life_expectancy
) as row_table
where row_num>1
;

delete from world_life_expectancy
where 
	row_id in (
    select row_id
from(
select row_id,concat(Country,year),
row_number()over(partition by concat(country,year) order by concat(country,year)) as row_num
from world_life_expectancy
) as row_table
where row_num>1
)
;

#Finding null values in the status column and populating it with other values 
select*
from world_life_expectancy
where status= ''
;

select distinct(status)
from world_life_expectancy
where status <>''
;

select distinct(country)
from world_life_expectancy
where status= 'Developing'
;

update world_life_expectancy
set status= 'Developing'
where country in (select distinct(country)
				from world_life_expectancy
				where status='Developing');
                
update world_life_expectancy t1
join world_life_expectancy t2
   on t1.country=t2.country
set t1.status= 'Developing'
where t1.status=''
and t2.status<>''
and t2.status='Developing'
;


select*
from world_life_expectancy
where Country= 'United States of America'
;

update world_life_expectancy t1
join world_life_expectancy t2
   on t1.country=t2.country
set t1.status= 'Developed'
where t1.status=''
and t2.status<>''
and t2.status='Developed'
;

#Fixing the null values in life expectancy column and populating its value with the avearge from the year above and year below it
select *
from world_life_expectancy
where `Life expectancy`=''
;

select t1.Country, t1.Year,t1.`Life expectancy`,
		t2.Country,t2.Year,t2.`Life expectancy`,
		t3.Country, t3.Year,t3.`Life expectancy`,
        round((t2.`Life expectancy` + t3.`Life expectancy` )/2,1)
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country= t2.Country
    and t1.Year=t2.Year - 1
join world_life_expectancy t3
	on t1.Country= t3.Country
    and t1.Year=t3.Year + 1
where t1.`Life expectancy`=''
;

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country= t2.Country
    and t1.Year=t2.Year - 1
join world_life_expectancy t3
	on t1.Country= t3.Country
    and t1.Year=t3.Year + 1
set t1.`Life expectancy`=round((t2.`Life expectancy` + t3.`Life expectancy` )/2,1)
where t1.`Life expectancy`=''
;



