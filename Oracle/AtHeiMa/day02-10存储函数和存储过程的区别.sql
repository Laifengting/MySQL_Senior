--存储过程和存储函数的区别？
--语法区别：关键字不一样
--存储过程的关键字是：PROCEDURE
--存储函数的关键字是：FUNCTION
--存储函数比存储过程多了两个return

--本质区别：存储函数有返回值，而存储过程没有返回值。
--如果存储过程想实现有返回值的业务，我们就必须使用OUT类型的参数。
--即使是存储过程使用了OUT类型的参数，其本质也不是真的有了返回值。而是在存储过程内部给OUT类型参数赋值，
--在执行完毕后，我们直接拿到输出类型参数的值。
--我们可以使用存储函数有返回值的特性，来自定义函数。
--而存储过程不能用来定义函数。

--【案例】查询出员工姓名，员工所在部门名称。
--【准备工作】把scott用户下的dept表复制到当前用户下。

/*CREATE TABLE DEPT AS SELECT * FROM SCOTT.DEPT;*/

--使用传统方式来实现案例需求
SELECT e.ename,
	   d.dname
FROM   emp  e,
	   dept d
WHERE  e.deptno = d.deptno;

--使用存储函数自定义函数来实现案例需求。

--【案例】使用存储函数来实现提供一个部门编号，输出一个部门名称
CREATE OR REPLACE FUNCTION my_function(dno IN dept.deptno%TYPE) RETURN dept.dname%TYPE AS
	dna dept.dname%TYPE;
BEGIN
	SELECT dname
	INTO   dna
	FROM   dept
	WHERE  deptno = dno;
	RETURN dna;
END;

	--使用my_function存储函数来实现案例需求:查询出员工姓名，员工所有部门名称。
SELECT e.ename, my_function(e.deptno) "部门名称" FROM emp e;
