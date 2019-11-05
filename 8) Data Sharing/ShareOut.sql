use database anondb;
use schema star;
use warehouse medium_wh;


-- WHAT DOES THIS DATA LOOK LIKE
-- Show data in a general sense 
-- Normal fact table with some figures
select *
from "ANONDB"."STAR"."FACT_SALES"
limit 100;


/* Revenue Report
 * Get Quantity, Revenue by Store for quater & month
 * Calculate the Rank for the Store for each particular month based on revenue
 * SHARE THIS DATA with another Snowflake account
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
group by MONTH, QTR, YEAR, STORE, STORENAME, ADDRESS
order by YEAR, MONTH, STORE, RNK
;

select *
from revenue;

