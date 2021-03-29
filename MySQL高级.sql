#### 七种 JOIN 的 SQL 编写
# 创建数据库
CREATE DATABASE IF NOT EXISTS lft;

# 使用数据库
USE lft;

# 创建表 tbl_dept
CREATE TABLE tbl_dept (
	id       INT(11) NOT NULL AUTO_INCREMENT,
	deptname VARCHAR(30) DEFAULT NULL,
	locadd   VARCHAR(40) DEFAULT NULL,
	PRIMARY KEY (id)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 创建表 tbl_emp
CREATE TABLE tbl_emp (
	id     INT(11) NOT NULL AUTO_INCREMENT,
	name   VARCHAR(20) DEFAULT NULL,
	deptid INT(11)     DEFAULT NULL,
	PRIMARY KEY (id),
	KEY fk_dept_id(deptid)
	#CONSTRAINT `fk_dept_id` FOREIGN KEY (`deptId`) REFERENCES `tbl_dept` (`id`)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# tbl_dept表中插入数据
INSERT INTO tbl_dept(deptname, locadd)
	VALUES ('RD', 11);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES ('HR', 12);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES ('MK', 13);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES ('MIS', 14);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES ('FD', 15);

# tbl_emp表中插入数据
INSERT INTO tbl_emp(name, deptid)
	VALUES ('Z1', 1);
INSERT INTO tbl_emp(name, deptid)
	VALUES ('Z2', 1);
INSERT INTO tbl_emp(name, deptid)
	VALUES ('Z3', 1);

INSERT INTO tbl_emp(name, deptid)
	VALUES ('W5', 2);
INSERT INTO tbl_emp(name, deptid)
	VALUES ('W6', 2);

INSERT INTO tbl_emp(name, deptid)
	VALUES ('S8', 3);
INSERT INTO tbl_emp(name, deptid)
	VALUES ('S9', 4);
INSERT INTO tbl_emp(name, deptid)
	VALUES ('S10', 51);

# 查询单表
SELECT *
	FROM tbl_dept AS td;

# 查询单表
SELECT *
	FROM tbl_emp AS te;

# 笛卡尔积1
SELECT *
	FROM tbl_dept AS td
	JOIN tbl_emp  AS te;

# 笛卡尔积2
SELECT *
	FROM tbl_dept AS td,
		 tbl_emp  AS te;


# 左连接——左表的全部
# 左表全部保留，右表关联不上用 NULL 表示。
SELECT *
	FROM tbl_emp       AS a
	LEFT JOIN tbl_dept AS b
			  ON a.deptid = b.id;

# 右连接——右表的全部
# 右表全部保留，左表关联不上用 NULL 表示。
SELECT *
	FROM tbl_emp        AS a
	RIGHT JOIN tbl_dept AS b
			   ON a.deptid = b.id;

# 内连接——交集
# 两表关联，保留两表中交集的记录。
SELECT *
	FROM tbl_emp        AS a
	INNER JOIN tbl_dept AS b
			   ON a.deptid = b.id;

# 左表独有
# 两表关联，查询左表独有的数据。
SELECT *
	FROM tbl_emp       AS a
	LEFT JOIN tbl_dept AS b
			  ON a.deptid = b.id
	WHERE b.id IS NULL;

# 右表独有
# 两表关联，查询右表独有的数据。
SELECT *
	FROM tbl_emp        AS a
	RIGHT JOIN tbl_dept AS b
			   ON a.deptid = b.id
	WHERE a.deptid IS NULL;

# 全表连接
# Oracle里面有full join,但是在 MySQL 中没有full join。我们可以使用union来达到目的。
# 两表关联，查询它们的所有记录。
SELECT *
	FROM tbl_emp       te1
	LEFT JOIN tbl_dept td1
			  ON te1.deptid = td1.id
UNION
SELECT *
	FROM tbl_emp        te2
	RIGHT JOIN tbl_dept td2
			   ON te2.deptid = td2.id;


# 并集去交集
# 两表关联，取并集然后去交集。
SELECT *
	FROM tbl_emp       AS a
	LEFT JOIN tbl_dept AS b
			  ON a.deptid = b.id
	WHERE b.id IS NULL
UNION
SELECT *
	FROM tbl_emp        AS a
	RIGHT JOIN tbl_dept AS b
			   ON a.deptid = b.id
	WHERE a.deptid IS NULL;

SELECT *
	FROM tbl_emp;



#### 索引的使用
# 查看索引
SHOW INDEX FROM tbl_emp;

# 创建索引——方式1
CREATE INDEX idx_emp_name ON tbl_emp(name);

# 创建索引——方式2
ALTER TABLE tbl_emp
	ADD INDEX idx_emp_deptid(deptid);

# 删除索引
DROP INDEX idx_emp_deptid ON tbl_emp;
DROP INDEX idx_emp_name ON tbl_emp;

#### Explain 命令
EXPLAIN
	SELECT *
		FROM tbl_emp;

EXPLAIN
	SELECT 0
		FROM tbl_emp;


EXPLAIN
	SELECT *
		FROM tbl_emp       te1
		LEFT JOIN tbl_dept td1
				  ON te1.deptid = td1.id
	UNION
	SELECT *
		FROM tbl_emp        te2
		RIGHT JOIN tbl_dept td2
				   ON te2.deptid = td2.id;

#### 显示数据表结构
DESC tbl_emp;
DESC tbl_dept;

USE lft;


#### 索引分析
### 单表
# 建表SQL
CREATE TABLE IF NOT EXISTS article (
	id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '表id',
	author_id   INT(10) UNSIGNED NOT NULL COMMENT '作者id',
	category_id INT(10) UNSIGNED NOT NULL COMMENT '分类id',
	views       INT(10) UNSIGNED NOT NULL COMMENT '浏览次数',
	comments    INT(10) UNSIGNED NOT NULL COMMENT '留言',
	title       VARBINARY(255)   NOT NULL COMMENT '标题',
	content     TEXT             NOT NULL COMMENT '内容'
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 插入数据
INSERT INTO article(author_id, category_id, views, comments, title, content)
	VALUES (1, 1, 1, 1, '1', '1'),
		   (2, 2, 2, 2, '2', '2'),
		   (1, 1, 3, 3, '3', '3');

# 预览表
SELECT *
	FROM article;

# 查询 category_id 为 1 且 comments 大于 1 的情况下，views 最多的 article_id
EXPLAIN
	SELECT id, author_id
		FROM article a
		WHERE category_id = 1 AND comments > 1
		ORDER BY views DESC
		LIMIT 1;

# 显示表的索引
SHOW INDEX FROM article;

# 创建索引方式1
ALTER TABLE article
	ADD INDEX idx_article_ccv(category_id, comments, views);

# 创建索引方式2
CREATE INDEX idx_article_ccv ON article(category_id, comments, views);

# 因为 comments > 1 是范围查询，如果是 comments = 1 号那就变成常量查询
EXPLAIN
	SELECT id, author_id
		FROM article a
		WHERE category_id = 1 AND comments = 1
		ORDER BY views DESC
		LIMIT 1;

# 删除索引
DROP INDEX idx_article_ccv ON article;

# 第 2 次创建索引
# ALTER TABLE `article` ADD INDEX idx_article_cv(`category_id`,`views`);
CREATE INDEX idx_article_cv ON article(category_id, views);



### 双表
## 建表SQL
# 创建类别表
CREATE TABLE IF NOT EXISTS class (
	id        INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '类别id',
	card      INT(10) UNSIGNED NOT NULL COMMENT '分类卡号',
	classname VARCHAR(20)      NOT NULL COMMENT '类别名称',
	PRIMARY KEY (id)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 创建书籍表
CREATE TABLE IF NOT EXISTS book (
	bookid   INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '图书id',
	bookname VARCHAR(50)      NOT NULL COMMENT '书名',
	author   VARCHAR(20)      NOT NULL COMMENT '作者',
	card     INT(10) UNSIGNED NOT NULL COMMENT '图书分类卡号',
	PRIMARY KEY (bookid)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 插入类别数据
INSERT INTO class(card, classname)
	VALUES (1, '小说');
INSERT INTO class(card, classname)
	VALUES (2, '文学');
INSERT INTO class(card, classname)
	VALUES (3, '科学');
INSERT INTO class(card, classname)
	VALUES (4, '计算机');
INSERT INTO class(card, classname)
	VALUES (5, '医学');
INSERT INTO class(card, classname)
	VALUES (6, '化学');
INSERT INTO class(card, classname)
	VALUES (7, '天文');
INSERT INTO class(card, classname)
	VALUES (8, '地理');
INSERT INTO class(card, classname)
	VALUES (9, '其他');

# 插入书籍数据
INSERT INTO book(card, bookname, author)
	VALUES (1, '金瓶梅', '兰陵笑笑生');
INSERT INTO book(card, bookname, author)
	VALUES (1, '三国演义', '罗贯中');
INSERT INTO book(card, bookname, author)
	VALUES (1, '红楼梦', '曹雪芹');
INSERT INTO book(card, bookname, author)
	VALUES (1, '西游记', '吴承恩');
INSERT INTO book(card, bookname, author)
	VALUES (2, '鲁迅', '鲁迅全集');
INSERT INTO book(card, bookname, author)
	VALUES (3, '雷军', '小米崛起');
INSERT INTO book(card, bookname, author)
	VALUES (4, 'Java', 'Java编程思想');
INSERT INTO book(card, bookname, author)
	VALUES (4, 'Java2', 'Effective Java');
INSERT INTO book(card, bookname, author)
	VALUES (5, '李时珍', '本草纲目');
INSERT INTO book(card, bookname, author)
	VALUES (6, '小学', '小学化学');

# 1.1. 查询书籍分类中的所有的书——左连接（LEFT JOIN）
SELECT *
	FROM class     c
	LEFT JOIN book b
			  ON c.card = b.card;

# 1.2. EXPLANIN 分析
EXPLAIN
	SELECT *
		FROM class     c
		LEFT JOIN book b
				  ON c.card = b.card;

# 1.3. 尝试在右表添加索引优化
ALTER TABLE book
	ADD INDEX idx_book_card(card);

# 1.4. 再次 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class     c
		LEFT JOIN book b
				  ON c.card = b.card;

# 1.5. 删除右表添加的索引
DROP INDEX idx_book_card ON book;

SHOW INDEX FROM book;
SHOW INDEX FROM class;

# 1.6. 尝试在右表添加索引优化
ALTER TABLE class
	ADD INDEX idx_class_card(card);

# 1.7. 再次 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class     c
		LEFT JOIN book b
				  ON c.card = b.card;

# 1.8. 删除左表添加的索引
DROP INDEX idx_class_card ON class;
DROP INDEX idx_book_card ON book;

# 2.1 查询所有书对应的书籍类别——右连接（RIGHT JOIN）
SELECT *
	FROM class      c
	RIGHT JOIN book b
			   ON b.card = c.card;

# 2.2 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class      c
		RIGHT JOIN book b
				   ON b.card = c.card;

# 2.3 创建右表索引
ALTER TABLE class
	ADD INDEX idx_class_card(card);

# 2.4 再次 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class      c
		RIGHT JOIN book b
				   ON b.card = c.card;

# 2.5 删除右表索引
DROP INDEX idx_class_card ON class;

# 2.6 创建左表索引
ALTER TABLE book
	ADD INDEX idx_book_card(card);

DROP INDEX idx_class_card ON class;
DROP INDEX idx_book_card ON book;

# 2.7 再次 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class      c
		RIGHT JOIN book b
				   ON b.card = c.card;

# 2.7 再次 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class      c
		RIGHT JOIN book b
				   ON b.card = c.card;



## 三表
# 建表SQL
CREATE TABLE IF NOT EXISTS phone (
	phoneid  INT(10) UNSIGNED    NOT NULL AUTO_INCREMENT,
	card     INT(10) UNSIGNED    NOT NULL,
	author   VARCHAR(20)         NOT NULL,
	phonenum BIGINT(20) UNSIGNED NOT NULL,
	PRIMARY KEY (phoneid)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	CHARSET = utf8;

INSERT INTO phone(card, author, phonenum)
	VALUES (1, '吴承恩', 18888888888);
INSERT INTO phone(card, author, phonenum)
	VALUES (1, '兰陵笑笑生', 16666666666);
INSERT INTO phone(card, author, phonenum)
	VALUES (1, '曹雪芹', 18999999999);
INSERT INTO phone(card, author, phonenum)
	VALUES (4, 'Java', 18999999999);

# 1.0 显示索引
SHOW INDEX FROM class;
SHOW INDEX FROM book;
SHOW INDEX FROM phone;

# 1.1 查询所有书籍作者和作者电话对应的类
SELECT *
	FROM class      c
	LEFT JOIN book  b
			  ON b.card = c.card
	LEFT JOIN phone p
			  ON p.author = b.author;

# 1.2 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class      c
		LEFT JOIN book  b
				  ON b.card = c.card
		LEFT JOIN phone p
				  ON p.author = b.author;

# 1.3.1 添加 phone 表索引
ALTER TABLE phone
	ADD INDEX idx_phone_author(author);

# 1.3.2 添加 book 表索引
ALTER TABLE book
	ADD INDEX idx_book_card(card);

# 1.4 EXPLAIN 分析
EXPLAIN
	SELECT *
		FROM class      c
		LEFT JOIN book  b
				  ON b.card = c.card
		LEFT JOIN phone p
				  ON p.author = b.author;


#### 索引优化
### 建表 SQL
CREATE TABLE staffs (
	id       INT PRIMARY KEY AUTO_INCREMENT,
	name     VARCHAR(24) NOT NULL DEFAULT '' COMMENT '姓名',
	age      INT         NOT NULL DEFAULT 0 COMMENT '年龄',
	pos      VARCHAR(20) NOT NULL DEFAULT '' COMMENT '职位',
	add_time TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入职时间'

)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	CHARSET = utf8 COMMENT '员工记录表';

### 插入数据
INSERT INTO staffs(name, age, pos, add_time)
	VALUES ('z3', 22, 'Manager', NOW());
INSERT INTO staffs(name, age, pos, add_time)
	VALUES ('l4', 25, 'Dev', NOW());
INSERT INTO staffs(name, age, pos, add_time)
	VALUES ('w5', 23, 'Dev', NOW());

### 添加索引
ALTER TABLE staffs
	ADD INDEX idx_staffs_name_age_pos(name, age, pos);

SHOW INDEX FROM staffs;

## 1.全值匹配
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3';

EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'l4' AND age = 25;

EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'w5' AND age = 23 AND pos = 'Dev';

# 查询语句1
SELECT *
	FROM staffs
	WHERE name = 'l4';

# EXPLAIN 分析查询语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'l4';

# 查询语句2
SELECT *
	FROM staffs
	WHERE LEFT(name,2) = 'l4';

# EXPLAIN 分析查询语句2
EXPLAIN
	SELECT *
		FROM staffs
		WHERE LEFT(name,2) = 'l4';


## 存储引擎不能使用索引中范围条件右边的列；
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3';

# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3' AND age = 22;

# EXPLAIN 分析语句3
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3' AND age = 22 AND pos = 'Manager';

# EXPLAIN 分析语句4
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3' AND age > 20 AND pos = 'Manager';


## 尽量使用覆盖索引（只访问索引的查询(索引列和查询列一致)），减少 SELECT *；
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3' AND age = 22 AND pos = 'Manager';

# EXPLAIN 分析语句2
EXPLAIN
	SELECT name, age, pos
		FROM staffs
		WHERE name = 'z3' AND age = 22 AND pos = 'Manager';

# EXPLAIN 分析语句3
EXPLAIN
	SELECT name, age, pos
		FROM staffs
		WHERE name = 'z3' AND age > 20 AND pos = 'Manager';

# EXPLAIN 分析语句4
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3' AND age > 20 AND pos = 'Manager';

# EXPLAIN 分析语句5
EXPLAIN
	SELECT name, age, pos
		FROM staffs
		WHERE name = 'z3' AND age = 22;

# EXPLAIN 分析语句6
EXPLAIN
	SELECT name, pos
		FROM staffs
		WHERE name = 'z3' AND age = 22;

# EXPLAIN 分析语句7
EXPLAIN
	SELECT age, pos
		FROM staffs
		WHERE name = 'z3' AND age = 22;

# EXPLAIN 分析语句8
EXPLAIN
	SELECT name, age
		FROM staffs
		WHERE name = 'z3' AND age = 22;


## MySQL 在使用不等于（!= 或者 <>）的时候无法使用索引会导致全表扫描；
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3';

# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name <> 'z3';

##  IS NULL，IS NOT NULL 也无法使用索引；
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3';

# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name IS NULL;

# EXPLAIN 分析语句3
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name IS NOT NULL;

## LIKE 以通配符开头（‘%abc…’）MySQL 索引失效会变成全表扫描的操作；
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3';

# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name LIKE '%z3%';

# EXPLAIN 分析语句3
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name LIKE '%z3';

# EXPLAIN 分析语句4
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name LIKE 'z3%';


## 问题：解决 LIKE ‘%字符串%’时索引不被使用的方法？
# 建表 SQL
CREATE TABLE tbl_user (
	id    INT(11) PRIMARY KEY AUTO_INCREMENT,
	name  VARCHAR(20) DEFAULT NULL,
	age   INT(11)     DEFAULT NULL,
	email VARCHAR(20) DEFAULT NULL
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 删除表
# DROP TABLE tbl_user;

INSERT INTO tbl_user(name, age, email)
	VALUES ('1aa1', 21, '1aa1@163.com');
INSERT INTO tbl_user(name, age, email)
	VALUES ('2aa2', 22, '2aa2@163.com');
INSERT INTO tbl_user(name, age, email)
	VALUES ('3aa3', 26, '3aa3@163.com');
INSERT INTO tbl_user(name, age, email)
	VALUES ('4aa4', 25, '4aa4@163.com');
INSERT INTO tbl_user(name, age, email)
	VALUES ('aa', 24, 'aa@163.com');

## 创建索引之前
# EXPLAIN 分析语句1
EXPLAIN
	SELECT name, age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句2
EXPLAIN
	SELECT id
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句3
EXPLAIN
	SELECT name
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句4
EXPLAIN
	SELECT age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句5
EXPLAIN
	SELECT id, name
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句6
EXPLAIN
	SELECT id, name, age
		FROM tbl_user
		WHERE name LIKE '%aa%';

# EXPLAIN 分析语句7
EXPLAIN
	SELECT name, age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句8
EXPLAIN
	SELECT *
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句9
EXPLAIN
	SELECT id, name, age, email
		FROM tbl_user
		WHERE name LIKE '%aa%';

## 创建索引
# 创建 name,age 复合索引
CREATE INDEX idx_user_name_age ON tbl_user(name, age);


## 创建索引之后
# EXPLAIN 分析语句1
EXPLAIN
	SELECT name, age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句2
EXPLAIN
	SELECT id
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句3
EXPLAIN
	SELECT name
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句4
EXPLAIN
	SELECT age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句5
EXPLAIN
	SELECT id, name
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句6
EXPLAIN
	SELECT id, name, age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句7
EXPLAIN
	SELECT name, age
		FROM tbl_user
		WHERE name LIKE '%aa%';
# EXPLAIN 分析语句8
EXPLAIN
	SELECT *
		FROM tbl_user
		WHERE name LIKE '%aa%';

# EXPLAIN 分析语句9
EXPLAIN
	SELECT id, name, age, email
		FROM tbl_user
		WHERE name LIKE '%aa%';


## 字符串不加单引号索引失效；
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3';

# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = z3;

# EXPLAIN 分析语句3
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = z3;

# EXPLAIN 分析语句4
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = z3;
# EXPLAIN 分析语句5
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = aa;
# EXPLAIN 分析语句6
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 10;


## 少用 OR，用它来连接时会索引失效。
# 查询语句
SELECT *
	FROM staffs
	WHERE name = 'z3' OR name = 'l4';
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM staffs
		WHERE name = 'z3' OR name = 'l4';



## 面试题讲解
# 建表SQL
CREATE TABLE test03 (
	id INT PRIMARY KEY AUTO_INCREMENT,
	c1 CHAR(10),
	c2 CHAR(10),
	c3 CHAR(10),
	c4 CHAR(10),
	c5 CHAR(10)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 插入数据
INSERT INTO test03(c1, c2, c3, c4, c5)
	VALUES ('a1', 'a2', 'a3', 'a4', 'a5');
INSERT INTO test03(c1, c2, c3, c4, c5)
	VALUES ('b1', 'b2', 'b3', 'b4', 'b5');
INSERT INTO test03(c1, c2, c3, c4, c5)
	VALUES ('c1', 'c2', 'c3', 'c4', 'c5');
INSERT INTO test03(c1, c2, c3, c4, c5)
	VALUES ('d1', 'd2', 'd3', 'd4', 'd5');
INSERT INTO test03(c1, c2, c3, c4, c5)
	VALUES ('e1', 'e2', 'e3', 'e4', 'e5');

SELECT *
	FROM test03;

# 创建索引
CREATE INDEX idx_test03_c1234 ON test03(c1, c2, c3, c4);

# 查看索引
SHOW INDEX FROM test03;

# EXPLAIN 语句 1
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1';

# EXPLAIN 语句 2
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2';

# EXPLAIN 语句 3
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c3 = 'a3';

# EXPLAIN 语句 4
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c3 = 'a3' AND c4 = 'a4';

# EXPLAIN 语句 5
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c4 = 'a4' AND c3 = 'a3';

# EXPLAIN 语句 6
EXPLAIN
	SELECT *
		FROM test03
		WHERE c4 = 'a4' AND c3 = 'a3' AND c2 = 'a2' AND c1 = 'a1';

# EXPLAIN 语句 7
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c3 > 'a3' AND c4 = 'a4';

# EXPLAIN 语句 8
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c4 > 'a4' AND c3 = 'a3';

# EXPLAIN 语句 9
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c4 = 'a4'
		ORDER BY c3;

# EXPLAIN 语句 10
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2'
		ORDER BY c3;

# EXPLAIN 语句 11
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2'
		ORDER BY c4;

# EXPLAIN 语句 12
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c5 = 'a5'
		ORDER BY c2, c3;

# EXPLAIN 语句 13
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c5 = 'a5'
		ORDER BY c3, c2;

# EXPLAIN 语句 14
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2'
		ORDER BY c2, c3;

# EXPLAIN 语句 15
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c5 = 'a5'
		ORDER BY c2, c3;

# EXPLAIN 语句 16
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c2 = 'a2' AND c5 = 'a5'
		ORDER BY c3, c2;

# EXPLAIN 语句 17
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c5 = 'a5'
		ORDER BY c3, c2;

# EXPLAIN 语句 18
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c4 = 'a4'
		GROUP BY c2, c3;

# EXPLAIN 语句 19
EXPLAIN
	SELECT *
		FROM test03
		WHERE c1 = 'a1' AND c4 = 'a4'
		GROUP BY c3, c2;

### 查询优化
# **永远小表驱动大表** —— 类似嵌套循环Nested Loop

# IN 语法使用
SELECT *
	FROM tbl_emp
	WHERE tbl_emp.deptid IN (
							SELECT id
								FROM tbl_dept);

# EXISTS 语法使用
SELECT *
	FROM tbl_emp a
	WHERE EXISTS(SELECT 1
					 FROM tbl_dept b
					 WHERE a.deptid = b.id);

SELECT *
	FROM tbl_emp;
SELECT *
	FROM tbl_dept;


## ORDER BY 关键字优化
# 建表 SQL
CREATE TABLE tbla (
	# id    INT PRIMARY KEY AUTO_INCREMENT,
	age   INT,
	birth TIMESTAMP NOT NULL
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 插入数据
INSERT INTO tbla(age, birth)
	VALUES (22, NOW());
INSERT INTO tbla(age, birth)
	VALUES (22, NOW());
INSERT INTO tbla(age, birth)
	VALUES (24, NOW());


SELECT *
	FROM tbla;

# 创建索引
CREATE INDEX idx_tbla_age_birth ON tbla(age, birth);

# 查看索引
SHOW INDEX FROM tbla;

## 案例1
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM tbla
		WHERE age > 20
		ORDER BY age;

# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM tbla
		WHERE age > 20
		ORDER BY age, birth;

# EXPLAIN 分析语句3
EXPLAIN
	SELECT *
		FROM tbla
		WHERE age > 20
		ORDER BY birth;

# EXPLAIN 分析语句4
EXPLAIN
	SELECT *
		FROM tbla
		WHERE age > 20
		ORDER BY birth, age;

## 案例2
# EXPLAIN 分析语句1
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY birth;
# EXPLAIN 分析语句2
EXPLAIN
	SELECT *
		FROM tbla
		WHERE birth > '2020-01-28 00:00:00'
		ORDER BY birth;
# EXPLAIN 分析语句3
EXPLAIN
	SELECT *
		FROM tbla
		WHERE birth > '2020-01-28 00:00:00'
		ORDER BY age;
# EXPLAIN 分析语句4
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY age ASC, birth ASC;
# EXPLAIN 分析语句5
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY age DESC, birth DESC;
# EXPLAIN 分析语句6
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY age ASC, birth DESC;
# EXPLAIN 分析语句7
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY age DESC, birth ASC;
# EXPLAIN 分析语句8
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY age ASC;
# EXPLAIN 分析语句9
EXPLAIN
	SELECT *
		FROM tbla
		ORDER BY age DESC;

## 慢查询日志分析
# 查询是否开启慢查询日志。
SHOW VARIABLES LIKE '%slow_query_log%';
# 开启慢查询日志。
SET GLOBAL SLOW_QUERY_LOG = 1;
SHOW VARIABLES LIKE '%long_query_time%';

# 关闭慢查询日志。
SET GLOBAL SLOW_QUERY_LOG = 0;

SELECT SLEEP(4), id, name, age, pos, add_time
	FROM staffs s;

SHOW GLOBAL STATUS LIKE '%slow_queries%';


### 往数据库表里插入 1000万数据
## 建表 SQL
# 新建数据库
CREATE DATABASE big_data;
# 使用库
USE big_data;

# 新建表1
CREATE TABLE dept (
	id        INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	dept_no   MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
	dept_name VARCHAR(20)        NOT NULL DEFAULT '',
	location  VARCHAR(13)        NOT NULL DEFAULT ''
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 新建表2
CREATE TABLE emp (
	id        INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	emp_no    MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '员工编号',
	emp_name  VARCHAR(20)        NOT NULL DEFAULT '' COMMENT '员工姓名',
	job       VARCHAR(9)         NOT NULL DEFAULT '' COMMENT '工作',
	mgr       MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级编号',
	hire_date DATE               NOT NULL COMMENT '入职时间',
	sal       DECIMAL(7, 2)      NOT NULL COMMENT '薪水',
	comm      DECIMAL(7, 2)      NOT NULL COMMENT '红利',
	dept_no   MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '部门编号'
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 随机生成字符串函数
DELIMITER $$ -- 重新定义结束符
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
BEGIN
	DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE return_str VARCHAR(255) DEFAULT '';
	DECLARE i INT DEFAULT 0;
	WHILE i < n
		DO
			SET return_str = CONCAT(return_str,SUBSTRING(chars_str,FLOOR(1 + RAND() * 52),1));
			SET i = i + 1;
			END WHILE;
	RETURN return_str;
END $$

# 删除函数
DELIMITER ;
DROP FUNCTION rand_string;

# 随机产生部门编号
DELIMITER $$
CREATE FUNCTION rand_num() RETURNS INT(5)
BEGIN
	DECLARE i INT DEFAULT 0;
	SET i = FLOOR(100 + RAND() * 10);
	RETURN i;
END $$

# 删除函数
DELIMITER ;
DROP FUNCTION rand_num;

# 创建往 emp 表中插入数据的存储过程
DELIMITER $$
CREATE PROCEDURE insert_emp(IN start INT(10), IN max_num INT(10))
BEGIN
	DECLARE i INT DEFAULT 0;
	# 先关闭自动提交。
	SET AUTOCOMMIT = 0;
	REPEAT
		SET i = i + 1;
		INSERT INTO emp(emp_no, emp_name, job, mgr, hire_date, sal, comm, dept_no)
			VALUES ((start + i), rand_string(6), 'SALESMAN', 0001, CURDATE(), 2000, 400, rand_num());
		UNTIL i = max_num
			END REPEAT;
	# 提交。
	COMMIT;
END $$

# 删除存储过程
DELIMITER ;
DROP PROCEDURE insert_emp;

# 创建往 dept 表中插入数据的存储过程
DELIMITER $$
CREATE PROCEDURE insert_dept(IN start INT(10), IN max_num INT(10))
BEGIN
	DECLARE i INT DEFAULT 0;
	SET AUTOCOMMIT = 0;
	REPEAT
		SET i = i + 1;
		INSERT INTO dept(dept_no, dept_name, location)
			VALUES ((start + i), rand_string(10), rand_string(8));
		UNTIL i = max_num
			END REPEAT;
	COMMIT;
END $$

# 删除存储过程
DELIMITER ;
DROP PROCEDURE insert_dept;

# 调用存储过程往 dept 表插入数据
DELIMITER ;
CALL insert_dept(100,10);

# 调用存储过程往 emp 表插入 50 万数据
DELIMITER ;
CALL insert_emp(100001,500000);


## SHOW PROFILE
# 查看是否支持
SHOW VARIABLES LIKE 'profiling';
SHOW VARIABLES LIKE 'profiling%';

# 开启
SET PROFILING = ON;

# 运行 SQL
# 查询语句1
SELECT *
	FROM emp
	GROUP BY id % 10
	LIMIT 150000;
# 查询语句2
SELECT *
	FROM emp
	GROUP BY id % 20
	ORDER BY 5;

SELECT *
	FROM emp;

SHOW VARIABLES LIKE 'profiling';

SET profiling = ON;

# SHOW PROFILE
SHOW PROFILES;

# 显示某一行查询的 CPU IO块详细信息。
SHOW PROFILE CPU, BLOCK IO FOR QUERY 22;

# 新增一条查询
SELECT *
	FROM emp
	WHERE id = 4;

# 显示该条查询的详情
SHOW PROFILE CPU, BLOCK IO FOR QUERY 24;


#### 锁
### 表锁
## 建表 SQL
# 建库
CREATE DATABASE IF NOT EXISTS mylockdb;

USE mylockdb;
# 建表
CREATE TABLE mylock (
	id   INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20)
)
	ENGINE myisam
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 插入数据
INSERT INTO mylock (name)
	VALUES ('a');
INSERT INTO mylock (name)
	VALUES ('b');
INSERT INTO mylock (name)
	VALUES ('c');
INSERT INTO mylock (name)
	VALUES ('d');
INSERT INTO mylock (name)
	VALUES ('e');


SELECT *
	FROM mylock;

# 查看表上加过的锁
SHOW OPEN TABLES;

# 加锁命令
LOCK TABLES mylock READ;
LOCK TABLES mylock WRITE;

# 解锁命令
UNLOCK TABLES;


### 行锁
## 建表 SQL
# 建表
CREATE TABLE test_innodb_lock (
	a INT(11),
	b VARCHAR(16)
)
	ENGINE = innodb;

# 插入数据
INSERT INTO test_innodb_lock VALUES(1,'b2');
INSERT INTO test_innodb_lock VALUES(3,'3');
INSERT INTO test_innodb_lock VALUES(4,'4000');
INSERT INTO test_innodb_lock VALUES(5,'5000');
INSERT INTO test_innodb_lock VALUES(6,'6000');
INSERT INTO test_innodb_lock VALUES(7,'7000');
INSERT INTO test_innodb_lock VALUES(8,'8000');
INSERT INTO test_innodb_lock VALUES(9,'9000');
INSERT INTO test_innodb_lock VALUES(1,'b1');

# 创建索引
CREATE INDEX idx_test_innodb_a_ind ON test_innodb_lock(a);
CREATE INDEX idx_test_innodb_b_ind ON test_innodb_lock(b);



# 关闭自动提交。
SET AUTOCOMMIT=0;

SHOW STATUS LIKE 'innodb_row_lock%';


