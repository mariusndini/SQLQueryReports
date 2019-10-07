/* SELECT ALL
 *
 */
select *
from fact_sales F
left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
left outer join dim_employee E on F.employee_id = E.employee_id
left outer join dim_product P on F.product_id = P.product_id
left outer join dim_store ST on F.store_id = ST.store_id
left outer join dim_time T on F.time_id = T.time_id
;


/* REPORT
 *
 */
select 
  T.action_qtr AS QTR
, T.action_month as MONTH
, f.store_id as STORE
, to_number( sum(quantity)/1000000, 10, 2)  AS QTY
, to_number( sum(price * quantity)/1000000, 10, 0) as REV_M
, rank() over (partition by MONTH order by REV_M DESC) as RNK

from fact_sales F
  left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
  left outer join dim_employee E on F.employee_id = E.employee_id
  left outer join dim_product P on F.product_id = P.product_id
  left outer join dim_store ST on F.store_id = ST.store_id
  left outer join dim_time T on F.time_id = T.time_id
where action_year = 2017 and month in (1,2,3,4,5,6,7,8,9,10,11,12) 
group by 1, 2, 3
order by QTR, MONTH, STORE, RNK
;


/* REPORT
 *
 */
select 
T.action_month as MONTH
, f.store_id as STORE
, to_number( sum(price * quantity)/1000000, 10, 0) as REV_M

from fact_sales F
  left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
  left outer join dim_employee E on F.employee_id = E.employee_id
  left outer join dim_product P on F.product_id = P.product_id
  left outer join dim_store ST on F.store_id = ST.store_id
  left outer join dim_time T on F.time_id = T.time_id
where action_year = 2017 and month in (1,2,3,4,5,6,7,8,9,10,11,12) 
group by rollup (MONTH, STORE)
order by MONTH, STORE
;


/* REPORT
 *
 */
select T.*
from fact_sales F
left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
left outer join dim_employee E on F.employee_id = E.employee_id
left outer join dim_product P on F.product_id = P.product_id
left outer join dim_store ST on F.store_id = ST.store_id
left outer join dim_time T on F.time_id = T.time_id
order by action_year, action_qtr, action_month, action_day
;





