/*
1.  创建表 dept1
		name	Null?		type
		id					int(7)
		name				varchar(25)
*/
CREATE TABLE IF NOT EXISTS dept1 (
	id INT(7),
	NAME VARCHAR(25)	
);

/*
2.  将表 departments 中的数据插入新表 dept2 中
*/
CREATE TABLE IF NOT EXISTS dept2
#从其他库中选择表可以使用：库名.表名
SELECT * FROM myemployees.departments;
/*
3.  创建表 emp5
		name	Null?		type
		id					int(7)
		First_name			Varchar (25)
		Last_name			Varchar(25)
		Dept_id				int(7)
*/
CREATE TABLE IF NOT EXISTS emp5 (
	id INT(7),
	First_name VARCHAR (25),
	Last_name VARCHAR(25),
	Dept_id INT(7)
);
/*
4.  将列 Last_name 的长度增加到 50
*/
DESC emp5;
ALTER TABLE emp5 MODIFY COLUMN Last_name VARCHAR(50);
/*
5.  根据表 employees 创建 employees2
*/
CREATE TABLE IF NOT EXISTS employees2 LIKE employees;

/*
6.  删除表 emp5
*/
DROP TABLE IF EXISTS emp5;
/*
7.  将表 employees2 重命名为 emp5
*/
ALTER TABLE employees2 RENAME TO emp5;
/*
8 在表 dept 和 emp5 中添加新列 test_column，并检查所作的操作
*/
ALTER TABLE dept1 ADD COLUMN test_column DOUBLE;
ALTER TABLE emp5 ADD COLUMN test_column DOUBLE;
SELECT * FROM dept1;
SELECT * FROM emp5;
/*
9.直接删除表 emp5 中的列 dept_id
*/
ALTER TABLE emp5 DROP COLUMN department_id;