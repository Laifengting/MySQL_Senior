## Sharding-JDBC——水平分库
# 创建数据库1
CREATE DATABASE edu_db_1;
USE edu_db_1;
# 创建数据表1。
CREATE TABLE course_0 (
	id      BIGINT(20) PRIMARY KEY,
	cname   VARCHAR(50) NOT NULL,
	user_id BIGINT(20)  NOT NULL,
	cstatus VARCHAR(10) NOT NULL
);

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

# 创建数据库2
CREATE DATABASE edu_db_2;
USE edu_db_2;
# 创建数据表0。
CREATE TABLE course_0 (
	id      BIGINT(20) PRIMARY KEY,
	cname   VARCHAR(50) NOT NULL,
	user_id BIGINT(20)  NOT NULL,
	cstatus VARCHAR(10) NOT NULL
);
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