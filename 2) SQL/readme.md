# SQL Documentation/ Set-Up
In order to create a real enough scenario of a fact table with dimension tables we need data. In the files within this folder are the DDLs for the tables used as well as the insert into statements to populate said tables. The population of these tables is done through random numbers or strings to query from. The table sizes will vary depending on the numbers inserted/provided.


Queries will be performed on the following tables and schemas outlined below. We will query a star schema with one fact table. Afterwards, we will query a galaxy schema with two fact tables to get a sense of runtimes.

The tables general sizes are below

```
1 fact_sales        12200000
2 fact_supply_order 2000100
3 dim_sales_type    30
4 dim_product       1000
5 dim_store         100
6 dim_time          2000
7 dim_supplier      100
8 dim_employee      500
```


### Star Schema
The tables for the star schema are below
![Star Schema](https://github.com/mariusndini/SQLQueryReports/blob/master/img/star.png)

### Star Schema
The tables for the galaxy schema are below
![Galaxy Schema](https://github.com/mariusndini/SQLQueryReports/blob/master/img/galaxy.png)





