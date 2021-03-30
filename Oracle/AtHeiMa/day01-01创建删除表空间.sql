--创建表空间
CREATE TABLESPACE lft DATAFILE 'C:\Oracle\oradata\orcl\lft.dbf'
size 100m
autoextend ON
NEXT 10m;

--删除表空间
DROP TABLESPACE lft;
