/*###############################################进阶20：流程控制结构###############################################*/
/*
		顺序结构：程序从上往下依次执行
		分支结构：程序从两条或多条路径中选择一条去执行。
		循环结构：程序在满足一定条件的基础上，重复执行一段代码
 */

/*
        1.分支结构
        1.1 IF函数

        功能：实现简单的双分支

        语法：
        SELECT IF(表达式1，表达式2，表达式3)

        执行顺序：如果表达式1成立，则IF函数返回表达2的值，否则返回表达式3的值;

        应用：任何地方


        1.2 CASE函数

        情况1：类似于JAVA中的switch语句，一般用于实现的等值判断

        语法：
            CASE 变量|表达式|字段
            WHEN 要判断的值 THEN 返回的值1或语句1;
            WHEN 要判断的值 THEN 返回的值2或语句2;
            ...
            [ELSE 要返回的值n或语句n;]
            END CASE;

        情况2：类似于JAVA中的多重if语句，一般用于实现区间判断

        语法：
            CASE
            WHEN 要判断的条件1 THEN 返回的值1或语句1;
            WHEN 要判断的条件2 THEN 返回的值2或语句2;
            ...
            [ELSE 要返回的值n或语句n;]
            END CASE;

        特点：
            ①可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，BEGIN END 中或BEGIN END 的外面；也可以作为独立的语句去使用，只能放在BEGIN END中。
            ②如果WHEN中的值满足或条件成立，则执行对就的THEN后面的语句，并且结束CASE；如果都不满足，则执行ELSE中的语句或值。
            ③ELSE可以省略，如果ELSE省略了，并且所有WHEN条件都不满足，则返回NULL。

        1.3 IF结构
        功能：实现多重分支

        语法：
        IF 条件1 THEN 语句1;
        ELSEIF 条件2 THEN 语句2;
        ...
        [ELSE 语句n]
        END IF;

        只能应用在BEGIN END中

 */

/*
        CASE应用
        创建存储过程，根据传入的成绩，来显示等级，比如传入的成绩：90-100，显示A;80-90显示B; 60-80显示C;否则，显示D
 */
DELIMITER $
CREATE PROCEDURE test_case(IN score INT)
BEGIN
	CASE
		WHEN score >= 90 AND score <= 100 THEN SELECT 'A';
		WHEN score >= 80 THEN SELECT 'B';
		WHEN score >= 60 THEN SELECT 'C';
		ELSE SELECT 'D';
		END CASE;
END $
CALL test_case(95) $

/*
        IF结构应用
        创建存储过程，根据传入的成绩，来显示等级，比如传入的成绩：90-100，返回A;80-90 返回B; 60-80 返回C; 否则，返回D
 */
CREATE FUNCTION test_if(score INT) RETURNS CHAR
BEGIN
	IF score >= 90 AND score <= 100 THEN
		RETURN 'A';
		ELSEIF score >= 80 THEN
			RETURN 'B';
		ELSEIF score >= 60 THEN
			RETURN 'C';
		ELSE
			RETURN 'D';
		END IF;
END $

SELECT test_if(90) $

/*
        2. 循环结构
        分类：
        WHILE、LOOP、REPEAT

        循环控制：
        ITERATE 类似于 JAVA中的CONTINUE，继续，结束本次循环，继续下一次。
        LEAVE 类似于 JAVA中的BREAK，跳出，结束当前所在的循环

/*
        2.1 WHILE
        语法：
        [标签:]WHILE 循环条件 DO
            循环体;
        END WHILE [标签];
*/

/*
        2.2 LOOP
        语法：
        [标签:]LOOP
            循环体;
        END LOOP[标签];

        可以用来模拟简单的死循环
        要结束可以搭配LEAVE
*/
/*
        2.3 REPEAT
        语法：
        [标签:]REPEAT
            循环体;
        UNTIL 结束循环的条件
        END REPEAT[标签];
 */

/*
        使用WHILE循环
        案例1：批量插入，根据次数插入到admin表中多条记录
 */
USE girls $
DELIMITER $
DROP PROCEDURE pro_while1 $
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i <= insertCount
		DO
			INSERT INTO girls.admin(girls.admin.username, password) VALUES (CONCAT('ROSE', i), '666');
			SET i = i + 1;
			END WHILE;
END $

CALL pro_while1(100) $

SELECT *
FROM girls.admin $

/*
        添加LEAVE语句
        案例2：批量插入，根据次数插入到admin表中多条记录，如果次数>20则停止
 */
TRUNCATE TABLE admin $
DROP PROCEDURE pro_while1 $
CREATE PROCEDURE test_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	a:
	WHILE i <= insertCount
		DO
			INSERT INTO admin(username, password) VALUES (CONCAT('xiaohua', i), '0000');
			IF i >= 20 THEN
				LEAVE a;
				END IF;
			SET i = i + 1;
			END WHILE a;
END $

CALL test_while1(100) $
SELECT *
FROM girls.admin $
/*
        添加ITERATE语句
        案例3：批量插入，根据次数插入到admin表中多条记录，只插入偶数次
 */
TRUNCATE TABLE admin $
DROP PROCEDURE test_while1 $
CREATE PROCEDURE test_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	a:
	WHILE i <= insertCount
		DO
			SET i = i + 1;
			IF mod(i, 2) <> 0 THEN
				ITERATE a;
				END IF;
			INSERT INTO admin(username, password) VALUES (CONCAT('xiaohua', i), '0000');
			END WHILE a;
END $

CALL test_while1(100) $
SELECT *
FROM girls.admin $