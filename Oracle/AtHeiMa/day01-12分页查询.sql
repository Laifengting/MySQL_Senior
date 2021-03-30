----ORACLE中的分页
--rownum行号：当我们做select操作的时候，每查询出一行记录，就会在该行上加上一个行号，从1开始，依次递增，不能跳着走。

--如果涉及到排序，但是还是要使用ROWNUM的话，我们可以再次嵌套查询。
SELECT rownum,
	   t.*
	FROM (
		 SELECT rownum,
				e.*
			 FROM emp e
			 ORDER BY e.sal DESC) t;

--【案例】EMP表式次倒序排列后，每页五条记录，查询第二页
--ROWNUM等号不能写上大于一个正数。
SELECT *
	FROM (
		 SELECT rownum rn,
				e.*
			 FROM (
				  SELECT *
					  FROM emp
					  ORDER BY sal DESC) e
			 WHERE rownum < 11)
	WHERE rn > 5

CREATE TABLE emp
AS
	SELECT *
		FROM scott.emp;
