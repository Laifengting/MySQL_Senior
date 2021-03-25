----视图
--视图的概念：视图就是提供一个查询的窗口，所有数据来自于原表。
--查询语句创建表

/*CREATE TABLE emp AS
SELECT *
FROM   scott.emp;*/

SELECT *
FROM   emp;

--创建视图[必须有dba权限]
CREATE view v_emp AS
	SELECT ename,
		   job
	FROM   emp;

--查询视图
SELECT *
FROM   v_emp;

--修改视图[能修改但不推荐]
UPDATE v_emp
SET    job = 'CLERK'
WHERE  ename = 'ALLEN';
COMMIT;

--创建只读视图
CREATE view v_emp1 AS
	SELECT ename,
		   job
	FROM   emp WITH READ ONLY;

----视图的作用？
--①视图可以屏蔽掉一些敏感的字段。
--②保证总部和分部数据及时统一。

SELECT *
FROM   v_emp1;
