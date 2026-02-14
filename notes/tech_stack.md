# Tech Stack
## S3 
Amazon S3 is a Object storage Service provided by AWS . I will use S3 buckets as data lake in this project to store all types of raw data.
## Snowflake 
Snowflake is the data warehouse that is used in this project. It will be a place where we store the data that is going to be used later on for reporting and analytics. 
### Why is it a good choice? 
- Because it is helpful for fast retrieval
- Scalability
- Integration-friendly with S3 and dbt
## dbt 
dbt is the data transformation tool that is used for the T part of the ELT. It helps build modular, maintainable and testable data pipelines using SQL.
### Why is it good choice ?
- Modular tranformation: Complex SQL Transformations are broken into smaller, reusable models that are easiser to manage.
- Testing : Supports built-in tests to ensure data accuracy
- Dependency Management: Automatically determines the order in which models should run based on dependencies.