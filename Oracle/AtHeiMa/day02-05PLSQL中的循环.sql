--PL/SQL中的LOOP循环
--【案例】用三种方式输出1-10的10个数字
--WHILE循环
DECLARE
	i NUMBER(2) := 1;
BEGIN WHILE i < 11
	LOOP
		dbms_output.put_line(i);
i := i + 1;
END LOOP;
END;

--EXIT循环
DECLARE
	i NUMBER(2) := 1;
BEGIN LOOP
		EXIT WHEN i > 10;
dbms_output.put_line(i);
i := i + 1;
END LOOP;
END;

--FOR循环
DECLARE

BEGIN FOR i IN 1 .. 10
	LOOP
		dbms_output.put_line(i);
END LOOP;
END;
