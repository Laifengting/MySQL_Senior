# 创建数据库
CREATE DATABASE IF NOT EXISTS lft;

# 使用数据库
USE lft;

# 创建表 tbl_dept
CREATE TABLE `tbl_dept`
(
	`id`       INT(11) NOT NULL AUTO_INCREMENT,
	`deptName` VARCHAR(30) DEFAULT NULL,
	`locAdd`   VARCHAR(40) DEFAULT NULL,
	PRIMARY KEY (`id`))
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# 创建表 tbl_emp
CREATE TABLE `tbl_emp`
(
	`id`     INT(11) NOT NULL AUTO_INCREMENT,
	`name`   VARCHAR(20) DEFAULT NULL,
	`deptId` INT(11)     DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `fk_dept_id` (`deptId`)
	#CONSTRAINT `fk_dept_id` FOREIGN KEY (`deptId`) REFERENCES `tbl_dept` (`id`)
)
	ENGINE = innodb
	AUTO_INCREMENT = 1
	DEFAULT CHARSET = utf8;

# tbl_dept表中插入数据
INSERT INTO tbl_dept(deptname, locadd)
	VALUES
		('RD', 11);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES
		('HR', 12);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES
		('MK', 13);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES
		('MIS', 14);
INSERT INTO tbl_dept(deptname, locadd)
	VALUES
		('FD', 15);

# tbl_emp表中插入数据
INSERT INTO tbl_emp(name, deptid)
	VALUES
		('Z1', 1);
INSERT INTO tbl_emp(name, deptid)
	VALUES
		('Z2', 1);
INSERT INTO tbl_emp(name, deptid)
	VALUES
		('Z3', 1);

INSERT INTO tbl_emp(name, deptid)
	VALUES
		('W5', 2);
INSERT INTO tbl_emp(name, deptid)
	VALUES
		('W6', 2);

INSERT INTO tbl_emp(name, deptid)
	VALUES
		('S8', 3);
INSERT INTO tbl_emp(name, deptid)
	VALUES
		('S9', 4);
INSERT INTO tbl_emp(name, deptid)
	VALUES
		('S10', 51);

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