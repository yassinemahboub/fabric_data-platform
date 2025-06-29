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



