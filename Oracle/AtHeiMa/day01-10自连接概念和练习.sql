--自连接：自连接其实就是站在不同的角度把一张表看成多张表。
--【案例】查询员工姓名，员工领导姓名。
SELECT e.ename,
	   ma.ename
	FROM emp e,
		 emp ma
	WHERE e.mgr = ma.empno;

--【案例】查询出员工姓名、员工部门名称，员工领导姓名，员工领导部门名称
SELECT e.ename,
	   ed.dname,
	   ma.ename,
	   md.dname

	FROM emp  e,
		 emp  ma,
		 dept ed,
		 dept md
	WHERE e.mgr = ma.empno
	  AND e.deptno = ed.deptno
	  AND ma.deptno = md.deptno;

--【案例】查询出每个员工编号，姓名，部门名称，工资等级和他的上级领导的姓名，工资等级
SELECT e.empno,
	   e.ename,
	   ed.dname,
	   CASE es.grade
		   WHEN 1
			   THEN
			   '一级'
		   WHEN 2
			   THEN
			   '二级'
		   WHEN 3
			   THEN
			   '三级'
		   WHEN 4
			   THEN
			   '四级'
		   WHEN 5
			   THEN
			   '五级'
		   END 等级,
	   ma.ename,
	   md.dname,
	   CASE ms.grade
		   WHEN 1
			   THEN
			   '一级'
		   WHEN 2
			   THEN
			   '二级'
		   WHEN 3
			   THEN
			   '三级'
		   WHEN 4
			   THEN
			   '四级'
		   WHEN 5
			   THEN
			   '五级'
		   END 等级
	FROM emp      e,
		 emp      ma,
		 dept     ed,
		 dept     md,
		 salgrade es,
		 salgrade ms
	WHERE e.mgr = ma.empno
	  AND e.deptno = ed.deptno
	  AND ma.deptno = md.deptno
	  AND e.sal BETWEEN es.losal AND es.hisal
	  AND ma.sal BETWEEN ms.losal AND ms.hisal;

SELECT *
	FROM salgrade;
