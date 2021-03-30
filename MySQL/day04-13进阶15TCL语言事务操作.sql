CREATE TABLE goods (
	id   INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(25)
);

SELECT COUNT(*)
	FROM goods;

TRUNCATE TABLE goods;

SELECT @@tx_isolation;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

#1.查看当前会话隔离级别
SELECT @@tx_isolation;

#2.查看系统当前隔离级别
SELECT @@global.tx_isolation;

#3.设置当前会话隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

#4.设置系统当前隔离级别
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

#5.命令行，开始事务时
SET autocommit = off 或者 START TRANSACTION