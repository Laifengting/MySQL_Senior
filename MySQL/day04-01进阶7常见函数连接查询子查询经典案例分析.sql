/*
		1. 查询工资最低的员工信息: last_name, salary
*/
# ① 查询最低的工资
 SELECT
    MIN(salary)
FROM
    employees;

# ② 查询last_name, salary，要求salary = ①
 SELECT
    last_name,
    salary
FROM
    employees
WHERE salary =
    (SELECT
        MIN(salary)
    FROM
        employees);

/*
		2. 查询平均工资最低的部门信息
*/
####方式一：
# ① 先查每个部门的平均工资
 SELECT
    ROUND(AVG(salary), 2) ag,
    department_id
FROM
    employees
GROUP BY department_id;

# ② 将①升序排序，并只显示一行
 SELECT
    ROUND(AVG(salary), 2) ag,
    department_id
FROM
    employees
GROUP BY department_id
ORDER BY ag ASC
LIMIT 0, 1;

# ③ 查询部门信息
 SELECT
    d.*
FROM
    departments d
WHERE d.`department_id` =
    (SELECT
        department_id
    FROM
        employees
    GROUP BY department_id
    ORDER BY ROUND(AVG(salary), 2) ASC
    LIMIT 0, 1);

####方式二：
# ① 先查每个部门的平均工资
 SELECT
    ROUND(AVG(salary), 2),
    department_id
FROM
    employees
GROUP BY department_id;

# ② 查询①结果上的最低平均工资
 SELECT
    MIN(ag)
FROM
    (SELECT
        ROUND(AVG(salary), 2) ag,
        department_id
    FROM
        employees
    GROUP BY department_id) ag_dep;

# ③ 查询哪个部门的平均工资=②
 SELECT
    ROUND(AVG(salary), 2),
    department_id
FROM
    employees
GROUP BY department_id
HAVING ROUND(AVG(salary), 2) =
    (SELECT
        MIN(ag)
    FROM
        (SELECT
            ROUND(AVG(salary), 2) ag,
            department_id
        FROM
            employees
        GROUP BY department_id) ag_dep);

# ④ 查询部门信息
 SELECT
    d.*
FROM
    departments d
WHERE d.`department_id` =
    (SELECT
        department_id
    FROM
        employees
    GROUP BY department_id
    HAVING ROUND(AVG(salary), 2) =
        (SELECT
            MIN(ag)
        FROM
            (SELECT
                ROUND(AVG(salary), 2) ag,
                department_id
            FROM
                employees
            GROUP BY department_id) ag_dep));

/*
		3. 查询平均工资最低的部门信息和该部门的平均工资
*/
# ① 先查每个部门的平均工资
 SELECT
    ROUND(AVG(salary), 2) ag,
    department_id
FROM
    employees
GROUP BY department_id;

# ② 将①升序排序，并只显示一行
 SELECT
    ROUND(AVG(salary), 2) ag,
    department_id
FROM
    employees
GROUP BY department_id
ORDER BY ag ASC
LIMIT 0, 1;

# ③ 查询部门信息
 SELECT
    d.*,
    ag
FROM
    departments d
    INNER JOIN
        (SELECT
            ROUND(AVG(salary), 2) ag,
            department_id
        FROM
            employees
        GROUP BY department_id
        ORDER BY ag ASC
        LIMIT 0, 1) ag_dep
        ON ag_dep.department_id = d.`department_id`;

/*
		4. 查询平均工资最高的 job 信息
*/
# ① 查询平均工资最高的工种id将按降序排序，选择出最高的平均工资的工种id
 SELECT
    AVG(salary) ag,
    job_id
FROM
    employees
GROUP BY job_id
ORDER BY ag DESC
LIMIT 0, 1;

# ② 查询平均工资最高的 job 信息。其job_id = ①中的job_id
 SELECT
    j.*
FROM
    jobs j
WHERE j.`job_id` =
    (SELECT
        job_id
    FROM
        employees
    GROUP BY job_id
    ORDER BY AVG(salary) DESC
    LIMIT 0, 1);

/*
		5. 查询平均工资高于公司平均工资的部门有哪些?	
*/
# ① 查询公司的平均工资
 SELECT
    AVG(salary)
FROM
    employees;

# ② 查询每部门的平均工资
 SELECT
    AVG(salary),
    department_id
FROM
    employees
GROUP BY department_id;

# ③ 查询 ②中哪些比①大
###方式一：
 SELECT
    AVG(salary),
    department_id
FROM
    employees
GROUP BY department_id
HAVING AVG(salary) >
    (SELECT
        AVG(salary)
    FROM
        employees);

###方式二：
 SELECT
    department_id
FROM
    (SELECT
        AVG(salary) ag,
        department_id
    FROM
        employees
    GROUP BY department_id) ag_dep
WHERE ag_dep.ag >
    (SELECT
        AVG(salary)
    FROM
        employees);

/*
		6. 查询出公司中所有 manager 的详细信息.
*/
# ① 查询出所有的manager_id
 SELECT DISTINCT
    manager_id
FROM
    employees;

# ② 查询出所有管理人员的员工号
 SELECT
    *
FROM
    employees e
WHERE e.`employee_id` IN
    (SELECT DISTINCT
        manager_id
    FROM
        employees);

# ③ 查询出所有员工号的详细信息连接其他表
 SELECT
    *
FROM
    employees e
    JOIN departments d
        ON e.`department_id` = d.`department_id`
    JOIN jobs j
        ON j.`job_id` = e.`job_id`
    JOIN `locations` l
        ON l.`location_id` = d.`location_id`
WHERE e.`employee_id` IN
    (SELECT
        `employee_id`
    FROM
        employees e
    WHERE e.`employee_id` IN
        (SELECT DISTINCT
            manager_id
        FROM
            employees));

/*
		7. 各个部门中 最高工资中最低的那个部门的 最低工资是多少
*/
# ① 各部门中的最高工资中最低的部门id，升序排序截取第一行
 SELECT
    MAX(salary) ms,
    department_id
FROM
    employees
GROUP BY department_id
ORDER BY ms ASC
LIMIT 0, 1;

# ② 查询部门id是①的最低工资
 SELECT
    MIN(salary),
    department_id
FROM
    employees
WHERE department_id =
    (SELECT
        department_id
    FROM
        employees
    GROUP BY department_id
    ORDER BY MAX(salary) ASC
    LIMIT 0, 1) #ONLY_FULL_GROUP_BY：对于GROUP BY聚合操作，如果在SELECT中的列，没有在GROUP BY中出现，那么这个SQL是不合法的，因为列不在GROUP BY从句中
 GROUP BY department_id;

#可以通过select @@sql_mode查出sql_mode
 SELECT
    @@sql_mode;

/*
		8. 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email,salary
*/
###方式一：
 # ① 查询平均工资最高的部门
 SELECT
    department_id
FROM
    employees
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 0, 1;

# ② 将employees 和departments连接查询，筛选条件为①
 SELECT
    `last_name`,
    d.`department_id`,
    `email`,
    salary
FROM
    employees e
    INNER JOIN departments d
        ON d.`manager_id` = e.`employee_id`
WHERE d.`department_id` =
    (SELECT
        department_id
    FROM
        employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 0, 1);

###方式二：
 # ① 查询平均工资最高的部门
 SELECT
    department_id
FROM
    employees
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 0, 1;

# ② 查询 ①部门的管理
 SELECT
    manager_id
FROM
    departments d
WHERE d.`department_id` =
    (SELECT
        department_id
    FROM
        employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 0, 1);

# ③ 由管理员id查询出详细信息
 SELECT
    last_name,
    department_id,
    email,
    salary
FROM
    employees e
WHERE e.`employee_id` =
    (SELECT
        manager_id
    FROM
        departments d
    WHERE d.`department_id` =
        (SELECT
            department_id
        FROM
            employees
        GROUP BY department_id
        ORDER BY AVG(salary) DESC
        LIMIT 0, 1));

/*
ONLY_FULL_GROUP_BY：对于GROUP BY聚合操作，如果在SELECT中的列，没有在GROUP BY中出现，那么这个SQL是不合法的，因为列不在GROUP BY从句中
NO_AUTO_VALUE_ON_ZERO：该值影响自增长列的插入。默认设置下，插入0或NULL代表生成下一个自增长值。如果用户希望插入的值为0，而该列又是自增长的，那么这个选项就有用了。
STRICT_TRANS_TABLES：在该模式下，如果一个值不能插入到一个事务表中，则中断当前的操作，对非事务表不做限制
NO_ZERO_IN_DATE：在严格模式下，不允许日期和月份为零
NO_ZERO_DATE：设置该值，mysql数据库不允许插入零日期，插入零日期会抛出错误而不是警告。
ERROR_FOR_DIVISION_BY_ZERO：在INSERT或UPDATE过程中，如果数据被零除，则产生错误而非警告。如果未给出该模式，那么数据被零除时MySQL返回NULL
NO_AUTO_CREATE_USER：禁止GRANT创建密码为空的用户
NO_ENGINE_SUBSTITUTION：如果需要的存储引擎被禁用或未编译，那么抛出错误。不设置此值时，用默认的存储引擎替代，并抛出一个异常
PIPES_AS_CONCAT：将”||”视为字符串的连接操作符而非或运算符，这和Oracle数据库是一样的，也和字符串的拼接函数Concat相类似

*/
