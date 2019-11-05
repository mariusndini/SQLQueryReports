# Basic Data Sharing Examples
Below you will find some data sharing examples and document for Snowflake. There are a three main ways to share data with Snowflake as your data warehouse.

1) Extract and export

2) Share through Reader or Full accounts

3) Snowflake provided data exchange (not covered here)


## Extract & Export to S3 w/ Snowflake
Snowflake understands that not all customers move at the pace of innovation and may require an extract. While some of the other options for data sharing Snowflake offers are more advantageous, timed data extracts certainly are a very viable & reasonable option to utilize when needed. 

![img](https://github.com/mariusndini/SQLQueryReports/blob/master/img/savefroms3.png)

https://docs.snowflake.net/manuals/user-guide/data-unload-s3.html

In order to take advantage of unloading data into S3 you will need to follow the steps below.

A stage must be created, this is where your data will be saved

https://docs.snowflake.net/manuals/sql-reference/sql/create-stage.html

Copy Into your S3 cloud storage repo as needed

https://docs.snowflake.net/manuals/sql-reference/sql/copy-into-location.html


## Data Sharing w/ Reader or Full Accounts
There are two options which Snowflake can share data externally to customers. Either through a reader account or share with another full Snowflake account. Both options offer real time window into the shared data set as data is being updated.

For data sharing purposes there are providers and consumers. Providers own the data which is going to be shared. They maintain and manage all aspects of the underlying data set. In Snowflake the physical data never moves but is instead provided a window to peek into. On the opposite side providers give access or to consumers to read/view the data.

![img](https://github.com/mariusndini/SQLQueryReports/blob/master/img/datashare.png)


### Sharing Data through Reader Accounts
For reader accounts you will be giving customers read only access to a specific data set through secure views or tables. Secure views (https://docs.snowflake.net/manuals/user-guide/views-secure.html) offer row level and column level security.

![img](https://github.com/mariusndini/SQLQueryReports/blob/master/img/readeracct.png)

Reader accounts can be set up entirely through the UI or through SQL code. The steps necessary to take advantage of reader accounts are outlined below.

Create secure view for which you would like to share to members

https://docs.snowflake.net/manuals/user-guide/views-secure.html

Create reader account to take advantage of secure view

https://docs.snowflake.net/manuals/user-guide/data-sharing-reader-create.html

Securely connect to Snowflake through any of the connectors or UI

https://docs.snowflake.net/manuals/user-guide-connecting.html

The important distinction to keep in mind is that the provider will be providing a virtual warehouse for the reader account to utilize for querying.


### Sharing Data to Existing Snowflake Accounts
Sharing data to other Snowflake accounts is similar to sharing to reader accounts. Instead of specifying a reader account to provide access to, you specify a Snowflake account within a given region. That full Snowflake account will utilize their own virtual warehouse. 

![img](https://github.com/mariusndini/SQLQueryReports/blob/master/img/sharefull2full.png)

## Security During Data Sharing
Snowflake's General Data Sharing Document is here https://docs.snowflake.net/manuals/user-guide/data-sharing-intro.html
Snowflake offers different methodology depending on the shared out methodology. 

Secure Views are nothing more then normal Database views with an added security feature on top for Data Sharing.
https://docs.snowflake.net/manuals/user-guide/views-secure.html
The documentation for <b>secure views</b> gets more detailed.


### Secure Views


```
/* Revenue Report
 * Get Quantity, Revenue by Store for quater & month
 * Calculate the Rank for the Store for each particular month based on revenue
 */
create or replace secure view revenue as
    select 
    T.action_qtr AS QTR
    , T.action_month as MONTH
    , T.action_year as YEAR
    , f.store_id as STORE
    , store_name as STORENAME
    , ST.store_address as ADDRESS
    , sum(quantity)  AS QTY
    , sum(price * quantity) as REV_M
    , rank() over (partition by MONTH, YEAR order by REV_M DESC) as RNK

    from fact_sales F
    left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
    left outer join dim_employee E on F.employee_id = E.employee_id
    left outer join dim_product P on F.product_id = P.product_id
    left outer join dim_store ST on F.store_id = ST.store_id
    left outer join dim_time T on F.time_id = T.time_id
    <b>where STORE = 100</b>
    group by MONTH, QTR, YEAR, STORE, STORENAME, ADDRESS
    order by YEAR, MONTH, STORE, RNK ;
```


















