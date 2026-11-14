# UK Retail Operations Analytics

![Python](https://img.shields.io/badge/Python-pandas-3776AB?logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-SQL-4479A1?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Data](https://img.shields.io/badge/Data-Synthetic-lightgrey)

I work in retail and I'm moving into data. In this project I tried to look at a retailer the way a data team would: clean the data, store it in a database, answer real business questions, try to improve a forecast, and share the results in a report and a dashboard.

**Quick links:** [Read the report (PDF)](Retail_Operations_Analysis.pdf
) · [SQL queries](retail_queries.sql) · [Main analysis python notebook](Report_Analysis.ipynb)

> All the data here is **synthetic**. I generated it to look like a UK retailer with 6 stores selling food and clothing. It is not real company data.

---

## Where the questions came from

I asked a Lead Data & Insight Manager in retail analytics which problems matter most to a retailer. He pointed me to four areas:

1. **Sales and availability**: are shelves empty when customers want to buy?
2. **Food waste**: how much is thrown away, and is a bad forecast the cause?
3. **Clothing**: do we buy too much and end up sending it to the outlet?
4. **Store profit**: which stores make money once fixed and variable costs are included?

Everything in this project is built around those four questions.

---

## The dashboard

I built a two-page dashboard in Power BI. On the first page you can pick a store, and the cards and the waste chart update. I kept the forecast and profit charts showing all 6 stores, so you can always compare them. The second page shows the forecast test.

<img width="832" height="470" alt="Dashboard overview" src="https://github.com/user-attachments/assets/522f6176-3c8c-4f2f-b0a6-9a94a66626b2" />
<img width="831" height="466" alt="Dashboard screenshot" src="https://github.com/user-attachments/assets/540cb090-57ee-4cfb-a780-afa29feb5f34" />
<img width="837" height="466" alt="Dashboard forecasting page" src="https://github.com/user-attachments/assets/2c7fdd4b-aba3-4cf8-bb49-4a058cb3d6ff" />

---

## What I found

| Area | Finding |
|---|---|
| 💷 **Sales** | £6.07M in total. City Centre is the biggest store at £1.89M. |
| 🛒 **Empty shelves** | £80K of sales lost. Station Square is the worst: empty 6.4% of the time, £23.7K lost. |
| 📈 **Forecasts** | Station Square forecasts 12% too low, so shelves run empty. Market Lane forecasts 11% too high, so it wastes more. |
| 🥪 **Food waste** | £83.6K in total. Three products that only last one day (a sandwich, a salad bowl and croissants) make up 72% of it. |
| 👕 **Clothing** | About 1 in 5 items bought ends up in the outlet. Swimsuits (30.8%) and coats (29.1%) are the worst. |
| 🏬 **Profit** | Overall margin is 13.8%. Hilltop Village is the only store losing money (-3.0%). Its fixed costs are too high for its sales, and it needs about 13% more sales to break even. |

---

## Can the forecast be better?

I picked one product at one store (a sandwich at Station Square) and tested a few simple methods on July to September 2026:

| Method | Average error (units per day) |
|---|:---:|
| ✅ **Same weekday, average of the last 4 weeks** | **4.57** |
| Current store forecast | 5.42 |
| Same day last week | 5.87 |
| 7-day moving average | 9.23 |

Sales follow a strong weekly pattern. Weekdays sell about 3 times more than weekends, because it's a commuter store. So looking at the same weekday works best: it was about **16% more accurate** than the store forecast, and it won in all three months. The store forecast was also too low by about 5 sandwiches a day, which matches the empty shelves.

---

## What I would suggest

If this were real data:

1. Try the 4-week weekday method for short-life food, starting with sandwiches at Station Square.
2. Review Market Lane's forecast, which runs about 11% too high.
3. Focus on the few one-day products that cause most of the waste.
4. Buy fewer seasonal clothes up front and keep some budget back to reorder what sells.
5. Look at Hilltop's costs, or find ways to grow its sales by about 13%.

---

## How I did it

```
Raw CSV files  →  Python cleaning  →  MySQL  →  SQL analysis  →  Forecast test  →  Report + Power BI
```

| File | What it does |
|---|---|
| [`products_cleaning.ipynb`](products_cleaning.ipynb) | Step 1: cleans the products table |
| [`sales_cleaning.ipynb`](sales_cleaning.ipynb) | Step 2: cleans the sales table (repeats, mixed date formats, prices typed in pence) |
| [`food_supply_cleaning.ipynb`](food_supply_cleaning.ipynb) | Step 3: cleans the food supply table and fixes stock numbers that didn't add up |
| [`Report_Analysis.ipynb`](Report_Analysis.ipynb) | Step 4: connects to MySQL, runs the SQL, makes the charts and the forecast test |
| [`retail_queries.sql`](retail_queries.sql) | All my SQL queries, one section per business question |
| [`Summary_report.pdf`](Retail_Operations_Analysis.pdf) | The full written report, in plain English |

The CSV files aren't included to keep the repo small. Every notebook shows its output, so you can follow the work without running anything.

---

## Contact

**Mohd Nafees** · [Portfolio](https://combatant94.github.io) · [LinkedIn](https://www.linkedin.com/in/nafees-mohd-59863524b)
