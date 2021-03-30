----条件表达式
----条件表达式的通用写法：mysql oracle通用。【建议使用通用】
--给emp表中员工起中文名
SELECT e.ename,
	   CASE e.ename
		   WHEN 'KING'
			   THEN
			   '老板'
		   WHEN 'SCOTT'
			   THEN
			   '用户'
			   ELSE
			   '其他'
		   END
	FROM emp e;

--判断emp中员工工资，如果高于3000显示高收入，如果高于1500低于3000显示中等收入，其余显示低收入。
SELECT e.sal,
	   CASE
		   WHEN e.sal >= 3000
			   THEN
			   '高收入'
		   WHEN e.sal > 1500
			   THEN
			   '中等收入'
			   ELSE
			   '低收入'
		   END
	FROM emp e;

----oracle专用条件表达式。
----oracle中除了起别名。都用单引号。起别名可以用``、""、省略

SELECT e.ename, DECODE(e.ename,'KING','老板','SCOTT','用户','其他') 中文名
	FROM emp e;
