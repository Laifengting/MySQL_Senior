/*
		1.  查询和 Zlotkey 相同部门的员工姓名和工资
*/
# ① 查询Zlotkey的部门
 SELECT
    department_id
FROM
    employees
WHERE last_name = 'Zlotkey';

# ② 查询与①部门相同的员工姓名和工资
 SELECT
    last_name,
    salary
FROM
    employees e
WHERE e.`department_id` =
    (SELECT
        department_id
    FROM
        employees
    WHERE last_name = 'Zlotkey');

/*
		2. 查询工资比公司平均工资高的员工的员工号，姓名和工资。
*/
# ① 查询公司的平均工资
 SELECT
    ROUND(AVG(salary), 2)
FROM
    employees;

# ② 查询比①高的员工号，姓名和工资
 SELECT
    e.employee_id,
    e.last_name,
    e.salary
FROM
    employees e
WHERE e.`salary` >
    (SELECT
        ROUND(AVG(salary), 2)
    FROM
        employees);

/*
		3. 查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资
*/
# ① 查询各部门的平均工资
 SELECT
    ROUND(AVG(salary), 2),
    department_id
FROM
    employees
GROUP BY department_id;

# ② 查询每部门中比本部门①高的员工的员工号，姓名和工资
 SELECT
    e.employee_id,
    e.last_name,
    e.salary
FROM
    employees e
    INNER JOIN
        (SELECT
            ROUND(AVG(salary), 2) ag,
            department_id did
        FROM
            employees
        GROUP BY department_id) da
        ON e.`department_id` = da.did
WHERE e.`salary` > da.ag;

/*
		4. 查询 和【姓名中包含字母 u 的员工】在相同部门的员工的员工号和姓名
*/
# ① 查询姓名中包含字母 u 的员工的部门
 SELECT DISTINCT
    department_id
FROM
    employees
WHERE last_name LIKE '%u%';

# ② 查询部门和①相同的员工的员工号和姓名
 SELECT
    employee_id,
    department_id,
    last_name
FROM
    employees
WHERE department_id IN
    (SELECT DISTINCT
        department_id
    FROM
        employees
    WHERE last_name LIKE '%u%');

/*
		5. 查询在部门的 location_id 为 1700 的部门工作的员工的员工号
*/
# ① 查询location_id 为1700的部门
 SELECT DISTINCT
    department_id
FROM
    departments
WHERE location_id = 1700;

# ② 查询 在①中工作的员工的员工号
 SELECT
    employee_id
FROM
    employees
WHERE department_id IN # IN可以替换为 = ANY
     (SELECT DISTINCT
        department_id
    FROM
        departments
    WHERE location_id = 1700);

/*
		6. 查询管理者是 King 的员工姓名和工资
*/
# ① 查询King的员工号
 SELECT
    employee_id
FROM
    employees
WHERE last_name = 'k_ing';

# ② 查询管理者的员工号是①的员工姓名和工资
 SELECT
    last_name,
    salary
FROM
    employees e
WHERE e.`manager_id` IN
    (SELECT
        employee_id
    FROM
        employees
    WHERE last_name = 'k_ing');

/*
		7. 查询工资最高的员工的姓名，要求 first_name 和 last_name 显示为一列，列名为 姓.名
*/
# ① 查询最高工资
 SELECT
    MAX(salary)
FROM
    employees;

# ② 查询工资等于①的员工的姓名
 SELECT
    CONCAT(first_name, last_name) `姓.名`
FROM
    employees
WHERE salary =
    (SELECT
        MAX(salary)
    FROM
        employees);

