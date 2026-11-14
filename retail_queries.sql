-- =====================================================================
-- UK Retail Operations Analytics: SQL queries
-- Database: MySQL (retail_ops)
-- All data is synthetic.
--
-- Q1  Which stores make the most money?
-- Q2  Which stores run out of stock most, and how much do we lose?
-- Q3  Which food categories waste the most, and what does it cost?
-- Q4  Is the forecast causing the waste and the empty shelves?
-- Q5  Which food products cost us the most in waste?
-- Q6  Fashion: which products do we buy too much of?
-- Q7  Which stores actually make a profit?
-- Q8  Daily data for the forecast test (one product, one store)
-- =====================================================================

-- Setup
CREATE DATABASE IF NOT EXISTS retail_ops;
USE retail_ops;

SHOW TABLES;
SELECT COUNT(*) FROM sales;   -- quick check that the data loaded


-- ---------------------------------------------------------------------
-- Q1. Which stores make the most money?
-- ---------------------------------------------------------------------
SELECT st.store_name,
       st.format,
       ROUND(SUM(s.revenue), 2) AS revenue
FROM sales s
JOIN stores st ON st.store_id = s.store_id
GROUP BY st.store_name, st.format
ORDER BY revenue DESC;


-- ---------------------------------------------------------------------
-- Q2. Which stores run out of stock most, and how much money do we lose?
-- stockout is a 0/1 column, so its average x 100 = share of days empty.
-- Lost sales are valued at selling price.
-- ---------------------------------------------------------------------
SELECT st.store_name,
       ROUND(AVG(f.stockout) * 100, 2)            AS stockout_pct,
       ROUND(SUM(f.lost_sales_units * p.price), 0) AS lost_sales_gbp
FROM food_supply f
JOIN products p ON p.sku = f.sku
JOIN stores st  ON st.store_id = f.store_id
GROUP BY st.store_name
ORDER BY lost_sales_gbp DESC;


-- ---------------------------------------------------------------------
-- Q3. Which food categories waste the most, and what does it cost?
-- Waste = expired + damaged units. Waste is valued at cost price.
-- ---------------------------------------------------------------------
SELECT p.category,
       SUM(f.waste_expired + f.waste_damaged) AS waste_units,
       ROUND(SUM(f.waste_expired + f.waste_damaged) * 100
             / SUM(f.delivered_units), 1)     AS waste_pct,
       ROUND(SUM((f.waste_expired + f.waste_damaged) * p.cost_price), 0) AS waste_cost_gbp
FROM food_supply f
JOIN products p ON p.sku = f.sku
GROUP BY p.category
ORDER BY waste_cost_gbp DESC;


-- ---------------------------------------------------------------------
-- Q4. Is the forecast causing the waste and the empty shelves?
-- Demand = units sold + lost sales (what customers wanted).
-- Rows with no forecast (system outage) are left out.
-- ---------------------------------------------------------------------

-- Step 1: total forecast vs total demand per store
SELECT f.store_id,
       SUM(f.forecast_units)                   AS total_forecast,
       SUM(f.units_sold + f.lost_sales_units)  AS total_demand
FROM food_supply f
WHERE f.forecast_units IS NOT NULL
GROUP BY f.store_id;

-- Step 2: forecast bias next to waste and stockouts
-- Bias above 0 = forecast too high (waste). Below 0 = too low (empty shelves).
SELECT st.store_name,
       ROUND((SUM(f.forecast_units) - SUM(f.units_sold + f.lost_sales_units)) * 100
             / SUM(f.units_sold + f.lost_sales_units), 1)              AS forecast_bias_pct,
       ROUND(SUM(f.waste_expired + f.waste_damaged) * 100
             / SUM(f.delivered_units), 1)                               AS waste_pct,
       ROUND(AVG(f.stockout) * 100, 2)                                  AS stockout_pct
FROM food_supply f
JOIN stores st ON st.store_id = f.store_id
WHERE f.forecast_units IS NOT NULL
GROUP BY st.store_name
ORDER BY forecast_bias_pct DESC;


-- ---------------------------------------------------------------------
-- Q5. Which food products cost us the most in waste?
-- ---------------------------------------------------------------------
SELECT p.sku,
       p.product_name,
       p.category,
       p.shelf_life_days,
       SUM(f.waste_expired + f.waste_damaged) AS total_waste_units,
       ROUND(SUM((f.waste_expired + f.waste_damaged) * p.cost_price), 0) AS waste_cost
FROM food_supply f
JOIN products p ON p.sku = f.sku
GROUP BY p.sku, p.product_name, p.category, p.shelf_life_days
ORDER BY waste_cost DESC
LIMIT 5;


-- ---------------------------------------------------------------------
-- Q6. Fashion: which products do we buy too much of?
-- Season AW26 is left out because it has not finished yet.
-- Bought and outlet are added up separately first (CTEs), then joined,
-- so the totals are not doubled by the join.
-- ---------------------------------------------------------------------

-- Step 1: units bought per product
SELECT sku, SUM(bought_units) AS total_bought
FROM fashion_buy_plan
WHERE season_code <> 'AW26'
GROUP BY sku;

-- Step 2: units sent to the outlet per product
SELECT sku, SUM(units_to_outlet) AS total_outlet
FROM fashion_inventory
WHERE season_code <> 'AW26'
GROUP BY sku;

-- Step 3: put them together
WITH bought AS (
    SELECT sku, SUM(bought_units) AS total_bought
    FROM fashion_buy_plan
    WHERE season_code <> 'AW26'
    GROUP BY sku
),
outlet AS (
    SELECT sku, SUM(units_to_outlet) AS total_outlet
    FROM fashion_inventory
    WHERE season_code <> 'AW26'
    GROUP BY sku
)
SELECT p.product_name,
       b.total_bought,
       o.total_outlet,
       ROUND(o.total_outlet * 100 / b.total_bought, 1) AS outlet_pct
FROM bought b
JOIN outlet o   ON o.sku = b.sku
JOIN products p ON p.sku = b.sku
ORDER BY outlet_pct DESC;

-- Check: follow one item through a season to see when it went to the outlet
SELECT week_ending, closing_stock, units_to_outlet
FROM fashion_inventory
WHERE sku = 'SK10028' AND store_id = 6 AND size = '12' AND season_code = 'SS25'
  AND units_to_outlet > 0;


-- ---------------------------------------------------------------------
-- Q7. Which stores actually make a profit?
-- Profit = revenue - fixed costs - variable costs.
-- ---------------------------------------------------------------------

-- Check: which cost types are fixed and which are variable
SELECT DISTINCT cost_type, cost_behaviour
FROM store_costs;

-- Step 1: fixed and variable costs per store
SELECT store_id,
       ROUND(SUM(CASE WHEN cost_behaviour = 'Fixed'  THEN amount_gbp ELSE 0 END), 0) AS fixed_costs,
       ROUND(SUM(CASE WHEN cost_behaviour <> 'Fixed' THEN amount_gbp ELSE 0 END), 0) AS variable_costs
FROM store_costs
GROUP BY store_id;

-- Step 2: revenue per store
SELECT store_id, SUM(revenue) AS revenue
FROM sales
GROUP BY store_id;

-- Step 3: profit and margin per store
WITH costs AS (
    SELECT store_id,
           ROUND(SUM(CASE WHEN cost_behaviour = 'Fixed'  THEN amount_gbp ELSE 0 END), 0) AS fixed_costs,
           ROUND(SUM(CASE WHEN cost_behaviour <> 'Fixed' THEN amount_gbp ELSE 0 END), 0) AS variable_costs
    FROM store_costs
    GROUP BY store_id
),
rev AS (
    SELECT store_id, SUM(revenue) AS revenue
    FROM sales
    GROUP BY store_id
)
SELECT st.store_name,
       ROUND(r.revenue, 0)                                        AS revenue,
       c.fixed_costs,
       c.variable_costs,
       ROUND(r.revenue - c.fixed_costs - c.variable_costs, 0)     AS profit,
       ROUND((r.revenue - c.fixed_costs - c.variable_costs) * 100
             / r.revenue, 1)                                      AS margin_pct
FROM rev r
JOIN costs c   ON c.store_id = r.store_id
JOIN stores st ON st.store_id = r.store_id
ORDER BY margin_pct DESC;


-- ---------------------------------------------------------------------
-- Q8. Daily data for the forecast test
-- One product at one store. This feeds the forecasting part in Python.
-- ---------------------------------------------------------------------
SELECT f.date,
       f.forecast_units,
       f.units_sold + f.lost_sales_units AS demand
FROM food_supply f
JOIN products p ON p.sku = f.sku
JOIN stores st  ON st.store_id = f.store_id
WHERE p.product_name = 'Chicken & Bacon Sandwich'
  AND st.store_name = 'Station Square'
ORDER BY f.date;
