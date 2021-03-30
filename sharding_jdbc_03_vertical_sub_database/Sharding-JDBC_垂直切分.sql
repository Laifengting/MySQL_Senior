## Sharding-JDBC_垂直切分
# 创建数据库
CREATE DATABASE user_db;
USE user_db;
# 创建数据表
CREATE TABLE t_user (
	user_id  BIGINT(20) PRIMARY KEY NOT NULL,
	username VARCHAR(100)           NOT NULL,
	ustatus  VARCHAR(50)            NOT NULL
);