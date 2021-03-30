/*
		任何操作之前都先打开库
*/
USE girls;

/*#############################################进阶10：DML语言#############################################*/
/*
		数据操作语言：
			插入：INSERT
			修改：UPDATE
			删除：DELETE
*/
/*
		1.1插入语句
		方式一：经典的插入
		
		语法：
			INSERT INTO 表名(列名1,列名2...) VALUES(值1,值2...);

		要求：1.插入的值的类型要与列的类型一致或兼容 
*/
SELECT *
	FROM beauty;

INSERT INTO beauty (id,
					name,
					sex,
					borndate,
					phone,
					photo,
					boyfriend_id)
	VALUES (13,
			'小龙女',
			'女',
			'1966-02-05',
			13345678984,
			NULL,
			9);

/*
		要求：2.不可以为null的列必须插入值。可以为null的列如何插入值？
*/
# 方式一：
INSERT INTO beauty (id,
					name,
					sex,
					borndate,
					phone,
					photo,
					boyfriend_id)
	VALUES (13,
			'小龙女',
			'女',
			'1966-02-05',
			13345678984,
			NULL,
			9);

# 方式二：
INSERT INTO beauty (id,
					name,
					sex,
					borndate,
					phone,
					boyfriend_id)
	VALUES (14,
			'陆无双',
			'女',
			'1988-03-05',
			13345678984,
			9);

/*
		要求：3.列的顺序可以调换
*/
INSERT INTO beauty (name,
					id,
					borndate,
					sex,
					phone,
					boyfriend_id)
	VALUES ('黄蓉',
			15,
			'1985-03-05',
			'女',
			13345678984,
			9);

/*
		要求：4.列数和值的个数必须一致
*/
INSERT INTO beauty (name,
					id,
					borndate,
					sex,
					phone,
					boyfriend_id)
	VALUES ('关晓彤',
			16,
			'1989-03-05',
			'女',
			18602079288,
			9);

/*
		要求：5.可以省略列名，默认所有列，而且列的顺序和表中列的顺序一致。
*/
INSERT INTO beauty
	VALUES (17,
			'张庭',
			'女',
			'1988-01-05',
			18816211324,
			NULL,
			9);

/*
		插入语句
		方式二：经典的插入
		
		语法：
			INSERT INTO 表名 SET 列名=值,列名=值,...
*/
INSERT INTO beauty
SET
	id    = 18,
	name  = '刘涛',
	phone = 119;

/*
		插入方式 PK
*/
/*
		① 方式一支持插入多行，方式二不支持
*/
INSERT INTO beauty
	VALUES (19,
			'张庭1',
			'女',
			'1988-01-05',
			18816211324,
			NULL,
			9),
		   (20,
			'张庭2',
			'女',
			'1988-01-05',
			18816211324,
			NULL,
			9),
		   (21,
			'张庭3',
			'女',
			'1988-01-05',
			18816211324,
			NULL,
			9);

/*
		② 方式一支持子查询，方式二不支持
*/
INSERT INTO beauty (id, name, phone)
SELECT 22,
	   '宋茜',
	   110;

INSERT INTO beauty (id, name, phone)
SELECT id,
	   boyname,
	   119
	FROM boys
	WHERE id < 3;

/*
		1.2修改语句
		
		1.2.1 修改单表的记录		✔✔
		语法：
			UPDATE 表名					--------------------- ①
			SET 列1=新值1,列2=新值2,...					----- ③
			WHERE 筛选条件;					----------------- ②
		
				
		1.2.2 修改多表的记录		【补充】
		
		SQL92语法：
			UPDATE 表1 别名1,表2 别名2
			SET 列1=新值1,列2=新值2,...
			WHERE 连接条件
			AND 筛选条件;
			
		SQL99语法：
			UPDATE 表1 别名1
			【INNER|LEFT|RIGHT】 JOIN 表2 别名2
			ON 连接条件
			SET 列1=新值1,列2=新值2,...
			WHERE 筛选条件;
			
*/
/*
		1.2.1 修改单表的记录
		案例1：修改beauty表中姓唐的女神的电话为13899888899
*/
UPDATE
	beauty
SET
	phone = 13899888899
	WHERE name LIKE '张%';

/*
		1.2.1 修改单表的记录
		案例2：修改boys表中id号为2的名称为吴磊，userCP为1000
*/
UPDATE
	boys
SET
	boyname = '吴磊',
	usercp  = 1000
	WHERE id = 2;

/*
		1.2.2 修改多表的记录
		案例1：修改张无忌的女朋友的手机号为：12580
*/
UPDATE
	boys bo
		INNER JOIN beauty b
		ON bo.id = b.boyfriend_id
SET
	b.phone = 114
	WHERE bo.boyname = '张无忌';

/*
		1.2.2 修改多表的记录
		案例2：修改没有男朋友的女神的男朋友编号为2号的
*/
UPDATE
	boys bo
		RIGHT JOIN beauty b
		ON bo.id = b.boyfriend_id
SET
	b.boyfriend_id = 2
	WHERE bo.id IS NULL;

SELECT *
	FROM beauty;

/*
		1.3删除语句
		
		1.3.1 方式一：delete
			1.3.1.1单表的删除-------------✔✔
			语法：
				#删除符合条件的某一行或多行
				DELETE FROM 表名
				WHERE 筛选条件
			
			1.3.1.2多表的删除-------------【补充】
			SQL92语法：
				DELETE 表1的别名,表2的别名
				FROM 表1 别名,表2 别名
				WHERE 连接条件
				AND 筛选条件
				
			SQL99语法：
				DELETE 表1的别名,表2的别名
				FROM 表1 别名
				【INNER|LEFT|RIGHT】JOIN 表2 别名 ON 连接条件
				WHERE 筛选条件
		
		1.3.2方式二：truncate
		语法：
			#删除表名中的所有内容
			TRUNCATE TABLE 表名	
*/
/*
		1.3.1 方式一：delete
		1.3.1.1 单表的删除
		案例：删除手机号以9结尾的女神信息
*/
DELETE
	FROM beauty
	WHERE phone LIKE '%9';

SELECT *
	FROM beauty;

/*
		1.3.1 方式一：delete
		1.3.1.2 多表的删除
		案例1：删除张无忌的女朋友的信息
*/
DELETE
	b,
	bo
	FROM beauty     b
	INNER JOIN boys bo
			   ON b.boyfriend_id = bo.id
	WHERE bo.boyname = '张无忌';

/*
		1.3.1 方式一：delete
		1.3.1.2 多表的删除
		案例2：删除黄晓明以及他女朋友的信息
*/
DELETE
	b,
	bo
	FROM beauty     b
	INNER JOIN boys bo
			   ON b.boyfriend_id = bo.id
	WHERE bo.boyname = '黄晓明';

/*
		1.3.2方式二：truncate
		案例：将魅力值>100的男神信息删除
*/
TRUNCATE TABLE boys;

/*
		DELETE 和 TRUNCATE 的异同【面试题】
		
		① DELETE可以加WHERE条件，TRUNCATE不能加
		
		② TRUNCATE删除，效率高一些。
		
		③ 假如要删除的表中有自增长列，
			如果用DELETE删除后，再插入数据，自增长列的值从断点开始;
			而TRUNCATE删除后，再插入数据，自增长列的值从1开始。
			
		④ TRUNCATE删除没有返回值,DELETE删除有返回值
		
		⑤ TRUNCATE删除不能回滚，DELETE删除可以回滚
*/
DELETE
	FROM boys;
INSERT INTO boys(boyname, usercp)
	VALUES ('刘备', 100),
		   ('关羽', 100),
		   ('张飞', 100);


TRUNCATE TABLE boys;
INSERT INTO boys(boyname, usercp)
	VALUES ('刘备', 100),
		   ('关羽', 100),
		   ('张飞', 100);








