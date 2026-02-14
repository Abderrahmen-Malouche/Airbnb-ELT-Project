# Data Ingestion

Up to this stage, I have uploaded the raw data into the **S3 bucket**. At the same time, I created **tables and schemas in Snowflake**: one for **bookings**, one for **listings**, and one for **hosts**.  

Now, the data needs to be moved from **S3 to Snowflake**.  

Here’s the first issue I ran into:  

S3 doesn’t automatically know that I own both the **AWS account** and the **Snowflake account**, so Snowflake doesn’t have permission to read the S3 bucket by default. To fix this, I need to provide access through either:  

- **Access Key ID & Secret Key**: Credentials that allow Snowflake to access the S3 bucket.  
- **Role-based access**: Create an **AWS IAM role** with permissions to read S3, and Snowflake can assume this role to access the data securely.  

## Staging

After setting up the authentication, another problem arises: our raw data is messy and inconsistent. Even though we **could move data directly from the S3 bucket to Snowflake tables**, it is a better approach to use **staging**.  

**Staging** is basically **not a table or schema** — it’s a place where files sit temporarily before being loaded into the tables.  

There are two types of stages:  

- **Internal Stage**: This is used when we upload the files ourselves into Snowflake using the `PUT` command.  
- **External Stage**: This points to a cloud storage bucket (like S3) and stores the credentials to access it.  

**Example of creating an external stage:**  
```sql
CREATE STAGE my_s3_stage
URL='s3://my-bucket-name/path/'
CREDENTIALS=(AWS_KEY_ID='XXXX' AWS_SECRET_KEY='YYYY');
