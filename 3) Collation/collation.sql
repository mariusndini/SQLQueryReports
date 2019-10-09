use database anondb;
use schema star;
use warehouse medium_wh;

create or replace table teacher(
    col String collate 'en-ci'
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