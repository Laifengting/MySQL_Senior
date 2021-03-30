--导入表格命令[在Command Window使用]
@d:/hr_popul.sql;

--查询表的内容
/*
语法：
SELECT *
FROM   table;
*/
SELECT *
	FROM employees;

--查询表中的某一列或某几列
/*
SELECT	*|{[DISTINCT] column|expression [alias],...}
FROM	table;
*/
SELECT employee_id,
	   last_name,
	   email
	FROM employees;

--查询表中的列[在Command Window使用]
DESC employees;

--查询EMPLOYEES表中的员工名，月薪，年薪+奖金
SELECT last_name,
	   salary,
	   salary * 12 + 1000
	FROM employees;

--注意运算符的优先级
SELECT last_name,
	   salary,
	   salary * 12 + 1000,
	   12 * (salary + 1000)
	FROM employees --日期类型的数学运算 日期可以进行加减运算。[日期类型乘法除法没有意义会报错]
SELECT sysdate,
	   sysdate + 1,
	   sysdate - 2
	FROM dual;

--空值的定义与处理
SELECT employee_id,
	   last_name,
	   commission_pct
	FROM employees;

--空值不同于0，凡是空值参与的运算，结果都为空(NULL)。
SELECT employee_id,
	   salary,
	   commission_pct,
	   salary * (1 + commission_pct) - -存在空值
	FROM employees;

--空值的处理NVL(expr1,expr2)：如果expr1为空，则返回expr2，如果expr1不为空，则返回expr1
SELECT employee_id,
	   salary,
	   commission_pct,
	   salary * (1 + nvl(commission_pct,
						 0))
	FROM employees;


--起别名
/*
SELECT last_name [AS] name, commission_pct comm
FROM   employees;


SELECT last_name [AS] "Name",
	   salary * 12 "Annual Salary"
FROM   employees;
*/
SELECT employee_id id,
	   last_name name,
	   salary * 12 "Annual Salary"
	FROM employees;


--连接符"||"
SELECT last_name || '`s job is ' || job_id employees
	FROM employees;

--删除重复行(去重)
SELECT DISTINCT department_id
	FROM employees;


--总结
/*
通过本课，您应该可以完成: 
    书写SELECT语句:  SELECT … FROM…
        返回表中的全部数据。
        返回表中指定列的数据。
        使用别名。 
        
    使用 SQL*Plus 环境，书写，保存和执行 SQL 语句和 SQL*Plus 命令。

SELECT	*|{[DISTINCT] column|expression [alias],...}
FROM	table;

*/
