/*
		一、查询编号>3 的女神的男朋友信息，如果有则列出详细，如果没有，用 null 填充
*/
USE girls;

SELECT bo.*,
	   b.*
	FROM beauty          b
	LEFT OUTER JOIN boys bo
					ON b.boyfriend_id = bo.id
	WHERE b.id > 3;

/*
		二、查询哪个城市没有部门
*/
USE myemployees;

SELECT l.city,
	   d.department_id
	FROM locations              l
	LEFT OUTER JOIN departments d
					ON d.location_id = l.location_id
	WHERE d.department_id IS NULL;

/*
		三、查询部门名为 SAL 或 IT 的员工信息
*/
USE myemployees;

SELECT e.*,
	   d.department_name,
	   d.department_id
	FROM departments          d
	LEFT OUTER JOIN employees e
					ON d.department_id = e.department_id
	WHERE d.department_name IN ('SAL', 'IT');

SELECT *
	FROM departments d
	WHERE d.department_name IN ('SAL', 'IT');