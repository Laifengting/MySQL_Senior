----分组查询
--【案例】查询出每个部门的平均工资。
--分组查询中，出现在GROUP BY后面的原始列，才能出现在SELECT后面
--没有出现在GROUP BY后面的列，想在SELECT后面，必须加上聚合函数。
--聚合函数有一个特性：可以把多行记录变成一个值。
SELECT e.deptno,
	   ROUND(AVG(e.sal),
			 2)
	FROM emp e
	GROUP BY e.deptno;

--【案例】查询平均工资高于2000的部门信息。

SELECT e.deptno,
	   ROUND(AVG(e.sal),
			 2)
	FROM emp e
	GROUP BY e.deptno
	HAVING ROUND(AVG(e.sal),2) > 2000;
--所有条件都不能使用别名来判断。

--比如下面的条件语句也不能使用别名当条件。
SELECT ename,
	   sal s
	FROM emp
	WHERE sal > 1500;

--【案例】查询每个部门工资高于800的员工的平均工资。
SELECT e.deptno,
	   AVG(e.sal)
	FROM emp e
	WHERE e.sal > 800
	GROUP BY e.deptno;
--WHERE是过滤分组前的数据，HAVING是过滤分组后的数据。表现形式：WHERE必须在GROUP BY之前，HAVING是在GROUP BY之后。

--【案例】查询出每具部门工资高于800的员工的平均工资，然后再查询出平均工资高于2000的部门。
SELECT e.deptno,
	   AVG(e.sal)
	FROM emp e
	WHERE e.sal > 800
	GROUP BY e.deptno
	HAVING AVG(e.sal) > 2000;
