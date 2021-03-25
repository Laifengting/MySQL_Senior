--触发器
/*
触发器是许多关系数据库系统都提供的一项技术。在 ORACLE 系统里， 触发器类似过程和函数，都有
声明，执行和异常处理过程的 PL/SQL  块。

*/


--触发器类型
/*
触发器在数据库里以独立的对象存储，它与存储过程不同的是，存储过程通过其它程序来启动运行或直接启动运行，
而触发器是由一个事件来启动运行。 即触发器是当某个事件发生时自动地隐式运行。并且，触发器不能接收参数。
所以 运行触发器就叫触发或点火（firing） ）。
ORACLE 事件指的是对数据库的表进行的INSERT 、UPDATE 及 DELETE 操作或对视图进行类似的操作。
ORACLE 将触发器的功能扩展到了触发 ORACLE，如数据库的启动与关闭等。
*/

--DML 触发器
/*
ORACLE 可以在 DML 语句进行触发，可以在 DML 操作前或操作后进行触发，并且 可以对每个行或语句操作上进行触发。
*/

--替代触发器
/*
由于在 ORACLE 里，不能直接对由两个以上的表建立的视图进行操作。所以给出了替代触发器。
*/

--系统触发器
/*
它可以在 ORACLE 数据库系统的事件中进行触发，如 ORACLE 系统的启动与关闭等。
*/


--触发器组成:
/*
  触发事件：即在何种情况下触发 TRIGGER; 例如：INSERT, UPDATE, DELETE。
  触发时间：即该 TRIGGER 是在触发事件发生之前（BEFORE）还是之后(AFTER)触发，也就是触发事件和
该 TRIGGER 的操作顺序。
  触发器本身：即该 TRIGGER 被触发之后的目的和意图，正是触发器本身要做的事情。 例如：PL/SQL 块。
  触发频率：说明触发器内定义的动作被执行的次数。即 语句级(STATEMENT) 触发器和行级(ROW) 触发器。

        语句级(STATEMENT)触发器：是指当某触发事件发生时，该触发器只执行一次；
        行级(ROW)触发器：是指当某触发事件发生时，对受到该操作影响的每一行数据，触发器都单独执行一次。
*/

--创建触发器
/*
创建触发器的一般语法是:
CREATE [OR REPLACE] TRIGGER trigger_name
{BEFORE | AFTER }
{INSERT | DELETE | UPDATE [OF column [, column …]]}
ON [schema.] table_name 
[FOR EACH ROW ]--省略会在更新完最后一行执行触发器
[WHEN condition]
trigger_body;

其中：
BEFORE 和 AFTER 指出触发器的触发时序分别为前触发和后触发方式，前触发是在执行触发事件之前触
发当前所创建的触发器，后触发是在执行触发事件之后触发当前所创建的触发器。
FOR EACH ROW 选项说明触发器为行触发器。 行触发器和语句触发器的区别表现在：行触发器要求当一
个 DML 语句操做影响数据库中的多行数据时，对于其中的每个数据行，只要它们符合触发约束条件，均激
活一次触发器；而语句触发器将整个语句操作作为触发事件，当它符合约束条件时，激活一次触发器。 当
省略 FOR EACH ROW  选项时，BEFORE 和 AFTER 触发器为 语句触发器，而 INSTEAD OF 触发器则为行触发
器。

WHEN 子句说明触发约束条件。Condition 为一个逻辑表达时，其中必须包含相关名称，而不能包含查
询语句，也不能调用 PL/SQL 函数。WHEN 子句指定的触发约束条件只能用在 BEFORE 和 AFTER 行触发器
中，不能用在 INSTEAD OF 行触发器和其它类型的触发器中。
当一个基表被修改( INSERT, UPDATE, DELETE)时要执行的存储过程，执行时根据其所依附的基表改动而自
动触发，因此与应用程序无关，用数据库触发器可以保证数据的一致性和完整性。

每张表最多可建立 12 种类型的触发器，它们是:
BEFORE INSERT
BEFORE INSERT FOR EACH ROW
AFTER INSERT
AFTER INSERT FOR EACH ROW
BEFORE UPDATE
BEFORE UPDATE FOR EACH ROW
AFTER UPDATE
AFTER UPDATE FOR EACH ROW
BEFORE DELETE
BEFORE DELETE FOR EACH ROW
AFTER DELETE
AFTER DELETE FOR EACH ROW
*/

--创建一个触发器
--一个helloworld级别的触发器
CREATE OR REPLACE TRIGGER update_emp_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
	dbms_output.put_line('HelloWorld');
END;
--然后执行：
UPDATE employees SET salary = salary + 1000;
ROLLBACK;


--28. 触发器的 helloworld: 编写一个触发器, 在向 emp 表中插入记录时, 打印 'helloworld'

CREATE OR REPLACE TRIGGER emp_trigger
	AFTER INSERT ON emp
	FOR EACH ROW
BEGIN
	dbms_output.put_line('helloworld');
END;

--29. 行级触发器: 每更新 employees 表中的一条记录, 都会导致触发器执行

CREATE OR REPLACE TRIGGER employees_trigger
	AFTER UPDATE ON employees
	FOR EACH ROW
BEGIN
	dbms_output.put_line('修改了一条记录!');
END;


--语句级触发器: 一个 update/delete/insert 语句只使触发器执行一次

CREATE OR REPLACE TRIGGER employees_trigger
	AFTER UPDATE ON employees
BEGIN
	dbms_output.put_line('修改了一条记录!');
END;


--触发器触发次序
/*
1.  执行 BEFORE  语句级触发器;
2.  对与受语句影响的每一行：
  执行 BEFORE  行级触发器
  执行 DML 语句
  执行 AFTER  行级触发器
3.  执行 AFTER  语句级触发器
*/

--创建 DML 触发器
/*
触发器名可以和表或过程有相同的名字，但在一个模式中触发器名不能相同。

触发器的限制
  CREATE TRIGGER 语句文本的字符长度不能超过 32KB；
  触发器体内的 SELECT  语句只能为 SELECT … INTO … 结构，或者为定义游标所使用的 SELECT  语句。
  触发器中不能使用数据库事务控制语句 COMMIT; ROLLBACK, SVAEPOINT 语句；
  由触发器所调用的过程或函数也不能使用数据库事务控制语句；

问题：当触发器被触发时，要使用被插入、更新或删除的记录中的列值，有时要使用操作前、 后
列的值.

实现: :NEW 修饰符访问操作完成后列的值
		:OLD 修饰符访问操作完成前列的值

特性  INSERT  UPDATE  DELETE
OLD  NULL  有效  有效
NEW  有效  有效  NULL
*/
--复制一张表
create table emp1 as
select * from employees
where department_id = 80;

--30. 使用 :new, :old 修饰符
SELECT * FROM emp1;

CREATE OR REPLACE TRIGGER update_emp1_trigger
	AFTER UPDATE ON emp1
	FOR EACH ROW
BEGIN
	dbms_output.put_line('Old:Salary: ' || :old.salary || ', New:Salry: ' || :new.salary);
END;

--修改salary触发触发器。
UPDATE emp1
SET    salary = salary + 100;



--创建替代(INSTEAD OF) 触发器
/*
创建触发器的一般语法是:
CREATE [OR REPLACE] TRIGGER trigger_name
INSTEAD OF
{INSERT | DELETE | UPDATE [OF column [, column …]]}
ON [schema.] view_name
[FOR EACH ROW ]
[WHEN condition]
trigger_body;

其中：
BEFORE 和 AFTER 指出触发器的触发时序分别为前触发和后触发方式，前触发是在执行触发事件之前触
发当前所创建的触发器，后触发是在执行触发事件之后触发当前所创建的触发器。
INSTEAD OF 选项使 ORACLE 激活触发器，而不执行触发事件。 只能对视图和对象视图建立 INSTEAD OF
触发器，而不能对表、模式和数据库建立 INSTEAD OF 触发器。
FOR EACH ROW 选项说明触发器为行触发器。行触发器和语句触发器的区别表现在：行触发器要求当一
个 DML 语句操做影响数据库中的多行数据时，对于其中的每个数据行，只要它们符合触发约束条件，均激
活一次触发器；而语句触发器将整个语句操作作为触发事件，当它符合约束条件时，激活一次触发器。当
省略 FOR EACH ROW 选项时，BEFORE 和 AFTER 触发器为语句触发器，而 INSTEAD OF 触发器则为行触发器。
WHEN 子句说明触发约束条件。Condition 为一个逻辑表达时，其中必须包含相关名称，而不能包含查
询语句，也不能调用 PL/SQL 函数。WHEN 子句指定的触发约束条件只能用在 BEFORE 和 AFTER 行触发器
中，不能用在 INSTEAD OF 行触发器和其它类型的触发器中。

INSTEAD_OF 用于对视图的 DML 触发，由于视图有可能是由多个表进行联结(join)而成，因而并非是所
有的联结都是可更新的。但可以按照所需的方式执行更新，例如下面情况：
CREATE OR REPLACE VIEW emp_view AS
SELECT deptno, count(*) total_employeer, sum(sal) total_salary
FROM emp GROUP BY deptno;
在此视图中直接删除是非法：
SQL>DELETE FROM emp_view WHERE deptno=10;
DELETE FROM emp_view WHERE deptno=10
*
ERROR 位于第 1 行:
ORA-01732: 此视图的数据操纵操作非法
但是可以创建 INSTEAD_OF 触发器来为 DELETE 操作执行所需的处理，即删除 EMP 表中所有基准行：
CREATE OR REPLACE TRIGGER emp_view_delete
INSTEAD OF DELETE ON emp_view FOR EACH ROW
BEGIN
DELETE FROM emp WHERE deptno= :old.deptno;
END emp_view_delete;
DELETE FROM emp_view WHERE deptno=10;
DROP TRIGGER emp_view_delete;
DROP VIEW emp_view;
*/


--创建系统事件触发器
/*
ORACLE 提供的系统事件触发器可以在 DDL 或数据库系统上被触发。DDL 指的是数据定义语言，如
CREATE 、ALTER 及 DROP 等。而数据库系统事件包括数据库服务器的启动或关闭，用户的登录与退出、数
据库服务错误等。创建系统触发器的语法如下：
创建触发器的一般语法是:
CREATE OR REPLACE TRIGGER [sachema.] trigger_name
{BEFORE|AFTER}
{ddl_event_list | database_event_list}
ON { DATABASE | [schema.] SCHEMA }
[WHEN_clause]
trigger_body;
其中: ddl_event_list：一个或多个 DDL 事件，事件间用 OR 分开；
database_event_list：一个或多个数据库事件，事件间用 OR 分开；
系统事件触发器既可以建立在一个模式上，又可以建立在整个数据库上。当建立在模式(SCHEMA)之上
时，只有模式所指定用户的 DDL 操作和它们所导致的错误才激活触发器, 默认时为当前用户模式。当建立在
数据库(DATABASE)之上时，该数据库所有用户的 DDL 操作和他们所导致的错误，以及数据库的启动和关闭均
可激活触发器。要在数据库之上建立触发器时，要求用户具有 ADMINISTER DATABASE TRIGGER 权限。
下面给出系统触发器的种类和事件出现的时机（前或后）：
事件  允许的时机  说明
启动 STARTUP  之后  实例启动时激活
关闭 SHUTDOWN  之前  实例正常关闭时激活
服务器错误 SERVERERROR  之后  只要有错误就激活
登录 LOGON  之后  成功登录后激活
注销 LOGOFF  之前  开始注销时激活
创建 CREATE 之前，之后  在创建之前或之后激活
撤消 DROP  之前，之后  在撤消之前或之后激活
变更 ALTER  之前，之后  在变更之前或之后激活
*/


--系统触发器事件属性
/*
事件属性\事件		Startup/Shutdown  Servererror  Logon/Logoff  DDL	DML
事件名称		   ＊				＊			＊			＊		＊
数据库名称		  ＊
数据库实例号		 ＊
错误号								  ＊
用户名								  			   ＊		   ＊ 
模式对象类型													 ＊		＊
模式对象名称													 ＊		＊
列																	  ＊
*/


--除 DML 语句的列属性外，其余事件属性值可通过调用 ORACLE 定义的事件属性函数来读取。
/*
函数名称		数据类型				说 明
Sysevent		VARCHAR2（20）	  激活触发器的事件名称
Instance_num	NUMBER				数据库实例名
Database_name	VARCHAR2（50）	  数据库名称
Server_error(posi)  NUMBER			错误信息栈中 posi 指定位置中的错误号
Is_servererror(err_number)	BOOLEAN	检查 err_number 指定的错误号是否在错
                                    误信息栈中，如果在则返回 TRUE，否则
                                    返回 FALSE。在触发器内调用此函数可以
                                    判断是否发生指定的错误。
Login_user			 VARCHAR2(30)	登陆或注销的用户名称
Dictionary_obj_type  VARCHAR2(20)	DDL 语句所操作的数据库对象类型
Dictionary_obj_name  VARCHAR2(30)	DDL 语句所操作的数据库对象名称
Dictionary_obj_owner VARCHAR2(30)	DDL语句所操作的数据库对象所有者名称
Des_encrypted_password  VARCHAR2(2)	正在创建或修改的经过DES算法加密的用户口令
*/


--使用触发器谓词
/*
ORACLE 提供三个参数 INSERTING, UPDATING, DELETING 用于判断触发了哪些操作。
谓词  行为
INSERTING  如果触发语句是 INSERT 语句，则为 TRUE,否则为 FALSE
UPDATING  如果触发语句是 UPDATE 语句，则为 TRUE,否则为 FALSE
DELETING  如果触发语句是 DELETE 语句，则为 TRUE,否则为 FALSE
*/



--重新编译触发器
/*
如果在触发器内调用其它函数或过程，当这些函数或过程被删除或修改后，触发器的状态将被标识为
无效。当 DML 语句激活一个无效触发器时，ORACLE 将重新编译触发器代码，如果编译时发现错误，这将导
致 DML 语句执行失败。
在 PL/SQL 程序中可以调用 ALTER TRIGGER 语句重新编译已经创建的触发器，格式为：
ALTER TRIGGER [schema.] trigger_name COMPILE [ DEBUG]
其中：DEBUG 选项要器编译器生成 PL/SQL 程序条使其所使用的调试代码。
*/

--删除和使能触发器
/*
  删除触发器 ：
DROP TRIGGER trigger_name;
当删除其他用户模式中的触发器名称，需要具有 DROP ANY TRIGGER 系统权限，当删除建立在数据库上
的触发器时，用户需要具有 ADMINISTER DATABASE TRIGGER 系统权限。
此外， 当删除表或视图时，建立在这些对象上的触发器也随之删除。

	触发器的状态
数据库 TRIGGER 的状态：
有效状态(ENABLE)：当触发事件发生时，处于有效状态的数据库触发器 TRIGGER 将被触发。
无效状态(DISABLE)：当触发事件发生时，处于无效状态的数据库触发器 TRIGGER 将不会被触发，此时
就跟没有这个数据库触发器(TRIGGER) 一样。
数据库 TRIGGER 的这两种状态可以互相转换。格式为：
ALTER TIGGER trigger_name [DISABLE | ENABLE ];
例：ALTER TRIGGER emp_view_delete DISABLE;
ALTER TRIGGER 语句一次只能改变一个触发器的状态，而 ALTER TABLE 语句则一次能够改变与指定表相
关的所有触发器的使用状态。格式为：
ALTER TABLE [schema.]table_name {ENABLE|DISABLE} ALL TRIGGERS;
例：使表 EMP 上的所有 TRIGGER 失效：
ALTER TABLE emp DISABLE ALL TRIGGERS;
*/


--31. 编写一个触发器, 在对 my_emp 记录进行删除的时候, 在 my_emp_bak 表中备份对应的记录

--1). 准备工作:
create table my_emp as select employee_id id, last_name name, salary sal from employees;
    
create table my_emp_bak as select employee_id id, last_name name, salary sal from employees where 1 = 2;

--2). 
CREATE OR REPLACE TRIGGER bak_emp_trigger
	BEFORE DELETE ON my_emp
	FOR EACH ROW

BEGIN
	INSERT INTO my_emp_bak
	VALUES
		(:old.id,
		 :old.name,
		 :old.sal);
END;
