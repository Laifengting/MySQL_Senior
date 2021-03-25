----其他数据库对象
--序列
/*
什么是序列?
序列: 可供多个用户用来产生唯一数值的数据库对象
    自动提供唯一的数值
    共享对象
    主要用于提供主键值
    将序列值装入内存可以提高访问效率

定义序列:
CREATE SEQUENCE sequence
       [INCREMENT BY n]  --每次增长的数值
       [START WITH n]    --从哪个值开始
       [{MAXVALUE n | NOMAXVALUE}]
       [{MINVALUE n | NOMINVALUE}]
       [{CYCLE | NOCYCLE}]     --是否需要循环
       [{CACHE n | NOCACHE}];  --是否缓存登录
*/
--创建序列
create sequence empseq
increment by 10 --每次增长10个
start with 10 --从10开始
maxvalue 100 --最大值100
cycle--需要循环
nocache;--不需要缓存登录

select empseq.nextval from dual;
select empseq.currval from dual;

--查询序列
/*
查询数据字典视图 USER_SEQUENCES 获取序列定义信息

SELECT	sequence_name, min_value, max_value, 
	increment_by, last_number
FROM	user_sequences;

如果指定NOCACHE 选项，则列LAST_NUMBER 显示序列中下一个有效的值
*/

SELECT	sequence_name, min_value, max_value, 
	increment_by, last_number
FROM	user_sequences;

--修改序列
/*
修改序列的增量, 最大值, 最小值, 循环选项, 或是否装入内存

ALTER SEQUENCE sequence_name
               INCREMENT BY 20
               MAXVALUE 999999
               NOCACHE
               NOCYCLE;

修改序列的注意事项：
    必须是序列的拥有者或对序列有 ALTER 权限
    只有将来的序列值会被改变
    改变序列的初始值只能通过删除序列之后重建序列的方法实现
*/
--创建表
CREATE TABLE emp3 AS
SELECT employee_id,
	   last_name,
	   salary
FROM   employees
WHERE  1 = 2;

SELECT * FROM emp3;
--插入数据
INSERT INTO emp3
VALUES
	(1,
	 'AA',
	 3000);

INSERT INTO emp3
VALUES
	(empseq.nextval,
	 'EE',
	 3300);

--删除数据
DELETE FROM emp3
WHERE  employee_id IN (21,
					   31,
					   41,
					   51,
					   61);

--修改序列
ALTER SEQUENCE empseq
INCREMENT BY 1
NOCYCLE;


--使用序列
/*
将序列值装入内存可提高访问效率

序列在下列情况下出现裂缝:
    回滚
    系统异常
    多个表同时使用同一序列
    
如果不将序列的值装入内存(NOCACHE), 可使用表 USER_SEQUENCES 查看序列当前的有效值
*/
INSERT INTO emp3
VALUES
	(empseq.nextval,
	 'GG',
	 3700);

rollback;
--删除序列
/*
使用 DROP SEQUENCE 语句删除序列
删除之后，序列不能再次被引用

DROP SEQUENCE sequence_name;
*/
--创建序列
create sequence empseq1
increment by 1 --每次增长10个
start with 1 --从10开始
maxvalue 99999 --最大值100
nocycle--需要循环
nocache;--不需要缓存登录

DROP SEQUENCE empseq1;


--索引
/*
索引:
    一种独立于表的模式对象, 可以存储在与表不同的磁盘或表空间中。
    索引被删除或损坏, 不会对表产生影响, 其影响的只是查询的速度。
    索引一旦建立, Oracle 管理系统会对其进行自动维护, 而且由 Oracle 管理系统决定何时使用索引。
    	用户不用在查询语句中指定使用哪个索引。
    在删除一个表时,所有基于该表的索引会自动被删除。
    通过指针加速 Oracle 服务器的查询速度。
    通过快速定位数据的方法，减少磁盘 I/O。
*/

--创建索引
/*
自动创建: 在定义 PRIMARY KEY 或 UNIQUE 约束后系统自动在相应的列上创建唯一性索引
手动创建: 用户可以在其它列上创建非唯一的索引，以加速查询

在一个或多个列上创建索引
CREATE INDEX index_name
ON table_name (column[, column]...);

在表 EMPLOYEES的列 LAST_NAME 上创建索引

CREATE INDEX 	emp_last_name_idx
ON 		employees(last_name);


什么时候创建索引
以下情况可以创建索引:
    列中数据值分布范围很广
    列经常在 WHERE 子句或连接条件中出现
    表经常被访问而且数据量很大 ，访问的数据大概占数据总量的2%到4%

什么时候不要创建索引
下列情况不要创建索引:
    表很小
    列不经常作为连接条件或出现在WHERE子句中
    查询的数据大于2%到4%
    表经常更新

*/

--创建索引
create index emp3_id_idx
on emp3(employee_id);


--查询索引
/*
可以使用数据字典视图 USER_INDEXES 和 USER_IND_COLUMNS 查看索引的信息
*/
SELECT	ic.index_name, ic.column_name,
	ic.column_position col_pos,ix.uniqueness
FROM	user_indexes ix, user_ind_columns ic
WHERE	ic.index_name = ix.index_name
AND	ic.table_name = 'EMP3';

--删除索引
/*
使用DROP INDEX 命令删除索引
DROP INDEX index_name;


删除索引EMP3_ID_IDX
DROP INDEX emp3_id_idx;

只有索引的拥有者或拥有DROP ANY INDEX 权限的用户才可以删除索引
删除操作是不可回滚的
*/
drop index emp3_id_idx;


--同义词-synonym
/*
使用同义词访问相同的对象:
方便访问其它用户的对象
缩短对象名字的长度

CREATE [PUBLIC] SYNONYM synonym
FOR    object;

可以为视图创建同义词
CREATE SYNONYM empv FOR EMPVIEW;
*/

--创建同义词
CREATE SYNONYM emp FOR employees;

--从同义词中查询表中信息。
SELECT * FROM emp;

--删除同义词
DROP SYNONYM emp;

--总结
/*
通过本章学习,您已经可以:
    使用序列
    使用索引提高查询效率
    为数据对象定义同义词
*/

--练习：1.创建序列dept_id_seq，开始值为200，每次增长10，最大值为10000
create sequence detp_id_seq
start with 200
increment by 10
maxvalue 10000;

--练习：2.使用序列向表dept中插入数据
insert into dept values(detp_id_seq.nextval,'HR');

SELECT * FROM dept;
--练习准备：创建一个空表
create table dept as 
select department_id id,department_name name 
from departments
where 1=2

--练习：65. 创建序列: 
/*
1). create sequence hs 
    increment by 10 
    start with 10

2). NEXTVAL 应在 CURRVAL 之前指定 ，二者应同时有效
*/


--练习：66. 序列通常用来生成主键:
/*
INSERT INTO emp2 VALUES (emp2_seq.nextval, 'xx', ...) 
*/
