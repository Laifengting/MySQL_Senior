----单行函数
--字符函数
/*
大小写控制函数
    LOWER
    UPPER
    INITCAP
    
大小写控制函数
这类函数改变字符的大小写。
    函数                          结果
LOWER('SQL Course')             sql course
UPPER('SQL Course')             SQL COURSE
INITCAP('SQL Course')           Sql Course


字符控制函数
    CONCAT
    SUBSTR
    LENGTH
    INSTR
    LPAD|RPAD
    TRIM
    REPLACE
    
    函数                          结果
CONCAT('Hello', 'World')        HelloWorld
SUBSTR('HelloWorld',1,5)        Hello
LENGTH('HelloWorld')            10
INSTR('HelloWorld', 'W')        6
LPAD(salary,10,'*')             *****24000
RPAD(salary, 10, '*')           24000*****
TRIM('H' FROM 'HelloWorld')     elloWorld
REPLACE(‘abcd’,’b’,’m’)         amcd
*/

--大小写控制函数的应用
SELECT LOWER('AGDFHDFHVDFGFDG'),
	   UPPER('sdfsdfasdfsdgfgha'),
	   initcap('sdfsdfs sdfsdfaghaa DGADFADFGADF')
	FROM dual;

--查询90号部门的员工信息
SELECT *
	FROM employees
	WHERE department_id = 90;

--【案例】查询King的员工信息
SELECT *
	FROM employees
	WHERE last_name = 'king';
--因为字符串是严格区分大小写的。所以查询不出来。

--通过使用大小控制函数来修改以上代码
SELECT *
	FROM employees
	WHERE LOWER(last_name) = 'king';
--通过lower()将last_name都改成小写。

--concat(),substr(),length(),instr()的使用
SELECT CONCAT('hello',
			  'world'),
	   SUBSTR('Helloworld',
			  2,
			  4),
	   LENGTH('Helloworld'),
	   INSTR('Helloworld',
			 'w')
	FROM dual;

--lpad(),rpad()的使用
SELECT employee_id,
	   last_name,
	   LPAD(salary,
			10,
			'*'),
	   RPAD(salary,
			10,
			'*')
	FROM employees;

--trim(),
REPLACE () 的使用
/*
TRIM([ { { LEADING | TRAILING | BOTH }
         [ trim_character ]
       | trim_character
       }
       FROM 
     ]
     trim_source
    )

REPLACE(char, search_string
        [, replacement_string ]
       )
*/
SELECT TRIM('h' FROM 'helloHworldh'),
	   REPLACE('abcdab',
			   'b',
			   'm')
	FROM dual;

--数值函数
/*
round(n [, integer ])
trunc(n1 [, n2 ])
mod(n2, n1)
*/
--round()的使用
SELECT ROUND(435.456,
			 2),
	   ROUND(435.456),
	   ROUND(435.456,
			 -2)
	FROM dual;

--trunc()的使用
SELECT trunc(435.456,
			 2),
	   trunc(435.456),
	   trunc(435.456,
			 -2)
	FROM dual;

SELECT MOD(10,
		   3)
	FROM dual;

--日期函数
/*
sysdate         返回日期时间
MONTHS_BETWEEN  两个日期相差的月数
ADD_MONTHS      向指定日期中加上若干月数
NEXT_DAY        指定日期的下一个星期 * 对应的日期
LAST_DAY        本月的最后一天
ROUND         日期四舍五入
TRUNC       日期截断
*/
SELECT sysdate,
	   sysdate + 1,
	   sysdate - 3
	FROM dual;

--【案例】查询员工到公司多少天了。
SELECT employee_id,
	   last_name,
	   trunc(sysdate - hire_date) worke_days
	FROM employees;

--【案例】查询员工到公司多少月了。
SELECT employee_id,
	   last_name,
	   months_between(sysdate,
					  hire_date) worke_months
	FROM employees;

--add_months(),next_day()的使用
SELECT add_months(sysdate,
				  2),
	   add_months(sysdate,
				  -3),
	   next_day(sysdate,
				'sunday')
	FROM dual;

--last_day()案例
--来公司的员工中，hire_date是每个月倒数第二天来公司的员工有哪些？
SELECT last_name,
	   hire_date
	FROM employees
	WHERE hire_date = LAST_DAY(hire_date) - 2;

--round(),trunc()的使用
SELECT sysdate,
	   ROUND(sysdate,
			 'YEAR'),
	   ROUND(sysdate,
			 'MONTH'),
	   ROUND(sysdate,
			 'DDD'),
	   ROUND(sysdate,
			 'HH24'),
	   ROUND(sysdate,
			 'MI')
	FROM dual;

SELECT sysdate,
	   trunc(sysdate,
			 'YEAR'),
	   trunc(sysdate,
			 'MONTH'),
	   trunc(sysdate,
			 'DDD'),
	   trunc(sysdate,
			 'HH24'),
	   trunc(sysdate,
			 'MI')
	FROM dual;

--转换函数
/*
隐性
date ↔ varchar2 ↔ number
*/
SELECT '12' + 2
	FROM dual;
--输出14

SELECT sysdate + '2'
	FROM dual;

/*
显性
to_date
to_number
to_char
*/
--字符转日期
SELECT employee_id,
	   to_char(hire_date,
			   'yyyy"年"mm"月"dd"日"')
	FROM employees --日期转字符
--
	WHERE to_char(hire_date, 'yyyy"年"mm"月"dd"日"') = '1994年06月07日';
--日期转字符
--WHERE  to_char(hire_date,'yyyy/mm/dd') = '1994/06/07';
WHERE  to_date('1994-06-07',
			   'yyyy-mm-dd') = hire_date;

--数字转字符
SELECT to_char(1234567.89,
			   '999,999,999.99')
	FROM dual;
--1,234,567.89
--数字转字符
SELECT to_char(1234567.89,
			   '000,000,000.00')
	FROM dual;
--001,234,567.89

--数字转字符
SELECT to_char(1234567.89,
			   '$000,000,000.00')
	FROM dual;
--$001,234,567.89

--字符转数字
SELECT to_number('$001,234,567.89',
				 '$000,000,000.00')
	FROM dual;

--通用函数
/*
以下函数适用于任何数据类型，也适用于空值：
nvl(expr1,expr2)：如果expr1为空,返回expr2,如果expr1不为空,返回expr1。
nvl2(expr1,expr2,expr3)：如果expr1不为空,返回expr2,如果expr1为空,返回expr3。
nullif(expr1,expr2)：比较expr1和expr2如果相等，返回null,如果不相等，返回expr1。expr1不能指定为null。
coalesce(expr1,expr2,...exprn)：返回至少两个表达式中的第一个非空表达式。如果所有表达式都为空，就返回null。
*/

--练习1：求公司员工的年薪（含commission_pct)
SELECT last_name,
	   12 * salary * (1 + nvl(commission_pct,
							  0)) 年薪
	FROM employees;

--练习2：输出last_name,department_id，当department_id为null时，显示‘没有部门’。
--当类型不兼容时，需要类型转换。
SELECT last_name,
	   nvl(to_char(department_id),
		   '没有部门')
		   - -nvl(to_char(department_id,'99999999'),'没有部门')
	FROM employees;

--练习3：查询员工的奖金率，若为空，返回0.01,若不为空，返回实际奖金率+0.015
SELECT last_name,
	   commission_pct,
	   nvl2(commission_pct,
			commission_pct + 0.015,
			0.01)
	FROM employees;

--条件表达式
/*
CASE expr 
    WHEN comparison_expr1 THEN return_expr1
    [WHEN comparison_expr2 THEN return_expr2
    ...
    WHEN comparison_exprn THEN return_exprn
    ELSE else_expr]
END
*/
--练习：查询部门号为 10, 20, 30 的员工信息, 若部门号为 10, 则打印其工资的 1.1 倍, 20 号部门, 
--则打印其工资的 1.2 倍, 30 号部门打印其工资的 1.3 倍数
SELECT employee_id,
	   last_name,
	   salary,
	   department_id,
	   CASE department_id
		   WHEN 10
			   THEN
			   salary * 1.1
		   WHEN 20
			   THEN
			   salary * 1.2
			   ELSE
			   salary * 1.3
		   END 薪水
	FROM employees
	WHERE department_id IN (10,
							20,
							30);

--改成DECODE
SELECT employee_id,
	   last_name,
	   salary,
	   department_id,
	   DECODE(department_id,
			  10,
			  salary * 1.1,
			  20,
			  salary * 1.2,
			  salary * 1.3) 薪水
	FROM employees
	WHERE department_id IN (10,
							20,
							30);

--总结
/*
    通过本章学习，您应该学会:
    • 使用函数对数据进行计算
    • 使用函数修改数据
    • 使用函数控制一组数据的输出格式
    • 使用函数改变日期的显示格式
    • 使用函数改变数据类型
    • 使用 NVL 函数
    • 使用IF-THEN-ELSE 逻辑
*/

--练习：打印出 "2009年10月14日 9:25:40" 格式的当前系统的日期和时间.
--fm去除年月日时分秒前面的0
SELECT to_char(sysdate,
			   'fmYYYY"年"MM"月"DD"日" HH:MI:SS') 时间日期
	FROM dual;

--练习：格式化数字: 1234567.89 为 1,234,567.89
SELECT to_char(1234567.89,
			   '999,999,999.99') 数字
	FROM dual;

--1.显示系统时间(注：日期+时间)
SELECT to_char(sysdate,
			   'fmYYYY"年"MM"月"DD"日" HH24:MI:SS')
	FROM dual;

--2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
SELECT employee_id,
	   last_name,
	   salary,
	   salary * 1.2 "new salary"
	FROM employees;

--3.将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT last_name,
	   LENGTH(last_name)
	FROM employees
	ORDER BY last_name ASC;

--4.查询各员工的姓名，并显示出各员工在公司工作的月份数（worked_month）。
SELECT last_name,
	   ROUND(months_between(sysdate,
							hire_date),
			 1) worked_month
	FROM employees;

--5.查询员工的姓名，以及在公司工作的月份数（worked_month），并按月份数降序排列
SELECT last_name,
	   hire_date,
	   ROUND(months_between(sysdate,
							hire_date),
			 1) worked_month
	FROM employees
	ORDER BY worked_month DESC;

--6.做一个查询，产生下面的结果
/*<last_name> earns <salary> monthly but wants <salary*3>
Dream Salary
King earns $24000 monthly but wants $72000*/

--使用||连接字符串
SELECT last_name || ' earns ' || to_char(salary,
										 'fm$999999') || ' monthly but wants ' ||
	   to_char(salary * 3,
			   'fm$999999') "Dream Salary"
	FROM employees;

--使用concat多重嵌套。【注意：MySQL中CONCAT是可以连接多个字符串的。】
SELECT CONCAT(CONCAT(CONCAT(last_name,
							' earns '),
					 CONCAT(to_char(salary,
									'fm$999999'),
							' monthly but wants ')),
			  to_char(salary * 3,
					  'fm$999999')) "Dream Salary"
	FROM employees;

--7.使用decode函数，按照下面的条件：
/*job             grade
AD_PRES            A
ST_MAN             B
IT_PROG            C
SA_REP             D
ST_CLERK           E
产生下面的结果
Last_name Job_id       Grade
king        AD_PRES      A*/
SELECT last_name last_name,
	   job_id job_id,
	   DECODE(job_id,
			  'AD_PRES',
			  'A',
			  'ST_MAN',
			  'B',
			  'IT_PROG',
			  'C',
			  'SA_REP',
			  'D',
			  'ST_CLERK',
			  'E') grade
	FROM employees
	WHERE job_id = 'AD_PRES';

SELECT *
	FROM employees;

--8.将第7题的查询用case函数再写一遍。
SELECT last_name last_name,
	   job_id job_id,
	   CASE job_id
		   WHEN 'AD_PRES'
			   THEN
			   'A'
		   WHEN 'ST_MAN'
			   THEN
			   'B'
		   WHEN 'IT_PROG'
			   THEN
			   'C'
		   WHEN 'SA_REP'
			   THEN
			   'D'
		   WHEN 'ST_CLERK'
			   THEN
			   'E'
		   END grade
	FROM employees
	WHERE job_id = 'AD_PRES';
