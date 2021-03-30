/*###############################################进阶17：变量###############################################*/
/*
		1. 系统变量：
			1.1 全局变量：
			1.2 会话变量：

		2. 自定义变量：
			2.1 用户变量：
			2.2 局部变量：
 */

/*
		1. 系统变量
		说明：变量由系统提供，不是用户定义，属于服务器层面

		使用语法：
			① 查看所有的系统变量
				SHOW [GLOBAL | [SESSION]] VARIABLES;
				SHOW GLOBAL VARIABLES;#查看全局变量
				SHOW SESSION VARIABLES;#查看会话变量
				SHOW VARIABLES;#查看会话变量

			② 查看满足条件的部分系统变量
				SHOW [GLOBAL | [SESSION]] VARIABLES LIKE '%char%';

			③ 查看指定的某个系统变量的值
				SELECT @@[ GLOBAL. | [SESSION.]]系统变量名;

			④ 为某个系统变量赋值
				SET [GLOBAL | [SESSION]] 系统变量名 = 值;
				OR
				SET @@[GLOBAL. | [SESSION.]] 系统变量名 = 值;

		注意：
			如果是全局级别，则需要加GLOBAL，如果是会话级别，则需要加SESSION，如果不写，则默认SESSION
*/

/*
        1.1 全局变量
        作用域：服务器每次启动将为所有的全局变量赋初始值,针对于所有的会话(连接)有效，但不能跨重启。
 */
/*
		1.1.1 查看所有的全局变量
 */
SHOW GLOBAL VARIABLES;

/*
		1.1.2 查看部分的全局变量
 */
SHOW GLOBAL VARIABLES LIKE '%char%';

/*
		1.1.3 查看指定的全局变量的值
 */
SELECT @@global.autocommit;
SELECT @@global.tx_isolation;

/*
        1.1.4 为某个指定的全局变量赋值
 */
#方式一：
SET @@global.autocommit = 1;
#方式二：
SET GLOBAL AUTOCOMMIT = 0;

/*
        1.2 会话变量
        作用域：针对于当前的会话(连接)有效
 */
/*
		1.2.1 查看所有的会话变量
 */
# 方式一：
SHOW SESSION VARIABLES;
# 方式二：
SHOW VARIABLES;

/*
		1.2.2 查看部分的会话变量
 */
# 方式一：
SHOW SESSION VARIABLES LIKE '%char%';
# 方式二：
SHOW VARIABLES LIKE '%char%';

/*
		1.2.3 查看指定的会话变量的值
 */
SELECT @@session.autocommit;
SELECT @@session.tx_isolation;
SELECT @@tx_isolation;

/*
        1.2.4 为某个指定的会话变量赋值
 */
#方式一：
SET @@session.autocommit = 1;
SET @@autocommit = 1;
#方式二：
SET SESSION AUTOCOMMIT = 0;



/*
		2. 自定义变量
		说明：变量是用户自定义的，不是由系统提供的

		使用步骤：
			声明
			赋值
			使用(查看、比较、运算等)



*/
/*
        2.1 用户变量
        作用域：针对于当前会话(连接)有效，同于系统变量中的会话变量
        应用在任何地方，也就是 BEGIN END的里面 或 BEGIN END的外面
 */
/*
        2.1.1 声明并初始化

        赋值的操作符为： = 或 :=

        语法：
        写法一：
			SET @用户变量名 = 值;
        写法二：
           SET @用户变量名 := 值;
        写法三：
          SELECT @用户变量名 := 值;
 */
/*
       2.1.2 赋值(更新用户变量的值)

       方式一：通过 SET 或 SELECT
               写法一：
				SET @用户变量名 = 值;
               写法二：
				SET @用户变量名 := 值;
               写法三：
				SELECT @用户变量名 := 值;

        方式二：通过 SELECT INTO
				SELECT 字段名 INTO @变量名 FROM 表;
 */

/*
       2.1.3 使用(查看用户变量的值)
        方式：
        SELECT @用户变量名;
 */
SELECT @count;

### 案例：
# 声明并初始化
SET @name = 'John';
SET @name = 100;
SET @count = 1;
# 赋值
SELECT COUNT(*)
	INTO @count
	FROM myemployees.employees;
# 使用(查看用户变量的值)
SELECT @count;

/*
        2.2 局部变量
		作用域：仅仅在定义它的 BEGIN END中有效
        应用在 BEGIN END 中的第一句话！！！         ✔
 */

/*
        2.2.1 声明
        DECLARE 变量名 类型;
        DECLARE 变量名 类型 DEFAULT 值;
 */

/*
        2.2.2 赋值
       方式一：通过 SET 或 SELECT
               写法一：
				SET 局部变量名 = 值;
               写法二：
				SET 局部变量名 := 值;
               写法三：
				SELECT @局部变量名 := 值;

        方式二：通过 SELECT INTO
				SELECT 字段名 INTO 局部变量名 FROM 表;
 */

/*
        2.2.3 使用
        方式：
        SELECT 局部变量名;
 */

/*

 对比用户变量和局部变量：
			作用域            定义和使用的位置                     语法
 用户变量    当前会话           会话中的任何地方                    必须加@符号，不用限定类型
 局部变量    BEGIN END中       只能在BEGIN END中，且为第一句话      一般不用加@符号，需要限定类型
 */

# 案例：声明两个变量并赋初始值，求和，并打印

# 使用 用户变量
SET @m = 1;
SET @n = 2;
SET @sum = @m + @n;
SELECT @sum;

# 使用 局部变量 以下写法会报错。因为局部变量只能应用在BEGIN END中，且为第一句。
DECLARE m INT DEFAULT 1;
DECLARE n INT DEFAULT 2;
DECLARE sum INT;
SET sum = m + n;
SELECT sum;















