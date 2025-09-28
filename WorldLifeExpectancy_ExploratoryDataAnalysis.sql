#World Life Expectancy Project ( Exploratory Data Analysis)

Select *
from world_life_expectancy
;

#Life expectancy for different countries based on min and max life expectancy
Select Country,	
	   min(`Life expectancy`), 
	   max(`Life expectancy`),
       round(max(`Life expectancy`)-min(`Life expectancy`),1) as Life_Increased_15_years
from world_life_expectancy
group by Country
Having min(`Life expectancy`)<>0
and max(`Life expectancy`)<>0
order by Life_Increased_15_years asc
;

#Life Expectancy changing over the years
select year, round(avg(`Life expectancy`),1)
from world_life_expectancy
where `Life expectancy` <>0
and `Life expectancy` <>0
group by year
order by year
;
#Result- over the period of time from 2007-2022 the life expectancy has increased by 4.8 years in the world

#Finding Corelation between the GDP and the Life expectancy for the countries

select Country, round(avg(`Life expectancy` ),1) as Life_exp, round(avg(GDP),1) as GDP
from world_life_expectancy
group by Country
having Life_exp >0
and GDP >0
order by GDP asc
;
#Result: The more the GDP of the countries have a very positive corelation with life expectancy which the countries with high GDP have very high Life expectancy 

select 
sum(case when GDP >= 1500 then 1 else 0 end ) high_GDP_Count,
avg(case when GDP >=1500 then `Life expectancy` else Null end) high_GDP_Life_Expectancy,
sum(case when GDP < 1500 then 1 else 0 end ) Low_GDP_Count,
avg(case when GDP <1500 then `Life expectancy` else Null end) Low_GDP_Life_Expectancy
from world_life_expectancy
;
#Result : Finding the average life expectancy of the countries with high GDP and low GDP says the countries with low GDP have less than 10years of life expectancy than compared to the countries with higher GDP.

#Corelation between the status of the countries and average life expectancy
Select status, round(avg(`Life expectancy`),2)
from world_life_expectancy
group by status
;

Select status, count(distinct Country),round(avg(`Life expectancy`),1)
from world_life_expectancy
group by status
;
#The query shows that the result are skewed a lot because of the number of developed countries

select Country, round(avg(`Life expectancy` ),1) as Life_exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by Country
having Life_exp >0
and BMI >0
order by BMI desc
;

#Finding insights on corelation between Life expectancy and adult mortatility by performing running total over the countries to calculate the total adult mortality over the years
Select Country, year, 
		`Life expectancy`, 
        `Adult Mortality`, sum(`Adult Mortality`) over(partition by Country order by year) as Rolling_Total
from world_life_expectancy
where Country like '%United%'
;

select *
from world_life_expectancy
;



