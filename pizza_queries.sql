
--getting the least ordered pizza
SELECT MIN (od.pizza_id) 
	FROM order_details od
	JOIN orders o
	ON od.order_id = o.order_id;
	
--sorting the most common order according to quantity 	
SELECT od.pizza_id, MAX (od.quantity) AS quantity_of_order
	FROM order_details od
	JOIN orders o
	ON od.order_id = o.order_id
	GROUP BY (od.pizza_id)
	ORDER BY quantity_of_order DESC;

--converting the date column into readable date format
SELECT TO_CHAR (date, 'YYYY-MM-DD') AS new_date
	FROM orders;
	
--getting the month with the highest orders and sorting them
SELECT DATE_PART('month', date) AS month, MAX (order_id)
	 FROM orders
	 GROUP BY 1
	 ORDER BY 2 DESC;

--getting the most ordered pizza name
SELECT name ,  od.quantity
 FROM pizza_types pt
 JOIN pizzas p ON
 pt.pizza_type_id = p.pizza_type_id
 JOIN order_details od ON 
 p.pizza_id = od.pizza_id
 GROUP BY pt.name, od.quantity
 ORDER BY 2 DESC;

--using HAVING to get more than two orders 
SELECT name ,  od.quantity
	FROM pizza_types pt
	JOIN pizzas p ON
	pt.pizza_type_id = p.pizza_type_id
	JOIN order_details od ON 
	p.pizza_id = od.pizza_id
	GROUP BY pt.name, od.quantity
	HAVING SUM(od.order_id) >2
	ORDER BY 2 DESC;
	
--getting the most expensive pizza	
SELECT pt.name, p.price, p.size
	FROM pizza_types pt
	JOIN pizzas p ON
	pt.pizza_type_id = p.pizza_type_id
	JOIN order_details od ON 
	p.pizza_id = od.pizza_id
	GROUP BY 1,2,3
	ORDER BY 2 DESC;


-- using CONCAT to combine date and time columns
SELECT date, time,
	CONCAT(date, '/', time) AS date_time
	FROM orders;
	
--using DATE_TRUNC to get the month with the most sales	
SELECT Month, SUM(sales) AS sales
	FROM
(SELECT DATE_TRUNC('month',date) AS Month, order_details.quantity as sales
	FROM orders 
	JOIN order_details 
	ON orders.order_id = order_details.order_id
	GROUP BY 1,2
	ORDER BY 1) sub
GROUP BY 1
ORDER BY 2 DESC;

-- using CTE to get average monthly saes
WITH monthly_sales AS(
	SELECT Month, SUM(sales) AS sales, TRUNC(AVG(amount),2) as sale_amnt
	FROM
(SELECT DATE_TRUNC('month',date) AS Month, order_details.quantity as sales, pizzas.price as amount
	FROM orders 
	JOIN order_details 
	ON orders.order_id = order_details.order_id
 	JOIN pizzas 
 	ON order_details.pizza_id = pizzas.pizza_id 
	GROUP BY 1,2,3
	ORDER BY 1) sub
GROUP BY 1
ORDER BY 2 DESC)
SELECT * FROM monthly_sales

-- using WINDOW function to get the rank of pizzas by name
SELECT pizzas.pizza_id,
       pizza_types.name,
       pizzas.price,
       RANK() OVER (PARTITION BY pizza_types.name ORDER BY pizzas.price DESC) AS rank
	FROM pizzas 
	JOIN pizza_types
	ON pizzas.pizza_type_id = pizza_types.pizza_type_id
	ORDER BY rank;


-- running total sum of sales
SELECT order_id, SUM(quantity) OVER (ORDER BY order_id) AS running_total
		FROM order_details;