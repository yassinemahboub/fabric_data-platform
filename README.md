# ⚙️ Microsoft Fabric End-to-End Data Platform PoC  

This project is a **production-grade proof of concept** for building a scalable, modular, and metadata-driven **data platform on Microsoft Fabric**. It demonstrates how to automate ingestion, transformation, and warehousing using industry best practices, all orchestrated with **notebooks**, **pipelines**, and **dynamic SQL configuration**.

Leveraging the open-source **Northwind retail database**, this architecture simulates an **enterprise-grade data stack** capable of supporting real-time business reporting, analytics, and data governance for any retail organization.

---

## 🧱 Solution Architecture

At its core, this PoC implements the **Medallion Architecture** in Microsoft Fabric with full support for:

- **Bronze Layer**: Raw, schema-aligned ingestion from SQL  
- **Silver Layer**: Cleaned, deduplicated, and partitioned datasets  
- **Gold Layer**: Dimensional models (star schema) for BI tools like Power BI

All ingestion and transformation logic is dynamically driven via a centralized **SQL metadata catalog**, making the entire pipeline **extensible**, **parameterized**, and **low-code**.

![Fabric Architecture Diagram](https://raw.githubusercontent.com/yassinemahboub/fabric_data-platform/refs/heads/main/IMAGES/Project%20Archi.png)

---

## 🎯 Objectives of This PoC

- ✅ Automate the **entire ELT lifecycle** in Microsoft Fabric  
- ✅ Demonstrate **reusability via metadata configuration**  
- ✅ Enable **incremental ingestion with watermarking**  
- ✅ Implement **structured transformation logic** (Silver → Gold)  
- ✅ Provide **enterprise-grade logging and auditability**  
- ✅ Deliver a **BI-ready analytical data warehouse**

---

## 🧩 Core Components

### 1. SQL Metadata & Control Layer

This layer acts as the **brain of the platform**, driving logic from metadata while separating configuration from execution.

- **`SQLCatalogTable`**: Master configuration table — defines table names, load types, keys, watermark columns, partition logic, and modeling roles (`Fact`, `Dimension`, `Bridge`)
- **`sp_UpdateSQLWatermark`**: Updates the last ingested value (ID or datetime) to support incremental loading
- **`SQLTableLogs` & `sp_SQLInsertTableLog`**: Tracks end-to-end execution status across Bronze, Silver, Gold layers — including rows inserted, runtime, and semantic refresh flags

---

### 2. Pipelines

#### 🧭 `NORTHWIND_PARENT` – Orchestration Controller

- Retrieves metadata from the SQL catalog  
- Iterates over active tables  
- Triggers the child ingestion pipeline  
- Orchestrates the Silver and Gold notebooks  
- Filters results, handles error logging, updates watermarks

#### 🔄 `NORTHWIND_CHILD` – Table Ingestion Engine

- Determines load type (initial or incremental)  
- Computes new watermark based on column and type  
- Executes delta or full extraction from SQL Server  
- Returns structured metadata to parent for downstream orchestration

---

### 3. Notebooks

#### 📘 `NB_SILVER_NORTHWIND` – Standardization Layer

- Applies **data type normalization**  
- Adds time-based partitioning columns (`YEAR`, `MONTH`, `DAY`)  
- Cleans, trims, and deduplicates Bronze data

#### 🟡 `NB_GOLD_NORTHWIND` – Dimensional Modeling

- Builds **star schema**: fact, dimension, and bridge tables  
- Joins keys and flattens models for BI consumption  
- Final outputs include: `facts_orders`, `dim_products`, `dim_customers`, and more

---

## 📊 Gold Layer Schema Highlights

| Table Name                | Type      |
|--------------------------|-----------|
| `dim_employees`          | Dimension |
| `dim_suppliers`          | Dimension |
| `facts_orders`           | Fact      |
| `facts_orderdetails`     | Fact      |
| `bridge_employeeterritories` | Bridge |

These curated tables are **BI-ready**, designed for use in semantic models and performance dashboards (e.g., Power BI, Looker, or Synapse).

---

## 🧠 What This PoC Proves

This project validates that **Microsoft Fabric** is capable of supporting:

- Metadata-driven data platforms  
- SQL-based configuration and dynamic orchestration  
- Real-world ingestion and transformation complexity  
- Full-lifecycle observability (logs, watermarks, audits)  
- Best practices in **Lakehouse architecture** using Delta format, partitioning, and layering

It serves as a **template for enterprise-scale solutions** in:

- Retail and e-commerce analytics  
- Supply chain intelligence  
- Customer 360 platforms  
- Sales and territory management  

---

## 📦 Technologies & Patterns Used

| Technology         | Role                                 |
|--------------------|--------------------------------------|
| **Microsoft Fabric** | Platform backbone                   |
| **Fabric Pipelines** | Orchestration (parent-child logic)  |
| **Fabric Notebooks** | Spark-based transformation scripts  |
| **Delta Lake**        | Storage format for Lakehouse       |
| **SQL Server**        | Source DB & metadata engine        |
| **T-SQL Procedures**  | Watermarking & audit logging       |

---

## 🚀 Getting Started

1. **Deploy SQL artifacts**  
   Create the metadata and logging tables (`SQLCatalogTable`, `SQLTableLogs`) and deploy the procedures for watermarking and logging.

2. **Configure ingestion**  
   Populate `SQLCatalogTable` with the Northwind tables you want to ingest.

3. **Trigger orchestration**  
   Run the `NORTHWIND_PARENT` pipeline from the Microsoft Fabric workspace.

4. **Monitor progress**  
   Use `SQLTableLogs` to monitor ingestion status across layers and validate row counts.

5. **Query BI-ready tables**  
   Use the `retail` schema in your Lakehouse to explore Gold-layer dimensional models and build semantic layers for reporting.

---




