----创建和管理表
--查询用户创建的表。
SELECT *
FROM   user_tables;

--查看用户定义的表, 视图, 同义词和序列
SELECT *
FROM   user_catalog;

--查看用户定义的各种数据库对象
SELECT *
FROM   user_objects;

--创建表
/*
必须具备:
    CREATE TABLE权限
    存储空间

语法：
CREATE TABLE [schema.]table
        (column datatype [DEFAULT expr][, ...]);

必须指定:
    表名
    列名, 数据类型, 尺寸
*/
--【案例】创建表的方式一(白手起家)：创建emp1表，number(10)类型的id,VARCHAR2(20)类型的name,NUMBER(10,2)类型的salary,date类型的hire_date
CREATE TABLE emp1(id NUMBER(10),
				  NAME VARCHAR2(20),
				  salary NUMBER(10,
						 2),
				  hire_date DATE);

--显示表的结构(Command Window使用)
DESC emp1;
--显示表的所有内容。
SELECT *
FROM   emp1;

--【案例】创建表的方式二(依托于现有的表)：
CREATE TABLE emp2 AS
	SELECT employee_id id,
		   last_name   NAME,
		   hire_date,
		   salary
	FROM   employees;

--创建表，复制现有表中的部分内容。
CREATE TABLE emp3 AS
	SELECT employee_id id,
		   last_name   NAME,
		   hire_date,
		   salary
	FROM   employees
	WHERE  department_id = 80;

--创建表，仅仅复制现有表的表格结构。
CREATE TABLE emp4 AS
	SELECT employee_id id,
		   last_name   NAME,
		   hire_date,
		   salary
	FROM   employees
	WHERE  1 = 2;

SELECT *
FROM   emp4;

--修改表
/*
使用 ALTER TABLE 语句可以:
    追加新的列
    修改现有的列
    为新追加的列定义默认值
    删除一个列
    重命名表的一个列名

语法：
添加列
ALTER TABLE table_name
ADD        (column_name datatype [DEFAULT expr]
           [, column datatype]...);


修改列
ALTER TABLE table_name
MODIFY     (column_name datatype [DEFAULT expr]
           [, column datatype]...);

设置该类不可用
ALTER TABLE table_name SET UNUSED COLUMN column_name1,column_name2,...column_namen;

删除不可用列
ALTER TABLE table_name DROP UNUSED COLUMNS;

删除列
ALTER TABLE table_name
DROP COLUMN  column_name;

重命名列
ALTER TABLE table_name RENAME COLUMM old_column_name TO new_column_name

*/
--添加列
ALTER TABLE emp1 add(email VARCHAR2(20));
--修改列类型
ALTER TABLE emp1 modify(id NUMBER(15));
--修改列默认值
ALTER TABLE emp1 modify(salary NUMBER(10) DEFAULT 2000);

ALTER TABLE emp2 SET unused column commission_pct;

--删除列
ALTER TABLE emp1 drop column email;
--重命名列
ALTER TABLE emp1 rename column salary TO sal;

--删除表
/*
    数据和结构都被删除
    所有正在运行的相关事务被提交
    所有相关索引被删除
    DROP TABLE 语句不能回滚
*/
drop TABLE emp2;

--清空表
/*
TRUNCATE TABLE 语句:
    删除表中所有的数据
    释放表的存储空间

TRUNCATE语句不能回滚
可以使用 DELETE 语句删除数据,可以回滚
对比：
  delete from emp2;
  select * from emp2;
  rollback;
  select * from emp2;
*/
truncate TABLE emp2;

--修改对象名
/*
执行RENAME语句改变表, 视图, 序列, 或同义词的名称 
    RENAME old_name TO new_name;
*/
rename emp3 TO emp6;

--总结
/*
通过本章学习，您已经学会如何使用DDL语句创建, 修改, 删除, 和重命名表. 

语句                  描述
CREATE TABLE        创建表
ALTER TABLE         修改表结构 
DROP TABLE          删除表
RENAME  TO          重命名表
TRUNCATE TABLE      删除表中的所有数据，并释放存储空间
SET UNUSED          设置列不可用
DROP COLUMN         删除列

【注意】以上这些DDL的命令，操作完，皆不可回滚！
*/

--练习：51. 利用子查询创建表 myemp, 该表中包含 employees 表的 employee_id(id), last_name(name), salary(sal), email 字段
--1). 创建表的同时复制 employees 对应的记录
CREATE TABLE myemp1 AS
	SELECT employee_id id,
		   last_name   NAME,
		   salary      sal,
		   email
	FROM   employees;
--2). 创建表的同时不包含 employees 中的记录, 即创建一个空表
CREATE TABLE myemp3 AS
	SELECT employee_id id,
		   last_name   NAME,
		   salary      sal,
		   email
	FROM   employees
	WHERE  1 = 2;

--练习：52. 对现有的表进行修改操作
--  1). 添加一个新列
ALTER TABLE myemp add(commission_pct NUMBER(4, 2) DEFAULT 0);

SELECT *
FROM   emp2;

--  2). 修改现有列的类型
ALTER TABLE myemp modify(commission_pct NUMBER(5, 2) DEFAULT 0);
--  3). 修改现有列的名字
ALTER TABLE myemp rename column commission_pct TO comm;
--  4). 删除现有的列
ALTER TABLE myemp drop column comm;
--练习：53. 清空表(截断： truncate), 不能回滚!!  
truncate TABLE myemp;

--练习：54. 1). 创建一个表, 该表和 employees 有相同的表结构, 但为空表:  
CREATE TABLE myemp2 AS
	SELECT *
	FROM   employees
	WHERE  1 = 2;

--练习：54. 2). 把 employees 表中 80 号部门的所有数据复制到 emp2 表中
drop TABLE emp2;

CREATE TABLE emp2 AS
	SELECT *
	FROM   employees
	WHERE  1 = 2;

INSERT INTO emp2
	SELECT *
	FROM   employees
	WHERE  department_id = 80;

SELECT *
FROM   emp2;

--练习：1.创建表dept1
/*
name    Null? type
id              Number(7)
name            Varchar2(25)
*/
CREATE TABLE dept1(id NUMBER(7),
				   NAME VARCHAR2(25));

--练习：2.将表departments中的数据插入新表dept2中
CREATE TABLE dept2 AS
	SELECT *
	FROM   departments;

--练习：3.创建表emp5
/*
name    Null? type
id              Number(7)
First_name      Varchar2(25)
Last_name       Varchar2(25)
Dept_id         Number(7)
*/
CREATE TABLE emp5(id NUMBER(7),
				  first_name VARCHAR2(25),
				  last_name VARCHAR2(25),
				  dept_id NUMBER(7));

--练习：4.将列Last_name的长度增加到50
ALTER TABLE emp5 modify(last_name VARCHAR2(50));

--练习：5.根据表employees创建employees2
CREATE TABLE employees2 AS
	SELECT *
	FROM   employees;

--练习：6.删除表emp5
drop TABLE emp5;

--练习：7.将表employees2重命名为emp5
rename employees2 TO emp5;

--练习：8.在表dept和emp5中添加新列test_column，并检查所作的操作
ALTER TABLE dept1 add(test_column NUMBER(10));
ALTER TABLE emp5 add(test_column NUMBER(10));
DESC dept1;

--练习：9.在表dept和emp5中将列test_column设置成不可用，之后删除
ALTER TABLE dept1 SET unused column test_column;
ALTER TABLE emp5 SET unused column test_column;

ALTER TABLE dept1 drop unused columns;
ALTER TABLE emp5 drop unused columns;

--练习：10.直接删除表emp5中的列 dept_id
ALTER TABLE emp5 drop column department_id;
