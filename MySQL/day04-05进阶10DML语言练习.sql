/*
						测  试
		1.  运行以下脚本创建表 my_employees
*/
CREATE TABLE my_employees (
    Id INT (10),
    First_name VARCHAR (10),
    Last_name VARCHAR (10),
    Userid VARCHAR (10),
    Salary DOUBLE (10, 2)
);

CREATE TABLE users (
    id INT,
    userid VARCHAR (10),
    department_id INT
);

/*
		2.  显示表 my_employees 的结构
*/
DESC my_employees;

/*
		3.  向 my_employees 表中插入下列数据
				ID  FIRST_NAME  LAST_NAME  USERID		SALARY
				1  	patel 		Ralph  		Rpatel  	895
				2  	Dancs  		Betty  		Bdancs  	860
				3  	Biri  		Ben  		Bbiri  		1100
				4  	Newman  	Chad  		Cnewman  	750
				5  	Ropeburn  	Audrey  	Aropebur  	1550
*/
#方式一：
 INSERT INTO my_employees
VALUES
    (1, 'patel', 'Ralph', 'Rpatel', 895),
    (2, 'Dancs', 'Betty', 'Bdancs', 860),
    (3, 'Biri', 'Ben', 'Bbiri', 1100),
    (4, 'Newman', 'Chad', 'Cnewman', 750),
    (
        5,
        'Ropeburn',
        'Audrey',
        'Aropebur',
        1550
    );

DELETE FROM my_employees;
#方式二：
 INSERT INTO my_employees
SELECT
    1,
    'patel',
    'Ralph',
    'Rpatel',
    895
UNION
SELECT
    2,
    'Dancs',
    'Betty',
    'Bdancs',
    860
UNION
SELECT
    3,
    'Biri',
    'Ben',
    'Bbiri',
    1100
UNION
SELECT
    4,
    'Newman',
    'Chad',
    'Cnewman',
    750
UNION
SELECT
    5,
    'Ropeburn',
    'Audrey',
    'Aropebur',
    1550;

SELECT
    *
FROM
    my_employees;

/*
		4.  向 users 表中插入数据

				1  Rpatel  10
				2  Bdancs  10
				3  Bbiri  20
				4  Cnewman  30
				5  Aropebur  40
				
*/
SELECT
    *
FROM
    users;

INSERT INTO users
VALUES
    (1, 'Rpatel', 10),
    (2, 'Bdancs', 10),
    (3, 'Bbiri', 20),
    (4, 'Cnewman', 30),
    (5, 'Aropebur', 40);

/*
		5.  将 3 号员工的 last_name 修改为“drelxer”
*/
UPDATE
    my_employees
SET
    Last_name = 'drelxer'
WHERE Id = 3;



SELECT
    *
FROM
    my_employees;

/*
		6.  将所有工资少于 900 的员工的工资修改为 1000
*/
UPDATE
    my_employees
SET
    Salary = 1000
WHERE Salary < 900;

/*
		7.  将 userid 为 Bbiri 的 user 表和 my_employees 表的记录全部删除
*/
DELETE
    u,
    m
FROM
    users u
    INNER JOIN my_employees m
        ON u.`userid` = m.`Userid`
WHERE u.`userid` = 'Bbiri';

/*
		8.  删除所有数据
*/
DELETE FROM my_employees;
DELETE FROM users;
/*
		9.  检查所作的修正
*/
SELECT * FROM my_employees;
SELECT * FROM users;


/*
		10. 清空表 my_employees
*/
TRUNCATE TABLE my_employees;
TRUNCATE TABLE users;