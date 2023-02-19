--checking what sub-category have higher than average shipping time

with cte as (select "Order ID"::text                            as order_id,
                    to_date("Order Date", 'dd.mm.yyyy')         as order_date,
                    to_date("Ship Date", 'dd.mm.yyyy')          as shipping_date,
                    "Category"::text                            as category,
                    "Sub-Category"::text                        as sub_category,
                    datediff('days', order_date, shipping_date) as days_to_ship
             from schema."Test_sample")

select category,
       sub_category,
       round(avg(days_to_ship) over (partition by category), 2)                     as avg_cat_ship_time,
       round(avg(days_to_ship) over (partition by sub_category), 2)                 as avg_sub_cat_ship_time,
       case when avg_sub_cat_ship_time > avg_cat_ship_time then true else false end as higher_than_avg
from cte



-- top 10 customer with most profitable orders

with profits as (select distinct "Order ID"::text                           as order_id,
                                 "Customer Name"                            as customer_name,
                                 count("Quantity"::int)                     as order_size,
                                 round(sum(replace("Profit", ',', '.')), 2) as profit
                 from schema."Test_sample"
                 group by 1, 2)

select *
from profits
order by profit desc
limit 10


