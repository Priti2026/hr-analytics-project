use project;
select * from order_details;
select * from orders;
select * from pizzas;
select * from pizza_types;

select count(order_id) as total_orders from orders;

select sum(pizzas.price * order_details.quantity) as total_sales from pizzas
inner join order_details
on pizzas.pizza_id = order_details.pizza_id;

select pizza_types.name, pizzas.price from pizza_types
inner join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizza_types.name desc limit 2;

select pizzas.size, count(order_details.order_details_id) as Total_quantity from pizzas
INNER JOIN order_details
on pizzas.pizza_type_id = order_details.order_details_id
group by pizzas.size order by total_quantity desc;

select pizza_types.name, count(order_details.quantity) as total_quantity from pizza_types
inner join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_quantity desc limit 5;

select pizza_types.category, count(order_details.quantity) as Total_quantity
from pizza_types inner join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;

select hour(time) as hour, count(order_id) as total_orders
from orders 
group by hour(time) order by hour asc;

select category, count(name) as total_pizzas from pizza_types
group by category;

select avg(quantity) as average_number from (select orders.date,sum(order_details.quantity) as quantity
from orders inner join order_details
on order_details.order_id = orders.order_id
group by orders.date) as order_quantity;

select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types inner join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

select pizza_types.category, (sum(order_details.quantity * pizzas.price) / (select sum(order_details.quantity * pizzas.price)
as total_sales from order_details inner join pizzas
on pizzas.pizza_id = order_details.pizza_id)) * 100 as revenue_percentage
from pizza_types inner join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id inner join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue_percentage desc;

SELECT Date,
       SUM(revenue) OVER (ORDER BY date) AS cum_revenue
FROM (
    SELECT orders.date,
           SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
   INNER JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    INNER JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY orders.date
) AS sales;

With A AS
(Select pizza_types.category, pizza_types.name,
SUM(order_details.quantity * pizzas.price) AS revenue 
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
inner join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category, pizza_types.name)

Select Name, revenue from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from A) AS B 
where rn<=3 Order By rn Desc LIMIT 3;

Select Name, revenue from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from (Select pizza_types.category, pizza_types.name,
SUM(order_details.quantity*pizzas.price) AS revenue 
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
inner join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as A)as b
where rn<=3 LIMIT 3;


