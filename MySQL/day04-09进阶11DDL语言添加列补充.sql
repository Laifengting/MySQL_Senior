DELETE
	FROM beauty
	WHERE boyfriend_id = 9
	LIMIT 1;

CREATE DATABASE test;

CREATE TABLE test_add_colunm (
	t1 INT,
	t2 INT,
	t3 INT
);
###插入列
# 默认插入在原表中的最后一列
ALTER TABLE test_add_colunm
	ADD COLUMN newt3 INT;

# FIRST关键字，插入到第一列
ALTER TABLE test_add_colunm
	ADD COLUMN newt INT FIRST;

# AFTER 列名 插入到指定列后
ALTER TABLE test_add_colunm
	ADD COLUMN newt2 INT AFTER t2;