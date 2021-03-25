--在查询中过滤行
/*
语法：
SELECT * |  { [ DISTINCT ] column | expression [ alias ],...}
FROM   TABLE [
WHERE  condition(s) ];*/
SELECT employee_id,
	   last_name,
	   salary
FROM   employees
WHERE  department_id = 90;

--字符和日期
/*
    字符和日期要包含在单引号中。
    字符大小写敏感，日期格式敏感。
    默认的日期格式是 DD-MON月-RR。
*/
--过滤字符串
SELECT employee_id,
	   last_name,
	   salary
FROM   employees
WHERE  last_name = 'Higgins';

--过滤日期
SELECT last_name,
	   hire_date
FROM   employees
WHERE  to_char(hire_date,
			   'yyyy-mm-dd') = '1994-06-07';

--比较运算
/*
操作符              含义
=               等于 (不是 ==)
>               大于 
>=                  大于、等于 
<               小于 
<=                  小于、等于
<>                  不等于 (也可以是 !=)
BETWEEN...AND...    在两个值之间 (包含边界)
IN(set)             等于值列表中的一个 
LIKE                模糊查询 
IS NULL             空值

赋值使用 := 符号
*/
-->= <的使用
SELECT last_name,
	   hire_date,
	   salary
FROM   employees
WHERE  salary >= 4000
AND    salary <= 7000;

--[not]between and的使用
SELECT last_name,
	   hire_date,
	   salary
FROM   employees
WHERE  salary BETWEEN 4000 AND 7000;

--[not]in的使用
SELECT last_name,
	   hire_date,
	   salary
FROM   employees
WHERE  department_id IN (70,
						 80,
						 90);

--like的使用
--【案例】查询名字中第三个字母是a的员工的姓名，部门编号，薪水。
--'_'匹配一个字符，'%'匹配0-多个字符。
SELECT last_name,
	   department_id,
	   salary
FROM   employees
WHERE  last_name LIKE '__a%';

--修改表中一个人的名字，加入_
UPDATE employees
SET    last_name = 'Wha_len'
WHERE  last_name = 'Whalen';

SELECT *
FROM   employees
WHERE  last_name = 'Wha_len';

--【案例】查询员工名字中带有'_'的员工有哪些？
--设置转义字符 'x' escape 'x'
SELECT last_name,
	   department_id,
	   salary
FROM   employees
WHERE  last_name LIKE '%$_%' ESCAPE '$';

--is null/is not null的使用
SELECT last_name,
	   department_id,
	   salary,
	   commission_pct
FROM   employees
WHERE  commission_pct IS NOT NULL;

--逻辑运算
/*
操作符           含义
and             逻辑与
or              逻辑或
not             逻辑非
*/
--【案例】查询部门编号80且工资小于等于7000的员工信息
SELECT *
FROM   employees
WHERE  department_id = 80
AND    salary <= 7000;

--运算符优先级
/*
 优先级
    1 算术运算符
    2 连接符
    3 比较符
    4 IS [NOT] NULL, LIKE, [NOT] IN
    5 [NOT] BETWEEN
    6 NOT 
    7 AND
    8 OR
*/

--排序数据
/*
使用 ORDER BY 子句排序|别名
ASC（ascend）: 升序   ——默认排序
DESC（descend）: 降序
*/
--【案例】将80号部门的员工按工资升序排序，如果工资一样按部门升序，如果部门号一样，按姓名降序。

SELECT last_name,
	   department_id,
	   salary AS "薪水",
	   commission_pct
FROM   employees
WHERE  department_id = 80
ORDER  BY 薪水          ASC,
		  department_id ASC,
		  last_name     DESC;


--总结
/*
通过本课，您应该可以完成: 
    使用WHERE 子句过滤数据
        使用比较运算
        使用 BETWEEN AND, IN, LIKE和 NULL运算
        使用逻辑运算符 AND, OR和NOT 
    使用 ORDER BY 子句进行排序。

SELECT     *|{[DISTINCT] column|expression [alias],...}
FROM       table
[WHERE     condition(s)]
[ORDER BY  {column, expr, alias} [ASC|DESC]];
*/


--练习
/*
1.查询工资大于12000的员工姓名和工资
*/
SELECT last_name,
	   salary
FROM   employees
WHERE  salary > 12000;

/*
2.查询员工号为176的员工的姓名和部门号
*/
SELECT last_name,
	   department_id
FROM   employees
WHERE  employee_id = 176;

/*
3.选择工资不在5000到12000的员工的姓名和工资
*/
SELECT last_name,
	   salary
FROM   employees
--where salary < 5000 or salary > 12000;
WHERE  salary NOT BETWEEN 5000 AND 12000;

/*
4.选择雇用时间在1998-02-01到1998-05-01之间的员工姓名，job_id和雇用时间
*/
SELECT last_name,
	   job_id,
	   hire_date
FROM   employees
WHERE  to_char(hire_date,
			   'YYYY-MM-DD') BETWEEN '1998-02-01' AND '1998-05-01';

/*
5.选择在20或50号部门工作的员工姓名和部门号
*/
SELECT last_name,
	   department_id
FROM   employees
--WHERE department_id = 20 or department_id = 50;
WHERE  department_id IN (20,
						 50);

/*
6.选择在1994年雇用的员工的姓名和雇用时间
*/
SELECT last_name,
	   hire_date
FROM   employees
--WHERE hire_date like '%94';
WHERE  to_char(hire_date,
			   'YYYY') = '1994';

/*
7.选择公司中没有管理者的员工姓名及job_id
*/
SELECT last_name,
	   job_id
FROM   employees
WHERE  manager_id IS NULL;

/*
8.选择公司中有奖金的员工姓名，工资和奖金级别
*/
SELECT last_name,
	   salary,
	   commission_pct
FROM   employees
WHERE  commission_pct IS NOT NULL;

/*
9.选择员工姓名的第三个字母是a的员工姓名
*/
SELECT last_name
FROM   employees
WHERE  last_name LIKE '__a%';

/*
10.选择姓名中有字母a和e的员工姓名
*/
SELECT last_name
FROM   employees
--WHERE last_name LIKE '%a%e%' OR last_name LIKE '%e%a%';
WHERE  last_name LIKE '%a%'
AND    last_name LIKE '%e%';

/*
11.查询姓名中有_的员工姓名
*/
SELECT last_name
FROM   employees
WHERE  last_name LIKE '%\_%' ESCAPE '\';
