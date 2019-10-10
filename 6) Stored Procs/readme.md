# Snowflake Stored Procedures
https://docs.snowflake.net/manuals/sql-reference/stored-procedures.html

Stored procedures allow you to extend Snowflake SQL by combining it with JavaScript so that you can include standard programming constructs such as branching and looping. Stored procedures also make code easier to maintain and re-use.


```
create or replace procedure add_to_fact()
  returns float not null
  language javascript
  as     
  $$  
    var my_sql_command = 
    `insert into ANONDB.STAR.fact_sales 
      select 
        uniform(1,1000,random(10)) as product 
        ,uniform(1,2000,random(1)) as time 
        ,uniform(1,100,random(1)) as store 
        ,uniform(1,500,random(1)) as emp 
        ,uniform(1,30,random(1)) as sales 
        ,uniform(1,10000,random(10))/100::decimal(18,2) as price 
        ,uniform(1,100,random(10))::int as qty 
        from table(generator(rowcount=>10000))
     `;
           
    var statement1 = snowflake.createStatement( {sqlText: my_sql_command} );
    var result_set1 = statement1.execute();

    return 0.0; // Replace with something more useful.
  $$
;

create or replace task add_to_fact
  warehouse = MEDIUM_WH
  schedule = '1 minute'
as
    call add_to_fact();
;
```











