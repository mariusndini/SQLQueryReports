create or replace table arrtable(arr array);

insert into arrtable (
select array_construct( PARSE_JSON('{"color" : "Purple", "id" : "200"}'), 
                        PARSE_JSON('{"color" : "Green", "id" : "100"}'), 
                        PARSE_JSON('{"color" : "Blue", "id" : "150"}') )
);


select hide_test(arr) as hidden, Arr as original
from arrtable,
   lateral flatten(input => ARR) f
;

CREATE OR REPLACE FUNCTION HIDE_TEST (STR ARRAY)
  RETURNS ARRAY
  LANGUAGE JAVASCRIPT
  AS $$
  for(i=0; i< STR.length; i++){
    STR[i].id = '*'
  }
  
  return STR
  $$;

