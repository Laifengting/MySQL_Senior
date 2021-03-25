#任何操作之前都先打开库
USE myemployees;
/*############################################进阶4：常见函数############################################*/
/*
概念：类似于JAVA中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名。

好处：1. 隐藏了实现细节。2. 提高了代码的重用性。

调用：SELECT 函数名(实参列表) 【FROM 表】;

特点：  ① 叫什么(函数名)
		② 干什么(函数功能)

分类：  ① 单行函数
	    如：CONCAT()、LENGTH()、IFNULL()等
		② 分组函数
	    功能：做统计用，又称为统计函数、聚合函数、组函数。


常见函数：
		一、单行函数
		字符函数：
		LENGTH(str)
		CONCAT(str1,str2,...)
        SUBSTR(str FROM pos FOR len)
        INSTR(str,substr)
        TRIM([remstr FROM] str)
        UPPER(str)
        LOWER(str)
        LPAD(str,len,padstr)
        RPAD(str,len,padstr)
        REPLACE(str,from_str,to_str)

        常数函数：
        ROUND(X)
        ROUND(X,D)
        CEIL(X)
        FLOOR(X)
        TRUNCATE(X,D)
        MOD(N,M)

        日期函数：
        NOW()
        CURDATE()
        CURTIME()
        YEAR(date)
        MONTH(date)
        DAY(date)
        HOUR(time)
        MINUTE(time)
        SECOND(time)
        STR_TO_DATE(str,format)
        DATE_FORMAT(date,format)

        其他函数：
        VERSION()
        DATABASE()
        USER()

        控制函数：
        IF(expr1,expr2,expr3)

        CASE case_value
            WHEN when_value THEN
                statement_list
            ELSE
                statement_list
        END CASE;


        CASE
        WHEN expr1    THEN expr1-2
        WHEN expr2    THEN expr2-2
        ELSE exprN-1
        END

*/
/*
*        一、字符函数
*/
/*
        1. LENGTH()：获取参数值的字节个数
*/
SELECT LENGTH('JOHN');
SELECT LENGTH('中国人HAHAHA');
SHOW VARIABLES LIKE '%char%';
/*
        2. CONCAT()：拼接字符串
*/
SELECT CONCAT(first_name, '_', last_name) AS 姓名
FROM employees;
/*
        3.1 UPPER(expr)：将expr所有字符变成大写
        3.2 LOWER(expr)：将expr所有字符变成小写
*/
SELECT UPPER('hello');
SELECT LOWER('HELLO');
/*
        示例：将姓变大写，名变小写，然后拼接。
*/
SELECT CONCAT(UPPER(last_name), '_', LOWER(first_name)) AS 姓名
FROM employees;
/*
        4. SUBSTR() / SUBSTRING()：
        注意：索引从1开始
*
############################################################################################################
/*
        截取从指定索引处后面所有字符.
*/
SELECT SUBSTR('李莫愁爱上了陆展元', 7) AS out_put;
/*
        截取从指定索引处指定字符长度的字符.
*/
SELECT SUBSTR('李莫愁爱上了陆展元', 1, 3) AS out_put;
/*
        案例：姓名中首字符大写，其他字符小写，然后用_拼接，显示出来.
*/
SELECT CONCAT(CONCAT(UPPER(SUBSTR(first_name, 1, 1)), '_', LOWER(SUBSTR(first_name, 2))))
FROM employees;
/*
        5. INSTR(str,substr)：返回substr第一次出现在str中的索引，如果找不到返回0.
*/
SELECT INSTR('杨不悔爱上了殷黎亭', '殷黎亭') AS out_put;
/*
        6.1 TRIM(str)：去除str前后的空格.
        6.2 TRIM([remstr FROM] str)：去除str前后的remstr.
*/
SELECT LENGTH(
               TRIM('             张翠山           ')) AS out_put;
SELECT TRIM('A' FROM 'AAAAAAAAAAAAAAAAAAA张AAAAAA翠AAA山AAAAAAAAAAAAAAAAAAAA') AS out_put;
/*
        7. LPAD(str,len,padstr)：用指定的字符实现左填充全str到达指定长度，如果str长度已经超指定长度，会从右边截断。
*/
SELECT LPAD('张无忌', 10, '*') AS out_put;
/*
        8. RPAD(str,len,padstr)：用指定的字符实现右填充全str到达指定长度，如果str长度已经超指定长度，会从右边截断。
*/
SELECT RPAD('张无忌', 10, 'AB') AS out_put;
/*
        9. REPLACE(str,from_str,to_str)：将str中的from_str替换为to_str.
*/
SELECT REPLACE
           ('张无忌爱上了周芷若,但周芷若还是爱着张无忌', '周芷若', '赵敏') AS out_put;
/*
*        二、数学函数
*/
/*
        1.1 ROUND(X)：X四舍五入
        1.2 ROUND(X,D)：X四舍五入，小数点保留D位
*/
SELECT ROUND(- 1.55);
SELECT ROUND(1.567, 2);
/*
        2 CEIL(X)：将X向上取整，返回>=该参数的最小整数
*/
SELECT CEIL(1.00);
/*
        3 FLOOR(X)：将X向下取整，返回<=该参数的最大整数
*/
SELECT FLOOR(- 9.99);
/*
        4 TRUNCATE(X,D)：将X保留D位小数截断。
*/
SELECT TRUNCATE
           (- 9.69999, 2);
/*
        5 MOD(N,M)：将N对M取余(取模)
        MOD(N,M)：M-M/N*N
        MOD(-10,-3)：-10 - (-10)/(-3)*(-3)
*/
SELECT MOD
           (10, - 3);
/*
        这两个的作用一样
*/
SELECT 10 % 3;
/*
        三、日期函数

    序号          格式符          功能
      1              %Y        4位的年份
      2              %y        2位的年份
      3              %m        月份(01,02...11,12)
      4              %c        月份(1,2,3...11,12)
      5              %d        日(01,02,31)
      6              %H        小时(24小时制)
      7              %h        小时(12小时制)
      8              %i        分钟(00,01...59)
      9              %s        秒  (00,01,...59)

*/
/*
        1. NOW()：返回当前系统日期+时间
*/
SELECT NOW();
/*
        2. CURDATE()：返回当前系统日期，不包含时间
*/
SELECT CURDATE();
/*
        3. CURTIME()：返回当前系统时间，不包含日期
*/
SELECT CURTIME();
/*
        4. 可以获取指定的部分：年、月、日、时、分、秒
            YEAR(date)、MONTH(date)、DAY(date)、HOUR(time)、MINUTE(time)、SECOND(time)
                        MONTHNAME(date)、DAYNAME(date)
*/
SELECT YEAR
           (
               NOW()) AS 年;
SELECT YEAR
           ('1989-10-19') AS 年;
SELECT YEAR
           (hiredate) AS 年
FROM employees;
SELECT MONTH
           (
               NOW()) AS 月;
SELECT MONTHNAME(
               NOW()) AS 月;
/*
        5. STR_TO_DATE(str,format)：将日期格式的str转换成指定格式format的日期
*/
SELECT STR_TO_DATE('1989-10-19', '%Y-%m-%d') AS 日期;
/*
        案例：查询入职日期为1992-4-3的员工信息
*/
/*
        方式一：
*/
SELECT *
FROM employees
WHERE hiredate = '1992-04-03';
/*
        方式二：
*/
SELECT *
FROM employees
WHERE hiredate = STR_TO_DATE('04-03-1992', '%m-%d-%Y');
/*
        6. DATE_FORMAT(date,format)：将日期格式转换成字符
*/
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日') AS out_put;
/*
        案例：查询有奖金的员工名和入职日期(xx月/xx日 xx年)
*/
SELECT last_name,
       (hiredate, '%m月/%d日 %y年') AS 入职日期
FROM employees
WHERE commission_pct IS NOT NULL;
SELECT DATE_FORMAT('2018/06/06', '%Y年%m月%d日') AS 日期;
/*
        四、其他函数
    SELECT VERSION();    显示数据库版本号
    SELECT DATABASE();    显示当前数据库
    SELECT USER();        显示当前用户
*/
/*
        五、流程控制函数
*/
/*
        1. IF(expr1,expr2,expr3)：如果expr1为true,返回expr2,否则返回expr3。类似于JAVA中的if else 和 三元运算符效果。
*/
SELECT IF
           (10 > 5, '大', '小');
SELECT last_name,
       commission_pct,
       IF
           (commission_pct IS NULL, '没奖金，呵呵', '有奖金，嘻嘻') AS 备注
FROM employees;
/*
        2. CASE函数的使用一：类似于JAVA中switch case的效果
*/
/*
JAVA中:
switch(变量或表达式){
    case 常量1：
        执行语句1;
        break;
    case 常量2：
        执行语句2;
        break;
    ...
    default:
        执行语句n;
        break;
}

MySQL中：
CASE case_value 要判断的字段或表达式
    WHEN
        when_value1 常量1 THEN    statement_list1 要显示的值1或语句1
    WHEN
        when_value2 常量2 THEN    statement_list2 要显示的值2或语句2
    ELSE
        statement_list要显示的值n或语句n
END;
*/
/*
        案例：查询员工的工资，要求
            部门号=30，显示的工资为1.1倍。
            部门号=40，显示的工资为1.2倍。
            部门号=50，显示的工资为1.3倍。
            其他部门，显示的工资为原工资。
*/
SELECT salary  AS 原始工资,
       department_id,
       CASE
           department_id
           WHEN 30 THEN
               salary * 1.1
           WHEN 40 THEN
               salary * 1.2
           WHEN 50 THEN
               salary * 1.3
           ELSE salary
           END AS 新工资
FROM employees;
/*
        3. CASE函数的使用二：类似于JAVA中的多重if
*/
/*
JAVA中：
if(条件1){
    语句1：
}else if(条件2){
    语句2;
}
...
else{
    语句n;
}


MySQl中：

CASE
WHEN 条件1 THEN 要显示的值1或语句1
WHEN 条件2 THEN 要显示的值2或语句2
...
ELSE 要显示的值n或语句n
END

*/
/*
        案例：查询员工的工资的情况，
            如果工资>20000，显示A级别;
            如果工资>15000，显示B级别;
            如果工资>10000，显示C级别;
            否则，显示D级别;
*/
SELECT salary,
       CASE

           WHEN salary > 20000 THEN
               'A'
           WHEN salary > 15000 THEN
               'B'
           WHEN salary > 10000 THEN
               'C'
           ELSE 'D'
           END AS 工资级别
FROM employees;
