/*
		任何操作之前都先打开库
*/
USE girls;

/*###########################################进阶12：常见数据类型###########################################*/
/*
		常见的数据类型：
		1.1 数值型:
			1.1.1 整型
			1.1.2 小数：1.1.2.1 定点数
						1.1.2.2 浮点数
		1.2 字符型：
			较短的文本：char、varchar
			较长的文本：text、blob(较长的二进制数据)
			
		1.3 日期型：
*/
/*
		1.1 数值型：
			1.1.1 整型
			
			分类：tinyint、smallint、mediumint、int/integer、bigint
			占位：	1			2		3			4			8
				
			特点：
				① 如果不设置无符号还是有符号，默认是有符号，如果想设置无符号，需要添加UNSIGNED关键字
				② 如果插入的数值超出了整形的范围，会报OUT OF RANG错误(5.5版本会警告，但插入临界值，8.0版本会报错，插入失败)
				③ 如果不设置长度，会有默认的长度。长度代表了显示的最大宽度，如果加了关键字ZEROFILL，不够位的会在左边填充0

*/
/*
		1.1.1 如何设置无符号和有符号
*/
DROP TABLE IF EXISTS tab_int;

CREATE TABLE IF NOT EXISTS tab_int (
	#如果加了ZEROFILL默认就是无符号。
	t1 INT(7) ZEROFILL,
	#设置为无符号，
	t2 INT(7) UNSIGNED ZEROFILL
);

DESC tab_int;

INSERT INTO tab_int
	VALUES (- 1234000005);

INSERT INTO tab_int
	VALUES (- 123456, - 123456);

INSERT INTO tab_int
	VALUES (2147483648, 4294967296);

INSERT INTO tab_int
	VALUES (123, 123);

SELECT *
	FROM tab_int;

/*
		1.1 数值型：
			1.1.2 小数
				1.1.2.1 浮点型 float(M,D) 、double(M,D)
								4				8
				
				
				1.1.2.2 定点型 DEC(M,D)/DECIMAL(M,D)
						给定的取值范围M+2 最大为8
									
			特点：
				① M 和 D的意思 	M = 整数部位 + 小数部位，
								D = 小数部位
								如果超过范围，则插入临界值(5.5版本，8.0版本直接报错)
				② M 和 D都可以省略。如果是DECIMAL,默认M是10，D是0(如果插入带小数，会四会五入取整)
									如果是float和double，则会根据插入的数值的精度来决定精度
				③ 定点型的精确度较高，如果要求插入数值的数度较高，如：货币运算等则考虑使用定点型。
			
			原则：
				所选择的类型越简单越好，能保存数值的类型越小越好。
				
*/
DROP TABLE IF EXISTS tab_float;

#带M和D
CREATE TABLE tab_float (
	f1 FLOAT(5, 2),
	f2 DOUBLE(5, 2),
	f3 DEC(5, 2)
);

#省略M和D
CREATE TABLE tab_float (
	f1 FLOAT,
	f2 DOUBLE,
	f3 DEC
);

DESC tab_float;

INSERT INTO tab_float
	VALUES (123.45, 123.45, 123.45);

INSERT INTO tab_float
	VALUES (123.456, 123.456, 123.456);

INSERT INTO tab_float
	VALUES (123.4, 123.4, 123.4);

INSERT INTO tab_float
	VALUES (12345.4, 12345.4, 12345.5);

/*
		1.2 字符型：
			1.2.1 较短的文本：
			
				字符串类型	最多字符数							描述及存储需求				特点				空间的耗费		效率性能
				char(M)			M(可以省略，默认为1)			M为0~255之间的整数			固定长度的字符		比较耗费			高
				varchar(M)		M								M为0~65535之间的整数		可变长度的字符		比较节省			低
			
				binary 和 varbinary用于保存较短的二进制
				ENUM类型用于保存枚举
				SET类型用于保存集合
				
			1.2.2 较长的文本：
				text
				
				blob(较长的二进制数据)
			

*/
/*
		1.2.1 ENUM类型
*/
CREATE TABLE tab_char (
	c1 ENUM ('a', 'b', 'c')
);

INSERT INTO tab_char
	VALUES ('a');

INSERT INTO tab_char
	VALUES ('b');

INSERT INTO tab_char
	VALUES ('c');

#5.5版本插入空白值，8.0版本插入失败
INSERT INTO tab_char
	VALUES ('d');

INSERT INTO tab_char
	VALUES ('A');

SELECT *
	FROM tab_char;

/*
			1.2.1 SET类型
*/
CREATE TABLE tab_set (
	s1 SET ('a', 'b', 'c', 'd', 'e')
);

INSERT INTO tab_set
	VALUES ('a');

INSERT INTO tab_set
	VALUES ('a,b');

INSERT INTO tab_set
	VALUES ('a,b,c');

/*
		1.3 日期型：
		
			日期和时间类型		字节	最小值					最大值
				date			4		1000-01-01				9999-12-31
				datetime		8		1000-01-01 00:00:00		9999-12-31 23:59:59
				timestamp		4		19700101080001			2038年的某个时刻
				time			3		-838:59:59				838:59:59
				year			1		1901					2155
				
			datetime和timestamp的区别:
				1、	Timestamp支持的时间范围较小，取值范围：19700101080001——2038年的某个时间
					Datetime的取值范围：1000-1-1 ——9999—12-31
				2、	timestamp和实际时区有关，更能反映实际的日期，而datetime则只能反映出插入时的当地时区
				3、	timestamp的属性受Mysql版本和SQLMode的影响很大
*/
CREATE TABLE tab_date (
	t1 DATETIME,
	t2 TIMESTAMP
);

INSERT INTO tab_date
	VALUES (NOW(), NOW());

SELECT *
	FROM tab_date;

SHOW VARIABLES LIKE 'time_zone';

SET time_zone = '+8:00';