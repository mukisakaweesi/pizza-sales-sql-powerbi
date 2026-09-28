-- Pizza sales analysis queries
-- Dialect: Microsoft SQL Server (T-SQL). DATENAME and TOP are SQL Server functions.
-- Table: pizza_sales (one row per pizza line in an order)
-- Converted from the original "SQL QUERIES.docx". Query logic is unchanged.

-- ============================================================
-- KPIs
-- ============================================================

-- Total revenue
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales;

-- Average order value
SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 1) AS Average_Order_Value
FROM pizza_sales;

-- Total pizzas sold
SELECT SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;

-- Total orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

-- Average pizzas per order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) /
            CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS average_pizza_per_order
FROM pizza_sales;

-- ============================================================
-- Trends
-- ============================================================

-- Daily trend for total orders
SELECT DATENAME(dw, order_date) AS order_day, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY DATENAME(dw, order_date);

-- Monthly trend for total orders
SELECT DATENAME(month, order_date) AS Month_name, COUNT(DISTINCT order_id) AS total_monthly_orders
FROM pizza_sales
GROUP BY DATENAME(month, order_date);

-- ============================================================
-- Category and size
-- ============================================================

-- Percentage of sales by pizza category
SELECT pizza_category,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS percentage_sales
FROM pizza_sales
GROUP BY pizza_category;

-- Percentage of sales by pizza size
SELECT pizza_size,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS percentage_sales
FROM pizza_sales
GROUP BY pizza_size;

-- Total pizzas sold by pizza category
-- Note: COUNT(*) counts order lines. Use SUM(quantity) to count pizzas.
SELECT pizza_category, COUNT(*) AS total_pizza_sales
FROM pizza_sales
GROUP BY pizza_category;

-- ============================================================
-- Best and worst sellers
-- ============================================================

-- Top 5 by revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_revenue DESC;

-- Top 5 by quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_quantity DESC;

-- Top 5 by number of orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_orders DESC;

-- Bottom 5 by revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_revenue ASC;

-- Bottom 5 by quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_quantity ASC;

-- Bottom 5 by number of orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_orders ASC;
