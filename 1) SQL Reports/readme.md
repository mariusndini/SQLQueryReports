# SQL Documentation/ Set-Up
In order to create a realistic scenario of a fact table with dimension tables we need data. In the files within this folder are the DDLs for the tables used as well as the insert into statements to populate said tables. 

The population of these tables is done through random numbers or strings to query from. The table sizes will vary depending on the numbers inserted/provided.

Queries will be performed on the following tables outlined below. We will query a star schema with one fact table. Afterwards, we will query a galaxy schema with two fact tables to get a sense of runtimes.

The tables & general row counts are below
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

With that said, Snowflake offers different layers of caching which make testing repeatedly challenging.
https://community.snowflake.com/s/article/Caching-in-Snowflake-Data-Warehouse
In all runtimes provided below, cold starts will be reported except whenever noted.


### Star Schema
The ER Diagram for the star schema is outlined below.
![Star Schema](https://github.com/mariusndini/SQLQueryReports/blob/master/img/star.png)

```
/* SELECT ALL
 * Join on all the tables and select all the rows
 */
select *
from fact_sales F
left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
left outer join dim_employee E on F.employee_id = E.employee_id
left outer join dim_product P on F.product_id = P.product_id
left outer join dim_store ST on F.store_id = ST.store_id
left outer join dim_time T on F.time_id = T.time_id
;
```
On a X-Small warehouse (1 node) it took 26.2 seconds to run the query above to return 12.2 million rows. 

There are more quiries within the <b>DML_1Fact.sql</b> file to test with.


### Galaxy Schema
A Galaxy schema for our purposes will be a SQL model with two fact tables joined. 
The ER Diagram is below for this particular data set.
![Galaxy Schema](https://github.com/mariusndini/SQLQueryReports/blob/master/img/galaxy.png)

```/* SELECT ALL
 * Join two fact tables on common dimensions
 * 
 */
select *
from fact_sales F
left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
left outer join dim_employee E on F.employee_id = E.employee_id
left outer join dim_product P on F.product_id = P.product_id
left outer join dim_store ST on F.store_id = ST.store_id
left outer join dim_time T on F.time_id = T.time_id
left outer join fact_supply_order FO on FO.employee_id = F.employee_id 
//left outer join (select * from fact_supply_order at (offset => -60*0) ) FO on FO.employee_id = F.employee_id -- demo time travel
                                    and FO.time_id = F.time_id
                                    and FO.product_id = F.product_id
left outer join dim_supplier D on d.supplier_id = FO.supplier_id
;
```
On a X-Small warehouse (1 node) it took 37.07 seconds to run the query above to return 20.8 million rows. 



