use database anondb;
use schema star;
use warehouse medium_wh;

merge into FACT_SALES
using (select 398 as pdct, 189 as time, 10 as store, 48 as emp, 5 as type) src 
  on src.pdct = FACT_SALES.product_id
  and src.time = FACT_SALES.time_id
  and src.store = FACT_SALES.store_id
  and src.emp = FACT_SALES.employee_id
  and src.type = FACT_SALES.SALES_TYPE_ID

//when matched -- matached logic to update|dlete from FACT_SALES

when not matched then 
    insert values (src.pdct, src.time, src.store, src.emp, src.type, 10, 10)
;


