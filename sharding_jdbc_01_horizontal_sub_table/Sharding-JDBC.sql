## Sharding-JDBC——水平分表
# 创建数据库
CREATE DATABASE course_db;

# 使用数据库
USE course_db;

# 创建数据表1。
CREATE TABLE course_1 (
	id      BIGINT(20) PRIMARY KEY,
	cname   VARCHAR(50) NOT NULL,
	user_id BIGINT(20)  NOT NULL,
	cstatus VARCHAR(10) NOT NULL
);

# 创建数据表2。
CREATE TABLE course_2 (
	id      BIGINT(20) PRIMARY KEY,
	cname   VARCHAR(50) NOT NULL,
	user_id BIGINT(20)  NOT NULL,
	cstatus VARCHAR(10) NOT NULL
);