--子查询
--子查询返回一个值
--【案例】查询出工资和SCOTT一样的员工信息
SELECT *
	FROM emp
	WHERE sal IN (
				 SELECT sal
					 FROM emp
					 WHERE ename = 'SCOTT');

--子查询返回一个集合
--【案例】查询出工资和10号部门任意员工一样的员工信息
SELECT *
	FROM emp
	WHERE sal IN (
				 SELECT sal
					 FROM emp
					 WHERE deptno = 10);

--子查询返回一张表
--【案例】查询出每个部门最低工资，和最低工资员工姓名，和该员工所在部门名称。
--方式一：
SELECT e.ename,
	   d.dname
	FROM emp  e,
		 dept d
	WHERE e.deptno = d.deptno
	  AND e.sal IN (
				   SELECT MIN(sal)
					   FROM emp
					   GROUP BY deptno);

--方式二：
SELECT t.deptno,
	   t.msal,
	   e.ename,
	   d.dname
	FROM (
		 SELECT deptno,
				MIN(sal) msal
			 FROM emp
			 GROUP BY deptno) t,
		 emp                  e,
		 dept                 d
	WHERE t.deptno = e.deptno
	  AND t.msal = e.sal
	  AND e.deptno = d.deptno;
