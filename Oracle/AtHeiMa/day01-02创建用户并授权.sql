--创建用户
create user LFT --创建新用户
identified by 201314 --设置用户密码
default tablespace laifengting; --用户的默认表空间

--给用户授权
--oracle数据库中常用角色
connect --连接角色，基本角色
resource --开发者角色
dba --超级管理员角色


--给lft用户授予dba角色
grant dba to LFT;

--切换到lft用户下
