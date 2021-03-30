/*
任何操作之前都先打开库
*/ USE myemployees;
/*##############################################进阶2：条件查询##############################################*/
/*
语法：
	select
		查询列表
	from
		表名
	where
		筛选条件;
		
分类：
	① 按条件表达式筛选
		JAVA中的比较运算符：> < == != >= <=
		MySQL中的比较运算符：> < = != <> >= <=
		
	② 按逻辑表达式筛选
		逻辑运算符：作用：用于连接条件表达式
		JAVA中的逻辑运算符：&& || !
		MySQL中的逻辑运算符：and or not
		&& 和 and：两个条件都为true,结果为true,反之为false.
		|| 和 or：只要有一个条件为true,结果为true,反之为false.
		! 和 not：如果连接的条件本身为false,结果为true,反之为false.
		
	③ 模糊查询
		like
		between and
		in
		is null
*/#------------------------------------------------------------------------------------------------------------#
###1. 按条件表达式筛选
#案例1：查询工资>12000的员工信息
SELECT *
	FROM employees
	WHERE salary > 12000;#案例2：查询部门编号不等于90号的员工名和部门编号。
SELECT last_name,
	   department_id
	FROM employees
	WHERE department_id != 90;
##----------------------------------------------------------------------------------------#
###2. 按逻辑表达式筛选
#案例1：查询工资在10000到20000之间的员工名、工资以及奖金
SELECT last_name,
	   salary,
	   commission_pct
	FROM employees
	WHERE salary >= 10000
	  AND salary <= 20000; #案例2：查询部门编号不是在90-110之间，或工资高于15000的员工信息
SELECT *
	FROM employees
	WHERE department_id < 90 OR department_id > 110 OR salary > 15000;
#----------------------------------------------------------------------------------------#
###3. 模糊查询
/*
like
特点：① 一般和通配符搭配使用，可以判断字符型数值或数值型
	通配符：
	% 任意多个字符，包含0个字符
	_ 任意单个字符。
	

between and
in
is null
*/#----------------------------------------------------------------------------------------#
##1. like
#案例1：查询员工名中包含字符a的员工信息
SELECT *
	FROM employees
	WHERE last_name LIKE '%a%';#案例2：查询员工名中第三个字符为e，第五个字符为a的员工名和工资
SELECT last_name,
	   salary
	FROM employees
	WHERE last_name LIKE '__n_l%';#案例3：查询员工名中第二个字符为_的员工名。
SELECT last_name
	FROM employees # \转义字符 "\_" 也可以自定义转义字符

	WHERE last_name LIKE '_$_%' ESCAPE '$';#案例4：查询部门编号大于100的员工名和员工部门编号
SELECT last_name,
	   department_id
	FROM employees
	WHERE department_id LIKE '1__';
#----------------------------------------------------------------------------------------#
##2. between and
/*
① 使用between and可以提高语句的简洁度
② 包含临界值
③ 两个临界值不能调换顺序
④ 两个临界值的类型一致。或能隐性转换。
*/#案例1：查询员工编号在100-120之间的员工信息
SELECT *
	FROM employees /*
旧写法：
where employee_id >= 100
  and employee_id <= 120;
*/#新写法：

	WHERE employee_id BETWEEN 100
			  AND 120;
#----------------------------------------------------------------------------------------#
##3. in
/*
in
含义：判断某字段的值是否属于in列表中的某一项
特点：
	① 使用in提高语句简洁度
	② in列表的值类型必须一致或兼容。
	③ in列表里不支持通配符。
*/#案例：查询员工的工种编号是IT_PROG、AD_VP、AD_PRES中的一个员工名和工种编号。
#旧写法：
SELECT last_name,
	   job_id
	FROM employees
	WHERE job_id = 'IT_PROG'
	   OR job_id = 'AD_VP'
	   OR job_id = 'AD_RPES' );
#----------------#
#新写法：
SELECT last_name,
	   job_id
	FROM employees
	WHERE job_id IN ('IT_PROG', 'AD_VP', 'AD_RPES');
#----------------------------------------------------------------------------------------#
## is null
/*
注意：
	=、!、<> 不能用于判断null值
	is null或is not null可以判断null值
*/#案例1：查询没有奖金的员工名和奖金率
SELECT last_name,
	   commission_pct
	FROM employees /*
where commission_pct = NULL;# =不能判断null值
*/

	WHERE commission_pct IS NULL;#案例2：查询有奖金的员工名和奖金率
SELECT last_name,
	   commission_pct
	FROM employees /*
where commission_pct = NULL;# =不能判断null值
*/

	WHERE commission_pct IS NOT NULL;
#----------------------------------------------------------------------------------------#
###<=>安全等于
/*


*/#案例1：查询没有奖金的员工名和奖金率
SELECT last_name,
	   commission_pct
	FROM employees /*
where commission_pct = NULL;# =不能判断null值
*/

	WHERE commission_pct <=> NULL;#案例2：查询工资为12000的员工信息
SELECT *
	FROM employees
	WHERE salary <=> 12000;
# is null  VS <=>
/*
is null / is not null：仅仅可以判断null值，可读性较高，建议使用。【推荐使用】
<=>：即可以判断null值，又可以判断普通的数值，可以读性较低。
*/