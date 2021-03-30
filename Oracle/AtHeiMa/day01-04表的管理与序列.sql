------修改表结构
----创建表
/*
语法：
	Create table 表名(
		字段 1  数据类型  [default 默认值],
		字段 2  数据类型  [default 默认值],
		...
		字段 n  数据类型  [default 默认值]
	);
*/


CREATE TABLE person (
	pid NUMBER (20),
	pname VARCHAR2 (10)
);

----删除表
/*
语法：
       DROP TABLE 表名;
*/
DROP TABLE person;

----修改表
/*
添加列语法：ALTER TABLE 表名称 ADD(列名 1 类型 [DEFAULT 默认值]，列名 1 类型[DEFAULT 默认值]...)

修改列类型语法：ALTER TABLE 表名称 MODIFY(列名 1 类型 [DEFAULT 默认值]，列名 1 类型[DEFAULT 默认值]...)

修改列名: ALTER TABLE 表名称 RENAME 列名 1 TO 列名 2

删除列：ALTER TABLE 表名称 DROP COLUMN 列名;
*/


--添加一列
ALTER TABLE person
	ADD gender NUMBER (1);

--修改列类型
ALTER TABLE person
	MODIFY gender CHAR(1);

--修改列名
ALTER TABLE person RENAME COLUMN gender TO sex;

--删除一列
ALTER TABLE person
	DROP COLUMN sex;


----表数据的操作
/*
--INSERT增加
标准写法：
INSERT INTO 表名[(列名 1，列名 2，...)]VALUES(值 1，值 2，...)

简单写法（不建议）：
INSERT INTO 表名 VALUES(值 1，值 2，...)
*/

--查询表中记录
SELECT *
	FROM person;

--添加一条记录
INSERT INTO person(pid, pname)
	VALUES (1, 'lft');
COMMIT;

/*
--UPDATE修改
全部修改：UPDATE 表名 SET 列名 1=值 1，列名 2=值 2，....

局部修改：UPDATE 表名 SET 列名 1=值 1，列名 2=值 2，....WHERE 修改条件；
*/

--修改一条记录
UPDATE person
SET
	pname = '小李'
	WHERE pid = 1;
COMMIT;


----三个删除
/*
语法: 
   --删除表中全部/部分记录
   DELETE FROM 表名  WHERE 删除条件;
   
   
   
*/
--删除表中全部记录
DELETE
	FROM person;
--删除表结构
DROP TABLE person;
--先删除表，再次创建表。效果等同于删除表中全部记录。
--在数据量大的情况下，尤其在表中带有索引的情况下，该操作效率高。
--索引可以提高查询效率，但是会影响增删改效率。
TRUNCATE TABLE person;



----序列：默认从1开始，依次递增，主要用来给主键赋值使用。
/*
语法：CREATE SEQUENCE 序列名
      [INCREMENT BY n]
      [START WITH n]
      [{MAXVALUE/ MINVALUE n|NOMAXVALUE}]
      [{CYCLE|NOCYCLE}]
      [{CACHE n|NOCACHE}];

*/

--序列不真的属于任何一张表，但是可以逻辑和表做绑定。
--DUAL:虚表，只是为了补全语法，没有任何意义。
CREATE
SEQUENCE s_person;
SELECT s_person.nextval
	FROM dual;

--添加一条记录
INSERT INTO person (pid, pname)
	VALUES (s_person.nextval, '小张');
COMMIT;

--查询表中记录
SELECT *
	FROM person;



















