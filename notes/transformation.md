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

