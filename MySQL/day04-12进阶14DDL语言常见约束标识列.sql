/*#############################################进阶14：标识列#############################################*/
/*
		标识列：又称为自增长列
		含义：可以不用手动的插入值，系统提供默认的序列值

		特点：
		①标识列必须和主键搭配吗？不一定，但要求是一个key
		②一个表可以有几个标识列？至多一个。
		③标识列的类型只能是数值型int float double都行。
		④标识列可以通过SET auto_increment_increment = 3;设置步长；也可以通过手动插入值，设置起始值。
*/
/*
        1. 创建表时设置标识列
 */
DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity (
	# 设置自增长列
	id   INT,
	name VARCHAR(20),
	seat INT
);

TRUNCATE TABLE tab_identity;
/*
官方文档，VALUE与VALUES都是正确的，经过验证，这两个也是可以混合着用的，只是两者对不同语句插入数量的执行效率各不相同。
对比之下，插入多行时，用VALUE比较快
根据所得出的结论，应该在插入单行的时候使用VALUES，在插入多行的时候使用VALUE
 */
INSERT INTO tab_identity
	VALUES (NULL, 'John');

INSERT INTO tab_identity(id, name)
	VALUES (NULL, 'John');

INSERT INTO tab_identity(name)
	VALUES ('John');

# 查看自增长的步长与偏移
SHOW VARIABLES LIKE '%auto_increment%';

# 设置自增长的步长  【5.5.64 - 8.0.19版本不支持设置自增长的步长，视频中5.5.15支持】
SET auto_increment_increment = 3;

/*
        2. 修改表时设置标识列
*/
ALTER TABLE tab_identity
	MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;

/*
        3. 修改表时删除标识列
*/
ALTER TABLE tab_identity
	MODIFY COLUMN id INT;










