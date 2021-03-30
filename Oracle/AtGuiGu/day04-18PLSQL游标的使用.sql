--游标的使用
/*
在 PL/SQL 程序中，对于 处理多行记录的事务经常使用游标来实现。

§4.1  游标概念
为了处理 SQL 语句，ORACLE 必须分配一片叫上下文( context area )的区域来处理所必需的信息，其中
包括要处理的行的数目，一个指向语句被分析以后的表示形式的指针以及查询的活动集(active set)。

游标是一个指向上下文的句柄( handle) 或指针。通过游标，PL/SQL 可以控制上下文区和处理语句时上下文区会发生些什么事情。

对于不同的 SQL 语句，游标的使用情况不同：
SQL语句               游标
非查询语句           隐式的
结果是单行的查询语句      隐式的或显示的
结果是多行的查询语句      显示的

§4.1.1  处理显式游标
1.  显式游标处理
显式游标处理需四个 PL/SQL  步骤:
  【定义游标】 ：就是定义一个游标名，以及与其相对应的 SELECT 语句。
格式：
CURSOR cursor_name[(parameter[, parameter]…)] IS select_statement;
游标参数只能为输入参数，其格式为：
parameter_name [IN] datatype [{:= | DEFAULT} expression]
在指定数据类型时，不能使用长度约束。如 NUMBER(4)、CHAR(10) 等都是错误的。

  【打开游标】 ：就是执行游标所对应的 SELECT 语句，将其查询结果放入工作区，并且指针指向工作区的首
部，标识游标结果集合。如果游标查询语句中带有 FOR UPDATE 选项，OPEN 语句还将锁定数据库表中
游标结果集合对应的数据行。
格式：
OPEN cursor_name[([parameter =>] value[, [parameter =>] value]…)];
在向游标传递参数时，可以使用与函数参数相同的传值方法，即位置表示法和名称表示 法。PL/SQL
程序不能用 OPEN  语句重复打开一个游标。

  【提取游标数据】 ：就是检索结果集合中的数据行，放入指定的输出变量中。
格式：
FETCH cursor_name INTO {variable_list | record_variable };
  对该记录进行处理；
  继续处理，直到活动集合中没有记录；

  【关闭游标】 ：当提取和处理完游标结果集合数据后，应及时关闭游标，以释放该游标所占用的系统资源，
并使该游标的工作区变成无效，不能再使用 FETCH 语句取其中数据。关闭后的游标可以使用 OPEN 语
句重新打开。
格式：
CLOSE cursor_name;
注： 定义的游标不能有 INTO  子句 。
*/

--要求: 打印出 80 部门的所有的员工的工资:salary: xxx
--方式一：
DECLARE
	v_sal       employees.salary%TYPE;
v_last_name employees.last_name%TYPE;
--定义游标
	CURSOR emp_sal_cursor IS
SELECT salary,
	   last_name
	FROM employees
	WHERE department_id = 80;
BEGIN --打开游标
	OPEN emp_sal_cursor;

--提取游标
	FETCH emp_sal_cursor
		INTO v_sal,
			 v_last_name;

WHILE emp_sal_cursor%FOUND
	LOOP
		dbms_output.put_line('Name: ' || v_last_name || ', Salary: ' || v_sal);
FETCH emp_sal_cursor
			INTO v_sal,
				 v_last_name;
END LOOP;

--关闭游标
	CLOSE emp_sal_cursor;
END;

--方式二：
DECLARE
	--声明一个记录类型
	TYPE emp_record IS RECORD(
		v_sal       employees.salary%TYPE,
		v_last_name employees.last_name%TYPE,
		v_hire_date employees.hire_date%TYPE);

--声明一个记录类型的变量
	v_emp_record emp_record;

--定义游标
	CURSOR emp_sal_cursor IS
SELECT salary,
	   last_name,
	   hire_date
	FROM employees
	WHERE department_id = 80;
BEGIN --打开游标
	OPEN emp_sal_cursor;

--提取游标
	FETCH emp_sal_cursor
		INTO v_emp_record;

WHILE emp_sal_cursor%FOUND
	LOOP
		dbms_output.put_line('Name: ' || v_emp_record.v_last_name || ', Salary: ' ||
							 v_emp_record.v_sal || ', Hire_date: ' || v_emp_record.v_hire_date);
FETCH emp_sal_cursor
			INTO v_emp_record;
END LOOP;

--关闭游标
	CLOSE emp_sal_cursor;
END;

--方式三：
DECLARE
	--定义游标
	CURSOR emp_sal_cursor IS
SELECT salary,
	   last_name,
	   hire_date
	FROM employees
	WHERE department_id = 80;
BEGIN --for循环可以自动打开提取关闭游标
	FOR c IN emp_sal_cursor
	LOOP
		dbms_output.put_line('Name: ' || c.last_name || ', Salary: ' || c.salary ||
							 ', Hire_date: ' || c.hire_date);
END LOOP;
END;

--14. 利用游标, 调整公司中员工的工资: 
/*
    工资范围       调整基数
    0 - 5000       5%
    5000 - 10000   3%
    10000 - 15000  2%
    15000 -        1%
*/
--准备新表
CREATE TABLE employees1
AS
	SELECT *
		FROM employees;

SELECT *
	FROM employees1;
--方式一：
DECLARE
	--定义游标
	CURSOR emp_sal_crusor IS
SELECT salary,
	   employee_id
	FROM employees;
--定义一个调整基数变量
	v_temp NUMBER(3,
				  2);

--定义存放游标值的变量
	v_sal    employees.salary%TYPE;
v_emp_id employees.employee_id%TYPE;

BEGIN --打开游标
	OPEN emp_sal_crusor;

--提取游标
	FETCH emp_sal_crusor
		INTO v_sal,
			 v_emp_id;

WHILE emp_sal_crusor%FOUND
	LOOP
		IF v_sal > 15000 THEN
			v_temp := 0.01;
ELSIF v_sal >= 10000 THEN
			v_temp := 0.02;
ELSIF v_sal >= 5000 THEN
			v_temp := 0.03;
ELSE
			v_temp := 0.05;
END IF;

UPDATE employees1
SET
	salary = salary * (1 + v_temp)
	WHERE employee_id = v_emp_id;

FETCH emp_sal_crusor
			INTO v_sal,
				 v_emp_id;
END LOOP;

--关闭游标
	CLOSE emp_sal_crusor;
END;

SELECT *
	FROM employees1;

--方式二：
DECLARE
	--定义游标
	CURSOR emp_sal_crusor IS
SELECT salary,
	   employee_id
	FROM employees;
--定义一个调整基数变量
	v_temp NUMBER(3,
				  2);

BEGIN FOR c IN emp_sal_crusor
	LOOP
		IF c.salary > 15000 THEN
			v_temp := 0.01;
ELSIF c.salary >= 10000 THEN
			v_temp := 0.02;
ELSIF c.salary >= 5000 THEN
			v_temp := 0.03;
ELSE
			v_temp := 0.05;
END IF;

UPDATE employees1
SET
	salary = salary * (1 + v_temp)
	WHERE employee_id = c.employee_id;
END LOOP;
END;

--16*. 带参数的游标

DECLARE
	--定义游标
	CURSOR emp_sal_cursor
	(
		dept_id NUMBER,
		sal     NUMBER
	) IS
SELECT salary + 1000 sal,
	   employee_id id
	FROM employees
	WHERE department_id = dept_id
	  AND salary > sal;

--定义基数变量
	temp NUMBER(4,
				2);
BEGIN --处理游标的循环操作
	FOR c IN emp_sal_cursor(sal     => 4000,
							dept_id => 80)
	LOOP
		--判断员工的工资, 执行
UPDATE 操作
	--dbms_output.put_line(c.id || ': ' || c.sal);

IF c.sal <= 5000 THEN
			temp := 0.05;
ELSIF c.sal <= 10000 THEN
			temp := 0.03;
ELSIF c.sal <= 15000 THEN
			temp := 0.02;
ELSE
			temp := 0.01;
END IF;

dbms_output.put_line(c.sal || ': ' || c.id || ', ' || temp);
--
UPDATE employees
SET
	salary = salary * (1 + temp)
	WHERE employee_id = c.id;
END LOOP;
END;

--17. 隐式游标: 更新指定员工 salary(涨工资 10)，如果该员工没有找到，则打印”查无此人” 信息

BEGIN
UPDATE employees
SET
	salary = salary + 10
	WHERE employee_id = 1005;

IF SQL%NOTFOUND THEN
		dbms_output.put_line('查无此人!');
END IF;
END;
