# UK Retail Operations Analytics

An end-to-end retail analytics project: cleaning messy data in Python, storing it in MySQL, answering business questions with SQL, testing a better sales forecast, and presenting the results in a report and a Power BI dashboard.

> **All data in this project is synthetic.** It was generated to look like a UK retailer with 6 stores, food and clothing. It is not real company data.

## Why I built this

I work in retail and want to move into a data role. I asked a Lead Data & Insight Manager in retail analytics which problems matter most to a retailer. He pointed me to these:

1. Sales and availability (empty shelves)
2. Food waste, and how much of it comes from bad forecasts
3. Clothing bought in too large amounts and sent to the outlet
4. Store profit, and fixed vs variable costs

This project answers those questions using the data.

## Dashboard
<img width="832" height="470" alt="Screenshot 2026-11-14 at 12 44 34" src="https://github.com/user-attachments/assets/522f6176-3c8c-4f2f-b0a6-9a94a66626b2" />
![Forecasting page](dashboard/dashboard_page2.png)

The Overview page has a store filter: the cards and the waste chart change with the store you pick. The forecast and profit charts always show all 6 stores, so you can compare them.

## What I found

- **Sales:** £6.07M in total. City Centre is the biggest store (£1.89M).
- **Empty shelves:** £80K in lost sales. Station Square is the worst (empty 6.4% of the time, £23.7K lost).
- **Forecasts:** Station Square's forecast is 12% too low (empty shelves). Market Lane's is 11% too high (more waste).
- **Food waste:** £83.6K. Three products with a 1-day shelf life (a sandwich, a salad bowl and croissants) make up 72% of the waste cost.
- **Clothing:** about 1 in 5 items bought ends up in the outlet. Swimsuits (30.8%) and coats (29.1%) are the worst.
- **Profit:** overall margin is 13.8%. Hilltop Village is the only store losing money (-3.0%). Its fixed costs are too high for its sales, and it would need about 13% more sales to break even.

## Forecast test

I took one product at one store (a sandwich at Station Square) and tested simple forecasting methods on July to September 2026.

| Method | Average error (units/day) |
|---|---|
| Same weekday, average of the last 4 weeks | **4.57** |
| Current store forecast | 5.42 |
| Same day last week | 5.87 |
| 7-day moving average | 9.23 |

Sales follow a strong weekly pattern (weekdays sell about 3x more than weekends), so looking at the same weekday works best. It was about **16% more accurate** than the store forecast. The store forecast was also too low by about 5 units a day.

## Files

| File | What it does |
|---|---|
| `1_products_cleaning.ipynb` | Cleans the products table |
| `2_sales_cleaning.ipynb` | Cleans the sales table |
| `3_food_supply_cleaning.ipynb` | Cleans the food supply table and loads the clean data into MySQL |
| `4_report_analysis.ipynb` | SQL queries, charts and the forecast test |
| `data/` | Raw and clean CSV files |
| `powerbi_data/` | Query results used by the dashboard |
| `report/Retail_Operations_Analysis.pdf` | The written report in plain English |
| `dashboard/` | Power BI file (.pbix), PDF and screenshots |

## Tools

Python (pandas, matplotlib, statsmodels), MySQL, SQL (joins, CTEs, CASE WHEN), Power BI (DAX measures, relationships, slicers, conditional formatting), Jupyter.

## How to run it

1. Install MySQL and create a database.
2. Run the cleaning notebooks in order (1 to 3). Notebook 3 loads the tables into MySQL.
3. Run `4_report_analysis.ipynb`. It asks for your MySQL password when it connects, so no password is saved in the code.
4. Open `dashboard/retail_operation.pbix` in Power BI Desktop.

## Contact

Mohd Nafees · [Portfolio](https://combatant94.github.io) · [LinkedIn](https://www.linkedin.com/in/nafees-mohd-59863524b)
