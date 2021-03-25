----多表查询中的一些概念
--笛卡尔积
SELECT *
FROM   emp  e,
	   dept d;

----等值连接(推荐)
SELECT *
FROM   emp  e,
	   dept d
WHERE  e.deptno = d.deptno;

----内连接
SELECT *
FROM   emp e
INNER  JOIN dept d
ON     e.deptno = d.deptno;

--【案例】查询出所有部门，以及部门下的员工信息。【外连接】
SELECT *
FROM   emp e
RIGHT  JOIN dept d
ON     e.deptno = d.deptno;

--【案例】查询所有员工信息，以及员工所属部门。
SELECT *
FROM   emp e
LEFT   JOIN dept d
ON     e.deptno = d.deptno;

--ORACLE中专用外连接
SELECT *
FROM   emp  e,
	   dept d
WHERE  e.deptno(+) = d.deptno; --将(+)=对面的信息显示完全补全。
