/*###############################################进阶16：视图###############################################*/
/*
		含义：虚拟表，和普通表一样使用。
			MySQL 5.1版本出现的新特性，是通过表动态生成的数据。一种虚拟存在的表，行和列的数据来自定义视图的查询中使用的表，并且是在使用视图时动态生成的，只保存了SQL逻辑，
			不保存查询结果。

		应用场景：
			① 多个地方用到同样的查询结果。
			② 该查询结果使用的SQL语句较复杂。

		好处：
			①重用SQL语句
			②简化复杂的SQL操作，不必知道它的查询细节
			③保护数据，提高安全性。

				创建语法的关键字        是否实际占用物理空间      使用
		视图      CREATE VIEW            只保存了SQL逻辑         增删改查，一般不增删改
		表        CREATE TABLE           保存了数据             增删改查

 */
# 案例：查询姓张的学生名和专业名
USE students;
SELECT stuname, majorname
FROM stuinfo s
	     INNER JOIN major m ON s.`majorid` = m.`id`
WHERE s.`stuname` LIKE '张%';

# 创建查询学生姓名，专业名的视图
CREATE VIEW v1
AS
SELECT stuname, majorname
FROM stuinfo s
	     INNER JOIN major m ON s.`majorid` = m.`id`;

# 查询的时候直接调用视图
SELECT *
FROM v1
WHERE stuname LIKE '张%';

/*
        1. 创建视图
        语法：
        CREATE [OR REPLACE] VIEW 视图名
        AS
        查询语句
        [WITH | CASCADED | LOCAL | CHECK OPTION];
 */

USE myemployees;

/*
       练习1. 查询姓名中包含a字符的员工名、部门名和工种信息。
*/
CREATE VIEW v1 AS
SELECT last_name, department_name, job_title
FROM employees e
	     INNER JOIN departments d ON e.department_id = d.department_id
	     INNER JOIN jobs j ON e.job_id = j.job_id;

SELECT *
FROM v1
WHERE last_name LIKE '%a%';
/*
        练习2. 查询各部门的平均工资级别
*/
# ①创建视图查询每个部门的平均工资
CREATE VIEW myv2 AS
SELECT AVG(salary) ag, department_id
FROM employees e
GROUP BY department_id;

# ②使用①中的myv2
SELECT myv2.ag, grade_level
FROM myv2
	     INNER JOIN job_grades g ON ag BETWEEN g.lowest_sal AND g.highest_sal;

/*
		练习3. 查询平均工资最低的部门信息
 */

SELECT *
FROM myv2
ORDER BY ag
LIMIT 1;

/*
		练习4. 查询平均工资最低的部门名和工资。
*/
CREATE VIEW myv3 AS
SELECT *
FROM myv2
ORDER BY ag
LIMIT 1;

SELECT d.*, m.ag
FROM myv3 m
	     INNER JOIN departments d ON m.department_id = d.department_id;

/*
        2. 修改视图
        语法：
        方式一：
        CREATE OR REPLACE VIEW 视图名
        AS
        查询语句
        [WITH | CASCADED | LOCAL | CHECK OPTION];

        方式二：
        ALTER VIEW 视图名
        AS
        查询语句
        [WITH | CASCADED | LOCAL | CHECK OPTION];
 */
SELECT *
FROM myv3;

# 方式一：
CREATE OR REPLACE VIEW myv3 AS
SELECT avg(salary), job_id
FROM employees
GROUP BY job_id;

# 方式二：
	ALTER VIEW myv3 AS
	SELECT *
	FROM employees;

/*
        3. 删除视图
        语法：
        DROP VIEW [IF EXISTS] 视图名,视图名,视图名,视图名,...[restrict | cascade]
 */

DROP VIEW v1;

/*
        4. 查看视图
        语法：
        方式一：
        SHOW TABLES;
        方式二：
        DESC 视图名;
		方式三：
        SHOW CREATE VIEW 视图名 \G;
 */
SHOW TABLES;
DESC myemployees.myv3;
SHOW CREATE VIEW myemployees.myv3;

/*
        4. 视图的更新

 */
CREATE OR REPLACE VIEW myv1
AS
SELECT last_name, email
FROM employees;

SELECT *
FROM myv1;

# 1. 插入

INSERT INTO myv1
VALUES ('刘备', 'lb@qq.com');

# 2. 修改
UPDATE myv1
SET last_name = '关羽'
WHERE last_name = '刘备';

SELECT *
FROM employees;

# 3.删除
DELETE
FROM myv1
WHERE last_name = '关羽';


# 视图的可更新性和视图中查询的定义有关系，以下类型的视图是不能更新的。
# ① 包含以下关键字的sql语句：分组函数、distinct、group by、having、union或者union all
CREATE OR REPLACE VIEW myv4
AS
SELECT max(salary) m, department_id
FROM employees
GROUP BY department_id;

SELECT *
FROM myv4;

#更新 --- 不支持
UPDATE myv4
SET m=9000
WHERE department_id = 10;


# ② 常量视图
CREATE OR REPLACE VIEW myv5
AS
SELECT 'John' name;

SELECT *
FROM myv5;

#更新 --- 不支持
UPDATE myv5
SET name='Luccy'
WHERE 1;


# ③ Select中包含子查询
CREATE OR REPLACE VIEW myv6
AS
SELECT (SELECT count(*) FROM employees) 全表;

SELECT *
FROM myv6;

#更新 --- 不支持
UPDATE myv6
SET 全表=10
WHERE 1;

# ④ JOIN
CREATE OR REPLACE VIEW myv7
AS
SELECT last_name, department_name
FROM employees
	     INNER JOIN departments d ON employees.department_id = d.department_id;

SELECT *
FROM myv7;

#更新 --- 不支持
UPDATE myv7
SET last_name='张飞'
WHERE last_name = 'Whalen';

INSERT INTO myv7
VALUES ('陈真', 'xxxx');


# ⑤ from一个不能更新的视图
CREATE OR REPLACE VIEW myv8
AS
SELECT *
FROM myv6;

SELECT *
FROM myv8;
#更新 --- 不支持
UPDATE myv8
SET 全表 = 20
WHERE 1;

# ⑥ where子句的子查询引用了from子句中的表
CREATE OR REPLACE VIEW myv9
AS
SELECT last_name, email, salary
FROM employees
WHERE employee_id IN (SELECT manager_id FROM employees WHERE manager_id IS NOT NULL);

SELECT *
FROM myv9;

#更新 --- 不支持
UPDATE myv9
SET salary = 20000
WHERE last_name = 'K_ing';