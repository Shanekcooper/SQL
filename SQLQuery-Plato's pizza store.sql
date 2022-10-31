SELECT *
FROM [Portfolio project]..order_details OD
JOIN [Portfolio project]..orders
ON OD.order_id = orders.order_id


-----Total revenue per pizza type
SELECT pizza_type_id, ROUND(SUM(price*quantity),2) AS Revenue_per_product
FROM [Portfolio project]..order_details OD
JOIN [Portfolio project]..pizzas
ON OD.pizza_id = pizzas.pizza_id
GROUP BY pizza_type_id
ORDER BY Revenue_per_product DESC

------Total revenue for the year
SELECT YEAR(date) AS Year, ROUND(SUM(price*quantity),2) AS Total_Revenue
FROM [Portfolio project]..order_details OD
JOIN [Portfolio project]..pizzas
ON OD.pizza_id = pizzas.pizza_id
JOIN [Portfolio project]..orders
ON OD.order_id = orders.order_id
GROUP BY YEAR(date)

-----Monthly Revenue
SELECT MONTH(date) AS Month, ROUND(SUM(price*quantity),2) AS Total_monthlyrevenue
FROM [Portfolio project]..order_details OD
JOIN [Portfolio project]..pizzas
ON OD.pizza_id = pizzas.pizza_id
JOIN [Portfolio project]..orders
ON OD.order_id = orders.order_id
GROUP BY MONTH(date)
ORDER BY Total_monthlyrevenue DESC

-----Total orders placed
SELECT COUNT(order_id) AS Number_of_Orders
FROM [Portfolio project]..orders

-----# of Pizzas sold
SELECT COUNT(quantity) AS Number_of_pizzas_sold
FROM [Portfolio project]..order_details

----Most Sold pizza
SELECT pizza_id, COUNT(pizza_id) AS Pizza_sold
FROM [Portfolio project]..order_details
GROUP BY pizza_id
ORDER BY Pizza_sold DESC

  -----Pizza sold by category
  SELECT category, COUNT(order_details.order_id) AS Amount_sold
FROM [Portfolio project]..pizza_types 
JOIN [Portfolio project]..pizzas
ON Pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN [Portfolio project]..order_details
  ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY Amount_sold DESC

-----Revenue by category
  SELECT category, ROUND(SUM(price*quantity),2) AS Total_Revenue
FROM [Portfolio project]..pizza_types 
JOIN [Portfolio project]..pizzas
ON Pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN [Portfolio project]..order_details
  ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY Total_Revenue DESC

---Average order value
SELECT YEAR(date) AS Year, (SUM(price*quantity)/COUNT(orders.order_id))
FROM [Portfolio project]..order_details OD
JOIN [Portfolio project]..pizzas
ON OD.pizza_id = pizzas.pizza_id
JOIN [Portfolio project]..orders
ON OD.order_id = orders.order_id
GROUP BY YEAR(date)

----Busiest days of the week







----Most used ingredients
SELECT *
FROM [Portfolio project]..pizza_types


