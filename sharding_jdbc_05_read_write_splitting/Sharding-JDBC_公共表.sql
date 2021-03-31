## Sharding-JDBC——公共表
USE user_db;
CREATE TABLE t_udict (
	dict_id BIGINT(20) PRIMARY KEY NOT NULL,
	ustatus VARCHAR(100)           NOT NULL,
	uvalue  VARCHAR(100)           NOT NULL
);

USE edu_db_1;
CREATE TABLE t_udict (
	dict_id BIGINT(20) PRIMARY KEY NOT NULL,
	ustatus VARCHAR(100)           NOT NULL,
	uvalue  VARCHAR(100)           NOT NULL
);

USE edu_db_2;
CREATE TABLE t_udict (
	dict_id BIGINT(20) PRIMARY KEY NOT NULL,
	ustatus VARCHAR(100)           NOT NULL,
	uvalue  VARCHAR(100)           NOT NULL
);

