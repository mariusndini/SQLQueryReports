use database anondb;
use schema star;
use warehouse medium_wh;


/* SELECT ALL
 * Join two fact tables on common dimensions
 */
select *
from fact_sales F
left outer join dim_sales_type S on F.sales_type_id = S.sales_type_id
left outer join dim_employee E on F.employee_id = E.employee_id
left outer join dim_product P on F.product_id = P.product_id
left outer join dim_store ST on F.store_id = ST.store_id
left outer join dim_time T on F.time_id = T.time_id
left outer join (select * from fact_supply_order at (offset => -60*0) ) FO on FO.employee_id = F.employee_id 
                                    and FO.time_id = F.time_id
                                    and FO.product_id = F.product_id
left outer join dim_supplier D on d.supplier_id = FO.supplier_id
;

select distinct
action_day
,action_month
,action_qtr
,action_year
,sum (price * quantity) over (partition by action_month, action_qtr, action_year order by action_day) as MTD
,sum (price * quantity) over (partition by action_qtr, action_year order by action_month) as QTD
,sum (price * quantity) over (partition by action_year order by action_qtr) as YTD

from fact_sales F
inner join dim_time T on F.time_id = T.time_id
where action_year = 2018
order by 3, 2, 1
;













