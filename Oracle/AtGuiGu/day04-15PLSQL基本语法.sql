--【简单案例】PLSQL的一个简单的程序
set serveroutput on
DECLARE
	--声明的变量、类型、游标
BEGIN
	--程序的执行部分(类似于JAVA里的main()方法)
	dbms_output.put_line('HelloWorld');
	--exception
	--针对begin块中出现的异常，提供处理的机制
	--when...then...
	--when...then...
END;

--【案例】查询100号员工的工资
--原方法：
SELECT salary
FROM   employees
WHERE  employee_id = 100;

--PLSQL语法：
DECLARE
    --声明变量
    v_salary employees.salary%type;
    v_email employees.email%type;
    v_hire_date employees.hire_date%type;
BEGIN
    --SQL语句的操作：select...into...from...where...
    SELECT salary,email,hire_date
    INTO   v_salary,v_email,v_hire_date
    FROM   employees
    WHERE  employee_id = 100;
    --打印输出语句
    dbms_output.put_line(v_salary||','||v_email||','||v_hire_date);
END;
