--触发器，就是制定一个规则，在我们做【增删改】操作的时候，只要满足该规则，自动触发，无需调用。

--语句级触发器：不包含有FOR EACH ROW的。

--行级触发器：包含有FOR EACH ROW的就是行级触发器。
--加FOR EACH ROW是为了使用:OLD或者:NEW对象或者一行记录。
--语句级触发器
--【案例】插入一条记录，输出一个新员工入职
CREATE OR REPLACE TRIGGER t1
	AFTER INSERT ON person
DECLARE

BEGIN
	dbms_output.put_line('一个新员工入职');
END;

--触发t1

INSERT INTO person
VALUES
	(1,
	 '小红');
COMMIT;
SELECT *
FROM   person;


--行级触发器
--【案例】不能给员工降薪。
-- raise_application_error(-20001~-20999之间,'错误提示信息');
CREATE OR REPLACE TRIGGER t2
    BEFORE UPDATE ON emp
    FOR EACH ROW
DECLARE
BEGIN
    IF :old.sal > :new.sal THEN
        raise_application_error(-20001,
                                '不能给员工降薪');
    END IF;
END;


--触发t2
SELECT * FROM emp where empno = 7788;

UPDATE emp
SET    sal = sal - 1
WHERE  empno = 7788;
COMMIT;



--触发器实现主键自增。【行级触发器】
--分析：在用户做插入操作的之前，拿到即将插入的数据，给该数据中的主键列赋值。
CREATE OR REPLACE TRIGGER auid
	BEFORE INSERT ON person
	FOR EACH ROW
DECLARE
BEGIN
	SELECT s_person.nextval
	INTO   :new.pid
	FROM   dual;
END;


--使得AUID实现主键自增
INSERT INTO person
	(pname)
VALUES
	('a');
COMMIT;

--查询PERSON表数据
SELECT *
FROM   person;












