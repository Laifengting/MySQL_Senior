/*#############################################进阶15：TCL语言#############################################*/
/*
		Transaction Control Language 事务控制语言

		事务：一个或一组SQL语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。

		案例：转账
		张三丰     1000
		郭襄       1000

		UPDATE 表 SET 张三丰的余额=500 WHERE NAME='张三丰'
		意外
		UPDATE 表 SET 郭襄的余额=1500 WHERE NAME='郭襄'

		事务的特性：ACID
		① 原子性（Atomicity）
		原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。
		② 一致性（Consistency）
		事务必须使数据库从一个一致性状态变换到另外一个一致性状态。
		③ 隔离性（Isolation）
		事务的隔离性是指一个事务的执行不能被其他事务干扰，即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。
		④ 持久性（Durability）
		持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，接下来的其他操作和数据库故障不应该对其有任何影响


		事务的创建
		隐式事务：事务没有明显的开启和结束的标记
			比如：INSERT、UPDATE、DELETE语句
			DELETE FROM 表 WHERE id = 1;


		显示事务：事务具有明显的开启和结束的标记。
			前提：必须先设计自动提交功能为禁用

		# 第一步，关闭自动提交功能
		SET AUTOCOMMIT = 0;
		# 开启事务【可选】;
		START TRANSACTION;

		# 第二步，编写事务中的SQL语句(SELECT、INSERT、UPDATE、DELETE语句)
		语句1;
		语句2;
		...

		# 第三步：结束事务;
		COMMIT;提交事务
		ROLLBACK;回滚事务
		SAVEPOINT 节点名;设置保存节点


		事务的隔离级别：
								脏读      不可重复读      幻读
			read uncommitted：   ✔           ✔           ✔
			read committed：     ✖           ✔           ✔
			repeatable read：    ✖           ✖           ✔
			serializable：       ✖           ✖           ✖

		MySQL中，默认repeatable read隔离级别;
		Oracle中，默认read committed隔离级别。

		#查看隔离级别
		SELECT @@tx_isolation;

		#设置隔离级别
		SET 【SESSION | GLOBAL】TRANSACTION ISOLATION LEVEL 隔离级别;

 */

# 查询变量
SHOW VARIABLES LIKE 'autocommit';
SHOW ENGINES;

/*
        演示1 事务的使用步骤
 */
USE students;
DROP TABLE IF EXISTS account;
CREATE TABLE account (
	id       INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	balance  DOUBLE
);

INSERT INTO account(username, balance)
	VALUES ('张无忌', 1000),
		   ('赵敏', 1000);

# 第一步 开启事务
SET AUTOCOMMIT = 0;
START TRANSACTION;

# 第二步 编写一组事务的语句
UPDATE account
SET
	balance = 1000
	WHERE username = '张无忌';
UPDATE account
SET
	balance = 1000
	WHERE username = '赵敏';

# 第三步 结束事务
ROLLBACK;
COMMIT;

SELECT *
	FROM account;

/*
        演示2 事务对于DELETE和TRUNCATE的处理的区别
 */
SET AUTOCOMMIT = 0;
START TRANSACTION;

# DELETE支持回滚
DELETE
	FROM account
	WHERE 1 = 1;
ROLLBACK;


SET AUTOCOMMIT = 0;
START TRANSACTION;
# TRUNCATE不支持回滚
TRUNCATE TABLE account;
ROLLBACK;

SELECT *
	FROM account;

/*
        演示3 SAVEPOINT的使用
        SAVEPOINT 跟 ROLLBACK TO搭配使用。
 */
SET AUTOCOMMIT = 0;
START TRANSACTION;
SAVEPOINT a;#设置保存点。
DELETE
	FROM account
	WHERE id = 1;
SAVEPOINT b;#设置保存点。
DELETE
	FROM account
	WHERE id = 2;

ROLLBACK TO b;
ROLLBACK TO a;




























