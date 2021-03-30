--记录类型
/*
记录类型是把
逻辑相关 的数据作为一个单元存储起来 称作 PL/S QL RECORD 的域 ( FIELD)，其作用是存放互不相同但逻辑相关的信息 。
*/
--【案例】查询100号员工的工资
DECLARE
	TYPE emp_record IS RECORD(
		--声明变量
		v_salary    employees.salary%TYPE,
		v_email     employees.email%TYPE,
		v_hire_date employees.hire_date%TYPE);
--定义一个记录类型的成员变量
	v_emp_record emp_record;
BEGIN --SQL语句的操作：select...into...from...where...
	SELECT salary,
		   email,
		   hire_date
	INTO   v_emp_record
	FROM   employees
	WHERE  employee_id = 100;
--打印输出语句
	dbms_output.put_line(v_emp_record.v_salary || ',' || v_emp_record.v_email || ',' ||
						 v_emp_record.v_hire_date);
END;

--复习
/*
1.PL/SQL基本的语法格式
    DECLARE
        --声明部分 : 在此声明 PL/SQL 用到的变量 类型及游标，以及局部的存储过程和函数
    BEGIN
        --执行部分 : 过程及 SQL 语句 , 即程序的主要部分
    EXCEPTION
        --执行异常部分 : 错误处理
    END;


2.记录类型
    TYPE record_type IS RECORD(
    Field1 type1 [NOT NULL] [:= exp1 ],
    Field2 type2 [NOT NULL] [:= exp2 ],
    . . . . .
    Fieldn typen [NOT NULL] [:= expn ] );


3.流程控制：
    3.1 条件判断(两种)：
        方式一：if...then...elsif then ... else ...end if;
        方式二：case...when...then...when...then...else...end;
    3.2 循环结构(三种)：
        方式一：loop...exit when...end loop;
        方式二：while...loop...end loop;
        方式三：for i in...loop...end loop;
    3.3 goto、exit

4.游标的使用(类似于Java中的Iterator)

5.异常的处理(三种方式)

6.会写一个存储函数(有返回值)、存储过程(没有返回值)

7.会写一个触发器
*/

--1.PL/SQL基本的语法格式

DECLARE
	--变量、记录类型等的声明
	v_sal       NUMBER(8, 2) := 0;
v_emp_id    NUMBER(10);
v_email     VARCHAR2(20);
v_hire_date DATE);

BEGIN --程序执行部分
SELECT salary,
	   employee_id,
	   email,
	   hire_date
	INTO v_sal,
		v_emp_id,
		v_email,
		v_hire_date
	FROM employees
	WHERE employee_id = 123;
dbms_output.put_line('Employee_id: ' || v_emp_id || ' Salary: ' || v_sal || ' Email: ' ||
						 v_email || ' Hire_date: ' || v_hire_date);
END;

--2.记录类型
/*
  使用%TYPE
  定义一个变量，其数据类型与已经定义的某个 数据变量的类型相同，或者与数据库表的某个列的数据类型
相同，这时可以使用%TYPE。
使用%TYPE 特性的优点在于：
  所引用的数据库列的数据类型可以不必知道；
  所引用的数据库列的数据类型可以实时改变。
*/
DECLARE
	--变量、记录类型等的声明
	--声明一个记录类型
	TYPE emp_record IS RECORD(
		v_sal       employees.salary%TYPE,
		v_emp_id    NUMBER(10),
		v_email     VARCHAR2(20),
		v_hire_date DATE);
--个记录类型的变量
	v_emp_record emp_record;
BEGIN --程序执行部分
SELECT salary,
	   employee_id,
	   email,
	   hire_date
	INTO v_emp_record
	FROM employees
	WHERE employee_id = 123;
dbms_output.put_line('Employee_id: ' || v_emp_record.v_emp_id || ' Salary: ' ||
						 v_emp_record.v_sal || ' Email: ' || v_emp_record.v_email ||
						 ' Hire_date: ' || v_emp_record.v_hire_date);
END;

--自定义记录类型
DECLARE
	TYPE salary_record IS RECORD(
		v_name   VARCHAR2(20),
		v_salary NUMBER(10, 2));
v_salary_record salary_record;
BEGIN v_salary_record.v_name   := '刘德华';
v_salary_record.v_salary := 120000;
dbms_output.put_line('Name: ' || v_salary_record.v_name || ' Salary: ' ||
						 v_salary_record.v_salary);
END;

--自定义表的全部列
DECLARE
	v_emp_record employees%ROWTYPE;
v_emp_id     NUMBER(10);
BEGIN v_emp_id := 123;
SELECT *
	INTO v_emp_record
	FROM employees
	WHERE employee_id = v_emp_id;
dbms_output.put_line('Employee_id: ' || v_emp_record.employee_id || ' Salary:' ||
						 v_emp_record.salary || ' Email:' || v_emp_record.email);
END;

--在修改表格中使用
DECLARE
	v_emp_id NUMBER(10);

BEGIN v_emp_id := 123;
UPDATE employees
SET
	salary = salary + 100
	WHERE employee_id = v_emp_id;
dbms_output.put_line('执行成功');
END;

ROLLBACK;
