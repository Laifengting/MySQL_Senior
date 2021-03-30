--包的创建和应用
/*
包是一组相关过程、函数、变量、常量和游标等 PL/SQL  程序设计元素的组合，它具有面向对象程序设
计语言的特点，是对这些 PL/SQL 程序设计元素的封装。 包类似于 C++和 和 JAVA  语言中的类，其中变量相当
于类中的成员变量，过程和函数相当于类方法。把相关的模块归类成为包， 可使开发人员利用面向对象的
方法进行存储过程的开发，从而提高系统性能。
与类相同， 包中的程序元素也分为公用元素和私用元素两种，这两种元素的区别是他们允许访问的程
序范围不同，即它们的作用域不同。 公用元素不仅可以被包中的函数、过程所调用，也可以被包外的 PL/SQL
程序访问，而 私有元素只能被包内的函数和过程序所访问。
在 PL/SQL 程序设计中，使用包不仅可以使程序设计模块化，对外隐藏包内所使用的信息（通过使用私
用变量），而且可以提高程序的执行效率。因为，当程序首次调用包内函数或过程时，ORACLE 将整个包调
入内存，当再次访问包内元素时，ORACLE 直接从内存中读取，而不需要进行磁盘 I/O 操作，从而使程序执
行效率得到提高。
一个包由两个分开的部分组成：
包定义（PACKAGE）：包定义部分声明包内数据类型、变量、常量、游标、子程序和异常错误处理等元
素，这些元素为包的公有元素。
包主体（PACKAGE BODY）：包主体则是包定义部分的具体实现，它定义了包定义部分所声明的游标和子
程序，在包主体中还可以声明包的私有元素。
包定义和包主体分开编译，并作为两部分分开的对象存放在数据库字典中，详见数据字典 user_source,
all_source, dba_source.
*/

--包的定义
/*
包定义的语法如下：
创建包定义:
CREATE [OR REPLACE] PACKAGE package_name
[AUTHID {CURRENT_USER | DEFINER}]
{IS | AS}
[公有数据类型定义[公有数据类型定义]…]
[公有游标声明[公有游标声明]…]
[公有变量、常量声明[公有变量、常量声明]…]
[公有子程序声明[公有子程序声明]…]
END [package_name];
其中：AUTHID CURRENT_USER和AUTHID DEFINER选项说明应用程序在调用函数时所使用的权限模式，它们与
CREATE FUNCTION语句中invoker_right_clause子句的作用相同。
*/


--创建包主体:
/*
CREATE [OR REPLACE] PACKAGE BODY package_name
{IS | AS}
    [私有数据类型定义[私有数据类型定义]…]
    [私有变量、常量声明[私有变量、常量声明]…]
    [私有子程序声明和定义[私有子程序声明和定义]…]
    [公有游标定义[公有游标定义]…]
    [公有子程序定义[公有子程序定义]…]
BEGIN
	PL/SQL 语句
END [package_name];

其中： 在包主体定义公有程序时，它们必须与包定义中所声明子程序的格式完全一致。
*/


--包的开发步骤
/*
与开发存储过程类似，包的开发需要几个步骤：
1． 将每个存储过程调式正确；
2． 用文本编辑软件将各个存储过程和函数集成在一起；
3． 按照包的定义要求将集成的文本的前面加上包定义；
4． 按照包的定义要求将集成的文本的前面加上包主体；
5． 使用 SQLPLUS 或开发工具进行调式。
*/

--包定义的说明
--例 1:创建的包为 demo_pack, 该包中包含一个记录变量 DeptRec、两个函数和一个过程。
CREATE OR
REPLACE package demo_pack IS
	deptrec dept%ROWTYPE;
FUNCTION add_dept
	(
		dept_no   NUMBER,
		dept_name VARCHAR2,
		location  VARCHAR2
	) RETURN NUMBER;
FUNCTION remove_dept(dept_no NUMBER) RETURN NUMBER;
PROCEDURE query_dept(dept_no IN NUMBER);
END demo_pack;


--包主体的创建方法，它实现上面所声明的包定义
CREATE OR
REPLACE package BODY demo_pack IS
	FUNCTION add_dept
(dept_no NUMBER,
 dept_name VARCHAR2,
 location VARCHAR2) RETURN NUMBER IS
	empno_remaining EXCEPTION;
PRAGMA EXCEPTION_INIT(empno_remaining,
							  -1);
		/* -1 是违反唯一约束条件的错误代码 */
BEGIN
INSERT INTO dept
	VALUES (dept_no,
			dept_name,
			location);
IF SQL%FOUND THEN
			RETURN 1;
END IF;
EXCEPTION
		WHEN empno_remaining THEN
			RETURN 0;
WHEN OTHERS THEN
			RETURN - 1;
END add_dept;
FUNCTION remove_dept(dept_no NUMBER) RETURN NUMBER IS
BEGIN
DELETE
	FROM dept
	WHERE deptno = dept_no;
IF SQL%FOUND THEN
			RETURN 1;
ELSE
			RETURN 0;
END IF;
EXCEPTION
		WHEN OTHERS THEN
			RETURN - 1;
END remove_dept;
PROCEDURE query_dept(dept_no IN NUMBER) IS
BEGIN
SELECT *
	INTO deptrec
	FROM dept
	WHERE deptno = dept_no;
EXCEPTION
		WHEN no_data_found THEN
			dbms_output.put_line('数据库中没有编码为' || dept_no || '的部门');
WHEN too_many_rows THEN
			dbms_output.put_line('程序运行错误!请使用游标');
WHEN OTHERS THEN
			dbms_output.put_line(SQLCODE || '----' || SQLERRM);
END query_dept;
BEGIN
	NULL;
END demo_pack;


--对包内共有元素的调用格式为：包名.
/*
调用 demo_pack 包内函数对 dept 表进行插入、查询和修改操作，并通过 demo_pack 包中的记录变量 DeptRec
显示所查询到的数据库信息：
*/

DECLARE
	var NUMBER;
BEGIN var := demo_pack.add_dept(90,
							  ’administration’,
							  ‘beijing’);
IF var = -1 THEN
		dbms_output.put_line(SQLCODE || '----' || SQLERRM);
ELSIF var = 0 THEN
		dbms_output.put_line('该部门记录已经存在！');
ELSE
		dbms_output.put_line('添加记录成功！');
demo_pack.query_dept(90);
dbms_output.put_line(demo_pack.deptrec.deptno || '---' || demo_pack.deptrec.dname || '---' ||
							 demo_pack.deptrec.loc);
var := demo_pack.remove_dept(90);
IF var = -1 THEN
			dbms_output.put_line(SQLCODE || '----' || SQLERRM);
ELSIF var = 0 THEN
			dbms_output.put_line('该部门记录不存在！');
ELSE
			dbms_output.put_line('删除记录成功！');
END IF;
END IF;
END;


--例 2: 创建包 emp_package
CREATE OR
REPLACE package emp_package IS
	TYPE emp_table_type IS TABLE OF emp%ROWTYPE INDEX BY BINARY_INTEGER;
PROCEDURE read_emp_table(p_emp_table OUT emp_table_type);
END emp_package;
--创建包的主体
CREATE OR
REPLACE package BODY emp_package IS
	PROCEDURE read_emp_table(p_emp_table OUT emp_table_type) IS
	i BINARY_INTEGER := 0;
BEGIN FOR emp_record IN (SELECT *
						   FROM   emp) LOOP
			p_emp_table(i) := emp_record;
i := i + 1;
END LOOP;
END read_emp_table;
END emp_package;

DECLARE
	e_table emp_package.emp_table_type;
BEGIN emp_package.read_emp_table(e_table);
FOR i IN e_table.first .. e_table.last LOOP
		dbms_output.put_line(e_table(i).empno || ’ ‘ || e_table(i).ename);
END LOOP;
END;


--例 3: 创建包 emp_mgmt：
--创建序列1
CREATE
SEQUENCE empseq
    START
WITH 1000
    INCREMENT BY 1
    ORDER NOCYCLE;

--创建序列2
CREATE
SEQUENCE deptseq
    START
WITH 50
    INCREMENT BY 10
    ORDER NOCYCLE;

--创建包
CREATE OR
REPLACE package emp_mgmt AS
	FUNCTION hire
(ename VARCHAR2,
 job VARCHAR2,
 mgr NUMBER,
 sal NUMBER,
 comm NUMBER,
 deptno NUMBER) RETURN NUMBER;
FUNCTION create_dept
	(
		dname VARCHAR2,
		loc   VARCHAR2
	) RETURN NUMBER;
PROCEDURE remove_emp(empno NUMBER);
PROCEDURE remove_dept(deptno NUMBER);
PROCEDURE increase_sal
	(
		empno    NUMBER,
		sal_incr NUMBER
	);
PROCEDURE increase_comm
	(
		empno     NUMBER,
		comm_incr NUMBER
	);
END emp_mgmt;

--创建包的主体
CREATE OR
REPLACE package BODY emp_mgmt AS
	tot_emps NUMBER;
tot_depts NUMBER;
no_sal  EXCEPTION;
no_comm EXCEPTION;

--存储函数
	FUNCTION hire
	(
		ename  VARCHAR2,
		job    VARCHAR2,
		mgr    NUMBER,
		sal    NUMBER,
		comm   NUMBER,
		deptno NUMBER
	) RETURN NUMBER IS
		new_empno NUMBER(4);
BEGIN
SELECT empseq.nextval
	INTO new_empno
	FROM dual;
INSERT INTO emp
	VALUES (new_empno,
			ename,
			job,
			mgr,
			sysdate,
			sal,
			comm,
			deptno);
tot_emps := tot_emps + 1;
RETURN
(new_empno);
EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('发生其它错误!');
END hire;

--存储函数
	FUNCTION create_dept
	(
		dname VARCHAR2,
		loc   VARCHAR2
	) RETURN NUMBER IS
		new_deptno NUMBER(4);
BEGIN
SELECT deptseq.nextval
	INTO new_deptno
	FROM dual;
INSERT INTO dept
	VALUES (new_deptno,
			dname,
			loc);
tot_depts := tot_depts;
RETURN
(new_deptno);
EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('发生其它错误!');
END create_dept;

--存储过程
	PROCEDURE remove_emp(empno NUMBER) IS
		no_result EXCEPTION;
BEGIN
DELETE
	FROM emp
	WHERE emp.empno = remove_emp.empno;
IF SQL%NOTFOUND THEN
			RAISE no_result;
END IF;
tot_emps := tot_emps - 1;
EXCEPTION
		WHEN no_result THEN
			dbms_output.put_line('你需要的数据不存在!');
WHEN OTHERS THEN
			dbms_output.put_line('发生其它错误!');
END remove_emp;

--存储过程
	PROCEDURE remove_dept(deptno NUMBER) IS
		no_result          EXCEPTION;
e_deptno_remaining EXCEPTION;
PRAGMA EXCEPTION_INIT(e_deptno_remaining,
							  -2292);
		/* -2292 是违反一致性约束的错误代码 */
BEGIN
DELETE
	FROM dept
	WHERE dept.deptno = remove_dept.deptno;
IF SQL%NOTFOUND THEN
			RAISE no_result;
END IF;
tot_depts := tot_depts - 1;
EXCEPTION
		WHEN no_result THEN
			dbms_output.put_line('你需要的数据不存在!');
WHEN e_deptno_remaining THEN
			dbms_output.put_line('违反数据完整性约束!');
WHEN OTHERS THEN
			dbms_output.put_line('发生其它错误!');
END remove_dept;

--存储过程
	PROCEDURE increase_sal
	(
		empno    NUMBER,
		sal_incr NUMBER
	) IS
		curr_sal NUMBER(7,
						2);
BEGIN
SELECT sal
	INTO curr_sal
	FROM emp
	WHERE emp.empno = increase_sal.empno;
IF curr_sal IS NULL THEN
			RAISE no_sal;
ELSE
UPDATE emp
SET
	sal = sal + increase_sal.sal_incr
	WHERE emp.empno = increase_sal.empno;
END IF;
EXCEPTION
		WHEN no_data_found THEN
			dbms_output.put_line('你需要的数据不存在!');
WHEN no_sal THEN
			dbms_output.put_line('此员工的工资不存在!');
WHEN OTHERS THEN
			dbms_output.put_line('发生其它错误!');
END increase_sal;

--存储过程
	PROCEDURE increase_comm
	(
		empno     NUMBER,
		comm_incr NUMBER
	) IS
		curr_comm NUMBER(7,
						 2);
BEGIN
SELECT comm
	INTO curr_comm
	FROM emp
	WHERE emp.empno = increase_comm.empno;
IF curr_comm IS NULL THEN
			RAISE no_comm;
ELSE
UPDATE emp
SET
	comm = comm + increase_comm.comm_incr
	WHERE emp.empno = increase_comm.empno;
END IF;
EXCEPTION
		WHEN no_data_found THEN
			dbms_output.put_line('你需要的数据不存在!');
WHEN no_comm THEN
			dbms_output.put_line('此员工的奖金不存在!');
WHEN OTHERS THEN
			dbms_output.put_line('发生其它错误!');
END increase_comm;

END emp_mgmt;


--例4.利用游标变量创建包 Curvarpack。由于游标变量指是一个指针，其状态是不确定的，
--因此它不能随同包存储在数据库中，既不能在 PL/SQL 包中声明游标变量。但在包中可以创建游标变量参照类型，
--并可向包中的子程序传递游标变量参数。

--创建包
CREATE OR
REPLACE package curvarpack AS
	TYPE deptcurtype IS REF CURSOR RETURN dept%ROWTYPE;
--强类型定义
	TYPE curtype IS REF CURSOR; -- 弱类型定义
PROCEDURE opendeptvar
	(
		cv        IN OUT deptcurtype,
		choice    INTEGER DEFAULT 0,
		dept_no   NUMBER DEFAULT 50,
		dept_name VARCHAR DEFAULT ‘%’
	);
END;

--创建包的主体
CREATE OR
REPLACE package BODY curvarpack AS
	PROCEDURE opendeptvar
(cv IN OUT deptcurtype,
 choice INTEGER DEFAULT 0,
 dept_no NUMBER DEFAULT 50,
 dept_name VARCHAR DEFAULT ‘ % ’) IS
BEGIN IF choice = 1 THEN
			OPEN cv FOR
SELECT *
	FROM dept
	WHERE deptno <= dept_no;
ELSIF choice = 2 THEN
			OPEN cv FOR
SELECT *
	FROM dept
	WHERE dname LIKE dept_name;
ELSE
			OPEN cv FOR
SELECT *
	FROM dept;
END IF;
END opendeptvar;
END curvarpack;

--定义一个过程
	CREATE OR
REPLACE procedure opencurtype
(
cv IN OUT curvarpack.curtype,
tab CHAR
)
AS
BEGIN --由于 CurVarPack.CurType 采用弱类型定义
	--所以可以使用它定义的游标变量打开不同类型的查询语句
	IF tab = ‘d’ THEN
		OPEN cv FOR
SELECT *
	FROM dept;
ELSE
		OPEN cv FOR
SELECT *
	FROM emp;
END IF;
END opencurtype;
--定义一个应用
DECLARE
	deptrec dept%ROWTYPE;
emprec  emp%ROWTYPE;
cv1     curvarpack.deptcurtype;
cv2     curvarpack.curtype;
BEGIN dbms_output.put_line('游标变量强类型定义应用');
curvarpack.opendeptvar(cv1,
						   1,
						   30);
FETCH cv1
		INTO deptrec;
WHILE cv1%FOUND LOOP
		dbms_output.put_line(deptrec.deptno || ' :' || deptrec.dname);
FETCH cv1
			INTO deptrec;
END LOOP;
CLOSE cv1;

dbms_output.put_line('游标变量弱类型定义应用');
curvarpack.opendeptvar(cv2,
						   2,
						   dept_name => 'a%');
FETCH cv2
		INTO deptrec;
WHILE cv2%FOUND LOOP
		dbms_output.put_line(deptrec.deptno || ' :' || deptrec.dname);
FETCH cv2
			INTO deptrec;
END LOOP;
dbms_output.put_line('游标变量弱类型定义应用—dept 表');
opencurtype
(cv2,
‘d’);
FETCH cv2
		INTO deptrec;
WHILE cv2%FOUND LOOP
		dbms_output.put_line(deptrec.deptno || ' :' || deptrec.dname);
FETCH cv2
			INTO deptrec;
END LOOP;
dbms_output.put_line('游标变量弱类型定义应用—emp 表');
opencurtype
(cv2,
‘e’);
FETCH cv2
		INTO emprec;
WHILE cv2%FOUND LOOP
		dbms_output.put_line(emprec.empno || ' :' || emprec.ename);
FETCH cv2
			INTO emprec;
END LOOP;
CLOSE cv2;
END;


--子程序重载
/*
PL/SQL  允许对包内子程序和本地子程序进行重载。所谓重载时指两个或多个子程序有相同的名称，但拥有
不同的参数变量、参数顺序或参数数据类型。
*/
--例 5
--创建包
CREATE OR
REPLACE package demo_pack1 IS
	deptrec dept%ROWTYPE;
v_sqlcode NUMBER;
v_sqlerr  VARCHAR2(2048);
FUNCTION query_dept(dept_no IN NUMBER) RETURN INTEGER;
FUNCTION query_dept(dept_no IN VARCHAR2) RETURN INTEGER;
END demo_pack1;

--创建包的主体
CREATE OR
REPLACE package BODY demo_pack1 IS
	--存储函数1
	FUNCTION check_dept(dept_no NUMBER) RETURN INTEGER IS
	flag INTEGER;
BEGIN
SELECT COUNT(*)
	INTO flag
	FROM dept
	WHERE deptno = dept_no;
IF flag > 0 THEN
			RETURN 1;
ELSE
			RETURN 0;
END IF;
END check_dept;

--存储函数1的重载
	FUNCTION check_dept(dept_no VARCHAR2) RETURN INTEGER IS
		flag INTEGER;
BEGIN
SELECT COUNT(*)
	INTO flag
	FROM dept
	WHERE deptno = dept_no;
IF flag > 0 THEN
			RETURN 1;
ELSE
			RETURN 0;
END IF;
END check_dept;

--存储函数2
	FUNCTION query_dept(dept_no IN NUMBER) RETURN INTEGER IS
BEGIN IF check_dept(dept_no) = 1 THEN
SELECT *
	INTO deptrec
	FROM dept
	WHERE deptno = dept_no;
RETURN 1;
ELSE
			RETURN 0;
END IF;
END query_dept;

--存储函数2的重载
	FUNCTION query_dept(dept_no IN VARCHAR2) RETURN INTEGER IS
BEGIN IF check_dept(dept_no) = 1 THEN
SELECT *
	INTO deptrec
	FROM dept
	WHERE deptno = dept_no;
RETURN 1;
ELSE
			RETURN 0;
END IF;
END query_dept;
END demo_pack1;

--删除包
--可以使用 DROP
PACKAGE 命令对不需要的包进行删除，语法如下：
--DROP
PACKAGE [BODY] [USER.]package_name;

DROP
PACKAGE demo_pack;
DROP
PACKAGE demo_pack1;
DROP
PACKAGE emp_mgmt;
DROP
PACKAGE emp_package;


--包的管理

--DBA_SOURCE, USER_SOURCE, USER_ERRORS, DBA-OBJECTS
