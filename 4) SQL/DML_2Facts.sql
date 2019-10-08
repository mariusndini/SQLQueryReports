use database anondb;
use schema star;
use warehouse medium_wh;


/* SELECT Count
 * Join two fact tables on common dimensions & count rows
 * 
 */
select count(*)
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





/* TO Date Reports
 * Get Quantity, Revenue by Store for quater & month
 * Calculate the Rank for the Store for each particular month based on revenue
 *
 */
select 
  T.action_qtr AS QTR
, T.action_month as MONTH
, f.store_id as STORE
, sum(f.quantity)  AS QTY
, sum(f.price * f.quantity) as REV_M
, rank() over (partition by MONTH order by REV_M DESC) as RNK

, sum(FO.quantity)  AS FOQTY
, sum(FO.price * FO.quantity) as FOREV_M
, rank() over (partition by MONTH order by FOREV_M DESC) as FORNK
, D.supplier_address as SUPADDRESS

from fact_sales F
  left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
  left outer join dim_employee E on F.employee_id = E.employee_id
  left outer join dim_product P on F.product_id = P.product_id
  left outer join dim_store ST on F.store_id = ST.store_id
  left outer join dim_time T on F.time_id = T.time_id
  left outer join fact_supply_order FO on FO.employee_id = F.employee_id 
                                      and FO.time_id = F.time_id
                                      and FO.product_id = F.product_id
  left outer join dim_supplier D on d.supplier_id = FO.supplier_id

group by QTR, MONTH, STORE, SUPADDRESS
order by QTR, MONTH, RNK
;

/* TO DATE REPORTS - How does it all compare to last year
 * Calculate MTD, QTD & YTD reports with Revenue 
 * 
 */
select distinct
 action_day
,action_month
,action_qtr
,action_year
,rev
,sum (price * quantity) over (partition by action_month, action_qtr, action_year order by action_day) as MTD
,sum (price * quantity) over (partition by action_qtr, action_year order by action_qtr) as QTD
,sum (price * quantity) over (partition by action_year order by action_year) as YTD

,LY.y
,LY.LYREV
,sum (LY.LYREV) over (partition by action_month, action_qtr, action_year order by action_day) as LYMTD
,sum (LY.LYREV) over (partition by action_qtr, action_year order by action_qtr) as LYQTD
,sum (LY.LYREV) over (partition by action_year order by action_year) as LYYTD

from fact_sales F
inner join dim_time T on F.time_id = T.time_id
  left outer join(
      select distinct
       action_day as d
      ,action_month as m
      ,action_qtr as q
      ,action_year as y
      ,sum (price * quantity) as REV
      from fact_sales F inner join dim_time T on F.time_id = T.time_id
      group by 1,2,3,4
      order by 4, 2, 1
  )R on R.d = t.action_day and r.m = t.action_month and r.y = t.action_year

  left outer join(
      select distinct
       action_day as d
      ,action_month as m
      ,action_qtr as q
      ,action_year as y
      ,sum (price * quantity) as LYREV
      from fact_sales F inner join dim_time T on F.time_id = T.time_id
      group by 1,2,3,4
      order by 4, 2, 1
  )LY on LY.d = t.action_day and LY.m = t.action_month and LY.y = t.action_year-1
where t.action_year > 2015 //avoid last year nulls because 2014 is first year in DB
order by 4, 2, 1
;






