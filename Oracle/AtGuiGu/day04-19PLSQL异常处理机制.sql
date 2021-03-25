--异常错误处理
/*
一个优秀的程序都应该能够正确处理各种出错情况，并尽可能从错误中恢复。ORACLE 提供异常情况
(EXCEPTION)和异常处理(EXCEPTION HANDLER)来实现错误处理。
§5.1  异常处理概念
异常情况处理(EXCEPTION) 是用来处理正常执行过程中未预料的事件, 程序块的异常处理预定义的错误
和 自定义错误, 由于 PL/SQL  程序块一旦产 生异常而没有指出如何处理时, 程序就会自动终止整个程序运行.
有三种类型的异常错误：

1.  预定义 ( Predefined ) 错误
ORACLE 预定义的异常情况大约有 24 个。对这种异常情况的处理，无需在程序中定义，由 由 ORACLE  自动
将其引发。

2.  非预定义 ( Predefined )错误
即其他标准的 ORACLE 错误。对这种异常情况的处理，需要用户在程序中定义，然后由 ORACLE 自动将
其引发。

3． 用户定义(User_define) 错误
程序执行过程中，出现编程人员认为的非正常情况。对这种异常情况的处理， 需要 用户在程序中定义，
然后显式地在程序中将其引发。

异常处理部分一般放在 PL/SQL 程序体的后半部,结构为:
EXCEPTION
WHEN first_exception THEN <code to handle first exception >
WHEN second_exception THEN <code to handle second exception >
WHEN OTHERS THEN <code to handle others exception >
END;
异常处理可以按任意次序排列,但 OTHERS 必须放在最后.

§5.1.1  预定义的异常处理
预定义说明的部分 ORACLE 异常错误
错误号    SQLCODE值  异常错误信息名称            说明
ORA-00001   -1      Dup_val_on_index        试图破坏一个唯一性限制
ORA-00051   -51     Timeout-on-resource     在等待资源时发生超时
ORA-00061   -0061   Transaction-backed-out  由于发生死锁事务被撤消
ORA-01001   -1001   Invalid-CURSOR          试图使用一个无效的游标
ORA-01012   -1012   Not-logged-on           没有连接到 ORACLE
ORA-01017   -1017   Login-denied            无效的用户名/口令
ORA-01403   -1403   No_data_found           SELECT INTO 没有找到数据
ORA-01410   -1410   SYS_INVALID_ROWID   从字符串向ROWID转换发生错误，因为字符串并不代表一个有效的ROWID。
ORA-01422   -1422   Too_many_rows       SELECT INTO 返回多行
ORA-01476   -1476   Zero-divide             试图被零除
ORA-01722   -1722   Invalid-NUMBER          转换一个数字失败
ORA-06500   -6500   Storage-error       内存不够引发的内部错误
ORA-06501   -6501   Program-error       内部错误
ORA-06502   -6502   Value-error             发生算术、转换、截断或长度约束错误
ORA-06504   -6504   Rowtype-mismatch        宿主游标变量与 PL/SQL 变量有不兼容行类型
ORA-06511   -6511   CURSOR-already-OPEN     试图打开一个已存在的游标
ORA-06530   -6530   Access-INTO-null        试图为 null 对象的属性赋值
ORA-06531   -6531   Collection-is-null      试图将 Exists 以外的集合( collection)方法应用于一个 null pl/sql 表上或 varray 上
ORA-06532   -6532   Subscript-outside-limit 对嵌套或 varray 索引得引用超出声明范围以外
ORA-06533   -6533   Subscript-beyond-count  对嵌套或 varray 索引得引用大于集合中元素的个数.
ORA-06592   -6592   CASE_NOT_FOUND          CASE语句中没有任何WHEN子句满足条件，并且没有编写ELSE子句。
ORA-3062    -30625  SELF_IS_NULL            程序尝试调用一个空实例的MEMBER方法。也就是内置参数SELF(它总是第一个传递到MEMBER方法的参数)是空。


对这种异常情况的处理，只需在 PL/SQL 块的异常处理部分，直接引用相应的异常情况名，并对其完成
相应的异常错误处理即可。
*/

--预定义的异常处理
DECLARE
	v_salary employees.salary%TYPE;

BEGIN
	SELECT salary
	INTO   v_salary
	FROM   employees
	WHERE  employee_id > 100;

	dbms_output.put_line(v_salary);

EXCEPTION
	WHEN too_many_rows THEN
		dbms_output.put_line('输出多行');
	WHEN OTHERS THEN
		dbms_output.put_line('出现其他类型异常');
	
END;

--非预定义的异常处理
/*
对于这类异常情况的处理，首先必须对非定义的 ORACLE 错误进行定义。步骤如下：
1.  在 PL/SQL  块的定义部分定义异常情况：
<异常情况> EXCEPTION;
2.  将其定义好的异常情况，与标准的 ORACLE  错误联系起来，使用 PRAGMA EXCEPTION_INIT  语句：
PRAGMA EXCEPTION_INIT(< 异常情况>, < 错误代码>);
3.  在 PL/SQL 块的异常情况处理部分对异常情况做出相应的处理。
*/

DECLARE
	e_delete_id_exception EXCEPTION;
	PRAGMA EXCEPTION_INIT(e_delete_id_exception,
						  -2292);

BEGIN
	DELETE FROM employees
	WHERE  employee_id = 100;

EXCEPTION
	WHEN e_delete_id_exception THEN
		dbms_output.put_line('违反完整性约束条件，故不可删除此用户');
	
END;

--用户自定义的异常处理
/*
当与一个异常错误相关的错误出现时，就会隐含触发该异常错误。 用户定义的异常错误是通过显式使
用 RAISE  语句来触发。当引发一个异常错误时，控制就转向到 EXCEPTION  块异常错误部分，执行错误处
理代码。
对于这类异常情况的处理，步骤如下：
1． 在 PL/SQL  块的定义部分定义异常情况：
    < 异常情况> EXCEPTION;
2． RAISE < 异常情况>；
3． 在 PL/SQL  块的异常情况处理部分对异常情况做出相应的处理。
*/

DECLARE
	e_too_high_sal EXCEPTION;
	v_sal employees.salary%TYPE;

BEGIN
	SELECT salary
	INTO   v_sal
	FROM   employees
	WHERE  employee_id = 100;
	IF v_sal > 10000 THEN
		RAISE e_too_high_sal;
	END IF;

EXCEPTION
	WHEN e_too_high_sal THEN
		dbms_output.put_line('工资太高');
	
END;

--异常整合

DECLARE
	e_too_high_sal EXCEPTION;
	v_sal employees.salary%TYPE;

	e_delete_id_exception EXCEPTION;
	PRAGMA EXCEPTION_INIT(e_delete_id_exception,
						  -2292);

BEGIN
	SELECT salary
	INTO   v_sal
	FROM   employees
	WHERE  employee_id = 100;
	IF v_sal > 10000 THEN
		RAISE e_too_high_sal;
	END IF;

	DELETE FROM employees
	WHERE  employee_id = 100;

EXCEPTION
	WHEN e_too_high_sal THEN
		dbms_output.put_line('工资太高');
	
	WHEN e_delete_id_exception THEN
		dbms_output.put_line('违反完整性约束条件，故不可删除此用户');
	
	WHEN OTHERS THEN
		dbms_output.put_line('出现其他类型异常');
	
END;

--18. 异常的基本程序: 通过 select ... into ... 查询某人的工资, 若没有查询到, 则输出 "未找到数据"
--定义一个
DECLARE
	v_sal employees.salary%TYPE;
BEGIN
	SELECT salary
	INTO   v_sal
	FROM   employees
	WHERE  employee_id = 1000;
EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('未找到数据');
	
END;

--定义多个
DECLARE
	v_sal employees.salary%TYPE;
BEGIN
	SELECT salary
	INTO   v_sal
	FROM   employees;
EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('查无此人');
	WHEN too_many_rows THEN
		dbms_output.put_line('输出多行');
	
END;

--19. 更新指定员工工资，如工资小于300，则加100；对 NO_DATA_FOUND 异常, TOO_MANY_ROWS 进行处理.
DECLARE
	v_sal employees.salary%TYPE;
BEGIN
	SELECT salary
	INTO   v_sal
	FROM   employees
	WHERE  employee_id = 101;

	IF v_sal < 300 THEN
		UPDATE employees
		SET    salary = salary + 100
		WHERE  employee_id = 101;
	END IF;

EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('查无此人');
	WHEN too_many_rows THEN
		dbms_output.put_line('输出多行');
	
END;

--自定义异常: 更新指定员工工资，增加100；若该员工不存在则抛出用户自定义异常: no_result
DECLARE
	--自定义异常                                   
	no_result EXCEPTION;
BEGIN
	UPDATE employees
	SET    salary = salary + 100
	WHERE  employee_id = 1001;

	--使用隐式游标, 抛出自定义异常
	IF SQL%NOTFOUND THEN
		RAISE no_result;
	END IF;

EXCEPTION

	--处理程序抛出的异常
	WHEN no_result THEN
		dbms_output.put_line('更新失败');
END;

--在 PL/SQL  中使用 SQLCODE, SQLERRM
/*
SQLCODE  返回错误代码数字
SQLERRM  返回错误信息.
如: SQLCODE=-100  SQLERRM=’no_data_found ‘
SQLCODE=0  SQLERRM=’normal, successfual completion’
*/

--例 5. 将 ORACLE 错误代码及其信息存入错误代码表
CREATE TABLE errors(errnum NUMBER(4),
					errmsg VARCHAR2(100));
DECLARE
	err_msg VARCHAR2(100);
BEGIN
	/* 得到所有 ORACLE 错误信息 */
	FOR err_num IN -100 .. 0
	LOOP
		err_msg := SQLERRM(err_num);
		INSERT INTO errors
		VALUES
			(err_num,
			 err_msg);
	END LOOP;
END;
drop TABLE errors;

--例 6. 查询 ORACLE 错误代码；
BEGIN
	INSERT INTO emp
		(empno,
		 ename,
		 hiredate,
		 deptno)
	VALUES
		(2222,
		 ‘jerry’,
		 SYSDATE,
		 20);
	dbms_output.put_line('插入数据记录成功!');
	INSERT INTO emp
		(empno,
		 ename,
		 hiredate,
		 deptno)
	VALUES
		(2222,
		 ‘jerry’,
		 SYSDATE,
		 20);
	dbms_output.put_line('插入数据记录成功!');
EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line(SQLCODE || '---' || SQLERRM);
END;
