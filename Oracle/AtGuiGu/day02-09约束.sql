--查询ORACLE所有关键字
SELECT *
	FROM v$reserved_words
	ORDER BY keyword ASC;

----约束
--创建表时添加约束
--NOT NULL非空约束
CREATE TABLE emp2 (

	id NUMBER (10) CONSTRAINT emp2_id_nonull NOT NULL,
	name VARCHAR2 (20) CONSTRAINT emp2_name_nonull NOT NULL,
	salary NUMBER (10,
		2)

);

--UNIQUE唯一约束(唯一键)
CREATE TABLE emp3 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp3_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10,
		2), --默认约束
				  --表级约束
				  CONSTRAINT emp3_email_uk UNIQUE(email), --可以为空，且空值不限定唯一。
				  CONSTRAINT emp3_id_uk UNIQUE(id)
				  
				  );

--DEFAULT默认约束
CREATE TABLE emp4 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp4_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000, --默认约束
				  --表级约束
				  CONSTRAINT emp4_email_uk UNIQUE(email), --可以为空，且空值不限定唯一。
				  CONSTRAINT emp4_id_uk UNIQUE(id)
				  
				  );

--主键约束--非空，唯一。
CREATE TABLE emp5 (

	id NUMBER (10) CONSTRAINT emp5_id_pk PRIMARY KEY,
	name VARCHAR2 (20) CONSTRAINT emp5_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000, --默认约束
				  
				  --表级约束
				  CONSTRAINT emp5_email_uk UNIQUE(email)
				  
				  );

--主键约束--非空，唯一。
CREATE TABLE emp6 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp6_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000, --默认约束
				  
				  --表级约束
				  CONSTRAINT emp6_email_uk UNIQUE(email), CONSTRAINT emp6_id_pk PRIMARY KEY (id)

	);

--外键约束
CREATE TABLE emp7 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp7_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000, --默认约束
				  department_id NUMBER(10), --表级约束
				  CONSTRAINT emp7_email_uk UNIQUE(email), CONSTRAINT emp7_id_pk PRIMARY KEY (id),
	CONSTRAINT emp7_dept_id_fk FOREIGN KEY (department_id) REFERENCES
		departments(department_id)

	);

INSERT INTO emp7
	VALUES (1001,
			'aa',
			'lft@qq.com',
			2000,
			200);

INSERT INTO emp7
	VALUES (1002,
			'aa',
			'lft@qq.com',
			2000,
			2010);

--外键约束 --级联删除ON
DELETE cascade --级联置空ON
DELETE
SET
	NULL
	--列级约束
CREATE TABLE emp81 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp8_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000, --默认约束
				   department_id NUMBER(10) REFERENCES departments(department_id) ON DELETE SET NULL, --表级约束
				   CONSTRAINT emp8_email_uk UNIQUE(email), CONSTRAINT emp8_id_pk PRIMARY KEY (id)

	);

--表级外键约束的创建
CREATE TABLE emp8 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp8_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000, --默认约束
				  department_id NUMBER(10), --表级约束
				  CONSTRAINT emp8_email_uk UNIQUE(email), CONSTRAINT emp8_id_pk PRIMARY KEY (id),
	CONSTRAINT emp8_dept_id_fk FOREIGN KEY (department_id) REFERENCES
		departments(department_id) ON DELETE SET NULL

	);

--CHECK约束
CREATE TABLE emp9 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp9_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10, 2) DEFAULT 1000 CHECK (salary > 1500 AND salary < 30000), --默认约束
				  department_id NUMBER(10), --表级约束
				  CONSTRAINT emp9_email_uk UNIQUE(email), CONSTRAINT emp9_id_pk PRIMARY KEY (id),
	CONSTRAINT emp9_dept_id_fk FOREIGN KEY (department_id) REFERENCES
		departments(department_id) ON DELETE SET NULL

	);

INSERT INTO emp9
	VALUES (1002,
			'bb',
			'bb@qq.com',
			29999,
			10);

SELECT *
	FROM emp9;

--修改表时添加约束
/*
使用 ALTER TABLE 语句:
    添加或删除约束,但是不能修改约束
    有效化或无效化约束
    【添加 NOT NULL 约束要使用 MODIFY 语句】

ALTER TABLE table_name
  ADD [CONSTRAINT constraint_name] constraint_type (column);

ALTER TABLE table_name MODIFY(column_name TYPE NOT NULL);
*/

CREATE TABLE emp10 (

	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp10_name_nn NOT NULL, -
	-
	列级约束
	email
	VARCHAR2 (
	30
),
	salary NUMBER (10,
		2) CONSTRAINT emp10_name_ck CHECK (salary > 1500 AND salary < 30000), --默认约束
				   department_id NUMBER(10), --表级约束
				   CONSTRAINT emp10_email_uk UNIQUE(email), CONSTRAINT emp10_id_pk PRIMARY KEY (id),
	CONSTRAINT emp10_dept_id_fk FOREIGN KEY (department_id) REFERENCES
		departments(department_id) ON DELETE SET NULL

	);

ALTER TABLE emp10
	MODIFY(salary NUMBER (10,
	2) NOT NULL);

--添加其他约束
ALTER TABLE emp10
	ADD CONSTRAINT emp10_email_uk UNIQUE (email);

--删除约束
/*
ALTER TABLE table_name
DROP CONSTRAINT  constraint_name;
*/
ALTER TABLE emp10
	DROP CONSTRAINT emp10_email_uk;

--无效化约束
/*
在ALTER TABLE 语句中使用 DISABLE 子句将约束无效化。

ALTER TABLE table_name
DISABLE CONSTRAINT  constraint_name;
*/

--激活约束
/*
ENABLE 子句可将当前无效的约束激活 ALTER TABLE table_name
ENABLE CONSTRAINT  constraint_name;
当定义或激活UNIQUE 或 PRIMARY KEY 约束时系统会自动创建UNIQUE 或 PRIMARY KEY索引
*/

--查询约束
/*
查询数据字典视图 USER_CONSTRAINTS
SELECT  constraint_name, constraint_type,
        search_condition
FROM    user_constraints
WHERE table_name = 'EMPLOYEES';

*/
SELECT constraint_name,
	   constraint_type,
	   search_condition
	FROM user_constraints
	WHERE table_name = 'EMP10';

--查询定义约束的列
/*
查询数据字典视图 USER_CONS_COLUMNS

SELECT  constraint_name, column_name
FROM    user_cons_columns
WHERE table_name = 'EMPLOYEES';

*/
SELECT constraint_name,
	   column_name
	FROM user_cons_columns
	WHERE table_name = 'EMP10';

--总结
/*
通过本章学习，您已经学会如何创建约束
描述约束的类型:
    NOT NULL
    UNIQUE
    PRIMARY KEY
    FOREIGN KEY
    CHECK
*/

--练习：57. 定义非空约束
--  1). 非空约束只能定义在列级.
CREATE TABLE emp11 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20)
);
--  2). 不指定约束名
ALTER TABLE emp11
	MODIFY(salary NUMBER (10) NOT NULL);
--  3). 指定约束名 
ALTER TABLE emp11
	MODIFY(NAME VARCHAR2 (20) CONSTRAINT emp11_name_nn NOT NULL);

--练习：58. 唯一约束
--  1). 列级定义
--      ①. 不指定约束名
CREATE TABLE emp12 (
	id NUMBER (10),
	name VARCHAR2 (20) UNIQUE,
	salary NUMBER (10),
	email VARCHAR2 (20)
);
--      ②. 指定约束名
CREATE TABLE emp13 (
	id NUMBER (10),
	name VARCHAR2 (20) CONSTRAINT emp13_name_uk UNIQUE,
	salary NUMBER (10),
	email VARCHAR2 (20)
);
--  2). 表级定义: 必须指定约束名
--      ①. 指定约束名
CREATE TABLE emp14 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	CONSTRAINT emp14_name_uk UNIQUE (name)
);
--练习：58.1 主键约束：唯一确定一行记录。表明此属性：非空，唯一
CREATE TABLE emp15 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	CONSTRAINT emp15_id_pk PRIMARY KEY (id)
);

--练习：59. 外键约束
--  1). 列级定义
--      ①. 不指定约束名
CREATE TABLE emp16 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	dept_id NUMBER (10) REFERENCES departments(department_id)
);
--      ②. 指定约束名
CREATE TABLE emp17 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	dept_id NUMBER (10) CONSTRAINT emp17_dept_id_fk REFERENCES
		departments(department_id)
);
--  2). 表级定义: 必须指定约束名
--      ①. 指定约束名
CREATE TABLE emp18 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	dept_id NUMBER (10),
	CONSTRAINT emp18_dept_id_fk FOREIGN KEY (dept_id) REFERENCES
		departments(department_id)
);

--练习：60. 约束需要注意的地方
/**
    1). ** 非空约束(not null)只能定义在列级

    2). ** 唯一约束(unique)的列值可以为空

    3). ** 外键(foreign key)引用的列起码要有一个唯一约束        
*/

--练习：61. 建立外键约束时的级联删除问题:
--  1). 级联删除:
CREATE TABLE emp19 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	dept_id NUMBER (10) CONSTRAINT emp19_dept_id_fk REFERENCES
		departments(department_id)
) ON DELETE CASCADE;

--  2). 级联置空：
CREATE TABLE emp20 (
	id NUMBER (10),
	name VARCHAR2 (20),
	salary NUMBER (10),
	email VARCHAR2 (20),
	dept_id NUMBER (10),
	CONSTRAINT emp20_dept_id_fk FOREIGN KEY (dept_id) REFERENCES
		departments(department_id)
) ON DELETE SET NULL;

--练习准备工作：
CREATE TABLE emp2
AS
	SELECT employee_id id,
		   last_name name,
		   salary
		FROM employees;

CREATE TABLE dept2
AS
	SELECT department_id id,
		   department_name dept_name
		FROM departments;
--练习：1.向表emp2的id列中添加PRIMARY KEY约束（my_emp_id_pk）
ALTER TABLE emp2
	ADD CONSTRAINT my_emp_id_pk PRIMARY KEY (id);

--练习：2.向表dept2的id列中添加PRIMARY KEY约束（my_dept_id_pk）
ALTER TABLE dept2
	ADD CONSTRAINT my_dept_id_pk PRIMARY KEY (id);

ALTER TABLE emp2
	DROP COLUMN dept_id;

--练习：3.向表emp2中添加列dept_id，并在其中定义FOREIGN KEY约束
--创建列并添加外键约束
ALTER TABLE emp2
	ADD (
		dept_id NUMBER (10) CONSTRAINT my_emp_dept_id_fk REFERENCES dept2(id)
		);

--可以省略括号
ALTER TABLE emp2
	ADD dept_id NUMBER (10) CONSTRAINT my_emp_dept_id_fk REFERENCES dept2(id);

-- 可以省略类型，默认会与外键类型一样(列级约束)。
ALTER TABLE emp2
	ADD dept_id CONSTRAINT my_emp_dept_id_fk REFERENCES dept2(id);

--向已有的列添加外键约束(表级约束)
ALTER TABLE emp2
	ADD CONSTRAINT my_emp_dept_id_fk FOREIGN KEY (dept_id) REFERENCES dept2(id);

--级联删除
ON
DELETE cascade;
--级联置空
ON
DELETE set NULL;
