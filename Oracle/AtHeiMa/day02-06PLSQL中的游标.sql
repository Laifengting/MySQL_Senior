--游标：可以存放多个对象，多行记录。
--【案例】输出EMP表中所有员工的姓名

DECLARE
	CURSOR c1 IS
SELECT *
	FROM emp;
emprow emp%ROWTYPE;
BEGIN OPEN c1;

LOOP
		FETCH c1
			INTO emprow;
EXIT WHEN c1%NOTFOUND;
dbms_output.put_line(emprow.ename);
END LOOP;
CLOSE c1;
END;

--【案例】给指定部门员工涨工资

DECLARE
	CURSOR c2(eno emp.deptno%TYPE) IS
SELECT empno
	FROM emp
	WHERE deptno = eno;
en emp.empno%TYPE;
BEGIN OPEN c2(10);
LOOP
		FETCH c2
			INTO en;
EXIT WHEN c2 %NOTFOUND;
UPDATE emp
SET
	sal = sal + 100
	WHERE empno = en;
COMMIT;
END LOOP;
CLOSE c2;
END;

--查询10号部门员工信息

SELECT *
	FROM emp
	WHERE deptno = 10;
