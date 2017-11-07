
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




