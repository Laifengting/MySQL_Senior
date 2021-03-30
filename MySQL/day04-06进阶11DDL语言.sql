/*
		任何操作之前都先打开库
*/
USE girls;

/*#############################################进阶11：DDL语言#############################################*/
/*
		数据定义语言：
		库和表的管理
		
		1. 库的管理
			创建、修改、删除
		
		2. 表的管理
			创建、修改、删除
		
		创建：CREATE
		修改：ALTER
		删除：DROP
			
*/
/*
		1. 库的管理
		1.1 库的创建
		
		语法：
		CREATE DATABASE 库名;
		
		案例：创建库Books
*/
# 创建库，如果库已经存在会报错。
CREATE DATABASE books;

#创建库，如果存在不创建，如果不存在创建。
CREATE DATABASE IF NOT EXISTS books;

/*
		1. 库的管理
		1.2 库的修改
*/
#修改库名 命令已经废弃
/*
rename database Books TO eBooks;
*/

# 更改库的字符集
ALTER DATABASE books CHARACTER SET utf8;

/*
		1. 库的管理
		1.3 库的删除  
*/
#删除库，如果库已经不存在会报错。
DROP DATABASE books;

#删除库，如果不存在不删除，如果存在删除。
DROP DATABASE IF EXISTS books;



/*
		2. 表的管理
		2.1 表的创建
		
		语法：
		CREATE TABLE 表名(
			列名 列的类型 【(长度) 约束】,
			列名 列的类型 【(长度) 约束】,
			列名 列的类型 【(长度) 约束】,
			...
			列名 列的类型 【(长度) 约束】	
		);
*/
/*
		案例：创建表book
*/
CREATE TABLE IF NOT EXISTS book (
	#书的编号
	id          INT,

	#图书名
	bookname    VARCHAR(20),

	#价格
	price       DOUBLE,

	#作者编号
	authorid    INT,

	#出版日期
	publishdate DATETIME
);

DESC book;

/*
		案例：创建表author
*/
CREATE TABLE IF NOT EXISTS author (
	authorid   INT,
	authorname VARCHAR(20),
	nation     VARCHAR(20)
);


/*
		2. 表的管理
		2.2 表的修改

		语法：ALTER TABLE 表名 ADD|DROP|MODIFY|CHANGE 【COLUMN】列名 【列类型 约束】
		
		① 修改表中的列名
		② 修改列的类型或约束
		③ 添加新列
		④ 删除列
		⑤ 修改表名
*/

/*
		2. 表的管理
		2.2 表的修改
		案例：修改表中的列名
*/
ALTER TABLE book
	CHANGE COLUMN pubdate pbdate DATETIME;
#注：修改列名时 COLUMN 关键字可以省略
ALTER TABLE book
	CHANGE pbdate pubdate DATETIME;

/*
		2. 表的管理
		2.2 表的修改
		案例：修改列的类型或约束
*/
ALTER TABLE book
	MODIFY COLUMN pubdate TIMESTAMP;
#注：修改列的类型或约束时 COLUMN 关键字可以省略
ALTER TABLE book
	MODIFY pubdate DATETIME;

/*
		2. 表的管理
		2.2 表的修改
		案例：添加新列
*/
ALTER TABLE author
	ADD COLUMN annual DOUBLE;
#注：添加新列时 COLUMN 关键字可以省略
ALTER TABLE author
	ADD annual2 DOUBLE;

/*
		2. 表的管理
		2.2 表的修改
		案例：删除列
*/
ALTER TABLE author
	DROP COLUMN annual;
#注：删除列时 COLUMN 关键字可以省略
ALTER TABLE author
	DROP annual2;

/*
		2. 表的管理
		2.2 表的修改
		案例：修改表名
*/
ALTER TABLE author RENAME TO authors;

DESC book;
DESC authors;

/*
		2. 表的管理
		2.3 表的删除

		语法：DROP TABLE 表名
*/
DROP TABLE IF EXISTS authors;

SHOW TABLES;


/*
		通过的写法：
*/
/*
DROP DATABASE IF EXISTS 旧库名;
CREATE DATABASE 新库名;

DROP TABLE IF EXISTS 旧表名;
CREATE TABLE 表名(列名 列的类型 【(长度) 约束】,
			列名 列的类型 【(长度) 约束】,
			列名 列的类型 【(长度) 约束】,
			...
			列名 列的类型 【(长度) 约束】);

*/

/*
		2. 表的管理
		2.4 表的复制
*/

INSERT INTO authors
	VALUES (1, '村上春树', '日本'),
		   (2, '莫言', '中国'),
		   (3, '金庸', '中国');

SELECT *
	FROM authors;

/*
		2.4.1仅仅复制表的结构
*/
CREATE TABLE authors_copy LIKE authors;

SELECT *
	FROM authors_copy;

/*
		2.4.2复制表的结构+数据
*/
CREATE TABLE authors_copy2
	SELECT *
		FROM authors;

/*
		2.4.3复制表的结构 + 部分数据
*/
CREATE TABLE authors_copy3
	SELECT *
		FROM authors
		WHERE nation = '中国';

/*
		2.4.4复制表的部分结构 + 部分数据
*/
CREATE TABLE authors_copy4
	# 仅复制列名，不复制数据
	SELECT authorid, authorname
		FROM authors
			#WHERE 1=2;
		WHERE 0;

