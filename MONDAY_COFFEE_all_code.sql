                                             -- Monday coffee  ---  Data Analysist
select * from city;
select  * from  products;
select * from customers;
select * from sales;

                                            -------- Q.1-REPORTS & DATA ANALYSIS -----------


  Coffee Consumers Count
How many people in each city are estimated to consume coffee , given that 25% of the population does ??

select city_name , ROUND((population * 0.25 ) /1000000,2) as coffee_estimated_in_millions , city_rank
from city

ORDER BY  population desc;


    
 -- select city_name	,round((population*0.25)/1000000,1) as coffe_estimated_in_millions ,  city_rank
 from city
 order by coffe_estimated_in_millions desc 


----------------------- Q.2  Total Revenue from Coffee Sales ------------------------------
-- what is the total revenue gnerated from cofee sales across all cities in the last quarter of 2023 ??

select  
ci.city_name,
sum(s.total) as total_revenue
from sales as  s 
join customers as c 
on s.customer_id = c.customer_id
JOIN city as ci
on ci.city_id = c.city_id

  where  
  EXTRACT(year from sale_date)=2023
           AND 
		   EXTRACT(quarter from s.sale_date)=4

		group by ci.city_name  
		ORDER BY total_revenue desc ;


--------------------------------------------- SALES COUNT FRO EACH PRODUCT ----------------------------------------------
   --- HOW MANY UNITS OD EACH COFFEE PRODUCT HAVE BEEN SOLD ???---

select   city_name,total  from sales as s

join  customers as c
ON s.customer_id = c.customer_id
JOIN city ci 
 on ci.city_id = c.city_id
 

select  product_name  , COUNT(s.sale_id) as total_orders 
from products as p
LEFT JOIN 
   sales as s
 on p.product_id = s.product_id
 GROUP by product_name 
  order by  total_orders desc 

     ------------------------------------- WHAT IS THE AVERAGE SALES AMOUNT PER CITY --------------------------------------------
	                        --------what is the average sales amout per customer in each city ?---------------

  select ci.city_name , sum(s.total) as total_revenue,count(distinct s.customer_id)as total_customer,
    ROUND(sum(s.total)::numeric / count(distinct s.customer_id),3)::numeric as average_sale 
   from sales  as s 
   join customers as c 
  on s.customer_id = c.customer_id
  JOIN city as ci
  on ci.city_id = c.city_id 
  GROUP by 1
  ORDER by total_revenue DESC

            ----------------------------- City Population And Coffee Consumers-----------------------------
			----------Provide a list of Citites along With Their Populations and Estimated Coffee Consumers.--------------------


 select  ci.city_name , round((ci.population*0.25)/1000000::"numeric",2) as coffee_consumers ,
 count(c.customer_id)  AS total_cust , 
 s.total as total_income 
 
 from city  as ci 
 LEFT join customers as c
 on ci.city_id = c.city_id
 JOIN sales as s
 on s.customer_id = c.customer_id
 GROUP by  ci.city_name , s.total ,ci.population
 order by coffee_consumers
 ---------------------------------------------------
WITH city_table as 
( SELECT ci.city_name , round(ci.population*0.25 /1000000,2) as coffee_consumers  
from city as ci),



customers_table
AS
(	
    select   ci.city_name , count(distinct c.customer_id) as unique_cx 
	from sales as s
	join customers as c 
	on c.customer_id = s.customer_id
	JOIN city as ci 
	on ci.city_id = c.city_id
	GROUP by ci.city_name
	)


select 

  customers_table.city_name,
  city_table.coffee_consumers   as coffee_consumer_in_millions
  from city_table

  JOIN  customers_table 
  on city_table.city_name = customers_table.city_name
 


----------------------------  top selling products by city -----------------------------
---------------------------- what are the top 3 selling products in each city based on sales volume ??? ---------------------------

 SELECT * FROM (
				 select  count(  s.sale_id) as total_orders ,ci.city_name, p.product_name
				 ,dense_rank() OVER(partition by ci.city_name ORDER BY COUNT (s.sale_id)DESC ) AS RANK
				 from sales as s 
				 join products as p 
				 on s.product_id = p.product_id
				 join customers as c
				 on c.customer_id = s.customer_id
				 join city as ci 
				 on ci.city_id = c.city_id
				 group by ci.city_name, p.product_name 
 --ORDER by total_orders desc;
 )AS T1 
 WHERE rank <=3
 
------- ----------- -----------         --   Customer Segmentation by City -----------------------------------------------------
 ----------------    How many unique customers are there in each city who have purchased coffee products ?? --------------------------

	
SELECT    count( distinct c.customer_id) as unique_cx, ci.city_name, s.total   from sales as s 
 left join  customers as c 
on c.customer_id = s.customer_id

JOIN products as p
on p.product_id = s.product_id
join city as ci 
on ci.city_id = c.city_id
GROUP by ci.city_id,s.total
ORDER by  s.total desc;


select  ci.city_name ,
count(DISTINCT c.customer_id)as unique_cx
from  city as ci 
LEFT join	customers as c
ON c.city_id =ci.city_id
join 	sales as s 
on s.customer_id = c.customer_id 

where 
s.product_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
group by 1
							---------Q8------------ Average Sale vs Rent ---------------------------
				------------------- Find each City and their average sale per customer and avg rent per Customer--------------------

-- 				----CONCLUTION---------------------
with city_table
AS
(select ci.city_name, sum(s.total) as total_rvenue ,
 count(distinct s.customer_id) as total_customers,
 round(sum(s.total)::numeric/ count(distinct s.customer_id)::numeric ,2) as avg_sale_pr_customer
from city as ci
LEFT join 
customers as c
on c.city_id = ci.city_id 
join sales as s
on s.customer_id = c.customer_id

GROUP by 1),
 city_rent
 AS(
      select  city_name, estimated_rent
	  from city

 )
  select  cr.city_name 
     ,cr.estimated_rent,
	 ct.total_customers,
	 ct.avg_sale_pr_customer ,ROUND(cr.estimated_rent::"numeric"/ ct.total_customers::"numeric",2) as average_rent_per_customer
	 
  from city_rent as cr
  JOIN  city_table as ct
   ON  cr.city_name = ct.city_name
   ORDER BY  average_rent_per_customer desc;
   
------------------------------------------------Q.9 Monthly Sales Growth------------------------------------------------------
  ----- Sales growth rate: Calcualte the percentage growth (or decline) in sales over differnt time periods (monthly) by each city------




--------------------------------------Q.10 market potential analysis--------------------------------------------
 ---------------------------identify top 3 city based on highest sales, return city name , total sales , total rent , total customers ,
 --, estimate coffee consumptions

 

 with city_table
AS
(select ci.city_name, sum(s.total) as total_rvenue ,
 count(distinct s.customer_id) as total_customers,
 round(sum(s.total)::numeric/ count(distinct s.customer_id)::numeric ,2) as avg_sale_pr_customer
from city as ci
LEFT join 
customers as c
on c.city_id = ci.city_id 
join sales as s
on s.customer_id = c.customer_id

GROUP by 1),
 city_rent
 AS(
      select  city_name,
	  estimated_rent, 
	  round((population *25)/1000000,2) as estimated_coffee_con_in_millions
 from city 
 )
  select  cr.city_name ,total_rvenue,
  cr.estimated_rent as total_rent,ct.total_customers,
  ct.avg_sale_pr_customer 
  ,ROUND(cr.estimated_rent::"numeric"/ ct.total_customers::"numeric",2) as average_rent_per_customer
  ,estimated_coffee_con_in_millions
  from city_rent as cr
  JOIN  city_table as ct
   ON  cr.city_name = ct.city_name
   ORDER BY  average_rent_per_customer ;


   /* 
       -- Recommenadtion 

   City 1 : jaipur
      1.Avg rent per customer is very less ,  
	  2.and the revenue is good in this city you can inveist in another branch,
	  avg_sale per customer is also high
     
 City 2: Delhi 
    1.highest estimated coffee consumer 
	2.Hihest total customer which is 68
	3.avg rent per customer 330 (still under 500)

City 3: Jaipur

     1. Highest customer no which is  69
	 2. avg rent per customer is very less 156
     3. avg sales per customer is 11.6 k


	
 