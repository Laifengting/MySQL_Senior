/*###############################################进阶18：存储过程和函数###############################################*/
/*
		存储过程和函数：类似于Java中的方法
		Java中方法的好处：
			① 提高代码的重用性
			② 简化操作
 */
/*
        1. 存储过程
        含义：一组预告编译好的SQL语句的集合，理解成批处理语句
        好处：
			① 提高代码的重用性
			② 简化操作
            ③ 减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率。

        1.1 创建语法：
        CREATE PROCEDURE 存储过程名(参数列表)
        BEGIN
            存储过程体(一组合法的SQL语句)
        END

        注意：
	     ① 参数列表包含三部分
	        参数模式    参数名     参数类型
	        IN  stuname VARCHAR(20)

            参数模式：
                IN：该参数可以作为输入，也就是该参数需要调用方法传入值
                OUT：该参数可以作为输出，也就是该参数可以作为返回值
                INOUT：该参数即可以作为输入又可以作为输出，也就是该参数即需要传入值，又可以返回值。
         ② 如果存储过程体仅仅只有一句话，BEGIN END可以省略。
            存储过程体中的每条SQL语句的结尾要求必须加分号。
            存储过程的结尾可以使用DELIMITER 重新设置

            语法：
            DELIMITER 结束标记
            例：
            DELIMITER $

        1.2 调用语法：
        CALL 存储过程名(实参列表);
 */
/*
        1.2.1. 空参列表
        # 案例：插入到admin表中五条记录
 */
SELECT *
FROM girls.admin;

USE girls;

# 创建
DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username, password)
	VALUES ('Jack', '0001'),
	       ('John', '0002'),
	       ('Helen', '0003'),
	       ('Jerry', '0004'),
	       ('Tom', '0005');
END $

# 调用
CALL myp1()$

/*
        1.2.2.1 创建带IN模式参数的存储过程
        # 案例：创建存储过程实现，根据女神名，查询对应的男神信息
 */
# 创建
USE girls;
DELIMITER $
CREATE PROCEDURE myp2(IN beautyName VARCHAR(20))
BEGIN
	SELECT bo.*
	FROM boys bo
		     RIGHT JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name = beautyName;
END $

# 调用
CALL myp2('Angelababy')$

/*
        1.2.2.2 创建带多个IN参数的存储过程
        # 案例：创建存储过程实现，用户是否登录成功？
 */
USE girls;
DELIMITER $
CREATE PROCEDURE myp4(IN username VARCHAR(20), IN password VARCHAR(10))
BEGIN
	DECLARE result INT DEFAULT 0; # 声明并初始化自定义变量

	SELECT count(*)
	INTO result #自定义变量赋值
	FROM admin a
	WHERE a.username = username
	  AND a.password = password;
	SELECT IF(result > 0, 'SUCCESS', 'DEFEAT'); #变量的使用
END $

# 调用
CALL myp4('Tom', 0005)$

/*
        1.2.3.1 创建带一个OUT参数的存储过程
        # 案例：创建存储过程实现，根据女神名，返回对应的男神名
 */
USE girls;
DELIMITER $
CREATE PROCEDURE myp5(IN beautyName VARCHAR(20), OUT boyName VARCHAR(10))
BEGIN
	SELECT bo.boyName
	INTO boyName
	FROM boys bo
		     INNER JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name = beautyName;
END $

# 调用
CALL myp5('Tom', @bName)$
SELECT @bName$

/*
        1.2.3.2 创建带多个OUT参数的存储过程
        # 案例：创建存储过程实现，根据女神名，返回对应的男神名，和男神魅力值
 */
USE girls;
DELIMITER $
CREATE PROCEDURE myp6(IN beautyName VARCHAR(20), OUT boyName VARCHAR(10), OUT userCP INT)
BEGIN
	SELECT bo.boyName, bo.userCP
	INTO boyName, userCP
	FROM boys bo
		     INNER JOIN beauty b
		                ON bo.id = b.boyfriend_id
	WHERE b.name = beautyName;
END $

# 调用
CALL myp6('Angelababy', @bName, @bUserCP) $
SELECT @bName, @bUserCP $

/*
        1.2.4. 创建带一个INOUT参数的存储过程
        # 案例：传入a和b两个值，最终a和b都翻倍都返回
 */
USE girls;
DELIMITER $
CREATE PROCEDURE myp7(INOUT a INT, INOUT b INT)
BEGIN
	SET a := a * 2;
	SET b := b * 2;
END $

#调用
SET @m = 10 $
SET @n = 20 $
CALL myp7(@m, @n) $
SELECT @m, @n $

/*
        1.3 删除存储过程
        语法：DROP PROCEDURE 存储过程名称
 */

DROP PROCEDURE myp1;

/*
        1.4 查看存储过程的信息
        语法：SHOW CREATE PROCEDURE 存储过程名称
 */
SHOW CREATE PROCEDURE myp7;

