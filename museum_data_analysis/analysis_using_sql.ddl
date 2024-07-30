-- 1. Fetch all the paintings which are not displayed on any musuems ?
select * from work where museum_id is null;

-- 2 are there museums without any paintings
select * from museum m
where not exists (select 1 from work w  where w.museum_id=m.museum_id);

-- 3) How many paintings have an asking price of more than their regular price?	
select * from product_size where sale_price > regular_price ;

--4) Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size where sale_price < (0.50 * regular_price);

--5) which canva size costs the most ?
with cte as (select *, rank() over(order by sale_price desc) as rn from product_size)
select c.size_id, height, width, label, regular_price, sale_price from cte c join canvas_size cs on c.size_id = cs.size_id where rn = 1 ;

-- 6) identify the museums with invalid city information in the given dataset
select * from museum where city like '[0-9]%';


-- 7) museum hours table has 1 invalid entry. identify it and remove it. 
delete from museum_hours where day in (
select distinct day from museum_hours where day not in ('monday','tuesday','wednesday','thursday','friday','saturday','sunday'));

-- 8) fetch the top 10 most famous painting subject
with famous as (select s.subject, count(*) as no_of_paintings, rank() over(order by count(*)  desc) as rn from subject s join work w on s.work_id = w.work_id
group by s.subject)
select top 10 * from famous

-- 9) Identify the museums which are open on both Sunday and Monday. Display museum name, city
select name, city from museum m join museum_hours mh1 on m.museum_id = mh1.museum_id where mh1.day ='sunday' and exists 
(select * from museum_hours mh2 where mh2.museum_id = mh1.museum_id and mh2.day ='monday');


-- 10) How many museums are open every single day?

select count(1) as total_museums from (select museum_id, count(*) as total_count from museum_hours group by museum_id having count(*) = 7) as s;

-- 11) top 5 most popular museum (popularity based on no of paintings in museum)
with popularity as (select m.museum_id, count(*) as total_no_of_paintings from museum m join work w on m.museum_id = w.museum_id 
group by m.museum_id)
select top 5 name, city, country,total_no_of_paintings 
from popularity p join museum m on p.museum_id = m.museum_id order by total_no_of_paintings desc;
