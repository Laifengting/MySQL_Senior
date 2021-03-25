/*
		任何操作之前都先打开库
*/
USE myemployees;

/*
已知表	stuinfo

id			学号
name		姓名
email		邮箱	john@126.com
gradeId		年级编号
sex			性别	男  女
age			年龄

已知表	grade
id			年级编号
gradeName	年级名称
*/
/*
		一、查询所有学员的邮箱的用户名(注：邮箱中@前面的字符)
*/
SELECT
    SUBSTR(email, 1, INSTR(email, '@') - 1) AS 用户名
FROM
    stuinfo;

/*
		二、查询男生和女生的个数
*/
SELECT
    COUNT(*)
FROM
    stuinfo
GROUP BY sex;

/*
		三、查询年龄>18岁的所有学生的姓名和年级名称
*/
SELECT
    `name`,
    gradeName
FROM
    stuinfo s,
    INNER JOIN grade g
        ON s.gradeId = g.id
WHERE age > 18;

/*
		四、查询哪个年级的学生最小年龄>20岁
*/
SELECT
    gradeId,
    MIN(age)
FROM
    stuinfo
GROUP BY gradeId
HAVING MIN(age) > 20;

/*
		五、试说出查询语句中涉及到的所有的关键字，以后执行先后顺序
*/
					SELECT 查询列表		-------------------(7)
					FROM 表		---------------------------(1)
					连接类型 JOIN 表2		---------------(2)
					ON 连接条件		-----------------------(3)
					WHERE 筛选条件		-------------------(4)
					GROUP BY 分组列表		---------------(5)
					HAVING 分组后的筛选条件		-----------(6)
					ORDER BY 排序列表		---------------(8)
					LIMIT 偏移，条目数		---------------(9)









