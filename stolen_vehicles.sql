USE stolen_vehicles_db;

-- number of vehicles stolen each year

select year(date_stolen) as year, count(vehicle_id) as number_of_vehicles
from stolen_vehicles
group by year(date_stolen);

-- number of vehicles stolen each month

select year(date_stolen) as year, month(date_stolen) as month, count(vehicle_id) as number_of_vehicles
from stolen_vehicles
group by year, month 
order by year, month;

select year(date_stolen) as year, month(date_stolen) as month, day(date_stolen) as day, count(vehicle_id) as number_of_vehicles
from stolen_vehicles
where month(date_stolen) = 4
group by year, month, day 
order by year, month, day;

-- number of vehicles stolen each day of the week

select dayofweek(date_stolen) as dow, count(vehicle_id) as number_of_vehicles
from stolen_vehicles 
group by dayofweek(date_stolen)
order by dow;


-- Replacing the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)

select dayofweek(date_stolen) as dow, 
       case when dayofweek(date_stolen) = 1 then 'Sunday'
            when dayofweek(date_stolen) = 2 then 'Monday'
            when dayofweek(date_stolen) = 3 then 'Tuesday'
            when dayofweek(date_stolen) = 4 then 'Wednesday'
            when dayofweek(date_stolen) = 5 then 'Thursday'
            when dayofweek(date_stolen) = 6 then 'Friday'
       else 'Saturday' end as day_of_week,
count(vehicle_id) as number_of_vehicles
from stolen_vehicles 
group by dayofweek(date_stolen), day_of_week
order by dow;

---------------------------------------------------------------------------------------------------------------------

 -- vehicle types that are most often and least often stolen
 
 select vehicle_type, count(vehicle_id) as number_of_vehicles
 from stolen_vehicles
 group by vehicle_type
 order by number_of_vehicles desc
 limit 5;
 
  select vehicle_type, count(vehicle_id) as number_of_vehicles
 from stolen_vehicles
 group by vehicle_type
 order by number_of_vehicles asc
 limit 5;
 
 
 -- For each vehicle type, find the average age of the cars that are stolen
 
 select vehicle_type, avg(year(date_stolen)- model_year) as avg_age
 from stolen_vehicles
 group by vehicle_type
 order by avg_age desc;
 
 
 -- For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
 
  select vehicle_type,
         case when make_type = 'luxury' then 1 else 0 end as 'luxury'
  from stolen_vehicles sv
  left join make_details md 
  on sv.make_id = md.make_id;
  
 with cte1 as (select vehicle_type,
         case when make_type = 'luxury' then 1 else 0 end as 'luxury'
  from stolen_vehicles sv
  left join make_details md 
  on sv.make_id = md.make_id)
  select vehicle_type, sum(luxury)/count(luxury) * 100 as pct_luxury
  from cte1
  group by vehicle_type
  order by pct_luxury desc;
 
 -- Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen
 
 select color , count(vehicle_id) as number_of_vehicles
 from stolen_vehicles
 group by color
 order by number_of_vehicles desc;
 
 
  select vehicle_type , count(vehicle_id) as number_of_vehicles,
        sum(case when color = 'Silver' then 1 else 0 end) as Silver,
		sum(case when color = 'White' then 1 else 0 end) as White,
		sum(case when color = 'Black' then 1 else 0 end) as Black,
		sum(case when color = 'Blue' then 1 else 0 end) as Blue,
		sum(case when color = 'Red' then 1 else 0 end) as Red,
		sum(case when color = 'Grey' then 1 else 0 end) as Grey,
		sum(case when color = 'Green' then 1 else 0 end) as Green,
		sum(case when color in ('Gold', 'Brown', 'Yellow', 'Orange', 'Purple', 'Cream', 'Pink') then 1 else 0 end) as other
from stolen_vehicles
group by vehicle_type
order by number_of_vehicles desc
limit 10;
 
 
 ------------------------------------------------------------------------------------------
 
 
 -- number of vehicles that were stolen in each region
 
 select l.region, count(sv.vehicle_id) as number_of_vehicles
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 group by l.region;
 
 
 -- Combine the previous output with the population and density statistics for each region
 
 select l.region, count(sv.vehicle_id) as number_of_vehicles, l.population, l.density
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 group by l.region, l.population, l.density
 order by number_of_vehicles desc;
 
 -- First find the three most and least dense regions, then look into the vehicle types stolen in those regions
 
  select l.region, count(sv.vehicle_id) as number_of_vehicles, l.population, l.density
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 group by l.region, l.population, l.density
 order by l.density desc;
 
 select sv.vehicle_type, count(sv.vehicle_id) as number_of_vehicles
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 group by sv.vehicle_type;
 
 select sv.vehicle_type, count(sv.vehicle_id) as number_of_vehicles
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 where l.region in ('Auckland', 'Nelson', 'Wellington')
 group by sv.vehicle_type
 order by number_of_vehicles desc;
 
 
  select sv.vehicle_type, count(sv.vehicle_id) as number_of_vehicles
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 where l.region in ('Otago', 'Gisborne', 'Southland')
 group by sv.vehicle_type
 order by number_of_vehicles desc;
 
 
 
 
 
 
 ( select 'High Density', sv.vehicle_type, count(sv.vehicle_id) as number_of_vehicles
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 where l.region in ('Auckland', 'Nelson', 'Wellington')
 group by sv.vehicle_type
 order by number_of_vehicles desc
 limit 5)
 union
 (select 'Low Density', sv.vehicle_type, count(sv.vehicle_id) as number_of_vehicles
 from stolen_vehicles sv 
 left join locations l 
 on sv.location_id = l.location_id
 where l.region in ('Otago', 'Gisborne', 'Southland')
 group by sv.vehicle_type
 order by number_of_vehicles desc
 limit 5);