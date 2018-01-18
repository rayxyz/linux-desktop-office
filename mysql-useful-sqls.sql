
#### Show currently in use database.
select database();

#### Change root password
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('pass')

#### Check if a database exists.
SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'sdp_db';


#### Query table size on disk.
## bytes
SELECT (data_length+index_length) tablesize
FROM information_schema.tables
WHERE table_schema='mydb' and table_name='mytable';

## Kilobytes
SELECT (data_length+index_length)/power(1024,1) tablesize_kb
FROM information_schema.tables
WHERE table_schema='mydb' and table_name='mytable';

## Megabytes
SELECT (data_length+index_length)/power(1024,2) tablesize_mb
FROM information_schema.tables
WHERE table_schema='sd_user_20170607' and table_name='users';

## Gigabytes
SELECT (data_length+index_length)/power(1024,3) tablesize_gb
FROM information_schema.tables
WHERE table_schema='mydb' and table_name='mytable';


#### DATE_ADD
select now();
select DATE_ADD(now(), interval 20 minute);

#### Change password

# show db activities
show full processlist;

# show db connections
show status like 'Conn%';

# kill db processes
select concat('KILL ',id,';') from information_schema.processlist where user='root';
select concat('KILL ',id,';') from information_schema.processlist where user='root' into outfile '/tmp/a.txt';
source /tmp/a.txt;



## biz useful clauses
select concat('\'', replace('5004897902349720496/5430531878760392339/5720216184843999856', '/', ','));


select 5720216184843999856, group_concat(t1.Name SEPARATOR '/') DeptTreeNames from organizationdepartment t1 where t1.Id in (5004897902349720496,5430531878760392339,5720216184843999856)
union
select 5720214843999856, group_concat(t1.Name SEPARATOR '/') DeptTreeNames from organizationdepartment t1 where t1.Id in (5004897902349720496,5430531878760392339,5720216184843999856)
union
select 57202184843999856, group_concat(t1.Name SEPARATOR '/') DeptTreeNames from organizationdepartment t1 where t1.Id in (5004897902349720496,5430531878760392339,5720216184843999856)
union
select 572021443543843999856, group_concat(t1.Name SEPARATOR '/') DeptTreeNames from organizationdepartment t1 where t1.Id in (5004897902349720496,5430531878760392339,5720216184843999856);

select 4686192761008088649, group_concat(t1.Name SEPARATOR '/') DeptTreeNames 
from (select t.* from organizationdepartment t where t.Id in (5317454385503830767,4686192761008088649) order by t.Level asc) t1;








