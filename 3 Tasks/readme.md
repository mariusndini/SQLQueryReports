# Snowflake Tasks
https://docs.snowflake.net/manuals/sql-reference/sql/create-task.html

Snowflake can create tasks (Think CRON jobs) internally to call stored procedures or to run jobs on a schedule. Tasks and Streams are good combination with eachother. 

```
-- Create Tasks
create or replace task add_to_fact
  warehouse = MEDIUM_WH
  schedule = '1 minute'
as
insert into ANONDB.STAR.fact_sales 
    select 
    uniform(1,1000,random(10)) as product 
    ,uniform(1,2000,random(1)) as time 
    ,uniform(1,100,random(1)) as store 
    ,uniform(1,500,random(1)) as emp 
    ,uniform(1,30,random(1)) as sales 
    ,uniform(1,10000,random(10))/100::decimal(18,2) as price 
    ,uniform(1,100,random(10))::int as qty 
    from table(generator(rowcount=>1))
;

-- Resume or Pause Task
alter task ADD_TO_FACT suspend;
alter task ADD_TO_FACT resume;

-- List all tasks
show tasks;
```