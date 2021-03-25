	--存储函数
	--语法：
	/*
        
CREATE OR REPLACE FUNCTION 函数名
(
	NAME IN TYPE,
	NAME IN TYPE,
	..   .
) RETURN 数据类型 IS
	[ AS ] 结果变量 数据类型;

BEGIN

	RETURN(结果变量);
END 函数名;
--*/

	--【案例】通过存储函数实现计算指定员工的年薪
	--存储过程和存储函数的参数都不能带长度。
	--存储函数的返回值类型不能带长度
CREATE OR REPLACE FUNCTION f_year_sal(eno emp.empno%TYPE) RETURN NUMBER IS
s NUMBER(10);
BEGIN
SELECT sal * 12 + nvl(comm, 0) INTO s FROM emp WHERE empno = eno; RETURN s;
END;
--测试f_year_sal
	--存储函数在调用的时候，返回值需要接收。
DECLARE s NUMBER(10);
BEGIN
s := f_year_sal(7788); dbms_output.put_line(s);
END;
