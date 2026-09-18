## Data Warehouse & Exploratory Data Analysis Project

An end-to-end SQL Data Warehouse solution built on **Microsoft SQL Server (T-SQL)**. This project demonstrates modern Data Engineering principles by designing a multi-layered data architecture (Medallion Architecture) and conducting thorough Exploratory Data Analysis (EDA) on modeled data.

---

## 🏗️ Architecture Overview

The warehouse follows the **Medallion (Bronze / Silver / Gold)** architecture pattern to separate concerns between raw ingestion, data cleansing, and dimensional modeling:

* **Bronze Layer (Raw Ingestion):** Ingests source data as-is without modification to preserve raw history.
* **Silver Layer (Cleansing & Standardization):** Cleanses, standardizes data types, handles null values, and enforces business rules.
* **Gold Layer (Analytical Data Model):** Implements a Star Schema featuring Fact (`fact_sales`) and Dimension (`dim_customers`, `dim_products`) tables designed for reporting and business intelligence.

---

## 📂 Project Repository Structure

```text
DataWareHouse-Project-SQL/
├── datasets/                 # Raw source CSV files / data inputs
├── scripts/                  # DDL & Data pipeline transformation logic
│   ├── bronze/               # Raw table creation & loading scripts
│   ├── silver/               # Cleansing & data transformation scripts
│   └── gold/                 # Star-schema dimensional modeling views/tables
├── eda/                      # Exploratory Data Analysis Scripts
│   ├── 01_database_exploration.sql
│   ├── 02_dimension_exploration.sql
│   ├── 03_date_exploration.sql
│   ├── 04_measure_exploration.sql
│   ├── 05_magnitude_exploration.sql
│   └── 06_ranking_exploration.sql
└── README.md                 # Project Overview & Documentation

```

---

## 📊 Exploratory Data Analysis (EDA) Module

The `eda/` directory contains structured T-SQL scripts to analyze data quality, domain metrics, and performance distributions directly against the **Gold Layer**:

### **1. Database Exploration (`01_database_exploration.sql`)**

* Audits schema metadata, table types, and column definitions across all layers.
* Uses dynamic SQL to dynamically count and verify row totals across all tables in the `bronze` layer.

### **2. Dimension Exploration (`02_dimension_exploration.sql`)**

* Analyzes customer geographic distributions (Country, State, City) and demographic metrics.
* Evaluates product catalog hierarchies across categories and sub-categories.
* Validates 1:1 business key mappings to ensure zero duplicate key creation.

### **3. Date Exploration (`03_date_exploration.sql`)**

* Inspects historical date bounds, total years/months spanned, and detects data continuity gaps.
* Evaluates annual and monthly sales trends.
* Computes operational efficiency metrics like shipping lead times and fulfillment delays.

### **4. Measure Exploration (`04_measure_exploration.sql`)**

* Computes global sales metrics: Total Revenue, Average Order Value (AOV), and total units sold.
* Analyzes product pricing structures (minimum, maximum, average price points).
* Aggregates metrics at the unique basket/order level.

### **5. Magnitude Exploration (`05_magnitude_exploration.sql`)**

* Calculates revenue percentage contributions per product category and country using window aggregate functions.
* Segments customers into spending tiers (VIP, Mid-Tier, Low-Tier) to analyze revenue distribution.

### **6. Ranking Exploration (`06_ranking_exploration.sql`)**

* Employs T-SQL window functions (`DENSE_RANK`, `ROW_NUMBER`, `RANK`) to partition and rank top 5 products per category.
* Pinpoints top 10 global customers by lifetime spend.
* Identifies bottom-performing product items for potential catalog optimization.

---

## 🚀 How to Run the Scripts

1. **Prerequisites:**
* Microsoft SQL Server (2016 or newer)
* SQL Server Management Studio (SSMS) or Azure Data Studio


2. **Setup Warehouse & Pipelines:**
* Execute `scripts/bronze/` to ingest raw tables.
* Execute `scripts/silver/` to transform and cleanse data.
* Execute `scripts/gold/` to construct the star schema model.


3. **Run Exploratory Data Analysis:**
* Navigate to the `eda/` folder and execute scripts sequentially (`01` through `06`) inside SSMS to inspect system health and generate business insights.
