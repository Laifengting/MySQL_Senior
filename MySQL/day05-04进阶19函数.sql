/*#################################################进阶19：函数#################################################*/
/*
        1. 函数
        含义：一组预告编译好的SQL语句的集合，理解成批处理语句
        好处：
			① 提高代码的重用性
			② 简化操作
            ③ 减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率。

        区别：
        存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新。
        函数：有且仅有 1 个返回。适合做处理数据后返回一个结果。

        1.1 创建语法：
        CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
        BEGIN
            函数体
            函数体中的最后一行RETURN 值;
        END $

        注意： 1. 参数列表 包含两部分：参数名 和 参数类型
              2. 函数体 肯定会有RETURN语句，如果没有会报错。如果RETURN语句没有放在函数体的最后也不报错，但不建议。
              3. 函数体中仅有一句话，则可以省略BEGIN END
              4. 使用 DELIMITER 语句设置结束标记

        1.2 调用语法：
        SELECT 函数名(参数列表)

 */

/*
        1.2.1 无参有返回
        案例：返回公司的员工个数
 */
USE myemployees;
DELIMITER $

# 创建
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	# 定义一个变量
	DECLARE c INT DEFAULT 0;
	SELECT count(*)
	INTO c #赋值
	FROM employees;
	RETURN c;
END $

SELECT myf1() $


/*
        1.2.2.1 有参有返回
        案例1：根据员工名，返回他的工资
 */
CREATE FUNCTION myf2(empName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal = 0;#定义一个用户变量
	SELECT salary
	INTO @sal #赋值
	FROM employees
	WHERE last_name = empName;
	RETURN @sal;
END $

SELECT myf2('Jones') $

/*
        1.2.2.2 有参有返回
        案例2：根据部门名，返回该部门的平均工资
 */
CREATE FUNCTION myf3(deptName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE sal DOUBLE;
	SELECT avg(salary)
	INTO sal
	FROM employees e
		     JOIN departments d ON e.department_id = d.department_id
	WHERE d.department_name = deptName;
	RETURN sal;
END $

SELECT myf3('IT') $

/*
        1.3 查看函数：
        SHOW CREATE FUNCTION 函数名
 */
SHOW CREATE FUNCTION myf3;

/*
        1.4 删除函数：
        DROP FUNCTION 函数名
 */
DROP FUNCTION myf3;

/*
        案例：创建函数，实现传入两个float，返回两者之各
 */
DROP FUNCTION sumFunc $
CREATE FUNCTION sumFunc(num1 FLOAT, num2 FLOAT) RETURNS FLOAT
BEGIN
	DECLARE sumN1N2 FLOAT;
# 	SELECT (num1 + num2) INTO sumN1N2;
	SET sumN1N2 = num1 + num2;
	RETURN sumN1N2;
END $

SELECT sumFunc(11, 12) $