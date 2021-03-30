/*
        流程控制【经典案例】讲解：
        已知表stringcontent
        其中字段：
            id 自增长
            content varchar(20)
        向该表插入指定个数的，随机的字符串
 */
DELIMITER $
USE test$
DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent (
	id      INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(20)
);

CREATE PROCEDURE test_randstr_insert(IN insertcount INT)
BEGIN
	DECLARE i INT DEFAULT 1;#定义一个循环变量i，表示插入次数
	DECLARE str VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
	DECLARE startindex INT DEFAULT 1;#代表起始索引位置
	DECLARE len INT DEFAULT 1;#代表截取的字符的长度
	WHILE i <= insertcount
		DO
			SET len = FLOOR(RAND() * (20 - startindex + 1) + 1); #产生一个随机的整数，代表截取长度1-（26-startIndex+1)
			SET startindex = FLOOR(RAND() * 26 + 1); #产生一个随机的整数，代表起始索引 1 - 26
			INSERT INTO stringcontent(content)
				VALUES (SUBSTR(str,startindex,len));
			SET i = i + 1;
			END WHILE;
END $

