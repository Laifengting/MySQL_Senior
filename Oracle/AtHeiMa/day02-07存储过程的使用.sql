--存储过程
--存储过程就是提前已经编译好的一段PL/SQ语言，放置在数据库端，可以直接被调用。这一段PL/SQL一般都是固定步骤的业务。
--语法：
/*
    CREATE [OR REPLACE] PROCEDURE 存储过程名[(参数名 IN/OUT 数据类型)] AS[IS]
    BEGIN
        PLSQL 子程序体;
    END;
        
    或
        
    CREATE [OR REPLACE] PROCEDURE  存储过程名[( 参数名 IN/OUT  数据类型)]IS[AS]
    BEGIN
    PLSQL 子程序体；
    END 过程名;
*/

--给指定员工涨100元钱
CREATE OR
REPLACE procedure pl(eno emp.empno%TYPE) AS
BEGIN
UPDATE emp
SET
	sal = sal + 100
	WHERE empno = eno;
COMMIT;
END;

SELECT *
	FROM emp
	WHERE empno = 7788;

--测试存储过程PL
DECLARE
BEGIN
	pl
(7788);
END;
