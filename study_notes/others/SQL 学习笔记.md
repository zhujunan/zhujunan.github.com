# SQL 学习笔记

[MySQL基本概念](#MySQL基本概念)

[MySQL常用指令](#MySQL常用指令)

[MySQL条件语句](#MySQL条件语句)

[MySQL数据处理](#MySQL数据处理)
>[DQL语句](#DQL语句)  
>[DML语句](#DML语句)  
>[DDL语句](#DDL语句)  
>[TCL语句(数据库事务)](#TCL语句)  

[其它](#其它)
>[视图](#视图)  
>[存储过程](#存储过程)  
>[函数](#函数)  
>[流程控制结构](#流程控制结构)  

==============================================

# MySQL基本概念

### 变量

一、全局变量  

作用域：针对于所有会话（连接）有效，但不能跨重启

	查看所有全局变量
	SHOW GLOBAL VARIABLES;
	查看满足条件的部分系统变量
	SHOW GLOBAL VARIABLES LIKE '%char%';
	查看指定的系统变量的值
	SELECT @@global.autocommit;
	为某个系统变量赋值
	SET @@global.autocommit=0;
	SET GLOBAL autocommit=0;

二、会话变量  

作用域：针对于当前会话（连接）有效

	查看所有会话变量
	SHOW SESSION VARIABLES;
	查看满足条件的部分会话变量
	SHOW SESSION VARIABLES LIKE '%char%';
	查看指定的会话变量的值
	SELECT @@autocommit;
	SELECT @@session.tx_isolation;
	为某个会话变量赋值
	SET @@session.tx_isolation='read-uncommitted';
	SET SESSION tx_isolation='read-committed';

三、用户变量  

* 声明并初始化:	
		
		SET @变量名=值;
		SET @变量名:=值;
		SELECT @变量名:=值;				

* 赋值: 

		方式一： 一般用于赋简单的值
			SET 变量名=值;
			SET 变量名:=值;
			SELECT 变量名:=值;

		方式二： 一般用于赋表 中的字段值
			SELECT 字段名或表达式 INTO 变量
			FROM 表;
* 使用：

		select @变量名;

二、局部变量   

* 声明：
	
		declare 变量名 类型 【default 值】;

* 赋值：

		方式一： 一般用于赋简单的值
			SET 变量名=值;
			SET 变量名:=值;
			SELECT 变量名:=值;
	
		方式二： 一般用于赋表中的字段值
			SELECT 字段名或表达式 INTO 变量
			FROM 表;

* 使用：

		select 变量名

三、二者的区别：

	1.用户变量 作用域是当前会话
	  局部变量 作用域是定义它的BEGIN END中
	2.用户变量 定义位置是会话的任何地方
	  局部变量 定义位置是BEGIN END的第一句话
	3.用户变量 加@符号，不用指定类型
	  局部变量 一般不用加@,需要指定类型
  

### 常见的约束

	NOT NULL：非空，该字段的值必填
	UNIQUE：唯一，该字段的值不可重复
	DEFAULT：默认，该字段的值不用手动插入有默认值
	CHECK：检查，mysql不支持
	PRIMARY KEY：主键，该字段的值不可重复并且非空  unique+not null
	FOREIGN KEY：外键，该字段的值引用了另外的表的字段
	
### 其它

* ``着重号，区分同名命令和名称

* 表名.列名

* 别名

		(1)as
		(2)空格

*   

		AVG();SUM() 必须数值型
		MIN();MAX() 任意数据类型
	
		COUNT
		COUNT(*) 返回记录总数
		COUNT(expr) 返回expr不为空总数
		
		
		
	
# MySQL常用指令

1、字符函数

		concat拼接
		substr截取子串
		upper转换成大写
		lower转换成小写
		trim去前后指定的空格和字符
		ltrim去左边空格
		rtrim去右边空格
		replace替换
		lpad左填充
		rpad右填充
		instr返回子串第一次出现的索引
		length 获取字节个数
		
2、数学函数
	
		round 四舍五入
		rand 随机数
		floor向下取整
		ceil向上取整
		mod取余
		truncate截断

3、日期函数
	
		now当前系统日期+时间
		curdate当前系统日期
		curtime当前系统时间
		str_to_date 将字符转换成日期
		date_format将日期转换成字符
		
5、其他函数
		
		ifnull(字段名/函数,值)若字段为null，则返回指定值
		version版本
		database当前库
		user当前连接用户

# MySQL条件语句

### WHERE 条件语句

	where 
		条件 （>;&&;like；in（））;
	order by 
		排序的字段|表达式|函数|别名 【asc|desc】
	group by 
		分组字段		having 【分组后的筛选条件】
	like
		% 任意个字符	_一个字符
	limit 
		【起始的条目索引(默认0)，】条目数;

* 筛选

		分组前筛选：	原始表　	    　	group by的前面		where
		分组后筛选：	分组后的结果集	      group by的后面             having

* limit

		公式：select * from  表 limit （page-1）*sizePerPage,sizePerPage
		假如:
		每页显示条目数sizePerPage
		要显示的页数 page
		
### JOIN 连接

	笛卡尔乘积：当查询多个表时，没有添加有效的连接条件，导致多个表所有行实现完全连接
	select 字段1，字段2
	from 表1，表2,...;

	等值连接、非等值连接 （内连接）
	外连接
	交叉连接
	
	内连接 [inner] join on

	外连接
	左外连接 left  [outer] join on
	右外连接 right [outer] join on


### UNION 联合

	UNION 运算符通过组合其他两个结果表（例如 TABLE1 和 TABLE2）并消去表中任何重复行而派生出一个结果表。
	当 ALL 随 UNION 一起使用时（即 UNION ALL），不消除重复行。
	两种情况下，派生表的每一行不是来自 TABLE1 就是来自 TABLE2。

* 意义

		1、将一条比较复杂的查询语句拆分成多条语句
		2、适用于查询多个表的时候，查询的列基本是一致

### EXCEPT | INTERSECT

	（SQL查询语句1)
		EXCEPT | INTERSECT 
	（SQL查询语句2）
	
		EXCEPT 运算符
		EXCEPT 运算符通过包括所有在 TABLE1 中但不在 TABLE2 中的行并消除所有重复行而派生出一个结果表。
		当 ALL 随 EXCEPT 一起使用时 (EXCEPT ALL)，不消除重复行。
		INTERSECT 运算符
		INTERSECT 运算符通过只包括 TABLE1 和 TABLE2 中都有的行并消除所有重复行而派生出一个结果表。
		当 ALL 随 INTERSECT 一起使用时 (INTERSECT ALL)，不消除重复行。

# MySQL数据处理

### DQL语句

查询

	select 
		要查询的字段|表达式|常量值|函数
	from 
		表

### DML语句

* 插入

		insert into 表名(字段名，...)
			values(值1，...);

		insert into 表名 set 字段=值,字段=值,...;
		
* 修改

		update 表1 别名1,表2 别名2
		set 字段=新值，字段=新值
		where 
			连接条件
		and 
			筛选条件

* 删除

	* 方式1：delete语句 

		单表的删除： ★
		delete from 表名 【where 筛选条件】【limit 条目数】

		多表的删除：
		delete 别名1，别名2
		from 表1 别名1，表2 别名2
		where
			连接条件
		and
			筛选条件;


		delete 别名1,别名2 from 表1 别名 
		inner|left|right join 表2 别名 
		on 连接条件
		【where 筛选条件】

	* 方式2：truncate语句(DLL语句)

		truncate table 表名

	* 两种方式的区别
		
		1.truncate删除带自增长的列的表后，如果再插入，标识列从1开始
		  delete删除带自增长列的表后，如果再插入，标识列从断点开始
		2.truncate不可以添加筛选条件
		  delete可以添加筛选条件
		3.truncate只能对表
		  delete可以是表和视图
		4.truncate没有返回值
		  delete可以返回受影响的行数
		5.truncate不可以回滚
		  delete可以回滚
		6.当表被truncate后，这个表和索引所占用的空间会恢复到初始大小，
		  delete操作不会减少表或索引所占用的空间。

### DDL语句

* 库的管理

	创建库
		
		create database 库名
		
	删除库
	
		drop database 库名
		
	查看当前所有的数据库
	
		show databases;
		
	打开指定的库
	
		use 库名
		
* 表的管理

1.创建表

	create table 【if not exists】 表名(
		字段名 字段类型 【约束】,
		字段名 字段类型 【约束】,
		...
		字段名 字段类型 【约束】 
	)

	DESC studentinfo;

2.修改表

	添加列
	alter table 表名 add column 列名 类型 【first|after 字段名】;
	
	修改列的类型或约束
	alter table 表名 modify column 列名 新类型 【新约束】;

	修改列名
	alter table 表名 change column 旧列名 新列名 类型;
	
	删除列
	alter table 表名 drop column 列名;
	
	修改表名
	alter table 表名 rename 【to】 新表名;
		
3.删除表
	
	drop table【if exists】 表名;

4.添加/删除主键

	Alter table tabname add/drop primary key(col)

5.复制表

	复制表的结构
	create table 表名 like 旧表;
	
	复制表的结构+数据
	create table 表名 
	select 查询列表 from 旧表【where 筛选】;

6.约束

	create table 表名(
		字段名 字段类型 not null,     #非空
		字段名 字段类型 primary key,  #主键
		字段名 字段类型 unique,       #唯一
		字段名 字段类型 default 值,   #默认
		constraint 约束名 foreign key(字段名) references 主表（被引用列）
		)

	修改表时添加或删除约束:
	
		1、非空
		添加非空
		alter table 表名 modify column 字段名 字段类型 not null;
		删除非空
		alter table 表名 modify column 字段名 字段类型 ;

		2、默认
		添加默认
		alter table 表名 modify column 字段名 字段类型 default 值;
		删除默认
		alter table 表名 modify column 字段名 字段类型 ;

		3、主键
		添加主键
		alter table 表名 add【 constraint 约束名】 primary key(字段名);
		删除主键
		alter table 表名 drop primary key;

		4、唯一
		添加唯一
		alter table 表名 add【 constraint 约束名】 unique(字段名);
		删除唯一
		alter table 表名 drop index 索引名;

		5、外键
		添加外键
		alter table 表名 add【 constraint 约束名】 foreign key(字段名) references 主表（被引用列）;
		删除外键
		alter table 表名 drop foreign key 约束名;

		可以通过以下两种方式来删除主表的记录
	
		方式一：级联删除
		ALTER TABLE 表名 ADD CONSTRAINT 约束名 FOREIGN KEY(字段名) REFERENCES 主表(被引用列) ON DELETE CASCADE;

		方式二：级联置空
		ALTER TABLE 表名 ADD CONSTRAINT 约束名 FOREIGN KEY(字段名) REFERENCES 主表(被引用列) ON DELETE SET NULL;

		6.自增长列
		特点：
		1、不用手动插入值，可以自动提供序列值，默认从1开始，步长为1
		auto_increment
		如果要更改起始值：手动插入值
		如果要更改步长：更改系统变量
		set auto_increment=值;
		2、一个表至多有一个自增长列
		3、自增长列只能支持数值型
		4、自增长列必须为一个key

		一、创建表时设置自增长列
		create table 表(
			字段名 字段类型 约束 auto_increment
		)
		二、修改表时设置自增长列
		alter table 表 modify column 字段名 字段类型 约束 auto_increment
		三、删除自增长列
		alter table 表 modify column 字段名 字段类型 约束 


7.索引

	创建索引：create [unique] index 索引名 on 表名(字段名)
	删除索引：drop index 索引名
	注：索引是不可更改的，想更改必须删除重新建。
	
8.视图

	创建视图：create view 视图名 as select statement
	删除视图：drop view 视图名


### TCL语句
一、含义

	事务：一条或多条sql语句组成一个执行单位，一组sql语句要么都执行要么都不执行
	     只支持insert,delete,update
	
二、特点（ACID）

	A 原子性：一个事务是不可再分割的整体，要么都执行，要么都回滚
	C 一致性：保证数据的状态在操作前和操作后保持一致
	I 隔离性：一个事务不受其他事务的干扰，多个事务互相隔离的
	D 持久性：一个事务一旦提交了，则永久的持久化到本地

三、事务的使用步骤 ★

* 定义

		隐式（自动）事务：没有明显的开启和结束，本身就是一条事务可以自动提交，比如insert、update、delete
		显式事务：具有明显的开启和结束

* 显式事务：

		开启事务
		set autocommit=0;
		start transaction;#可以省略

		编写一组逻辑操作单元（多条sql语句）
		注意：sql语句支持的是insert、update、delete

		设置回滚点：
		savepoint 回滚点名;

		结束事务
		提交：commit;
		回滚：rollback;
		回滚到指定的地方：rollback to 回滚点名;
	
* 并发事务
	
		1、事务的并发问题是如何发生的？
		多个事务 同时 操作 同一个数据库的相同数据时
		
		2、并发问题都有哪些？
		脏读：一个事务读取了其他事务还没有提交的数据，读到的是其他事务“更新”的数据
		不可重复读：一个事务多次读取，结果不一样
		幻读：一个事务读取了其他事务还没有提交的数据，只是读到的是 其他事务“插入”的数据
		
		3、如何解决并发问题
		通过设置隔离级别来解决并发问题
		
		4、隔离级别
				            脏读	  	 不可重复读        幻读
		read uncommitted:读未提交     ×                ×              ×        
		read committed：读已提交      √                ×              ×
		repeatable read：可重复读     √                √              ×
		serializable：串行化          √                √              √

如何避免事务的并发问题？

	通过设置事务的隔离级别
	1、READ UNCOMMITTED
	2、READ COMMITTED 可以避免脏读
	3、REPEATABLE READ 可以避免脏读、不可重复读和一部分幻读
	4、SERIALIZABLE可以避免脏读、不可重复读和幻读
	
设置隔离级别：

	set session|global  transaction isolation level 隔离级别名;

查看隔离级别：

	select @@tx_isolation;
	

# 其它

### 视图

含义：一张虚拟的表

视图的好处：

	1、sql语句提高重用性，效率高
	2、和表实现了分离，提高了安全性

视图的创建

	create view 视图名
		as

视图的增删改查

视图的修改

	方式一：
	create or replace view 视图名
	as
	查询语句;
	方式二：
	alter view 视图名
	as
	查询语句

视图的删除

	drop view 视图1，视图2,...;

视图的查看

	desc 视图名;
	show create view 视图名;

视图的使用

	1.插入
	insert
	2.修改
	update
	3.删除
	delete
	4.查看
	select

不能更新的视图

	视图一般用于查询的，而不是更新的，所以具备以下特点的视图都不允许更新
	包含分组函数、group by、distinct、having、union、
	join
	常量视图
	where后的子查询用到了from中的表
	Select中包含子查询
	用到了（from）不可更新的视图


### 存储过程

含义：一组经过预先编译的sql语句的集合  

好处：

	1、提高了sql语句的重用性，减少了开发程序员的压力
	2、提高了效率
	3、减少了传输次数

分类：

	参数模式：in、out、inout，其中in可以省略
	1、无返回无参
	2、仅仅带in类型，无返回有参
	3、仅仅带out类型，有返回无参
	4、既带in又带out，有返回有参
	5、带inout，有返回有参
	注意：in、out、inout都可以在一个存储过程中带多个

创建存储过程  

	create procedure 存储过程名(参数模式 参数名 参数类型)
	begin
		存储过程体
	end

类似于方法：

	修饰符 返回类型 方法名(参数类型 参数名,...){

		方法体;
	}

注意

	1、需要设置新的结束标记
	delimiter 新的结束标记
	示例：
	delimiter $

	CREATE PROCEDURE 存储过程名(IN|OUT|INOUT 参数名  参数类型,...)
	BEGIN
		sql语句1;
		sql语句2;

	END $

	2、存储过程体中可以有多条sql语句，如果仅仅一条sql语句，则可以省略begin end

	3、参数前面的符号的意思
	in:该参数只能作为输入 （该参数不能做返回值）
	out：该参数只能作为输出（该参数只能做返回值）
	inout：既能做输入又能做输出


调用存储过程

	call 存储过程名(实参列表)
	举例：
	调用in模式的参数：call sp1（‘值’）;
	调用out模式的参数：set @name; call sp1(@name);select @name;
	调用inout模式的参数：set @name=值; call sp1(@name); select @name;

查看

	show create procedure 存储过程名;

删除
	
	drop procedure 存储过程名;


### 函数

创建函数

	create function 函数名(参数名 参数类型) returns  返回类型
	begin
		函数体
	end

	注意：函数体中肯定需要有return语句

调用

	select 函数名(实参列表);

查看
	
	show create function 函数名;

删除
	
	drop function 函数名；

函数和存储过程的区别

			关键字		调用语法	返回值			应用场景
	函数		FUNCTION	SELECT 函数()	只能是一个		一般用于查询结果为一个值并返回时，当有返回值而且仅仅一个
	存储过程	PROCEDURE	CALL 存储过程()	可以有0个或多个		一般用于更新


### 流程控制结构

* 分支结构

if函数

	语法：if(条件，值1，值2)
	特点：可以用在任何位置

case语句

语法：

	情况一：类似于switch
	case 表达式
	when 值1 then 结果1或语句1(如果是语句，需要加分号) 
	when 值2 then 结果2或语句2(如果是语句，需要加分号)
	...
	else 结果n或语句n(如果是语句，需要加分号)
	end 【case】（如果是放在begin end中需要加上case，如果放在select后面不需要）

	情况二：类似于多重if
	case 
	when 条件1 then 结果1或语句1(如果是语句，需要加分号) 
	when 条件2 then 结果2或语句2(如果是语句，需要加分号)
	...
	else 结果n或语句n(如果是语句，需要加分号)
	end 【case】（如果是放在begin end中需要加上case，如果放在select后面不需要）


if elseif语句

语法：

	if 情况1 then 语句1;
	elseif 情况2 then 语句2;
	...
	else 语句n;
	end if;

特点：
	
	只能用在begin end中！！！！！！！！！！！！！！！


三者比较：

			  应用场合
	if函数		简单双分支
	case结构	等值判断 的多分支
	if结构		区间判断 的多分支


* 循环结构

1、while

	【名称:】while 循环条件 do
		循环体
	end while 【名称】;
	
2、loop

	【名称：】loop
		循环体
	end loop 【名称】;

3、repeat

	【名称:】repeat
		循环体
	until 结束条件 
	end repeat 【名称】;

* 循环控制语句
	
		leave：类似于break，用于跳出所在的循环
		iterate：类似于continue，用于结束本次循环，继续下一次


	



