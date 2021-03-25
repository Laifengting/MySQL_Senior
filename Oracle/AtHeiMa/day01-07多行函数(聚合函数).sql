----多行函数【聚合函数】：作用于多行，返回一个值。
SELECT COUNT(1) FROM emp; --查询总数量：count(1) 就相当于count(主键列)
SELECT SUM(sal) FROM emp; --工资总和
SELECT MAX(sal) FROM emp; --最大工资
SELECT MIN(sal) FROM emp; --最低工资
SELECT AVG(sal) FROM emp; --平均工资
