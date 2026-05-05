-- 1. How much does each customer contribute in terms of total orders and revenue?

select customer_id,
count(order_id) as total_orders,
sum(revenue) as total_revenue
from shopify_analysis
group by customer_id;

-- 2. What is the average revenue generated per order (Average Order Value)?

select 
sum(revenue) / count(distinct order_id) as avg_order_value
from shopify_analysis;

-- 3. Which products generate the highest revenue, and how do they rank compared to others?

select product_id,
sum(revenue) as total_revenue,
rank() over (order by sum(revenue) desc) as revenue_rank
from shopify_analysis
group by product_id;

-- 4. Which products are frequently returned?

select product_id,
count(*) as total_orders,
sum(case when is_returned = 'Yes' then 1 else 0 end) as returned_orders
from shopify_analysis
group by product_id
order by returned_orders desc;

-- 5. What is the return rate per product?

select product_id,
count(*) as total_orders,
sum(case when is_returned = 'Yes' then 1 else 0 end) * 1.0 / count(*) as return_rate
from shopify_analysis
group by product_id
order by return_rate desc;

-- 6. Which products generate high revenue but low profit?

select product_id,
sum(revenue) as total_revenue,
sum(profit) as total_profit
from shopify_analysis
group by product_id
having sum(profit) < 0.2 * sum(revenue)
order by total_revenue desc;

-- 7. Identify repeat customers (customers with more than 1 order)

select customer_id,
count(order_id) as total_orders
from shopify_analysis
group by customer_id
having count(order_id) > 1;

-- 8.  What is the most purchased product for each customer?

select *
from(
    select customer_id, product_id,
    sum(revenue) as total_spent,
    rank() over (partition by customer_id order by sum(revenue) desc) as rank_per_customer
    from shopify_analysis
    group by customer_id, product_id
) as sub
where rank_per_customer = 1;

-- 9. Who are the top 10 most profitable customers?

select customer_id,
sum(profit) as total_profit
from shopify_analysis
group by customer_id
order by total_profit desc
limit 10;

-- 10. Which customers have spent more than the average customer?

select customer_id, sum(revenue) as total_spent
from shopify_analysis
group by customer_id
having sum(revenue) > (
    select avg(total_spent)
    from(
        select customer_id, sum(revenue) as total_spent
        from shopify_analysis
        group by customer_id
    ) as sub
);











