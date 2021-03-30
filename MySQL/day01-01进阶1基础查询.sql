###MySQL服务的启动和停止
方式一：计算机——右击管理——服务
	方式二：通过管理员身份运行
	net START
服务名（启动服务）
	net STOP
服务名（停止服务）


###MySQL服务的登录和退出   
	方式一：通过mysql自带的客户端
	只限于root用户

	方式二：通过windows自带的客户端
	登录：
	mysql 【-h主机名 -P端口号 】-u用户名 -p密码

	也可以使用：
	mysql 【-h主机名 -P端口号 】-u用户名 -p回车
	会提示输入密码

	退出：
	exit或ctrl+C
	
	
###MySQL的常见命令 

	1.查看当前所有的数据库
SHOW DATABASES;

2.打开指定的库
USE 库名 3.查看当前库的所有表
SHOW TABLES;

4.查看其它库的所有表
SHOW TABLES FROM 库名;

5.创建表
CREATE TABLE 表名 (

	列名 列类型,
	列名 列类型，
		。。。
);

6.查看表结构
DESC 表名;


7.查看服务器的版本
	方式一：登录到mysql服务端
SELECT VERSION();
方式二：没有登录到mysql服务端
	mysql --version
	或
	mysql --V

	8.显示当前所在的库名
SELECT DATABASE();

###MySQL的语法规范
1.不区分大小写,但建议关键字大写，表名、列名小写
	2.每条命令最好用分号结尾
	3.每条命令根据需要，可以进行缩进 或换行
	4.注释
		单行注释：#注释文字
		单行注释：-- 注释文字
		多行注释：/* 注释文字  */

#---------------------------------------------------------------------------------------------------------#
##############################################进阶1：基础查询##############################################
/*
 * 语法：
 * select 查询列表 from 表名;
 *
 *
 * 类似于：System.out.println(打印东西);
 *
 * 特点：
 * 1.查询列表可以是：表中的字段、常量值、表达式、函数
 * 2.查询的结果是一个虚拟的表格。
 *
 */
#任何操作之前都先打开库
USE myemployees;

#1.查询表中的单个字段
SELECT last_name
	FROM employees;

#2.查询表中的多个字段
SELECT last_name,
	   salary,
	   email
	FROM employees;

#3.查询表中的所有字段
#查询所有字段的方式一：
SELECT employee_id,
	   first_name,
	   last_name,
	   email,
	   phone_number,
	   job_id,
	   salary,
	   commission_pct,
	   manager_id,
	   department_id,
	   hiredate
	FROM employees;

#查询所有字段的方式二：
SELECT *
	FROM employees;

#4.查询常量值
SELECT 100;
SELECT 'john';

#5.查询表达式
SELECT 100 % 98;

#6.查询函数(方法)
SELECT VERSION();

#7.为字段起别名
#好处①：便于理解
#好处②：如果要查询的字段有重名的情况，使用别名可以区分开来。
#方式一：
SELECT 100 % 98 结果;
SELECT last_name 姓,
	   first_name 名
	FROM employees;

#方式二：AS可以省略
SELECT last_name 姓,
	   first_name 名
	FROM employees;

#案例：查询salary,显示结果为out put
#注：out put中间有空格，可以使用""/''/``包含起来。
SELECT salary "out put"
	FROM employees;

#8.去重
#案例：查询员工表中涉及到的所有的部门编号
#未去重复的写法：
SELECT department_id
	FROM employees;
#去重复的写法：
SELECT DISTINCT
	   department_id
	FROM employees;

#9.+号的作用
/*
Java中的+号：
  ①运算符：两个操作数都为数值型
  ②连接符：只要有一个操作数据为字符串
  
    
MySQL中的+号：
  仅仅只有一个功能：运算符
  
SELECT 100+90;		#两个操作数都为数值型，则做加法运算。
SELECT '123'+90;	#其中一方为字符型，试图将字符型数值转换成数值型。
			#如果转换成功，则继续做加法运算。
SELECT 'john'+90;	#如果转换失败，则将字符型数值转换成0。
SELECT null+10;		#只要其中一方为null,则结果肯定为null。
*/
#案例：查询员工名和姓连接成一个字段，并显示为 姓名
#CONCAT()函数用于拼接
SELECT CONCAT('A','B','C') 结果;
SELECT CONCAT(last_name,',',first_name) 姓名
	FROM employees;