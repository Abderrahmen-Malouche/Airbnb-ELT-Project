# End-to-End Cloud ELT Pipeline with AWS, Snowflake, dbt

![ELT Architecture Diagram](architecture diagram.png)

## Project Overview

This project demonstrates the design and implementation of a modern, end-to-end cloud ELT (Extract, Load, Transform) data pipeline using industry-standard data engineering tools.  
Raw Airbnb booking, listing, and host data is ingested from Amazon S3 into Snowflake, transformed using dbt following a medallion architecture (Bronze, Silver, Gold), and modeled into analytics-ready fact and dimension tables.

The project emphasizes scalability, data quality, modular transformations, and the usability of analytics, reflecting real-world data engineering best practices.

---

## Architecture & Tech Stack

- **Cloud Storage:** Amazon S3  
- **Data Warehouse:** Snowflake  
- **Transformation Layer:** dbt (Data Build Tool)  
- **Data Modeling:** Dimensional Modeling (Facts & Dimensions)  
- **Data Quality:** dbt built-in and custom generic tests  
- **Version Control:** Git & GitHub  

---

## Data Ingestion

Raw source data is stored in Amazon S3 and ingested into Snowflake using external stages.  
Secure access between AWS and Snowflake is configured using IAM credentials, ensuring Snowflake has controlled, read-only access to the S3 bucket.

Staging is used as an intermediate layer to:
- Decouple raw file ingestion from table loading
- Enable schema validation and error handling
- Support reprocessing without impacting downstream models

---

## Data Transformations with dbt

dbt is used as the transformation layer, applying ELT principles directly within Snowflake.  
Transformations are organized using a **medallion architecture** to improve clarity, maintainability, and scalability.

### Bronze Layer
The Bronze layer represents lightly cleaned data sourced directly from raw Snowflake tables.  
This layer focuses on:
- Data type casting
- Basic standardization
- Minimal business logic

### Silver Layer
The Silver layer applies core business logic and enrichment:
- Data normalization and consistency checks
- Derived metrics and flags (e.g., long stays)
- Incremental materializations for performance optimization
- Reusable dbt macros to avoid duplicated logic

### Gold Layer
The Gold layer provides analytics-ready datasets optimized for reporting and BI:
- One Big Table (OBT) for exploratory analysis
- Fact and dimension tables following dimensional modeling principles
- Slowly Changing Dimensions (Type 2) implemented using dbt snapshots

---

## Data Modeling

The project applies dimensional modeling best practices:
- **Fact tables** capture measurable business events such as bookings and revenue
- **Dimension tables** describe business entities such as hosts and listings

This approach ensures:
- High-performance analytical queries
- Clear and consistent business definitions
- Easy integration with BI and reporting tools

---

## Data Quality & Testing

Data quality is enforced directly within the warehouse using dbt tests:
- Built-in tests (`not_null`, `unique`)
- Custom generic tests for business rules (e.g., positive numeric values, valid percentage ranges)
- Column-level validation to prevent invalid data from reaching analytics layers

Reusable dbt macros are implemented to standardize transformations and testing logic, supporting CI/CD workflows and long-term maintainability.

---

## How to Run the Project

1. Clone the repository:
   ```bash
   git clone git@github.com:Abderrahmen-Malouche/Airbnb-ELT-Project.git
2. Configure Snowflake credentials in profiles.yml
3. Install dependencies:
  ```bash
     dbt deps
  ```
4. Run transformations:
  ```bash
  dbt run
  ```
6. Run data quality tests:
  ```bash
  dbt test
  ```
