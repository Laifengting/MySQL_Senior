--创建表空间
create tablespace lft
datafile 'C:\Oracle\oradata\orcl\lft.dbf'
size 100m
autoextend on
next 10m;

--删除表空间
drop  tablespace  lft;
