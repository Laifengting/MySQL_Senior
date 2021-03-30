--学习目标
/*
通过本章学习，您将可以:
    创建用户
    创建角色
    使用GRANT 和 REVOKE 语句赋予和回收权限
    创建数据库联接
*/

--权 限
/*
数据库安全性:
    系统安全性
    数据安全性
系统权限: 对于数据库的权限
对象权限: 操作数据库对象的权限
*/

--系统权限
/*
超过一百多种有效的权限
数据库管理员具有高级权限以完成管理任务，例如:
创建表空间
删除表空间
创建新用户
删除用户
删除表
备份表
*/
--创建临时表空间
/*CREATE
  [ SMALLFILE | BIGFILE ]
  TEMPORARY TABLESPACE tablespace_name
    [ TEMPFILE { [ 'filename' | 'ASM_filename' ]
                 [ SIZE integer [ K | M | G | T | P | E ] ]
                 [ REUSE ]
                 [ AUTOEXTEND
                     { OFF
                     | ON [ NEXT integer [ K | M | G | T | P | E ] ]
                     [ MAXSIZE { UNLIMITED | integer [ K | M | G | T | P | E ] } ]
                     }
                 ]
               | [ 'filename | ASM_filename'
               | ('filename | ASM_filename'
                   [, 'filename | ASM_filename' ] )
               ]
               [ SIZE integer [ K | M | G | T | P | E ] ]
               [ REUSE ]
               }
    [ TABLESPACE GROUP { tablespace_group_name | '' } ]
    [ EXTENT MANAGEMENT
       { LOCAL
          [ AUTOALLOCATE | UNIFORM [ SIZE integer [ K | M | G | T | P | E ] ] ]
       | DICTIONARY
       } ]
参数说明

SMALLFILE - 包含1022个数据或临时文件的表空间(每个文件最多可以有400万个块)。这是要创建的最常见的表空间大小。
BIGFILE - 只包含一个数据或临时文件的表空间(该文件最多可以有400万个块)。

提示：如果省略SMALLFILE或BIGFILE选项，Oracle数据库将使用默认的表空间类型。

tablespace_name - 要创建的表空间的名称。
*/

CREATE TEMPORARY
TABLESPACE TRAFFIC_TEMP
      /*   TEMPFILE 'C:\Oracle\oradata\orcl\TRAFFIC_TEMP.DBF'--临时表空间的存放地址*/
         TEMPFILE 'C:\ORACLE\oradata\orcl\TRAFFIC_TEMP.DBF'
         SIZE 100M--表空间的初始大小
         AUTOEXTEND ON--是否自动扩展
         NEXT 10M MAXSIZE UNLIMITED--每次扩展多少,到达最大值后无限制
         EXTENT MANAGEMENT LOCAL;


--创建数据表空间
/*
CREATE
  [ SMALLFILE | BIGFILE ]
  TABLESPACE tablespace_name
  { DATAFILE { [ 'filename' | 'ASM_filename' ]
               [ SIZE integer [ K | M | G | T | P | E ] ]
               [ REUSE ]
               [ AUTOEXTEND
                   { OFF
                   | ON [ NEXT integer [ K | M | G | T | P | E ] ]
                   [ MAXSIZE { UNLIMITED | integer [ K | M | G | T | P | E ] } ]
                   }
               ]
             | [ 'filename | ASM_filename'
             | ('filename | ASM_filename'
                 [, 'filename | ASM_filename' ] )
             ]
             [ SIZE integer [ K | M | G | T | P | E ] ]
             [ REUSE ]
             }
     { MINIMUM EXTENT integer [ K | M | G | T | P | E ]
     | BLOCKSIZE integer [ K ]
     | { LOGGING | NOLOGGING }
     | FORCE LOGGING
     | DEFAULT [ { COMPRESS | NOCOMPRESS } ]
   storage_clause
     | { ONLINE | OFFLINE }
     | EXTENT MANAGEMENT
        { LOCAL
           [ AUTOALLOCATE
           | UNIFORM
              [ SIZE integer [ K | M | G | T | P | E ] ]
           ]
        | DICTIONARY
        }
     | SEGMENT SPACE MANAGEMENT { AUTO | MANUAL }
     | FLASHBACK { ON | OFF }
         [ MINIMUM EXTENT integer [ K | M | G | T | P | E ]
         | BLOCKSIZE integer [ K ]
         | { LOGGING | NOLOGGING }
         | FORCE LOGGING
         | DEFAULT [ { COMPRESS | NOCOMPRESS } ]
         storage_clause
         | { ONLINE | OFFLINE }
         | EXTENT MANAGEMENT
              { LOCAL
                [ AUTOALLOCATE | UNIFORM [ SIZE integer [ K | M | G | T | P | E ] ] ]
                | DICTIONARY
              }
         | SEGMENT SPACE MANAGEMENT { AUTO | MANUAL }
         | FLASHBACK { ON | OFF }
         ]
     }
参数

SMALLFILE - 包含1022个数据或临时文件的表空间(每个文件最多可以有400万个块)。这是要创建的最常见的表空间大小。
BIGFILE - 只包含一个数据或临时文件的表空间(该文件最多可以有400万个块)。
提示：如果省略SMALLFILE或BIGFILE选项，Oracle数据库将使用默认的表空间类型。

tablespace_name - 要创建的表空间的名称。
storage_clause - storage_clause的语法是：
STORAGE
 ({ INITIAL integer [ K | M | G | T | P | E ]
  | NEXT integer [ K | M | G | T | P | E ]
  | MINEXTENTS integer
  | MAXEXTENTS { integer | UNLIMITED }
  | PCTINCREASE integer
  | FREELISTS integer
  | FREELIST GROUPS integer
  | OPTIMAL [ integer [ K | M | G | T | P | E ] | NULL ]
  | BUFFER_POOL { KEEP | RECYCLE | DEFAULT }
  }
     [ INITIAL integer [ K | M | G | T | P | E ]
     | NEXT integer [ K | M | G | T | P | E ]
     | MINEXTENTS integer
     | MAXEXTENTS { integer | UNLIMITED }
     | PCTINCREASE integer
     | FREELISTS integer
     | FREELIST GROUPS integer
     | OPTIMAL [ integer [ K | M | G | T | P | E ] | NULL ]
     | BUFFER_POOL { KEEP | RECYCLE | DEFAULT }
     ]
 )
*/
CREATE TABLESPACE lft
	/*DATAFILE 'C:\Oracle\oradata\orcl\annie.dbf'--数据表空间的存放地址*/
	DATAFILE 'C:\ORACLE\oradata\orcl\lft.dbf'
SIZE 100m--表空间的初始大小
AUTOEXTEND ON--是否自动扩展
NEXT 10m MAXSIZE UNLIMITED--每次扩展多少,到达最大值后无限制
EXTENT MANAGEMENT LOCAL;


--UNDO表空间
/*
如果Oracle数据库以自动撤消管理模式运行，则会创建撤消表空间来管理撤消数据。

CREATE
  [ SMALLFILE | BIGFILE ]
  UNDO TABLESPACE tablespace_name
    [ DATAFILE { [ 'filename' | 'ASM_filename' ]
                 [ SIZE integer [ K | M | G | T | P | E ] ]
                 [ REUSE ]
                 [ AUTOEXTEND
                     { OFF
                     | ON [ NEXT integer [ K | M | G | T | P | E ] ]
                     [ MAXSIZE { UNLIMITED | integer [ K | M | G | T | P | E ] } ]
                     }
                 ]
               | [ 'filename | ASM_filename'
               | ('filename | ASM_filename'
                   [, 'filename | ASM_filename' ] )
               ]
               [ SIZE integer [ K | M | G | T | P | E ] ]
               [ REUSE ]
               }
    [ EXTENT MANAGEMENT
       { LOCAL
          [ AUTOALLOCATE | UNIFORM [ SIZE integer [ K | M | G | T | P | E ] ] ]
       | DICTIONARY
       } ]
    [ RETENTION { GUARANTEE | NOGUARANTEE } ]
参数说明

SMALLFILE - 包含1022个数据或临时文件的表空间(每个文件最多可以有400万个块)。这是要创建的最常见的表空间大小。
BIGFILE - 只包含一个数据或临时文件的表空间(该文件最多可以有400万个块)。

提示：如果省略SMALLFILE或BIGFILE选项，Oracle数据库将使用默认的表空间类型。

tablespace_name - 要创建的表空间的名称。
*/


--删除表空间
DROP TABLESPACE annie;

--创建用户
/*
DBA 使用 CREATE USER 语句创建用户

CREATE USER user              			   
IDENTIFIED BY   password;
*/
CREATE USER lft IDENTIFIED BY 201314--创建用户和密码
	ACCOUNT
UNLOCK
--解锁用户账号
DEFAULT TABLESPACE LFT --分配数据表空间
TEMPORARY TABLESPACE traffic_temp;
--分配临时表空间

--用户的系统权限
/*
用户创建之后, DBA 会赋予用户一些系统权限

GRANT privilege [, privilege...]			
TO user [, user| role, PUBLIC...];

以应用程序开发者为例, 一般具有下列系统权限:
    CREATE SESSION（创建会话）
    CREATE TABLE（创建表）
    CREATE SEQUENCE（创建序列）
    CREATE VIEW（创建视图）
    CREATE PROCEDURE（创建过程）
*/
GRANT CREATE SESSION,CREATE TABLE TO lft;
--给用户赋予权限

GRANT DBA TO lft;
--给用户赋予角色

--修改用户表空间(TABLESPACE)
/*用户拥有create table权限之外，还需要分配相应的表空间才可开辟存储空间用于创建的表
ALTER USER user_name QUOTA UNLIMITED 
ON table_space_name
*/
ALTER USER annie QUOTA UNLIMITED
ON annie;

ALTER USER annie QUOTA 10M
ON annie;


----scott用户,密码默认为tiger.实际为201314
--解锁scott用户
ALTER USER scott ACCOUNT UNLOCK;

--解锁scott用户的密码【此句也可以用来重置密码】
ALTER USER scott IDENTIFIED BY 201314;



--创建角色并赋予权限
/*
创建角色
*/
CREATE ROLE manager;

/*
为角色赋予权限
*/
GRANT CREATE SESSION, CREATE TABLE,CREATE VIEW TO manager;

/*
将角色赋予用户
*/
GRANT manager TO LFT,ANNIE;



--修改密码
/*
DBA 可以创建用户和修改密码

用户本人可以使用 ALTER USER 语句修改密码
ALTER USER scott             			  
IDENTIFIED BY 201314;
*/


--对象权限
/*
不同的对象具有不同的对象权限
对象的拥有者拥有所有权限
对象的拥有者可以向外分配权限

 GRANT	object_priv [(columns)]
 ON		object
 TO		{user|role|PUBLIC}--PUBLIC向数据库中所有用户分配权限
  [WITH GRANT OPTION];--使用户同样具有分配权限的权利
*/

--分配表 EMPLOYEES 的查询权限
GRANT SELECT--什么权限
ON     employees--分配某个表
TO     lft,annie;
--给哪个或哪些用户



--分配表中各个列的更新权限
GRANT UPDATE
	ON scott.departments
	TO lft,annie;

--查询权限分配情况
/*
数据字典视图				描述
ROLE_SYS_PRIVS			角色拥有的系统权限
ROLE_TAB_PRIVS			角色拥有的对象权限
USER_ROLE_PRIVS			用户拥有的角色
USER_TAB_PRIVS_MADE		用户分配的关于表对象权限
USER_TAB_PRIVS_RECD		用户拥有的关于表对象权限
USER_COL_PRIVS_MADE		用户分配的关于列的对象权限
USER_COL_PRIVS_RECD		用户拥有的关于列的对象权限
USER_SYS_PRIVS			用户拥有的系统权限
*/
SELECT *
	FROM user_sys_privs;

--收回对象权限
/*
使用 REVOKE 语句收回权限
使用 WITH GRANT OPTION 子句所分配的权限同样被收回

REVOKE {privilege [, privilege...]|ALL}
ON	  object
FROM   {user[, user...]|role|PUBLIC}
[CASCADE CONSTRAINTS];
*/

REVOKE SELECT, INSERT
	ON departments
	FROM scott;


--总结
/*
通过本章学习,您已经可以使用 DCL 控制数据库权限，
创建数据库联接:
语句                      功能
CREATE USER               创建用户（通常由DBA完成）
GRANT                     分配权限
CREATE ROLE               创建角色（通常由DBA完成）
ALTER USER                修改用户密码
REVOKE                    收回权限
*/


