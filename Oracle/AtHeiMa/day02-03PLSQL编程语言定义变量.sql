----PL/SQL编程语言
--PL/SQL编程语言是对SQL语言的扩展，使得SQL语言具有过程化编程的特性。
--PL/SQL编程语言比一般的过程化编程语言，更加灵活高效。
--PL/SQL编程语言主要用来编写存储过程和存储函数等。

--声明方法
--赋值操作可以用:=也可以使用查询语句+into赋值
DECLARE
	i      NUMBER(2) := 20;
s      VARCHAR2(10) := '小强';
ena    emp.ename%TYPE;
--引用型变量
	emprow emp%ROWTYPE;
--记录型变量
BEGIN dbms_output.put_line(i);
dbms_output.put_line(s);
SELECT ename
	INTO ena
	FROM emp
	WHERE empno = 7788;

dbms_output.put_line(ena);

SELECT *
	INTO emprow
	FROM emp
	WHERE empno = 7788;
dbms_output.put_line(emprow.ename || '的工作为：' || emprow.job);
END;
