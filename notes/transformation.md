## Transformations with dbt

After initializing dbt and creating the connection with my Snowflake account, the **first step in the transformation layer** is to define the **sources**.

The sources are linked to the **raw tables already populated in Snowflake**, which were loaded earlier from the S3 bucket. These raw tables represent the initial state of the data and should not be modified directly.

---

### Defining Sources

Creating sources allows me to explicitly declare where the raw data is coming from and treat it as **read-only input** for all transformations.

By using sources, I can:
- Clearly separate **raw data** from transformed data
- Add data quality and freshness checks on the raw tables
- Make the transformation logic easier to understand and maintain

At this stage, the sources point to raw tables such as:
- listings
- hosts
- bookings

These tables act as the **starting point** for all downstream models.

---

## Bronze Layer

After defining the sources, the next step is to create the **bronze layer**, which represents the **first transformation layer** in the dbt project.

The bronze layer is built directly on top of the sources and contains lightly transformed versions of the raw data.

---

### Materialization in the Bronze Layer

In the bronze layer, the models are **materialized as tables**.

This means that when dbt runs:
- Each bronze model is executed once
- The result is stored as a **physical table in Snowflake**

Example:
- `listings_bronze` → Snowflake table
- `hosts_bronze` → Snowflake table
- `bookings_bronze` → Snowflake table

These tables physically exist in Snowflake and can be queried directly.

---

### Why Use Table Materialization in Bronze

Using `table` materialization in the bronze layer is important because:

- **Performance**  
  Raw data can be large, and rebuilding logic repeatedly would be expensive.

- **Stability**  
  Bronze tables act as a stable snapshot of cleaned raw data.

- **Separation of concerns**  
  Raw sources remain untouched, and all transformations start from bronze.

- **Reusability**  
  Silver and gold models can safely build on bronze tables.

---

### What Exists in Snowflake After Bronze Runs

After running dbt, the following objects exist in Snowflake:

- Raw tables (loaded from S3, declared as sources)
- Bronze tables created by dbt:
  - `listings_bronze`
  - `hosts_bronze`
  - `bookings_bronze`

At this point:
- Sources → represent raw tables (read-only)
- Bronze models → physical tables created by dbt

This establishes a clean and reliable base for deeper transformations in the next layers.

## Custom Schema Naming and Macros

As the dbt project grows and multiple layers are introduced (bronze, silver, gold), managing schemas becomes important. By default, dbt generates schema names automatically, but this can quickly become messy and hard to control.

To solve this, I use a **custom schema naming strategy**.

---

### generate_schema_name Macro

`generate_schema_name` is a **dbt macro** that allows me to control how schemas are created in Snowflake.

Instead of letting dbt decide the schema name, this macro lets me:
- Organize models by layer (bronze, silver, gold)
- Keep schemas clean and predictable
- Avoid manually setting schema names in every model

With this approach, dbt automatically places models into the correct schema based on their folder or configuration.

---

### Why This Is a Good Approach

Using a custom `generate_schema_name` macro helps because:

- **Consistency**  
  All models follow the same schema naming rules.

- **Scalability**  
  New models automatically land in the correct schema.

- **Cleaner warehouse structure**  
  Snowflake schemas clearly reflect the data layers.

- **Less configuration repetition**  
  No need to hardcode schema names in every model.

---

### What Are Macros in dbt?

Macros in dbt are **reusable pieces of logic written in Jinja**.

In simple terms:
> A macro is like a function for SQL.

Macros allow me to:
- Reuse logic across models
- Avoid duplication
- Add dynamic behavior to SQL and configurations

Macros are usually used when:
- Logic is repeated in multiple places
- Behavior needs to change dynamically
- Default dbt behavior needs to be customized

The `generate_schema_name` macro is a perfect example of this.

---
## Jinja Templating in dbt

dbt uses **Jinja** as a templating engine to make SQL **dynamic and reusable**.

In simple terms:
> Jinja allows me to write SQL that adapts based on variables, environments, and configurations, instead of being hard-coded.

## Silver Layer

After the bronze layer, where the data is cleaned and standardized, the next step is the **silver layer**.

The silver layer is where the data becomes **business-ready**. At this stage, the data is already clean, so the focus shifts to **structure, enrichment, and efficiency**, rather than basic cleaning.

---

### Materialization in the Silver Layer

In this project, silver models are **materialized as incremental tables**.

Incremental materialization means:
- The table is created once
- On subsequent runs, only **new or updated records** are processed
- Existing data is preserved

This is especially useful in real-world projects where data grows over time and full refreshes would be expensive.

---

### Incremental Keys (Unique Keys)

Each incremental model uses a **unique key** to identify records.

Examples:
- `booking_id` for bookings
- `listing_id` for listings
- `host_id` for hosts

The unique key allows dbt to:
- Detect new records
- Update existing ones when needed
- Avoid duplicates

This makes the silver layer reliable and idempotent.

---

## What was done in the Silver Layer

Even though the data is clean after bronze, silver is where meaningful improvements happen.


###  Added Derived Columns 

Silver is the right place for **simple derived fields**, such as:
- `total_booking_cost = booking_amount + cleaning_fee + service_fee`
- `is_long_stay = nights_booked >= 7`
- `is_active_listing`

These are reusable fields that gold models can build upon.

## Using Macros in the Silver Layer
To make the project more professional and reusable, macros is introduced in the silver layer.

## Metadata-Driven Pipelines

As data pipelines grow in size and complexity, hardcoding logic directly into SQL models becomes difficult to maintain. This is where **metadata-driven pipelines** come into play.

A metadata-driven pipeline is a pipeline where **behavior is controlled by configuration and metadata**, rather than by rewriting transformation logic every time requirements change.

---

### What Is Metadata?

Metadata is “data about data”. In a data pipeline, metadata can include:
- Which tables should be processed
- Load types (full vs incremental)
- Column-level rules
- Business thresholds
- Enable/disable flags
- Freshness expectations

Instead of embedding these rules directly in SQL, they are stored in:
- YAML files
- Seed tables
- Configuration models
- dbt variables

---

### Why Metadata-Driven Pipelines Became Popular

Metadata-driven pipelines became popular as companies faced several challenges:

- **Too much duplicated logic**  
  The same SQL patterns repeated across models.

- **Frequent requirement changes**  
  Business rules changed faster than engineers could rewrite code.

- **Scalability issues**  
  Adding new datasets required copying and modifying existing pipelines.

- **Maintenance overhead**  
  Small changes required touching many models.

Metadata-driven design addresses these problems by **separating logic from configuration**.

---

### How This Relates to dbt

dbt naturally supports metadata-driven pipelines through:
- YAML files
- Variables (`var()`)
- Macros
- Seeds
- Model configurations

Instead of changing SQL, you change metadata — and dbt adapts the pipeline behavior automatically.

---

### Examples in This Project

Even in this project, metadata-driven concepts are already being used:

- **Materializations** defined in `dbt_project.yml`
- **Incremental logic** controlled by configuration
- **Macros** that apply reusable logic
- **Sources** defined declaratively in YAML
- **Business rules** abstracted into macros

These are all early forms of metadata-driven design.

---

### Metadata-Driven Gold Layer

In the gold layer, metadata-driven design becomes especially powerful.

Examples:
- Defining which dimensions should be included in the OBT
- Controlling aggregation levels through configuration
- Managing KPI definitions centrally
- Toggling metrics on/off without rewriting SQL

This allows analytics models to evolve without breaking downstream consumers.

---

### Why Metadata-Driven Pipelines Are a Good Practice

- **Flexibility**  
  Pipelines adapt to change without code rewrites.

- **Reusability**  
  One macro or model can serve many datasets.

- **Consistency**  
  Business logic is applied uniformly.

- **Scalability**  
  New sources or metrics can be added easily.

- **Maintainability**  
  Less code, fewer bugs, easier reviews.

---

### How This Complements the OBT

The One Big Table (OBT) provides a **stable, analytics-ready output**.

Metadata-driven design ensures:
- The OBT can evolve safely
- Metrics can be added or modified without refactoring
- The pipeline remains clean and extensible

Together, they form a robust and production-oriented gold layer.



# Gold Layer: From OBT to Fact & Dimension Tables (Using Snapshots – SCD Type 2)

After building the **OBT (One Big Table)** in the gold layer, the next logical step is to design **analytics-ready models**:  
**fact tables** and **dimension tables**.

In this project, I chose to use **snapshots** to handle **Slowly Changing Dimensions (SCD Type 2)**, because some entities (like hosts or listings) can change over time, and I want to **preserve history**, not overwrite it.

## What Is Slowly Changing Dimension (Type 2)?

SCD Type 2 means:

- We **do not overwrite old values**
- Every change creates a **new row**
- We track:
  - when the record was valid
  - which record is current

So instead of losing history, we keep it.

Example (Host response rate changes):

| host_id | response_rate | valid_from | valid_to   | is_current |
|---------|---------------|------------|------------|------------|
| 123     |       85      | 2023-01-01 | 2024-03-01 |    false   |
| 123     |       92      | 2024-03-01 |    NULL    |    true    |

---

## Why Use Snapshots for SCD Type 2

Snapshots are designed exactly for this use case.

They:
- Compare current data vs previous state
- Detect changes automatically
- Store historical versions
- Add metadata columns for time validity

Instead of writing complex merge logic, dbt handles it.

---

## What a Snapshot Is (Conceptually)

A snapshot:
- Runs on a schedule
- Looks at a **source query**
- Tracks changes based on a **unique key**
- Saves versions when values change

It creates a **history table**, not a model you overwrite.

---

## Snapshot Strategy Choices

There are two main snapshot strategies:

### 1. Timestamp Strategy
Use when you have a reliable `updated_at` column.

```sql
strategy: timestamp
updated_at: updated_at
