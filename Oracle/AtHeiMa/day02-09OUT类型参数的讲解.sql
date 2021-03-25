--OUT类型参数如何使用？
--【案例】使用存储过程来算年薪
CREATE OR REPLACE PROCEDURE p_year_sal
(
	eno     IN emp.empno%TYPE,
	yearsal OUT NUMBER
) AS

	s NUMBER(10);
	c emp.comm%TYPE;
BEGIN
	SELECT sal * 12,
		   nvl(comm,
			   0)
	INTO   s,
		   c
	FROM   emp
	WHERE  empno = eno;
	yearsal := s + c;
END;

	--测试p_year_sal
DECLARE yearsal NUMBER(10);
BEGIN
p_year_sal(7788, yearsal); dbms_output.put_line(yearsal);
END;

	--IN 和 OUT类型参数的区别是什么？
	--凡是涉及到INTO 查询语句赋值或者:=赋值操作的参数，都必须使用OUT来修饰。否则其余都用IN。
