# E-commerce Transaction Analytics with PostgreSQL, Python, and Tableau

This project simulates a real-world retail data pipeline and analytical framework using PostgreSQL for data modeling, Python for ETL, and Tableau Public for dashboarding. The goal is to uncover customer behavior, sales trends, and return patterns from raw sales transactions. This project mainly focuses on Data modelling (Schema, Dimension Table, Fact Table) concepts.

---

## Project Objectives

- Design a normalized data warehouse schema using **PostgreSQL**
- Build an **ETL pipeline** to clean and load raw Excel data into a dimensional model
- Create **fact and dimension tables** (Star Schema)
- Generate analytical views and metrics using advanced **SQL (CTEs, window functions)**
- Visualize insights like **weekly sales trends**, and **churn behavior**, etc using **Tableau Public**

---

## Tech Stack

- **Database**: PostgreSQL
- **ETL & Scripting**: Python (pandas, psycopg2)
- **Data Visualization**: Tableau Public
- **Data Source**: [UCI Online Retail Dataset](https://archive.ics.uci.edu/dataset/502/online+retail+ii)

---

## Data Model

The PostgreSQL database follows a star schema:

### Dimension Tables
- `dim_customer`: customer_id, country
- `dim_product`: product_id (StockCode), description
- `dim_date`: full_date, year, month, day, weekday

### 🔹 Fact Table
- `fact_sales`: transaction_id, customer_id, product_id, date_id, quantity, unit_price, total_price, weekend_flag (Created later)

---

## 🧪 Key Analyses Performed

| Analysis | SQL Tools Used | Output |
|---------|----------------|--------|
| **Churn Detection** | Date arithmetic, aggregation | Churned vs Active customers |
| **Returns Analysis** | Grouping by negative quantities | Return behavior per product/customer |
| **Weekly, Monthly Sales Trend** | Date dimension, grouping | Time series of sales volume |
| **Average Transactions by Country (Weekday vs Weekend)** | Boolean aggregates | Regional sales performance |

---

## 📈 Tableau Dashboards

📊 **[Click to View on Tableau Public](#)**  
_https://public.tableau.com/app/profile/pranjali.borse/viz/Online_Sales_UCI_Retail_Data/Dashboard1?publish=yes_

---
