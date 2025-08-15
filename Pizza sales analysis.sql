use dominos;


select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;


-- Total Revenue
select  round(sum(pizzas.price*order_details.quantity)) as Total_Rev from order_details
join
pizzas on
pizzas.pizza_id = order_details.pizza_id;

-- Total number of order and total sales from those orders

select count(pizza_id) as total_order, sum(price) as Total_Revenue from pizzas;

-- Avg price per order

select count(pizza_id) as total_order, sum(price) as Total_Revenue, sum(price)/count(pizza_id) as Avg_Price_Per_Order from pizzas;

-- Which size of pizzas generating highest sales

select size,sum(price) as Size_based_Sales from pizzas
group by size
order by sum(price) desc;

-- List the top 5 most ordered pizza types along with their quantities.

select pizza_id, sum(quantity) as Total_Quantity from order_details
group by pizza_id
order by Total_Quantity desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category and avg amount of pizzas ordered.

SELECT 
    pizza_types.category, count(pizzas.pizza_type_id) as categorywise_pizzas_quantity, round(avg(pizzas.price),2) as avg_price
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY avg(pizzas.price) DESC;

-- Determine the distribution of orders by hour of the day.

select t1.meal_type, count(t1.meal_type) as order_shifts from(select *,
case
when order_time between '00:00:00' and '10:59:59' then 'Morning_Order'
when order_time between '11:00:00' and '19:59:59' then 'Evening_Order'
when order_time between '20:00:00' and '23:59:59' then 'Night_Order'
else 'Unknown_timing' end as meal_type
from orders) as t1
group by t1.meal_type;

select count(order_id) from orders;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity)  as total_quantity_order, ROUND(
        SUM(order_details.quantity) * 100.0 / 
        SUM(SUM(order_details.quantity)) OVER (), 
        1
    ) AS share_percentage from order_details
join 
pizzas
on pizzas.pizza_id = order_details.pizza_id
join 
pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category
order by sum(order_details.quantity);

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select distinct(order_date), count(order_id) as Order_countperday from orders
group by order_date
order by Order_countperday desc;



select t1.order_cal, count(t1.order_id) as total_order_count from 
( select *,
case
when order_date between '2015-01-01' and '2015-01-31' then 'Jan_Order'
when order_date between '2015-02-01' and '2015-02-28' then 'Feb_Order'
when order_date between '2015-03-01' and '2015-03-31' then 'Mar_Order'
when order_date between '2015-04-01' and '2015-04-30' then 'Apr_Order'
when order_date between '2015-05-01' and '2015-05-31' then 'May_Order'
when order_date between '2015-06-01' and '2015-06-30' then 'Jun_Order'
when order_date between '2015-07-01' and '2015-07-31' then 'Jul_Order'
when order_date between '2015-08-01' and '2015-08-31' then 'Aug_Order'
when order_date between '2015-09-01' and '2015-09-30' then 'Sept_Order'
when order_date between '2015-10-01' and '2015-10-31' then 'Oct_Order'
when order_date between '2015-11-01' and '2015-11-30' then 'Nov_Order'
when order_date between '2015-12-01' and '2015-12-31' then 'Dec_Order'
else 'date_not_available' end as order_cal 
from orders) as t1
group by t1.order_cal;


-- Determine the top 3 most ordered pizza types based on revenue.

select pizzas.pizza_type_id, round(sum(pizzas.price*order_details.quantity)) as Total_Rev from order_details
join
pizzas on
pizzas.pizza_id = order_details.pizza_id
group by pizzas.pizza_type_id
order by Total_Rev desc limit 3;


-- Rev based on Veg or Non veg pizza and Rev share

select t1.pizza_type, 
round(sum(order_details.quantity * pizzas.price)) as Total_sales, 
round(sum(order_details.quantity * pizzas.price)*100/sum(sum(order_details.quantity * pizzas.price))over(),2) as Rev_Share
from ( select *,
case 

when ingredients regexp 'chicken|bacon|ham|capocollo|anchovies|beef|prosciutto|salami' then 'Nonveg_pizza'
else 'veg_pizza'
end as pizza_type
from pizza_types) as t1
join pizzas
on t1.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by t1.pizza_type;


-- when ingredients like '%chicken%'  then 'nonveg'
-- when ingredients like '%bacon%'  then 'nonveg'
-- when ingredients like '%ham%'  then 'nonveg'
-- when ingredients like '%capocollo%'  then 'nonveg'
-- when ingredients like '%anchovies%'  then 'nonveg'
-- when ingredients like '%beef%'  then 'nonveg'
-- when ingredients like '%prosciutto%'  then 'nonveg'
-- when ingredients like '%salami%'  then 'nonveg'
