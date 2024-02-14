use my;
 
 select * from sheet1;
 select * from rate ;  
 select * from country;
 alter table sheet1  modify column datekey_opening date ;
 select count(*) as `Rows` from sheet1;
 
 create table sheet1
 (restaurantid int,
 restaurantname varchar(255),
 country_code varchar(10),
 city varchar(255),
Cuisines varchar(255) ,
Currency varchar(255) ,
Has_Table_booking varchar(255) ,
Has_Online_delivery varchar(255) ,
Price_range varchar(255),
 Votes varchar(255) ,
 Average_Cost_for_two varchar(255) ,
 Rating varchar(255) ,
 Datekey_Opening date);
 -- # kpi 2 Build a Calendar Table using the Columns Datekey_Opening 
   -- A.Year B.Monthno C.Monthfullname D.Quarter(Q1,Q2,Q3,Q4) E. YearMonth ( YYYY-MMM) F. Weekdayno
   -- G.Weekdayname H.FinancialMOnth ( April = FM1, May= FM2  …. March = FM12)
   -- I. Financial Quarter ( Quarters based on Financial Month FQ-1 . FQ-2..)
   select date(datekey_opening) as dates,
   year(datekey_opening) as years ,
   month(datekey_opening) as monthno,
   monthname(datekey_opening) as monthnames, 
   concat('Q',quarter(datekey_opening))as quarters ,
   date_format(datekey_opening,'%Y-%b')as yearmonth,
   dayofweek(datekey_opening) as weekdayno,
   dayname(datekey_opening) as day,
   CASE 
when month(Datekey_Opening) = 4 then "FM1"
when month(Datekey_Opening) = 5 then "FM2"
when month(Datekey_Opening) = 6 then "FM3"
when month(Datekey_Opening) = 7 then "FM4"
when month(Datekey_Opening) = 8 then "FM5"
when month(Datekey_Opening) = 9 then "FM6"
when month(Datekey_Opening) = 10 then "FM7"
when month(Datekey_Opening) = 11 then "FM8"
when month(Datekey_Opening) = 12 then "FM9"
when month(Datekey_Opening) = 1 then "FM10"
when month(Datekey_Opening) = 2 then "FM11"
else "FM12"
END as Financial_Month, 

CASE 
when month(Datekey_Opening) between 1 and 3 then "FQ4"
when month(Datekey_Opening) between 4 and 6 then "FQ1"
when month(Datekey_Opening) between 7 and 9 then "FQ2"
else "FQ3"
END AS Financial_Quarter
   from sheet1
   order by date(datekey_opening);
 
 -- #kpi 3 Convert the Average cost for 2 column into USD dollars 
select sheet1.restaurantid, sheet1.city ,sheet1.currency,rate.usd,sheet1.average_cost_for_two, 
sheet1.average_cost_for_two * rate.usd as converted 
from sheet1 inner join  rate
on sheet1.currency = rate.currency; 

-- #kpi 4.Find the Numbers of Resturants based on City and Country.
	
    SELECT country.Countryname , sheet1.City , count(*) as RestroCount
    FROM sheet1
    inner join country 
    on sheet1.country_code= country.CountryID
    group by Countryname, City 
    order by Countryname, City ;
    
    
-- #kpi 5.Numbers of Resturants opening based on Year , Quarter , Month

	SELECT year (datekey_opening), 
    quarter (datekey_opening) , 
    month (datekey_opening) , count(*) as RestroCount 
    from sheet1 group by year (datekey_opening), 
    quarter(datekey_opening),month (datekey_opening)
    order by year(datekey_opening) ,quarter(datekey_opening) , month(datekey_opening) ;
 
-- #6. Count of Resturants based on Average Ratings.
select 
case
 when rating <=2 then "0-2" 
when rating <=3 then "2-3" 
when rating <=4 then "3-4" 
when Rating<=5 then "4-5" 
end rating_range,
count(restaurantid) 
from sheet1 
group by rating_range 
order by rating_range;
 
 -- #7. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select 
case
when price_range=1 then "0-500" 
when price_range=2 then "500-3000" 
when Price_range=3 then "3000-10000" 
when Price_range=4 then ">10000" 
end price_range,
count(restaurantid)
from sheet1 
group by price_range
order by Price_range;
 
-- #8.Percentage of Resturants based on "Has_Table_booking"
 SELECT 
    CONCAT(round(COUNT(CASE
                WHEN Has_table_booking= 'Yes' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS yes, 
            CONCAT(round(COUNT(CASE
                WHEN has_table_booking = 'no' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS no
            FROM sheet1;
   
   


-- # kpi 9 Percentage of Resturants based on "Has_Online_delivery"
  
  SELECT 
    CONCAT(round(COUNT(CASE
                WHEN Has_online_delivery= 'Yes' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS yes, 
            CONCAT(round(COUNT(CASE
                WHEN has_online_delivery = 'no' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS no
            FROM sheet1;
    
    -- kpi 10 
    select count( distinct cuisines) from  sheet1;
    
    select count(distinct city ) from sheet1;
    