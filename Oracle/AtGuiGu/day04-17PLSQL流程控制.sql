--流程控制
/*
条件语句
IF <布尔表达式> THEN
PL/SQL 和 SQL 语句;
END IF;

IF <布尔表达式> THEN
PL/SQL 和 SQL 语句;
ELSE
其它语句;
END IF;

IF <布尔表达式> THEN
PL/SQL 和 SQL 语句;
ELSIF < 其它布尔表达式> THEN
其它语句;
ELSIF < 其它布尔表达式> THEN
其它语句;
ELSE
其它语句;
END IF;

提示: ELSIF  不能写成 ELSEIF




CASE 表达式

CASE selector
WHEN expression1 THEN result1
WHEN expression2 THEN result2
WHEN expressionN THEN resultN
[ ELSE resultN+1]
END;

*/
/*
要求: 查询出 150号 员工的工资, 若其工资大于或等于 10000 则打印 'salary >= 10000'; 
若在 5000 到 10000 之间, 则打印 '5000<= salary < 10000'; 否则打印 'salary < 5000'
*/
--方式一：
DECLARE
	v_sal employees.salary%TYPE;
BEGIN
SELECT salary
	INTO v_sal
	FROM employees
	WHERE employee_id = 150;
dbms_output.put_line('Salary: ' || v_sal);
IF v_sal >= 10000 THEN
		dbms_output.put_line('salary >= 10000');
ELSIF v_sal >= 5000 THEN
		dbms_output.put_line('5000 <= salary < 10000');
ELSE
		dbms_output.put_line('salary < 5000');
END IF;
END;

--方式二：
DECLARE
	v_sal  employees.salary%TYPE;
v_temp VARCHAR2(50);
BEGIN
SELECT salary
	INTO v_sal
	FROM employees
	WHERE employee_id = 150;
dbms_output.put_line('Salary: ' || v_sal);
IF v_sal >= 10000 THEN
		v_temp := 'salary >= 10000';
ELSIF v_sal >= 5000 THEN
		v_temp := '5000 <= salary < 10000';
ELSE
		v_temp := 'salary < 5000';
END IF;
dbms_output.put_line('Salary: ' || v_temp);
END;

--方式三：CASE方法一
DECLARE
	v_sal  employees.salary%TYPE;
v_temp VARCHAR2(50);
BEGIN
SELECT salary
	INTO v_sal
	FROM employees
	WHERE employee_id = 150;
dbms_output.put_line('Salary: ' || v_sal);

v_temp := CASE
				  WHEN v_sal >= 10000 THEN
				   'salary >= 10000'
				  WHEN v_sal >= 5000 THEN
				   '5000 <= salary < 10000'
				  ELSE
				   'salary < 5000'
			  END;

dbms_output.put_line('Salary: ' || v_temp);
END;

--方式四：CASE方法二
DECLARE
	v_sal  employees.salary%TYPE;
v_temp VARCHAR2(50);
BEGIN
SELECT salary
	INTO v_sal
	FROM employees
	WHERE employee_id = 150;
dbms_output.put_line('Salary: ' || v_sal);

v_temp := CASE trunc(v_sal / 5000)
				  WHEN 0 THEN
				   'salary < 5000'
				  WHEN 1 THEN
				   '5000 <= salary < 10000'
				  ELSE
				   'salary >= 10000'
			  END;

dbms_output.put_line('Salary: ' || v_temp);
END;

--要求: 查询出 122 号员工的 JOB_ID, 若其值为 'IT_PROG', 则打印 'GRADE: A';
--'AC_MGT', 打印 'GRADE B', 'AC_ACCOUNT', 打印 'GRADE C';
否则打印 'GRADE D'
DECLARE
	v_job_id VARCHAR2(10);
v_temp   VARCHAR2(10);

BEGIN
SELECT job_id
	INTO v_job_id
	FROM employees
	WHERE employee_id = 122;

v_temp := CASE v_job_id
				  WHEN 'IT_PROG' THEN
				   'GRADE: A'
				  WHEN 'AC_MGT' THEN
				   'GRADE B'
				  WHEN 'AC_ACCOUNT' THEN
				   'GRADE C'
				  ELSE
				   'GRADE D'
			  END;
dbms_output.put_line(v_temp);
END;

--循环控制
--9. 使用循环语句打印 1 - 100.（三种方式）
--方式一：loop...exit WHEN...end LOOP;
DECLARE
	i NUMBER(3) := 1;
BEGIN LOOP
		dbms_output.put_line(i);
i := i + 1;
EXIT WHEN i > 100;
END LOOP;
END;

--方式二：while...loop...end LOOP;
DECLARE
	i NUMBER(3) := 1;
BEGIN WHILE i <= 100
	LOOP
		dbms_output.put_line(i);
i := i + 1;
END LOOP;
END;

--方式三：for i IN [REVERSE] 1 .. 100 LOOP...end LOOP;
DECLARE
	i NUMBER(3) := 1;
BEGIN FOR i IN REVERSE 1 .. 100
	LOOP
		dbms_output.put_line(i);
END LOOP;
END;

--10. 综合使用 IF, WHILE 语句, 打印 1 - 100 之间的所有素数
--(素数: 有且仅用两个正约数的整数, 2, 3, 5, 7, 11, 13, ...).
--方式一：
DECLARE
	v_i    NUMBER(3) := 2;
v_j    NUMBER(3) := 2;
v_flag NUMBER(1) := 1;

BEGIN WHILE v_i <= 100
	LOOP
		WHILE v_j <= sqrt(v_i)
		LOOP
			IF MOD(v_i,
				   v_j) = 0 THEN
				v_flag := 0;
END IF;
v_j := v_j + 1;
END LOOP;
IF v_flag = 1 THEN
			dbms_output.put_line(v_i);
END IF;
v_i    := v_i + 1;
v_j    := 2;
v_flag := 1;
END LOOP;
END;

--使用for循环
DECLARE
	v_flag NUMBER(1) := 1;

BEGIN FOR v_i IN 2 .. 100
	LOOP
		FOR v_j IN 2 .. sqrt(v_i)
		LOOP
			IF MOD(v_i,
				   v_j) = 0 THEN
				v_flag := 0;
GOTO label;
END IF;
END LOOP;
<<label>>
		IF v_flag = 1 THEN
			dbms_output.put_line(v_i);
END IF;
v_flag := 1;
END LOOP;
END;

--11+.打印1——100的自然数，当打印到50时，跳出循环，输出“打印结束”
--方式一：
DECLARE
	v_i NUMBER(3);
BEGIN FOR v_i IN 1 .. 100
	LOOP
		IF v_i = 50 THEN
			GOTO label;
END IF;
dbms_output.put_line(v_i);
END LOOP;
<<label>>
	dbms_output.put_line('打印结束');
END;

--方式二：
DECLARE
	v_i NUMBER(3);
BEGIN FOR v_i IN 1 .. 100
	LOOP
		IF v_i = 50 THEN
			dbms_output.put_line('打印结束');
EXIT;
END IF;
dbms_output.put_line(v_i);
END LOOP;
END;
