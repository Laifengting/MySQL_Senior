----数据处理
--插入数据
/*
INSERT 语句语法：
使用 INSERT 语句向表中插入数据。
    INSERT INTO	table [(column [, column...])]
    VALUES		(value [, value...]);

使用这种语法一次只能向表中插入一条数据。
*/
--创建一个表emp1
CREATE TABLE emp1
AS
	SELECT employee_id,
		   last_name,
		   hire_date,
		   salary
		FROM employees
		WHERE 1 = 2;

--向emp1中插入数据
INSERT INTO emp1
	VALUES (1001,
			'AA',
			sysdate,
			10000);

INSERT INTO emp1
	VALUES (1002,
			'BB',
			to_date('1998-12-21',
					'yyyy-mm-dd'),
			20000);

INSERT INTO emp1
	VALUES (1003,
			'CC',
			to_date('1989-12-21',
					'yyyy-mm-dd'),
			NULL);

INSERT INTO emp1
(employee_id,
 last_name,
 hire_date) --顺序可以交换，但后面的赋值也需要按此顺序。
	VALUES
		(1004,
		'DD',
		to_date('1989-10-21',
		'yyyy-mm-dd'));

/*
为每一列添加一个新值。
按列的默认顺序列出各个列的值。 
在 INSERT 子句中随意列出列名和他们的值。

【注意】字符和日期型数据应包含在单引号中。
*/

--从其它表中拷贝数据
INSERT INTO emp1
(employee_id,
 hire_date,
 last_name,
 salary)
SELECT employee_id,
	   hire_date,
	   last_name,
	   salary
	FROM employees
	WHERE department_id = 80;

--创建脚本
/*
在SQL 语句中使用 & 变量指定列值。& 变量放在VALUES子句中。
*/

INSERT INTO emp1
(employee_id,
 hire_date,
 last_name,
 salary)
	VALUES (&id,
			 '&hire_date',
			 '&name',
			   &salary);

--更新数据
/*
UPDATE 语句语法

使用 UPDATE 语句更新数据。

UPDATE      table
SET     column = value [, column = value, ...]
[WHERE      condition];

可以一次更新多条数据。
*/
UPDATE emp1
SET
	salary = 12000
	WHERE employee_id = 179;

COMMIT;

SELECT *
	FROM emp1;

--【案例】更新 114号员工的工作和工资使其与205号员工相同。
--创建一副表
CREATE TABLE employees1
AS
	SELECT *
		FROM employees;
--更新表
UPDATE employees1
SET
	job_id =
		(
		SELECT job_id
			FROM employees1
			WHERE employee_id = 205),
	salary =
		(
		SELECT salary
			FROM employees1
			WHERE employee_id = 205)
	WHERE employee_id = 114;
--查询更新结果
SELECT employee_id,
	   job_id,
	   salary
	FROM employees1
	WHERE employee_id IN (114,
						  205);

--【案例】调整与employee_id 为200的员工job_id相同的员工的department_id为employee_id为100的员工的department_id。
--① 查询employee_id 为200的员工job_id
SELECT job_id
	FROM employees1
	WHERE employee_id = 200;

--② 查询employee_id为100的员工的department_id
SELECT department_id
	FROM employees1
	WHERE employee_id = 100;

--③ 修改job_id=①的department_id为②
UPDATE employees1
SET
	department_id =
		(
		SELECT department_id
			FROM employees1
			WHERE employee_id = 100)
	WHERE job_id = (
				   SELECT job_id
					   FROM employees1
					   WHERE employee_id = 200);

--更新中的数据完整性错误
/*
更新的department_id要在departments表中存在
*/
UPDATE employees
SET
	department_id = 55
	WHERE department_id = 110;

/*
更新的manager_id对应在employees中的employee_id要存在。
*/
UPDATE employees
SET
	manager_id = 299
	WHERE employee_id = 203;

--删除数据
/*
DELETE 语句
使用 DELETE 语句从表中删除数据。

语法：
DELETE FROM     table
[WHERE    condition];
*/
--【案例】从employees1表中删除部门名称中含Public字符的部门id
DELETE
	FROM employees1
	WHERE department_id = (
						  SELECT department_id
							  FROM departments
							  WHERE department_name LIKE '%Public%');

--删除中的数据完整性错误
/*
DELETE FROM departments
WHERE       department_id = 60;

You cannot delete a row that contains a primary key that is used as a foreign key in another table.
不能删除一行包含主键在另外一个表中被用作外键。
*/

/*
小结

添加数据
insert into ...
values(...);

insert into ...
select ... from... where...

修改数据
update ...
set...
where...

删除数据
delete from ...
where ...
*/

--数据库事务
/*
事务：一组逻辑操作单元,使数据从一种状态变换到另一种状态。
数据库事务由以下的部分组成:
    一个或多个DML 语句
    一个 DDL(Data Definition Language – 数据定义语言) 语句
    一个 DCL(Data Control Language – 数据控制语言) 语句

以第一个 DML 语句的执行作为开始

以下面的其中之一作为结束:
    COMMIT 或 ROLLBACK 语句
    DDL 语句（自动提交）
    用户会话正常结束
    系统异常终止


--COMMIT和ROLLBACK语句的优点

使用COMMIT 和 ROLLBACK语句,我们可以: 
    确保数据完整性。
    数据改变被提交之前预览。
    将逻辑上相关的操作分组。


--回滚到保留点
使用 SAVEPOINT 语句在当前事务中创建保存点。
使用 ROLLBACK TO SAVEPOINT 语句回滚到创建的保存点。

UPDATE...
SAVEPOINT update_done;

INSERT...
ROLLBACK TO update_done;


自动提交在以下情况中执行:
    DDL 语句。
    DCL 语句。
    不使用 COMMIT 或 ROLLBACK 语句提交或回滚，正常结束会话。
    会话异常结束或系统异常会导致自动回滚。


提交或回滚前的数据状态
改变前的数据状态是可以恢复的
执行 DML 操作的用户可以通过 SELECT 语句查询之前的修正
其他用户不能看到当前用户所做的改变，直到当前用户结束事务。
DML语句所涉及到的行被锁定， 其他用户不能操作。

提交后的数据状态
数据的改变已经被保存到数据库中。
改变前的数据已经丢失。
所有用户可以看到结果。
锁被释放,其他用户可以操作涉及到的数据。
所有保存点被释放。
*/

--总结
/*
通过本章学习, 您应学会如何使用DML语句改变数据和事务控制
语句          功能
INSERT          插入
UPDATE          修正
DELETE          删除

DCL语句
COMMIT          提交
SAVEPOINT   保存点
ROLLBACK        回滚
*/

--练习：55. 更改 108 员工的信息: 使其工资变为所在部门中的最高工资, job 变为公司中平均工资最低的 job
--  1). 搭建骨架
UPDATE employees1
SET
	salary =
		(),
	job_id =
		()
	WHERE employee_id = 108;
--  2). 所在部门中的最高工资  
SELECT MIN(salary)
	FROM employees1
	WHERE department_id = (
						  SELECT department_id
							  FROM employees1
							  WHERE employee_id = 108);
--  3). 公司中平均工资最低的 job
SELECT job_id
	FROM employees1
	GROUP BY job_id
	HAVING AVG(salary) = (
						 SELECT MIN(AVG(salary))
							 FROM employees1
							 GROUP BY job_id);

--  4). 填充
UPDATE employees1 e
SET
	salary =
		(
		SELECT MAX(salary)
			FROM employees1
			WHERE department_id = (
								  SELECT department_id
									  FROM employees1
									  WHERE employee_id = 108)),
	job_id =
		(
		SELECT job_id
			FROM employees1
			GROUP BY job_id
			HAVING AVG(salary) = (
								 SELECT MIN(AVG(salary))
									 FROM employees1
									 GROUP BY job_id))
	WHERE employee_id = 108;

COMMIT;

SELECT *
	FROM employees1
	WHERE employee_id = 108;

--练习：56. 删除 108 号员工所在部门中工资最低的那个员工.
--  1). 查询 108 员工所在的部门 id
SELECT department_id
FROM   employees1
WHERE  employee_id = 108;

--  2). 查询 1) 部门中的最低工资:
SELECT MIN(salary)
	FROM employees1
	WHERE department_id = (
						  SELECT department_id
							  FROM employees1
							  WHERE employee_id = 108);

--  3). 删除 1) 部门中工资为 2) 的员工信息:
DELETE
	FROM employees1 e
	WHERE salary = (
				   SELECT MIN(salary)
					   FROM employees1
					   WHERE department_id = e.department_id) - -sql优化
	  AND department_id = (
						  SELECT department_id
							  FROM employees1
							  WHERE employee_id = 108);

--练习：1.运行以下脚本创建表my_employees
CREATE TABLE my_employee (
	id NUMBER (3),
	first_name VARCHAR2 (10),
	last_name VARCHAR2 (10),
	user_id VARCHAR2 (10),
	salary NUMBER (5)
);

--练习：2.显示表my_employees的结构
DESC my_employees;

--练习：3.向表中插入下列数据
/*
ID          FIRST_NAME  LAST_NAME USERID      SALARY
1           patel       Ralph       Rpatel      895
2           Dancs       Betty   Bdancs      860
3           Biri        Ben         Bbiri       1100
4           Newman      Chad        Cnewman     750
5           Ropeburn    Audrey      Aropebur    1550
*/

INSERT INTO my_employee
	VALUES (1,
			'patel',
			'Ralph',
			'Rpatel',
			895);

INSERT INTO my_employee
	VALUES (2,
			'Dancs',
			'Betty',
			'Bdancs',
			860);

INSERT INTO my_employee
	VALUES (3,
			'Biri',
			'Ben',
			'Bbiri',
			1100);

INSERT INTO my_employee
	VALUES (4,
			'Newman',
			'Chad',
			'Cnewman',
			750);

INSERT INTO my_employee
	VALUES (5,
			'Ropeburn',
			'Audrey',
			'Aropebur',
			1550);

SELECT *
	FROM my_employee;

--练习：4.提交
COMMIT;

--练习：5.将3号员工的last_name修改为“drelxer”
UPDATE my_employee
SET
	last_name = 'drelxer'
	WHERE id = 3;

--练习：6.将所有工资少于900的员工的工资修改为1000
UPDATE my_employee
SET
	salary = 1000
	WHERE salary < 900;

--练习：7.检查所作的修正
SELECT *
	FROM my_employee
	WHERE salary < 900;
--练习：8.提交
COMMIT;

--练习：9.删除所有数据
DELETE
	FROM my_employee
	WHERE 1 = 1;
--练习：10.检查所作的修正
SELECT *
	FROM my_employee;
--练习：11.回滚
ROLLBACK;
--练习：12.清空表my_employee
TRUNCATE TABLE my_employee;
