/*
		一、查询每个专业的学生人数
*/
SELECT COUNT(*),
	   majorid
	FROM student
	GROUP BY majorid;

/*
		二、查询参加考试的学生中，每个学生的平均分、最高分
*/
SELECT AVG(score),
	   MAX(score),
	   studentno
	FROM result
	GROUP BY studentno;

/*
		三、查询姓张的每个学生的最低分大于60的学号、姓名
*/
SELECT s.studentno,
	   s.studentname,
	   MIN(score)
	FROM student s
	JOIN result  r
		 ON s.studentno = r.studentno
	WHERE studentname LIKE '张%'
	GROUP BY s.studentno
	HAVING MIN(score) > 60;

/*
		四、查询专业生日在“1988-1-1”后的学生姓名、专业名称
*/
SELECT s.studentname,
	   m.majorname,
	   s.borndate
	FROM student s
	JOIN major   m
		 ON s.majorid = m.majorid #  WHERE s.`borndate` > '1988-1-1';
	WHERE DATEDIFF(s.borndate,'1988-1-1') > 0;

/*
		五、查询每个专业的男生人数和女生人数分别是多少
*/
###方式一：
SELECT COUNT(*) 人数,
	   sex,
	   majorid
	FROM student
	GROUP BY sex,
			 majorid;

###方式二：
SELECT SUM(sex = '男') 男生人数,
	   SUM(sex = '女') 女生人数,
	   majorid
	FROM student
	GROUP BY majorid;

###方式三：
SELECT majorid,
	   (
	   SELECT COUNT(*)
		   FROM student
		   WHERE sex = '男'
			 AND majorid = s.majorid) 男生,
	   (
	   SELECT COUNT(*)
		   FROM student
		   WHERE sex = '女'
			 AND majorid = s.majorid) 女生
	FROM student s
	GROUP BY majorid;

###方式四：
# ① 每个专业的总人数
SELECT COUNT(*) 女生人数,
	   majorid
	FROM student #WHERE sex = '女'
	GROUP BY majorid;

# ② 每个专业的男生人数
SELECT COUNT(*) 男生人数,
	   majorid
	FROM student
	WHERE sex = '男'
	GROUP BY majorid;

# ③ 合并两个表
SELECT 女生人数,
	   男生人数,
	   b1.majorid
	FROM (
		 SELECT COUNT(*) 女生人数,
				majorid
			 FROM student
			 WHERE sex = '女'
			 GROUP BY majorid) b1
	JOIN
	(
	SELECT COUNT(*) 男生人数,
		   majorid
		FROM student
		WHERE sex = '男'
		GROUP BY majorid)      b2
	ON b1.majorid = b2.majorid;

/*
		六、查询专业和张翠山一样的学生的最低分
*/
# ① 查询张翠山的专业
SELECT majorid
	FROM student
	WHERE studentname = '张翠山';

# ② 和①一样专业的学生有哪些学号
SELECT studentno
	FROM student
	WHERE majorid =
		  (
		  SELECT majorid
			  FROM student
			  WHERE studentname = '张翠山');

# ③ 从②中筛选出最低分
SELECT MIN(score)
	FROM result
	WHERE studentno IN
		  (
		  SELECT studentno
			  FROM student
			  WHERE majorid =
					(
					SELECT majorid
						FROM student
						WHERE studentname = '张翠山'));

/*
		七、查询大于60分的学生的姓名、密码、专业名
*/
###方式一：
SELECT studentname,
	   loginpwd,
	   majorname
	FROM student s
	JOIN major   m
		 ON s.majorid = m.majorid
	JOIN result  r
		 ON r.studentno = s.studentno
	WHERE r.score > 60;


###方式二：
# ① 查询大于60分的学生的学号
SELECT studentno
	FROM result
	WHERE score > 60;

# ② 查询学号是①中的学生的姓名，字码，专业名
SELECT s.studentname,
	   s.loginpwd,
	   m.majorname
	FROM student s
	JOIN major   m
		 ON s.majorid = m.majorid
	WHERE s.studentno = ANY
		  (
		  SELECT studentno
			  FROM result
			  WHERE score > 60);

/*
		八、按邮箱位数分组，查询每组的学生个数
*/
SELECT COUNT(*),
	   LENGTH(email)
	FROM student
	GROUP BY LENGTH(email);

/*
		九、查询学生名、专业名、分数
*/
SELECT s.studentname,
	   majorname,
	   score
	FROM student     s
	JOIN      major  m
			  ON s.majorid = m.majorid
	LEFT JOIN result r
			  ON r.studentno = s.studentno;

/*
		十、查询哪个专业没有学生，分别用左连接和右连接实现
*/
###左外连接实现
SELECT m.majorid, m.majorname, s.studentno
	FROM major        m
	LEFT JOIN student s
			  ON m.majorid = s.majorid
	WHERE s.studentno IS NULL;

###右外连接实现
SELECT m.majorid, m.majorname, s.studentno
	FROM student     s
	RIGHT JOIN major m
			   ON m.majorid = s.majorid
	WHERE s.studentno IS NULL;



/*
		十一、查询没有成绩的学生人数
*/
###方式一：
SELECT COUNT(*)
	FROM student     s
	LEFT JOIN result r
			  ON s.studentno = r.studentno
	WHERE r.score IS NULL;

