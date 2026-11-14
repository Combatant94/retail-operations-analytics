UK Retail Operations Analytics

An end-to-end retail analytics project: cleaning messy data in Python, storing it in MySQL, answering business questions with SQL, testing a better sales forecast, and presenting the results in a report and a Power BI dashboard.

All data in this project is synthetic. It was generated to look like a UK retailer with 6 stores, food and clothing. It is not real company data.

Why I built this

I work in retail and want to move into a data role. I asked a Lead Data & Insight Manager in retail analytics which problems matter most to a retailer. He pointed me to these:

Sales and availability (empty shelves)
Food waste, and how much of it comes from bad forecasts
Clothing bought in too large amounts and sent to the outlet
Store profit, and fixed vs variable costs

This project answers those questions using the data.

Dashboard

Overview page Forecasting page

The Overview page has a store filter: the cards and the waste chart change with the store you pick. The forecast and profit charts always show all 6 stores, so you can compare them.

What I found
Sales: £6.07M in total. City Centre is the biggest store (£1.89M).
Empty shelves: £80K in lost sales. Station Square is the worst (empty 6.4% of the time, £23.7K lost).
Forecasts: Station Square's forecast is 12% too low (empty shelves). Market Lane's is 11% too high (more waste).
Food waste: £83.6K. Three products with a 1-day shelf life (a sandwich, a salad bowl and croissants) make up 72% of the waste cost.
Clothing: about 1 in 5 items bought ends up in the outlet. Swimsuits (30.8%) and coats (29.1%) are the worst.
Profit: overall margin is 13.8%. Hilltop Village is the only store losing money (-3.0%). Its fixed costs are too high for its sales, and it would need about 13% more sales to break even.
Forecast test

I took one product at one store (a sandwich at Station Square) and tested simple forecasting methods on July to September 2026.

Method	Average error (units/day)
Same weekday, average of the last 4 weeks	4.57
Current store forecast	5.42
Same day last week	5.87
7-day moving average	9.23

Sales follow a strong weekly pattern (weekdays sell about 3x more than weekends), so looking at the same weekday works best. It was about 16% more accurate than the store forecast. The store forecast was also too low by about 5 units a day.

Files
File	What it does
products_cleaning.ipynb	Step 1: cleans the products table
sales_cleaning.ipynb	Step 2: cleans the sales table
food_supply_cleaning.ipynb	Step 3: cleans the food supply table
Report_Analysis.ipynb	Step 4: connects to MySQL, runs the SQL, makes the charts and the forecast test
retail_queries.sql	All the SQL queries, one section per business question
Summary_report.pdf	The written report in plain English
dashboard_page1.png, dashboard_page2.png	Screenshots of the Power BI dashboard
Tools

Python (pandas, matplotlib, statsmodels), MySQL, SQL (joins, CTEs, CASE WHEN), Power BI (DAX measures, relationships, slicers, conditional formatting), Jupyter.

Note on the data

The CSV files are not included to keep the project small. The notebooks show every step with its output, so you can follow the work without running it.

Contact

Mohd Nafees · Portfolio · LinkedIn
