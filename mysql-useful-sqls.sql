
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




# change column order
ALTER TABLE `sd_mobi_smartcampus`.`t_announce` 
CHANGE COLUMN `create_time` `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '公告创建时间' AFTER `sms_notif`;

# partial odering
select *
from table t
order by (eventdate = curdate()) desc,                               -- put today's events first
         (case when eventdate = curdate() then eventtime end) asc,   -- order today in ascending order
         (case when eventdate <> curdate() then eventtime end) desc; -- order the rest in descending order
Eg.: 
select
    t.id node_id,
    t.name,
    t.template_id,
    t.user_id,
    t.user_name,
	t.type,
    t.create_time
from
    t_approve_process_template_nodes t
where
	t.template_id in (23, 24, 25, 26) order by template_id desc, node_id asc;

# date operations
## DATE_ADD
select now();
select DATE_ADD(now(), interval 20 minute);
## format, add, sub
select date_sub(date_format(date_add(now(), interval 1 day), '%Y-%m-%d'), interval 1 second) last_second_of_the_day;
select date_format(now(), '%Y-%m-%d') first_second_of_today;
select date_format(date_add(now(), interval 50 year), '%Y-%m-%d %H:%s:%i') first_second_of_tomorrow;

# lock & unlock tables
SHOW OPEN TABLES FROM sd_mobi_smartcampus WHERE In_use > 0 and `Table` = 't_leave';

LOCK TABLES `t_leave_approve_conf` WRITE;
UNLOCK TABLES;

# Show tables status
```
select t.TABLE_NAME, t.TABLE_COMMENT, t.TABLE_ROWS from information_schema.tables t where t.TABLE_SCHEMA = 'db';
```


