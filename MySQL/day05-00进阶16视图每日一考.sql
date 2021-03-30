/*
		一、创建表Book表，字段如下：
			bid 整型，要求主键
			bname 字符型，要求设置唯一键，并非空
			price 浮点型，要求有默认值10
			btypeId 类型编号，要求引用bookType表的id字段

		已知bookType表(不用创建)，字段如下
		id
		name
*/
USE myemployees;
CREATE TABLE IF NOT EXISTS book (
	bid     INT PRIMARY KEY,
	bname   VARCHAR(20) UNIQUE NOT NULL,
	price   DOUBLE DEFAULT 10,
	btypeid INT,
	CONSTRAINT fk_book_booktype FOREIGN KEY (btypeid) REFERENCES booktype(id)
);

CREATE TABLE IF NOT EXISTS booktype (
	id   INT PRIMARY KEY,
	name VARCHAR(20) UNICODE NOT NULL
);

/*
        二、开启事务
        向表中插入1行数据，并结束
 */
TRUNCATE TABLE book;
DELETE
	FROM booktype
	WHERE 1;
TRUNCATE TABLE booktype;
INSERT INTO booktype
	VALUES (1, '黄书'),
		   (2, '小说');

SET AUTOCOMMIT = 0;
INSERT INTO book(bid, bname, price, btypeid)
	VALUES (1, '金瓶梅', 888, 1),
		   (2, '三国演义', 8, 2),
		   (3, '灯草和尚', 88, 1),
		   (4, '西游记', 188, 2),
		   (5, '玉蒲团', 100, 1),
		   (6, '红楼梦', 90, 2);
COMMIT;

/*
        三、创建视图，实现查询价格大于100的书名和类型名
 */
CREATE OR REPLACE VIEW mybook
AS
	SELECT b.bname, bt.name
		FROM book           b
		INNER JOIN booktype bt
				   ON b.btypeid = bt.id
		WHERE b.price > 100;

SELECT *
	FROM mybook;

/*
        四、修改视图，实现查询价格在90-120之间的书名和价格
 */
CREATE OR REPLACE VIEW mybook
AS
	SELECT bname, price
		FROM book
		WHERE price BETWEEN 90 AND 120;


ALTER VIEW mybook
	AS
		SELECT bname, price
			FROM book
			WHERE price BETWEEN 90 AND 120;
# [WITH | CASCADED | LOCAL | CHECK OPTION];

/*
        五、删除刚才建的视图。
 */
DROP VIEW IF EXISTS mybook;


