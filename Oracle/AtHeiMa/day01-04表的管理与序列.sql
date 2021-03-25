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


create table person(
       pid number(20),
       pname varchar2(10)
);

----删除表
/*
语法：
       DROP TABLE 表名;
*/
drop table person;

----修改表
/*
添加列语法：ALTER TABLE 表名称 ADD(列名 1 类型 [DEFAULT 默认值]，列名 1 类型[DEFAULT 默认值]...)

修改列类型语法：ALTER TABLE 表名称 MODIFY(列名 1 类型 [DEFAULT 默认值]，列名 1 类型[DEFAULT 默认值]...)

修改列名: ALTER TABLE 表名称 RENAME 列名 1 TO 列名 2

删除列：ALTER TABLE 表名称 DROP COLUMN 列名;
*/


--添加一列
alter table person add gender number(1);

--修改列类型
alter table person modify gender char(1);

--修改列名
alter table person rename column gender to sex;

--删除一列
alter table person drop column sex;


----表数据的操作
/*
--INSERT增加
标准写法：
INSERT INTO 表名[(列名 1，列名 2，...)]VALUES(值 1，值 2，...)

简单写法（不建议）：
INSERT INTO 表名 VALUES(值 1，值 2，...)
*/

--查询表中记录
select * from person;

--添加一条记录
insert into person(pid,pname) values(1,'lft');
commit;


/*
--UPDATE修改
全部修改：UPDATE 表名 SET 列名 1=值 1，列名 2=值 2，....

局部修改：UPDATE 表名 SET 列名 1=值 1，列名 2=值 2，....WHERE 修改条件；
*/

--修改一条记录
update person set pname = '小李' where pid = 1;
commit;


----三个删除
/*
语法: 
   --删除表中全部/部分记录
   DELETE FROM 表名  WHERE 删除条件;
   
   
   
*/
--删除表中全部记录
delete from person;
--删除表结构
drop table person;
--先删除表，再次创建表。效果等同于删除表中全部记录。
--在数据量大的情况下，尤其在表中带有索引的情况下，该操作效率高。
--索引可以提高查询效率，但是会影响增删改效率。
truncate table person;



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
--dual:虚表，只是为了补全语法，没有任何意义。
create sequence s_person;
select s_person.nextval from dual;

--添加一条记录
insert into person (pid, pname) values(s_person.nextval,'小张');
commit;

--查询表中记录
select * from person;



















