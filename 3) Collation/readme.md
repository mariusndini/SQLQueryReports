# Snowflake Documentation Collation
https://docs.snowflake.net/manuals/sql-reference/collation.html

Snowflake can handle case sensitivity on an as needed basis through Collation (docs above). In order for a column to be case insensitive define it as such on the table DDL or alter table DDL.
```
create or replace table teacher(
    col String collate 'en-ci' -- Collation
);

insert into teacher values ('Teacher');
insert into teacher values ('TEacher');
insert into teacher values ('TeAcher');
insert into teacher values ('TeaCher');
insert into teacher values ('TeacHer');
insert into teacher values ('TeachEr');
insert into teacher values ('TEACHER');
insert into teacher values ('TeaCHER');

select col, count(*)
from teacher
group by col;
```
Returns the following result set:
```
COL	        COUNT(*)
Teacher	        8
```