----索引
--索引的概念：索引就是在表的列上构建一个二叉树。达到大幅度提高查询效率的目的，但是索引会影响增删改的效率。

--单列索引
--创建一个单列索引
CREATE INDEX idx_ename ON emp(ename);
--单列索引触发规则，条件必须是索引列中的原始值。
SELECT *
	FROM emp
	WHERE ename = 'SCOTT';
--单行函数，模糊查询，都会影响索引的触发。


--复合索引
--创建一个复合索引
CREATE INDEX idx_ename_job ON emp(ename, job);
--复合索引中第一列为优先检索列
--如果要触发复合索引，必须包含有优先检索列中的原始值。
SELECT *
	FROM emp
	WHERE ename = 'SCOTT'
	  AND job = 'xx';
--触发复合索引

SELECT *
	FROM emp
	WHERE ename = 'SCOTT'
	   OR job = 'xx';
--不触发索引

SELECT *
	FROM emp
	WHERE ename = 'SCOTT';
--触发单列索引
