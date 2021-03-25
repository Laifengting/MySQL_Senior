/*############################################进阶13：常见约束############################################*/
/*
		常见约束
		含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确和可靠性。
		
		分类：六大约束
			NOT NULL：非空约束，用于保证该字段的值不能为空，必须填写
				比如：姓名，学号等
			DEFAULT：默认约束，用于保证该字段有默认值。
				比如：性别等
			PRIMARY KEY：主键约束，用于保证该字段的值具有唯一性，并且非空
				比如：学号、员工编号等
			UNIQUE：唯一约束，用于保证该字段的值具有唯一性，可以为空。
				比如：座位号等
			CHECK：检查约束(mysql中不支持)
		        比如：年龄、性别
		    FOREIGN KEY：外键约束，用于限制两个表的关系，用于保证该字段的值必须来自于主表的关联列的值
		        在从表添加外键约束，用于引用主表中某列的值
		        比如：学生表的专业编号，员工表的部门编号，员工表的工种编号。


		主键 和 唯一 的对比：
					保证唯一性       是否允许为空      一个表中可以有多少个          是否允许组合
			主键      ✔               ✖               至多有一个，可以没有          ✔ 但不推荐
			唯一      ✔               ✔               可以有多个                   ✔ 但不推荐

			例：
			INSERT INTO major VALUES(1,'Java');
			INSERT INTO major VALUES(2,'H5');

			# 唯一约束中5.5.62-8.0.19版本null可以不唯一。其他值必须唯一。视频中5.5.15版本null也必须唯一。
			INSERT INTO stuInfo VALUES(1,'John','男',19,null,1);
			INSERT INTO stuInfo VALUES(2,'Lily','女',20,null,2);

		外键：
			① 要求在从表设置外键关系
			② 从表的外键列的类型和主表的关联列的类型要求一致或兼容，名称无要求
			③ 主表的关联列必须是一个KEY(主键✔、唯一、外键)
			④ 插入数据时，先插入主表，再插入从表；删除数据时，先删除从表，再删除主表。


		添加约束的时机：
		    1. 创建表时
		    2. 修改表时

		约束的添加分类：
		    列级约束：
		        六大约束语法上都支持，但外键约束没有效果。
		    表级约束：
                除了非空、默认，其他的都支持。
		create table 表名(
            字段名 字段类型 列级约束,
            字段名 字段类型,
            表级约束
        );
*/
/*
        1. 创建表时添加约束
           1.1 添加列级约束
            直接在字段名和类型后面追回约束类型即可。只支持：DEFAULT、NOT NULL、PRIMARY KEY、UNIQUE。不支持：CHECK 和  FOREIGN KEY
            注：同一字段可以添加多个约束类型用空格分开。
            语法：
                字段名 字段类型 约束类型 约束类型...,
                字段名 字段类型 约束类型 约束类型...
*/
CREATE DATABASE IF NOT EXISTS students;

USE students;
CREATE TABLE stuInfo (
	#主键约束
	id      INT PRIMARY KEY,
# 	#主键约束 不能为多个
# 	id1      INT PRIMARY KEY,
	#非空约束
	stuName VARCHAR(20) NOT NULL,
	#检查约束
	gender  CHAR(1) CHECK ( gender IN ('男', '女')),
	#唯一约束
	seat    INT UNIQUE,
# 	#唯一约束 可以有多个
# 	seat2    INT UNIQUE,
	#默认约束
	age     INT DEFAULT 18,
	#外键
	majorId INT /*FOREIGN KEY*/ REFERENCES major (id)
);

CREATE TABLE major (
	id        INT PRIMARY KEY,
	majorName VARCHAR(20)
);

DESC stuInfo;

#查看stuInfo表中所有的索引，包括主键，外键，唯一
SHOW INDEX FROM stuInfo;

/*
        1. 创建表时添加约束
           1.2 添加表级约束

            语法：
                字段名1 字段类型1,
                字段名2 字段类型2,
                ...
                【CONSTRAINT 约束名】 约束类型(字段名)

*/
DROP TABLE IF EXISTS stuInfo;

CREATE TABLE IF NOT EXISTS stuInfo (
	id      INT,
	stuName VARCHAR(20),
	gender  CHAR(1),
	seat    INT,
	age     INT,
	majorId INT,
	#添加主键约束 (添加键名pk时，在MySQL中主键名只能为PRIMARY，在Oracle中别名可以是自己取的名字pk)
	CONSTRAINT pk PRIMARY KEY (id),

# 	#添加组合主键约束 当id,stuname都相同时，就不能添加
# 	CONSTRAINT pk PRIMARY KEY (id,stuname),

	#添加唯一约定
	CONSTRAINT uq UNIQUE (seat),
	#添加检查约束
	CONSTRAINT ck CHECK ( gender IN ('男', '女') ),
	#添加外键约束
	CONSTRAINT fk_stuInfo_major FOREIGN KEY (majorId) REFERENCES major (id)
);

SHOW INDEX FROM stuInfo;

/*
        通用的写法：
 */

CREATE TABLE IF NOT EXISTS stuInfo (
	id      INT PRIMARY KEY,
	stuName VARCHAR(20) NOT NULL,
	sex     CHAR(1),
	age     INT DEFAULT 18,
	seat    INT UNIQUE,
	majorId INT,
	CONSTRAINT fk_stuInfo_major FOREIGN KEY (majorId) REFERENCES major (id)
);

/*
 *      删除表，创建新表，不带约束。
 */

DROP TABLE IF EXISTS stuInfo;

CREATE TABLE IF NOT EXISTS stuInfo (
	id      INT,
	stuName VARCHAR(20),
	gender  CHAR(1),
	seat    INT,
	age     INT,
	majorId INT
);

/*
        2. 修改表时添加约束
			2.1 添加列级约束
            ALTER TABLE 表名 MODIFY COLUMN 字段名 字段类型 约束类型;

            2.2 添加表级约束【非空，默认不支持】
			ALTER TABLE 表名 ADD 【CONSTRAINT 约束别名】 约束类型(字段名) 【外键的引用】;
*/

/*
         2. 修改表时添加约束
           2.1 添加非空约束
*/
ALTER TABLE stuInfo
	MODIFY COLUMN stuName VARCHAR(20) NOT NULL;

/*
        2. 修改表时添加约束
           2.2 添加默认约束
*/
ALTER TABLE stuinfo
	MODIFY COLUMN age INT DEFAULT 18;

/*
        2. 修改表时添加约束
           2.3 添加主键约束
*/
# 方式一：列级约束
ALTER TABLE stuinfo
	MODIFY COLUMN id INT PRIMARY KEY;
# 方式二：表级约束
ALTER TABLE stuinfo
	ADD PRIMARY KEY (id);
# 方式二：表级约束 带起名字
ALTER TABLE stuinfo
	ADD CONSTRAINT pk PRIMARY KEY (id);

/*
        2. 修改表时添加约束
           2.4 添加唯一约束
*/
# 方式一：列级约束
ALTER TABLE stuinfo
	MODIFY COLUMN seat INT UNIQUE;
# 方式二：表级约束
ALTER TABLE stuinfo
	ADD UNIQUE (seat);
# 方式二：表级约束 带起名字
ALTER TABLE stuinfo
	ADD CONSTRAINT uq UNIQUE (seat);

/*
        2. 修改表时添加约束
           2.5 添加外键约束
*/
# 表级约束
ALTER TABLE stuinfo
	ADD FOREIGN KEY (majorId) REFERENCES major (id);
# 表级约束 带名字 传统方式添加外键
ALTER TABLE stuinfo
	ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId) REFERENCES major (id);

# 删除外键
ALTER TABLE students.stuInfo
	DROP FOREIGN KEY fk_stuinfo_major;

SELECT *
FROM major;
INSERT INTO major
VALUES (3, '大数据');

SELECT *
FROM stuInfo;

TRUNCATE TABLE students.stuInfo;

INSERT INTO students.stuInfo
SELECT 1, 'John1', '女', NULL, NULL, 1
UNION ALL
SELECT 2, 'John2', '女', NULL, NULL, 1
UNION ALL
SELECT 3, 'John3', '女', NULL, NULL, 2
UNION ALL
SELECT 4, 'John4', '女', NULL, NULL, 1
UNION ALL
SELECT 5, 'John5', '女', NULL, NULL, 2
UNION ALL
SELECT 6, 'John6', '女', NULL, NULL, 1
UNION ALL
SELECT 7, 'John7', '女', NULL, NULL, 3
UNION ALL
SELECT 8, 'John8', '女', NULL, NULL, 1;

# 删除专业表的3号专业
# 以下方式无法删除。以下为主表，删除时，要先删除从表，再删除主表。
DELETE
FROM major
WHERE id = 3;

# 解决上面的方式一：级联删除
ALTER TABLE stuinfo
	ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId) REFERENCES major (id) ON DELETE CASCADE;

DELETE
FROM major
WHERE id = 3;

# 解决上面的方式二：级联置空
ALTER TABLE stuinfo
	ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId) REFERENCES major (id) ON DELETE SET NULL;

DELETE
FROM major
WHERE id = 2;


/*
        3. 修改表时删除约束
			3.1 删除列级约束
            ALTER TABLE 表名 MODIFY COLUMN 字段名 字段类型;

            3.2 删除表级约束
			ALTER TABLE 表名 DROP 约束类型 约束名;
*/
/*
        3. 修改表时删除约束
			3.1 删除非空约束
*/
ALTER TABLE stuinfo
	MODIFY COLUMN stuName VARCHAR(20) NULL;

ALTER TABLE stuinfo
	MODIFY COLUMN stuName VARCHAR(20);

/*
        3. 修改表时删除约束
			3.2 删除默认约束
*/

ALTER TABLE stuinfo
	MODIFY COLUMN age INT;

/*
        3. 修改表时删除约束
			3.3 删除主键约束
*/
# 方式一：删除列级约束
ALTER TABLE stuinfo
	MODIFY COLUMN id INT;

# 方式二：删除表级约束
ALTER TABLE stuinfo
	DROP PRIMARY KEY;

/*
        3. 修改表时删除约束
			3.4 删除唯一约束
*/
ALTER TABLE stuinfo
	DROP INDEX uq;

/*
        3. 修改表时删除约束
			3.5 删除外键约束
*/
ALTER TABLE stuinfo
	DROP FOREIGN KEY fk_stuinfo_major;


DESC stuinfo;
DESC major;
SHOW INDEX FROM stuinfo;











