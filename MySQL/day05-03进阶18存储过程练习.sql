/*
		1. 创建存储过程实现传入用户名和密码，插入到admin表中
*/
USE girls;
DELIMITER $
CREATE PROCEDURE test_pro1(IN username VARCHAR(20), IN loginpwd VARCHAR(20))
BEGIN
	INSERT INTO admin(admin.username, admin.password)
		VALUES (username, loginpwd);
END $

/*
        2. 创建存储过程或函数实现传入女神编号，返回女神名称和女神电话
 */
CREATE PROCEDURE test_pro2(IN userid INT, OUT username VARCHAR(20), OUT userphone VARCHAR(11))
BEGIN
	SELECT b.name, b.phone
		INTO username,userphone
		FROM beauty b
		WHERE b.id = userid;
END $
# 调用
CALL test_pro2(1,@username,@userphone)$
SELECT @username, @userphone$

/*
        3. 创建存储过程或函数实现传入两个女神的生日，返回大小
 */
CREATE PROCEDURE test_pro3(IN birth1 DATETIME, IN birth2 DATETIME, OUT result INT)
BEGIN
	SELECT DATEDIFF(birth1,birth2)
		INTO result;
END$
# 调用
CALL test_pro3('1998-1-1',NOW(),@result)$
SELECT @result$

/*
        4. 创建存储过程或函数实现传入一个日期，格式化成XX年xx月xx日并返回
 */
USE girls $
DELIMITER $
CREATE PROCEDURE test_pro4(IN date_time DATETIME, OUT fm_date_time VARCHAR(200))
BEGIN
	SELECT DATE_FORMAT(date_time,'%y年%m月%d日')
		INTO fm_date_time;
END $

CALL test_pro4(NOW(),@result) $
SELECT @result $

/*
       5. 创建存储过程或函数实现传入女神名，返回：女神 AND 男神 格式的字符串
       如：传入：小昭     返回：小昭 AND 张无忌
 */
USE girls $
DELIMITER $
CREATE PROCEDURE test_pro5(IN beautyname VARCHAR(20), OUT concatname VARCHAR(50))
BEGIN
	# 写法一：
	SELECT CONCAT(beautyname,' AND ',IFNULL((
											SELECT boyname
												FROM boys         bo
												INNER JOIN beauty b
														   ON bo.id = b.boyfriend_id
												WHERE b.id = (
															 SELECT b2.id
																 FROM beauty b2
																 WHERE b2.name = beautyname)),
											'null'))
		INTO concatname;

	#写法二：
	# 	SELECT concat(beautyName, ' AND ', IFNULL(bo.boyName, 'null'))
	# 	INTO concatName
	# 	FROM boys bo
	# 		     RIGHT JOIN beauty b ON bo.id = b.boyfriend_id
	# 	WHERE b.name = beautyName;
END $

CALL test_pro5('Angelababy',@result) $
SELECT @result $

/*
        6.创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录。
 */
USE girls $
DELIMITER $
DROP PROCEDURE test_pro6 $
CREATE PROCEDURE test_pro6(IN startindex INT, IN size INT)
BEGIN
	SELECT *
		FROM beauty
		LIMIT startindex,size;
END $

CALL test_pro6(3,5) $
