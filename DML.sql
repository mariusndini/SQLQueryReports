use schema ANONDB.star;

-- Table: fact_sales
CREATE OR REPLACE TABLE fact_sales (
    product_id int  NOT NULL,
    time_id int  NOT NULL,
    store_id int  NOT NULL,
    employee_id int  NOT NULL,
    sales_type_id int  NOT NULL,
    price decimal(8,2)  NOT NULL,
    quantity int  NOT NULL,
    CONSTRAINT fact_sales_pk PRIMARY KEY (product_id,time_id,store_id,employee_id,sales_type_id)
);

//truncate fact_sales;
insert into fact_sales 
select 
  uniform(1,1000,random(10)) as product 
  ,uniform(1,2000,random(1)) as time 
  ,uniform(1,100,random(1)) as store 
  ,uniform(1,500,random(1)) as emp 
  ,uniform(1,30,random(1)) as sales 
  ,uniform(1,10000,random(10))/100::decimal(18,2) as price 
  ,uniform(1,100,random(10))::int as qty 

  from table(generator(rowcount=>1000000))
;

select count(*)
from fact_sales;

-----------------------------------------------------------------------------------------------------------------------------

-- Table: fact_sales
CREATE TABLE dim_employee (
    employee_id int  NOT NULL,
    first_name varchar(128)  NOT NULL,
    last_name varchar(128)  NOT NULL,
    birth_year int  NOT NULL,
    CONSTRAINT dim_employee_pk PRIMARY KEY (employee_id)
);


create or replace sequence counter start = 1 increment = 1;

insert into dim_employee 
select 
  counter.nextval as id 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as fname 
  ,INITCAP(randstr(uniform(3,10,random(101)),random(201)), '') as lname 
  ,uniform(1950,2000,random(1)) as birthYear 
  from table(generator(rowcount=>500))
;

select *
from dim_employee;



-----------------------------------------------------------------------------------------------------------------------------

-- Table: fact_sales
CREATE TABLE dim_product (
    product_id int  NOT NULL,
    product_name varchar(256)  NOT NULL,
    product_type varchar(256)  NOT NULL,
    CONSTRAINT dim_product_pk PRIMARY KEY (product_id)
);


create or replace sequence counter start = 1 increment = 1;

insert into dim_product 
select 
  counter.nextval as id 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as fname 
  ,INITCAP(randstr(uniform(3,10,random(101)),random(201)), '') as lname 
  from table(generator(rowcount=>1000))
;

select *
from dim_product;



-----------------------------------------------------------------------------------------------------------------------------

-- Table: dim_sales_type 30
CREATE TABLE dim_sales_type (
    sales_type_id int  NOT NULL,
    type_name varchar(128)  NOT NULL,
    CONSTRAINT dim_sales_type_pk PRIMARY KEY (sales_type_id)
);


create or replace sequence counter start = 1 increment = 1;

insert into dim_sales_type 
select 
  counter.nextval as id 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as fname 
  from table(generator(rowcount=>30))
;

select *
from dim_sales_type;



-----------------------------------------------------------------------------------------------------------------------------

-- Table: dim_store 100
CREATE TABLE dim_store (
    store_id int  NOT NULL,
    store_address varchar(256)  NOT NULL,
    city varchar(128)  NOT NULL,
    region varchar(128)  NOT NULL,
    state varchar(128)  NOT NULL,
    country varchar(128)  NOT NULL,
    CONSTRAINT dim_store_pk PRIMARY KEY (store_id)
);


create or replace sequence counter start = 1 increment = 1;

insert into dim_store 
select 
  counter.nextval as id 
  ,INITCAP(randstr(uniform(3,10,random(10)),random(10)), '') as addr 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(4)), '') as city 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as region 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as state 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as country 
  from table(generator(rowcount=>100))
;

select *
from dim_store;



-----------------------------------------------------------------------------------------------------------------------------

-- Table: dim_time 2000
CREATE OR REPLACE TABLE dim_time (
    time_id int  NOT NULL,
    action_date date NOT NULL,
    action_day int  NOT NULL,
    action_week int  NOT NULL,
    action_month int  NOT NULL,
    action_qtr int  NOT NULL,
    action_year int  NOT NULL,
    CONSTRAINT dim_time_pk PRIMARY KEY (time_id)
);


create or replace sequence counter start = 1 increment = 1;

insert into dim_time 
select 
  counter.nextval as id 
  ,dateadd(day, '-' || seq4(), current_date()) as dte
  ,date_part(day, dte::date) as d
  ,date_part(week, dte::date) as w
  ,date_part(month, dte::date) as m
  ,date_part(quarter, dte::date) as q
  ,date_part(year, dte::date) as y
  from table(generator(rowcount=>2000))
;

select *
from dim_time;



-----------------------------------------------------------------------------------------------------------------------------
-- Table: dim_supplier 100
CREATE OR REPLACE TABLE dim_supplier (
    supplier_id int  NOT NULL,
    supplier_address varchar(256)  NOT NULL,
    city varchar(128)  NOT NULL,
    region varchar(128)  NOT NULL,
    state varchar(128)  NOT NULL,
    country varchar(128)  NOT NULL,
    CONSTRAINT dim_supplier_pk PRIMARY KEY (supplier_id)
);

create or replace sequence counter start = 1 increment = 1;

insert into dim_supplier 
select 
  counter.nextval as id 
  ,INITCAP(randstr(uniform(3,10,random(10)),random(10)), '') as addr 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(4)), '') as city 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as region 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as state 
  ,INITCAP(randstr(uniform(3,10,random(100)),random(98)), '') as country 
  from table(generator(rowcount=>100))
;

select *
from dim_supplier;


-----------------------------------------------------------------------------------------------------------------------------


-- Table: fact_supply_order
CREATE OR REPLACE TABLE fact_supply_order (
    product_id int  NOT NULL,
    time_id int  NOT NULL,
    supplier_id int  NOT NULL,
    employee_id int  NOT NULL,
    price decimal(8,2)  NOT NULL,
    quantity decimal(8,2)  NOT NULL,
    CONSTRAINT fact_supply_order_pk PRIMARY KEY (supplier_id)
);

//truncate fact_sales;
insert into fact_supply_order 
select 
  uniform(1,1000,random(10)) as product 
  ,uniform(1,2000,random(1)) as time 
  ,uniform(1,100,random(1)) as supplier 
  ,uniform(1,500,random(1)) as employee  
  ,uniform(1,10000,random(10))/100::decimal(18,2) as price 
  ,uniform(1,100,random(10))::int as qty 

  from table(generator(rowcount=>100))
;

select *
from fact_supply_order;








