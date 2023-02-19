
-- Which sub-category have higher than average shipping time

with cte as (select "Order ID"::text                            as order_id,
                    to_date("Order Date", 'dd.mm.yyyy')         as order_date,
                    to_date("Ship Date", 'dd.mm.yyyy')          as shipping_date,
                    "Category"::text                            as category,
                    "Sub-Category"::text                        as sub_category,
                    datediff('days', order_date, shipping_date) as days_to_ship
             from schema."Test_sample")


-- How are the 10 customers with most profitable orders

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

-- Quarter over Quarter and Year over Year sales overview

select round(sum(replace("Profit", ',', '.')), 2)                 as sales,
       date_trunc('quarter', to_date("Order Date", 'dd.mm.yyyy')) as order_quarter,
       date_trunc('year', to_date("Order Date", 'dd.mm.yyyy'))    as order_year,
       case
           when lead(sales) over (order by order_quarter) > sales
               then true
           else false end                                         as has_grown_QoQ,
       case
           when lead(sales) over (order by order_year) > sales
               then true
           else false end                                         as has_grown_YoY,
       round(sales - lag(sales) over (order by order_quarter), 2) as QoQ_difference
from schema."Test_sample"
group by 2, 3
order by order_quarter
