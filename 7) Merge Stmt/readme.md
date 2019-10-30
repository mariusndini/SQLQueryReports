# Snowflake Merge Statment
https://docs.snowflake.net/manuals/sql-reference/sql/merge.html#matchedclause-for-updates-or-deletes

Merge statment allows you to run logic on insert or update based on some conditions.

Snowflake does not enforce primary keys and a way to get around the concept is to use a merge statment like the one below.

What the code sample below will do is essentially return <b>0</b> if the row already exists in the table (which then an application can handle or error out on). If the row is not in conflict then the row will be inserted and the row count is <b>1</b>.

```
merge into FACT_SALES
using (select 398 as pdct, 189 as time, 10 as store, 48 as emp, 5 as type) src 
  on src.pdct = FACT_SALES.product_id
  and src.time = FACT_SALES.time_id
  and src.store = FACT_SALES.store_id
  and src.emp = FACT_SALES.employee_id
  and src.type = FACT_SALES.SALES_TYPE_ID

//when matched -- matached logic to update|delete from FACT_SALES

when not matched then 
    insert values (src.pdct, src.time, src.store, src.emp, src.type, 10, 10)
;
```











