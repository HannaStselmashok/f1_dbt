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

I have 2 tables in PostgreSQL. To read it in Pandas dataframe - execute step 1 from [migration.ipynb](D:\da\dbt\f1_dbt\migration.ipynb)

[raceresultsPandas]: D:\da\dbt\f1_dbt\images\raceresultsPandas.png
