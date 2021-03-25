--存储函数和过程
/*
ORACLE  提供可以把 PL/SQL  程序存储在数据库中，并可以在任何地方来运行它。这样就叫存储过
程或函数。过程和函数统称为 PL/SQL 子程序，他们是被命名的 PL/SQL 块，均存储在数据库中，并
通过输入、输出参数或输入/输出参数与其调用者交换信息。 过程和函数的唯一区别是函数总向调
用者返回数据，而过程则不返回数据。
*/

--创建存储函数
/*
建立内嵌函数
语法如下：
CREATE [OR REPLACE] FUNCTION function_name
[ (argment [ { IN | IN OUT }] Type,
argment [ { IN | OUT | IN OUT } ] Type ]
[ AUTHID DEFINER | CURRENT_USER ]
RETURN return_type
{ IS | AS }--存储函数/存储过程/自定义类型/包中没有区别 视图中能用AS 游标中只能用IS
<类型.变量的说明>
BEGIN
	FUNCTION_body
EXCEPTION
	其它语句
END;

[格式]
--函数的声明(有参数的写在小括号里)
CREATE OR REPLACE FUNCTION func_name(v_param VARCHAR2)
--返回值类型
 RETURN VARCHAR2 IS
	--PL/SQL块变量、记录类型、游标的声明(类似于前面的declare的部分)
BEGIN
	--函数体(可以实现增删改查等操作，返回值需要return)
	RETURN 'helloworld' || v_logo;
END; */

--不带参数的存储函数
--22.1 函数的 helloworld: 返回一个 "helloworld" 的字符串
CREATE OR REPLACE FUNCTION func_print_helloworld RETURN VARCHAR2 IS
--PL/SQL块变量的声明
BEGIN
--函数体
RETURN 'HelloWorld';
END;

--调用函数
BEGIN
dbms_output.put_line(func_print_helloworld);
END;

SELECT func_print_helloworld FROM dual;

--带一个参数的存储函数
CREATE OR REPLACE FUNCTION func_print_helloworld2(v_logo VARCHAR2) RETURN VARCHAR2 IS
--PL/SQL块变量的声明
BEGIN
--函数体
RETURN 'HelloWorld' || ':' || v_logo;
END;

--简单调用
SELECT func_print_helloworld2('LFT') FROM dual;

--PLSQL调用函数
BEGIN
dbms_output.put_line(func_print_helloworld2('LFT'));
END;

--22.3 创建一个存储函数，返回当前的系统时间
CREATE OR REPLACE FUNCTION get_sysdate RETURN DATE IS
v_date DATE;
BEGIN
v_date := SYSDATE; RETURN v_date;
END;

SELECT get_sysdate FROM dual;

--23. 定义带参数的函数: 两个数相加
CREATE OR REPLACE FUNCTION number_plus(v_num1 NUMBER, v_num2 NUMBER) RETURN NUMBER IS
v_sum NUMBER(10);
BEGIN
v_sum := v_num1 + v_num2; RETURN v_sum;
END;

--简单调用
SELECT number_plus(10.2, 0.2) FROM dual;

--PLSQL调用函数
BEGIN
dbms_output.put_line(number_plus(0.3, 0.8));
END;

--24. 定义一个函数: 获取给定部门的工资总和, 要求:部门号定义为参数, 工资总额定义为返回值.
--方式一：简单方式
CREATE OR REPLACE FUNCTION get_sum_salary2(v_dept_id employees.department_id%TYPE) RETURN NUMBER IS
--声明一个变量用来接收总工资。
v_sum_salary NUMBER(10) := 0;
BEGIN
SELECT SUM(salary) INTO v_sum_salary FROM employees WHERE department_id = v_dept_id;

RETURN v_sum_salary;
END;

--方式二：使用游标
CREATE OR REPLACE FUNCTION get_sum_salary(v_dept_id employees.department_id%TYPE) RETURN NUMBER IS

CURSOR sal_cursor IS
SELECT salary FROM employees WHERE department_id = v_dept_id;

--声明一个变量用来接收总工资。
v_sum_salary NUMBER(10) := 0;
BEGIN
FOR c IN sal_cursor LOOP v_sum_salary := v_sum_salary + c.salary;
END LOOP;

RETURN v_sum_salary;
END;

--PLSQL调用函数
DECLARE v_dept_id NUMBER(3) := 80;
BEGIN
dbms_output.put_line(get_sum_salary2(v_dept_id));
END;

--普通调用
SELECT SUM(salary) FROM employees WHERE department_id = 80;

--25. 关于 OUT 型的参数: 因为函数只能有一个返回值, PL/SQL 程序可以通过 OUT 型的参数实现有多个返回值
/*
要求: 定义一个函数: 获取给定部门的工资总和该部门的员工总数(定义为 OUT 类型的参数).
要求: 部门号定义为参数, 工资总额定义为返回值.
*/
CREATE OR REPLACE FUNCTION get_sum_salary3
(
	v_dept_id   NUMBER,
	total_count OUT NUMBER
) RETURN NUMBER IS

	CURSOR sal_cursor IS
		SELECT salary
		FROM   employees
		WHERE  department_id = v_dept_id;

	--声明一个变量用来接收总工资。
	v_sum_salary NUMBER(10) := 0;

BEGIN

	total_count := 0;

	FOR c IN sal_cursor
	LOOP
		v_sum_salary := v_sum_salary + c.salary;
		total_count  := total_count + 1;
	END LOOP;

	RETURN v_sum_salary;
END;
--PLSQL调用函数
DECLARE
	v_num NUMBER(5) := 0;
BEGIN
	dbms_output.put_line(get_sum_salary3(80,
										 v_num));
	dbms_output.put_line(v_num);
END;


--存储过程
/*
建立存储过程
在 ORACLE SERVER 上建立存储过程,可以被多个应用程序调用,可以向存储过程传递参数,也可以向存储
过程传回参数.

创建过程语法:
CREATE [OR REPLACE] PROCEDURE Procedure_name
[ (argment [ { IN | IN OUT }] Type,
argment [ { IN | OUT | IN OUT } ] Type ]
[ AUTHID DEFINER | CURRENT_USER ]
{ IS | AS }
<类型.变量的说明>
BEGIN
<执行部分>
EXCEPTION
<可选的异常错误处理程序>
END;
*/
--26*. 定义一个存储过程: 获取给定部门的工资总和(通过 out 参数), 要求:部门号和工资总额定义为参数
CREATE OR REPLACE procedure get_sum_salary4(
	v_dept_id   NUMBER,
	sumsal OUT NUMBER
) IS

	CURSOR sal_cursor IS
		SELECT salary
		FROM   employees
		WHERE  department_id = v_dept_id;

BEGIN

	sumsal := 0;

	FOR c IN sal_cursor
	LOOP
		sumsal := sumsal + c.salary;
	END LOOP;
	
    dbms_output.put_line(sumsal);
    
END;

--PLSQL调用函数
DECLARE
	v_num NUMBER(6) := 0;
BEGIN
	get_sum_salary4(80,v_num);
END;



--27*. 自定义一个存储过程完成以下操作: 
/*
对给定部门(作为输入参数)的员工进行加薪操作, 若其到公司的时间在 (? , 95) 期间,    为其加薪 %5
                                                               [95 , 98)             %3       
                                                               [98, ?)               %1
得到以下返回结果: 为此次加薪公司每月需要额外付出多少成本(定义一个 OUT 型的输出参数).
*/
CREATE OR REPLACE PROCEDURE add_salary_procedure
(
	v_detp_id NUMBER,
	v_cost    OUT NUMBER
) IS
	CURSOR sal_cursor IS
		SELECT employee_id id,
			   hire_date   hd,
			   salary      sal
		FROM   employees1
		WHERE  department_id = v_detp_id;

	v_add_divisor NUMBER(3, 2) := 0;

BEGIN
	v_cost := 0;

	FOR c IN sal_cursor LOOP
		v_add_divisor := 0;
		IF c.hd < to_date('1995-1-1',
						  'yyyy-mm-dd') THEN
			v_add_divisor := 0.05;
		ELSIF c.hd < to_date('1998-1-1',
							 'yyyy-mm-dd') THEN
			v_add_divisor := 0.03;
		ELSE
			v_add_divisor := 0.01;
		END IF;
	
		v_cost := v_cost + c.sal * v_add_divisor;
	
		UPDATE employees1
		SET    salary = salary * (1 + v_add_divisor)
		WHERE  employee_id = c.id;
	
	END LOOP;
     dbms_output.put_line(v_cost);
END;

--PLSQL调用函数
DECLARE
	v_num NUMBER(6) := 0;
BEGIN
	add_salary_procedure(80,v_num);
END;

--查询
SELECT * FROM employees1 where department_id = 80;
