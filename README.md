# f1 2023 results data analyses using dbt

## Summary

- Create virtual env
- Read data from PostgreSQL to Pandas dataframe
- Transfer data from PostgreSQL to Snowflake
- Connect dbt and Snowflake
- Build dbt data pipelines
- Establish data quality tests

## Create virtual env

```shell
pip install virtualenv
virtualenv f1dbt
f1dbt\Scripts\activate
```

## Read data from PostgreSQL to Pandas dataframe

I have 2 tables in PostgreSQL. To read it in Pandas dataframe - execute step 1 from [migration.ipynb](migration.ipynb)

![raceresultsPandas](images\raceresultsPandas.png)

## Transfer data from PostgreSQL to Snowflake

First of all we need to create database, scema and dbt user in Snowflake

```sql
-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the `transform` role
CREATE ROLE IF NOT EXISTS transform;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Create the default warehouse if necessary
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='f1dbt'
  LOGIN_NAME='hannaf1'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE='transform'
  DEFAULT_NAMESPACE='F1.RAW'
  COMMENT='DBT user used for data transformation';
GRANT ROLE transform to USER dbt;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS F1;
CREATE SCHEMA IF NOT EXISTS F1.RAW;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE transform;
GRANT ALL ON DATABASE F1 to ROLE transform;
GRANT ALL ON ALL SCHEMAS IN DATABASE F1 to ROLE transform;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE F1 to ROLE transform;
GRANT ALL ON ALL TABLES IN SCHEMA F1.RAW to ROLE transform;
GRANT ALL ON FUTURE TABLES IN SCHEMA F1.RAW to ROLE transform;
```

To Migrate datasets from PostgreSQL to Snowflake - complete step 2 [migration.ipynb](migration.ipynb)
