--PL/SQL中的IF判断
--【案例】输入小于18的数字，输出未成年，输入大于18小于40的数字，输出中年人，输入大于40的数字，输出老年人。

DECLARE
	i NUMBER(3) := &ii;
BEGIN
	IF i < 18 THEN
		dbms_output.put_line('未成年');
	ELSIF i < 40 THEN
		dbms_output.put_line('中年人');
	ELSE
		dbms_output.put_line('老年人');
	END IF;
END;
