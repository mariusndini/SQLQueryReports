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

-- See Results of this particular
select count(*)
from fact_sales;



------------------------------------------------------------------------------------------------------------
----------------------------------  STREAMS ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------


-- Create Stream
create or replace stream fact_sales_stream on table fact_sales;

-- See what is inside the stream
select *
from fact_sales_stream;

-- TIME TRAVEL - Example
select count(*) from fact_sales
union 
select count(*) from fact_sales at(timestamp => 'Tue, 08 Oct 2019 16:20:00 -0700'::timestamp) -- Before/At a particular time
union
select count(*) from fact_sales before (statement => '018f6a98-016d-8511-0000-4365005b32da') -- before/at a particular query/DML statement
union
select count(*) from fact_sales at (offset => -60*3)
union
select count(*) from fact_sales at (offset => -60*4)
union
select count(*) from fact_sales at (offset => -60*5)
;









