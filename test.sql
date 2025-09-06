

select * from Employees1;

with cte as (
select * from Employees1 where salary>50000) 
select * from cte;

with cte as (
select * from Employees1 where year(HireDate) >2023)
select * from cte
;

with cte as(

select dept_id,avg(salary) as avgsal from Employees1 group by dept_id)
select e.name,e.salary,e.dept_id,d.avgsal from Employees1 e
join cte d on e.dept_id=d.dept_id
where e.salary>d.avgsal
;

select * from Orders1;

with cte as (
select customer_id,avg(purch_amt) as avgp from Orders1
group by customer_id)

select e.customer_id,e.salesman_id,d.avgp from Orders1 e
join cte d on e.customer_id=d.customer_id where e.purch_amt>d.avgp;

with hs as(
select emp_id,name,salary from Employees1 
where salary >50000),
longservice as(
select emp_id,name,HireDate from Employees1
where HireDate<'2023-01-01'
)
select h.emp_id,h.name,h.salary from hs h
join longservice l on h.emp_id=l.emp_id;



with cte as (
select 2 as n
union all
select n+2 from cte where n<20)
select * from  cte;

with orderlastyear as(
select * from Orders1 where year(ord_date)='2012'  ),
customersales as(
select customer_id,sum(purch_amt) as ts from orderlastyear group by customer_id),
topcustomer as (
select customer_id,ts,
rank() over(order by ts desc) as rnk
from customersales)
select * from topcustomer where rnk<=5;

with orderlastyear as(
select * from Orders1 where ord_date>= DATEADD(month,-6,GETDATE())),
customersales as(
select customer_id,sum(purch_amt) as ts from orderlastyear group by customer_id),
topcustomer as (
select customer_id,ts,
rank() over(order by ts desc) as rnk
from customersales)
select * from topcustomer where rnk<=3;

with cte as(
select name,salary,dept_id,
rank() over(partition by dept_id order by salary desc) as rnk
from Employees1)
select * from cte where rnk=2


-----------------------------------------


with cte as(
select * from Employees1 where salary>60000
)
select * from cte;

with cte as(
select dept_id,avg(salary)as avgsal from
Employees1 group by dept_id)
select e.name,e.salary,d.avgsal from Employees1 e
join cte d on e.dept_id=d.dept_id
where e.salary>d.avgsal;

with salaryh as(
select * from Employees1 where salary>70000
),
hd as (
select * from salaryh where year(HireDate)<'2024'
)
select * from hd;

with cte as(
select dept_id,name,salary,
ROW_NUMBER() over(partition by dept_id order by salary desc) as rnk
from Employees1)
select * from cte where rnk<=3;

with cte as(
select dept_id,name,salary,
dense_rank() over(partition by dept_id order by salary desc) as rnk
from Employees1)
select * from cte where rnk=2;

with cte as (
select 1 as n
union all
select n+1 from cte where n<20)
select * from cte
;


with emplchain as(
select id,name,manager_id,1 as level
from Employees01
where manager_id is null 
union all
select e.id,e.name,e.manager_id,h.level+1 
from Employees01 e join emplchain h on e.manager_id=h.id)
select * from emplchain
;

select * from Customer;
select * from Orders1;


with cte as(
select salesman_id,sum(purch_amt) as ps from Orders1
group by salesman_id)
select e.cust_name,d.ps from Customer e
 join cte d on e.salesman_id=d.salesman_id;


 9. CTE with DATEADD

Write a CTE to return orders placed in the last 6 months, then find the top 5 customers by purchase amount.

with cte as(
select * from Orders1 where ord_date>= DATEADD(month,-600,getdate()))
,cte2 as (
select customer_id,sum(purch_amt) as ts from cte
group by customer_id),

cte3 as (
select customer_id,ts,
ROW_NUMBER() over(order by ts desc) as rnk
from cte2)
select e.cust_name,e.city,d.ts from Customer e
join cte3 d on e.customer_id=d.customer_id where  rnk<=5


11. CTE with UNION

Create a CTE with:

Active employees

Inactive employees
Combine them with UNION.

with cte as(
select * from Employees where status='Active'
union
select * from Employees where status='Inactive') 
select * from cte;

12. Update with CTE (if supported in your SQL)

Increase salaries by 10% for employees whose salary is below department average.;

with cte as(
select dept_id,avg(salary) as avgsal from Employees1 group by dept_id)
update e set salary=salary*1.1 from Employees1 e
join cte d on e.dept_id=d.dept_id
where e.salary<d.avgsal;

select * from Employees1;


13. Delete with CTE (if supported)

Delete customers who have never placed an order.

select * from Orders1
select * from Customer;

with cte as(

select c.customer_id from Customer c left join Orders1 o
on c.customer_id=o.customer_id
where o.customer_id is null )
delete from Customer where
customer_id in (select customer_id from cte)
;




14. Recursive CTE – Running Total

Write a recursive CTE to calculate a running total of salaries ordered by hire date.

with cte as(
select name,salary,HireDate,dept_id,
sum(salary) over(partition by dept_id order by HireDate desc) as rnk
from Employees1)
select * from cte


15. Complex CTE Chain

Build a 3-step CTE query:

CTE1 → Orders in last year.

CTE2 → Sales per product.

CTE3 → Rank products by sales.
Final → Return the top 5 products.


with cte1 as (
select * from Orders1 where ord_date>='2012'),
cte2 as (
select customer_id,sum(purch_amt) as ts from cte1 group by customer_id)
,cte3 as (
select customer_id,ts,
row_number() over(partition by customer_id order by ts desc   ) as rnk
from cte2)

select * from cte3 where rnk<=5;


---------------vews--------------


create view vw_emsal as
select name,salary,dept_id from Employees1;

update vw_emsal set salary= 1234 where name like 's%'

select * from Employees1

select * from vw_emp_salary_summary
select * from vw_emsal

create view vw_orderdetails as
select o.ord_date,c.cust_name,o.purch_amt,o.ord_no from Orders1 o
join Customer c on c.salesman_id=o.salesman_id

select * from vw_orderdetails

create view vw_customersales as
select customer_id,sum(purch_amt)as ts from Orders1
group by customer_id

select * from vw_customersales


create view vw_updatepuru as 
update Orders1 set purch_amt=546.21 where customer_id=3004


create or alter view vw_ts 
with SCHEMABINDING
as
select dept_id ,sum(isnull(salary,0)) as tsal,COUNT_BIG(*) AS row_count from dbo.Employees1
group by dept_id


select * from vw_ts

create unique CLUSTERED INDEX idx_ts
on vw_ts(dept_id)


create view vw_custsum
with schemabinding
as
select o.customer_id,c.cust_name,sum(isnull(o.purch_amt,0))as ts,COUNT_BIG(*) as cb from dbo.Orders1 o
join dbo.Customer c on o.customer_id=c.customer_id
group by o.customer_id,c.cust_name

create unique clustered index idx_vw
on vw_custsum(customer_id)

select * from vw_custsum

drop  index idx_vw on vw_custsum

;
-----------------proc------------------------

create proc empdet
as
begin 
select * from Employees1
end

exec empdet;

create proc empdet1 
@deptid int
as
begin 
select * from Employees1 where dept_id=@deptid;
end

exec empdet1 10

create proc empdet2 
@deptid int,
@totalsum decimal(10,2) output
as
begin 
select @totalsum=sum(salary) from Employees1 where dept_id=@deptid
end
declare @result decimal(10,2)
exec empdet2 10,@totalsum=@result output
print(@result)

select * from Employees1


create proc empdet33
@emp_id int,
@name varchar(36),
@dept_id int,
@salary int
as
begin
		begin try
		 begin transaction 
		  insert into Employees1 (emp_id,name,dept_id,salary,HireDate)
		  values (@emp_id,@name,@dept_id,@salary,getdate())

		  commit transaction
		end try
		begin catch
		rollback transaction
			print('error')
			end catch
		end


exec empdet33 17,'sai',30,85412



create proc empdel5
@emp_id int,
@name varchar(36),
@dept_id int,
@salary int
as
begin
		merge Employees1 as target
		using (select @emp_id as emp_id,
					  @name as name,
					  @dept_id as dept_id,
					  @salary as salary) as src on target.emp_id =src.emp_id

		when matched then 
		update set name=src.name,dept_id=src.dept_id,salary=src.salary 
		when not matched then
		insert (emp_id,name,dept_id,salary,hiredate)
		values(@emp_id,@name,@dept_id,@salary,getdate());

		end;

		exec empdel5 2 ,'rahul', 20, 98456

select * from Employees1



create proc empdet4
@emp_id int,
@dept_id int,
@salary int
as
begin 
		begin try
		begin transaction 
		update Employees1 set dept_id=@dept_id,salary=@salary where emp_id=@emp_id
		commit transaction 
		end try

		begin catch
		rollback transaction 
		 print('error')
		 end catch

	end

	exec empdet4 2,56748,30
	;


	create proc  emp1
	as
	begin 
	      with cte as (
		  select dept_id,avg(salary)as ts from Employees1
		  group by dept_id)
		  select e.name,e.salary,d.ts from Employees1 e
		  join cte d on e.dept_id=d.dept_id

		  end

		  exec emp1



select * from matches
select * from deliveries


create or alter proc yearscore
@year int
as
begin
		select m.season,d.batter,sum(d.total_runs) as tr from 
		matches m join deliveries d on m.id=d.match_id
		where left(season,4)=@year
		group by season,batter 

end


exec yearscore 2018

create table emp11(
id int identity,
name varchar(55)
)

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO emp11(name)
    VALUES ('Employee_' + CAST(@i AS VARCHAR(10)));
    SET @i = @i + 1;
END

truncate table emp11

select * from emp11

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 1000
)
INSERT INTO emp11(name)
SELECT 'Employee_' + CAST(n AS VARCHAR(10))
FROM Numbers
OPTION (MAXRECURSION 1000);


-- Insert 1000 rows in emp11
INSERT INTO emp11(name)
SELECT TOP 1000
       'Employee_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10))
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;


with nub as(
select 1 as n
union all
select n+1 from nub where n<=1000
)
insert into emp11(name)
select 'emp'+cast(n as varchar(33))
from nub
option(maxrecursion 1000)


create  clustered index idx_clu on emp11(id)



create  nonclustered index idx_name on emp11(name)

create nonclustered index idx_name on emp11(name) where name='sss'

drop index idx_nameid on emp11

create nonclustered index idx_nameid
 on emp11(name,id)


sp_help emp11

;


create function fnname (@firstname varchar(33), @lastname varchar(33))
returns varchar(100)
as
begin
     return(@firstname +'  '+@lastname)
end



select dbo.fnname('shiva','kumar') as fullname



create function tsy (@salary int)
returns int
as
begin
     return(@salary * 12)
end

select dbo.tsy(70000)

create function cubenum(@num int)
returns int
as
begin

return(@num *@num)
end

select dbo.cubenum(22)



create function ts(@sub1 int,@sub2 int,@sub3 int)
returns int
as
begin
declare @totalmarks int
set @totalmarks=(@sub1+@sub2+@sub3)
return @totalmarks
end;

select dbo.ts(80,99,77)

any mistake tellme this ^


Create a scalar function to return Age from BirthYear.

create function agediff(@birthdate date)
returns int
as
begin
declare @age int;
set @age=datediff(year,@birthdate,getdate());
return @age;

end

select dbo.agediff('1996-10-13')

Create a scalar function to return Simple Interest = (P × R × T)/100.



Create a scalar function to return Grade based on marks:

≥90 → A

≥75 → B

≥50 → C

Else → Fail

create function marks(@sub int)
returns varchar(22)
as
begin
return( case 
when @sub>90 then 'a'
when @sub>75 then 'b'
when @sub>50 then 'c'
else 'bye'
end 
);
end

select dbo.marks(76)

select emp_id,dbo.cubenum(emp_id) as cubes from Employees1

select * from Employees1 where dbo.cubenum(emp_id)>100

select emp_id from Employees1 order by dbo.cubenum(emp_id) desc
;

create function emp(@salary1 int)
returns table
as

return(
		select * from Employees1 where salary >@salary1

);

select * from dbo.emp(50000)



create or alter function emp01(@salary1 int)
returns table
as

return(
		select dept_id,sum(salary) as avgsal from Employees1 where dept_id=@salary1
		group by dept_id 

);


select * from dbo.emp01(10)



create function mtvfemp()
returns @emp table(empid int,name varchar(33),salary int)
as
begin 
		insert into @emp 
		select emp_id,name,salary from Employees1 ;
		return;

	end



select * from dbo.mtvfemp()




Q1: High Salary Employees

Create a function to return employees with salary greater than a given amount.
create function emp(@salary1 int)
returns table
as

return(
		select * from Employees1 where salary >@salary1

);

select * from dbo.emp(50000)

Q2: Employees by Department

Create a function to return employees for a specific DeptID passed as a parameter.

create function emp02(@dept int)
returns table
as

return(
		select * from Employees1 where dept_id=@dept

);

select * from dbo.emp02(10)

Q3: Employees Joined After a Date

Return all employees who joined after the given date.


create function afterdate(@dategievn date)
returns table
as

return(
		select * from Employees1 where HireDate>@dategievn

);


select * from dbo.afterdate(2024)

Q4: Employees by Status

Return employees based on Status = 'Active' or 'Inactive' parameter.

create function checksata(@status varchar(33))
returns table
as

return(
		select * from Employees1 where Status = @status
	

);


Q5: Employees by Salary Range

Pass two parameters: MinSalary and MaxSalary. Return employees whose salary is between them.

create function minmax(@min int,@max int)
returns table
as


return(
		select * from Employees1 where salary between @min and @max
	

);


select * from dbo.minmax(60000,90000)




Q6: Employees by Name Starting Letter

Pass a single character, return employees whose name starts with that character.


create or alter function namestarts(@name varchar(33))
returns table
as

return(
		select * from Employees1 where name like @name +'%'
	

);

select * from dbo.namestarts('s')

Q7: Employees by Multiple Departments

Pass a DeptID parameter. If DeptID = 0, return employees from all departments; else only that department.

create or alter function dept0(@dept int)
returns table
as

return(
select * from Employees1 where (@dept=0 or dept_id=@dept)


);

select * from dbo.dept0(10)


Q8: Employees Count by Department

Pass DeptID and return total count of employees in that department.

create or alter function dept1(@dept varchar(33))
returns table
as

return(
select count(*) as tc from Employees1 where dept_id=@dept


);

select * from dept1(20)


Q9: Employees by Month of Joining

Pass a month number (1–12), return employees who joined in that month.

create or alter function monthpass(@mp int)
returns table
as

return(
select *  from Employees1 where month(HireDate)=@mp


);

select * from monthpass(5)

Q10: Employees Earning More than Dept Average

Return employees whose salary is greater than the average salary of their department.

create or alter function empsal(@sal int)
returns table
as

return(
select *  from Employees1 e where salary>(select avg(salary) from Employees1 where dept_id=e.dept_id)


);

select * from dbo.empsal(1)

Q1: Employees with Bonus

Create a function to return employees with salary > given amount and add a column "Bonus" = 10% of salary.

create or alter function mtvfemph(@salary int)
returns @emp table(emp_id int,name varchar(33),salary int,bonus decimal(10,2))
as
begin
		insert into @emp
		select emp_id,name,salary,salary*0.1 as bonus from Employees1 where salary >@salary;
		return
end

select * from mtvfemph(60000)


Q2: Employees by Joining Year

Pass a year as input, return employees who joined in or after that year. Also,
add a column "Experience" = current year – joining year.

create function mtvfyear(@year int)
returns @emp table(emp_id int,name varchar(33),salary int,experience int)
as
begin
		insert into @emp
		select emp_id,name,salary,DATEDIFF(year,HireDate,GETDATE())
		from Employees1 where year(hiredate) >=@year
		return
end

select * from dbo.mtvfyear(2023)



Q3: Employees Department & Count

Return DeptID, total employees in that department, and add a column "Status" = 'Small' if count < 5 else 'Big'.

create or alter  function mtvfcount(@dept int)
returns @emp table(dept_id int,contdept int,status varchar(33))
as
begin
		insert into @emp
		select dept_id,count(*) as contdept,
		case 
		when count(*)<5 then 'small'
		else 'big'
		end as status
		
		from Employees1
		where dept_id =@dept
		group by dept_id 
		return
end

select * from mtvfcount(30)




Q4: Salary Classification

Pass MinSalary, return employees with column "Category":

'Low' if salary < 50000

'Medium' if 50000–100000

'High' if > 100000

create or alter  function mtvfmin(@salary int)
returns @emp table(dept_id int,name varchar(33),salary int,Category varchar(33))
as
begin
		insert into @emp
		select dept_id,name,salary,'' as category from Employees1 where salary>@salary
		;
		update @emp
		set Category =case 
		when salary >100000 then'high'
		when salary >50000 then'medium'
		else 'low'
		end ;
		
		return 


end

select *from dbo.mtvfmin(30)

Q5: Employees by First Letter

Pass a starting letter, return employees whose names start with that letter and add column "NameLength".

create function mtvfname(@sname varchar(2))
returns @emp table(name varchar(33),salary int, namelength int)
as
begin
		insert into @emp
		select name,salary,len(name) as namelength from Employees1 where name like @sname+'%';
		return

end



select * from dbo.mtvfname('s')

Q6: Employees Age Category

Pass BirthYear, return employees with column:

'Junior' if Age < 30

'Senior' if Age >= 30

 create or alter function mtvfage(@by int)
returns @emp table(name varchar(33),salary int, age varchar(33))
as
begin
		insert into @emp
		select name,salary,
		case
		when (year(getdate())- @by >=30) then 'Senior'
		else 'Junior'
		end as age
		from Employees1
		return
end

select * from dbo.mtvfage(1998)

Q7: Salary Difference from Dept Average

Pass DeptID, return employees with Salary and a column "DiffFromAvg" = Salary – DeptAverageSalary.

 create or alter function mtvfsaldiff(@dept int)
returns @emp table(name varchar(33),salary int, difffromavg int)
as
begin
		insert into @emp
		select name,salary, salary-(select avg(salary) from Employees1 where dept_id=@dept) from Employees1
		where dept_id=@dept
		return
end

select * from dbo.mtvfsaldiff(10)

Q8: Employees from Multiple Departments

Pass a comma-separated department list, return employees only from those departments.


create or alter function mtvfonlydept(@dept varchar(33))
returns @emp table(name varchar(33),salary int,dept_id int)
as
begin
		insert into @emp
		select name,salary,dept_id from Employees1 where dept_id in(
		select cast(value as int) from string_split(@dept,','));
		return
end

select * from dbo.mtvfonlydept('10,20,55')


Q9: Employees Joining Month Name
Pass month number (1–12), return employees joined in that month and column "MonthName" (e.g., January, February).


create or alter function mtvfempm(@month int)
returns @emp table(name varchar(33),salary int,Monthname  varchar(55))
as
begin
		insert into @emp
		select name,salary ,'' as monthname from Employees1 where month(HireDate) =@month

		update @emp set
		Monthname = DATENAME(month, DATEFROMPARTS(YEAR(GETDATE()), @month, 1));
		return

end

select * from dbo.mtvfempm(5)

Q10: High Salary Employees with Rank

Pass a minimum salary, return employees with salary > min salary and 
column "Rank" = 1 for highest salary, 2 for next, etc.


create or alter function mtvfminsal(@salary int)
returns @emp table(name varchar(33),salary int,rank int)
as
begin
		insert into @emp
		select name,salary ,
		row_number() over (order by salary desc) as rank
		
		from Employees1 where salary >@salary

		return
end

select * from dbo.mtvfminsal(90000)



-----------------temp tables-----------------------

create table #student(
id int,
name varchar(33),
class int,
total int)

insert into #student values(1,'shiva',8,99)


select * from #student

create unique index idx_id on #student(id)

select top (10) * into
#toporders from employees1
select * from #toporders


From Sales.Orders, create #BigAmt with orders Amount > 5000, 
add nonclustered index on (cust_id), then join to Sales.Customers to list top customers by total amount.





Use SELECT…INTO to make #YesterdaysOrders, then add a computed column IsHigh = CASE WHEN Amount>3000 THEN 1 ELSE 0 END (via ALTER TABLE ADD) and index it.

Declare @TopPerCustomer with columns (cust_id int PRIMARY KEY, top_amt money) and load each customer’s max order amount; return the top 10 customers.

Compare performance: same query using @t vs #t when rowcount ≈ 5, 5000, 500k (if you can). Note plan differences.

Capture sp_whoisactive or sp_who2 results into #SessionSnap and filter only sleeping sessions.

Use OUTPUT…INTO to collect changed rows from a price update into #Audit.

Build #SkuList from a CSV-like string split (use STRING_SPLIT) and join to Inventory to fetch stock.

Create ##GlobalWatch and, from another session, read it (observe global scope). Then drop it.

Implement a proc that fills a #temp and returns a paged result (inputs: @Page, @PageSize).

(If In-Memory OLTP is available) Declare a memory-optimized table variable and compare insert/select latency vs normal @t.













