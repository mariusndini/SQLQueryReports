use database anondb;
use schema star;
use warehouse medium_wh;


/*
  Create Procedure - Simulate adding data and merging there after

*/
create or replace procedure add_merge()
  returns string not null
  language javascript
  as       

$$  
  for(q=0; q<10; q++){// big loop
    var data = {};
    data.whsize = 'med'; // hard coded warehouse
    data.startFunc = new Date();
    data.merges = [];

    for(k=0; k < 10; k++){ // For loop to insert 10m records into fact table
        var SQL = 
        `insert into ANONDB.STAR.fact_sales 
          select 
            uniform(1,1000,random(10)) as product 
            ,uniform(1,2000,random(1)) as time 
            ,uniform(1,100,random(1)) as store 
            ,uniform(1,500,random(1)) as emp 
            ,uniform(1,30,random(1)) as sales 
            ,uniform(1,10000,random(10))/100::decimal(18,2) as price 
            ,uniform(1,100,random(10))::int as qty 
            from table(generator(rowcount=>10000000)) `;

        var addStmt = snowflake.createStatement( {sqlText: SQL} );
        var addRS = addStmt.execute();

        data.newRows = new Date();

        SQL = ` select count(*) from ANONDB.STAR.fact_sales `;
        addStmt = snowflake.createStatement( {sqlText: SQL} );
        addRS = addStmt.execute();
        addRS.next();
        var rowcount = addRS.getColumnValue(1);

        for(i=0; i < 10; i++){ // merge loop
          var index = i + (k*10); 
          data.merges[index] = {}; 

          data.merges[index].rowcount = rowcount;
          data.merges[index].mstart = new Date(); //MERGE STARTING

          //SQL to Merge
          SQL = `
              merge into FACT_SALES
                using (select ABS((random()/10000000000000000)::integer) as pdct, ABS((random()/10000000000000000)::integer)*2 as time, ABS((random()/100000000000000000)::integer) as store, (ABS((random()/100000000000000000)::integer))*5 as emp, LEAST(ABS(random()/100000000000000000)::integer,30) as type) src 
                  on src.pdct = FACT_SALES.product_id
                  and src.time = FACT_SALES.time_id
                  and src.store = FACT_SALES.store_id
                  and src.emp = FACT_SALES.employee_id
                  and src.type = FACT_SALES.SALES_TYPE_ID

                //when matched -- matached logic to update|dlete from FACT_SALES

                when not matched then 
                    insert values (src.pdct, src.time, src.store, src.emp, src.type, 10, 10) 
          `; // end sql

          addStmt = snowflake.createStatement( {sqlText: SQL} );

          addRS = addStmt.execute();

          data.merges[index].mend = new Date(); //MERGE IS COMPLETE

          addRS.next();
          data.merges[index].result = addRS.getColumnValue(1);
          data.merges[index].queryid = addStmt.getQueryId();

          data.merges[index].diff = data.merges[index].mend - data.merges[index].mstart;
        }

    }//-- For1

    data.rtrnFunc = new Date();

    SQL = ` insert into runtimes (select PARSE_JSON('` + JSON.stringify(data) + `')) `;
    addStmt = snowflake.createStatement( {sqlText: SQL} );
    addRS = addStmt.execute();

  }//big big loop
  return 'DONE'; // All complete check runtimes table for information
 
$$
;

call add_merge();
//truncate FACT_SALES;


select v:whsize
--, value:queryid::string
, value:rowcount
, avg(value:diff)

from runtimes ,lateral flatten(V:merges)

where v:whsize = 'med'
group by 1, 2
order by v:whsize desc, value:rowcount asc

;






