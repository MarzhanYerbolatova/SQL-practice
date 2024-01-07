#DELETE DUPLICATE DATA - id is not duplicated

# 1. delete using Unique Identifer

delete from cars
where id in 
(select max(id)
from cars
group by model, brand
having count(*) > 1);

# 2. using self join

delete from cars
where id in (
select c2.id
from cars c1
join cars c2 on c1.model = c2.model and c1.brand = c2.brand
where c1.id < c2.id);

# 3. Using window function
delete from cars where id in (
        select id from(
                    select * ,
                    row_number() over(partition by model, brand) as rn
					from cars) x
		where x.rn > 1);

# 4. Using MIN function. Multiole ducplicate records

delete from cars 
where id not in (
              select  min(id)
			  from cars
			  group by model,brand);
              
# 5.  Using backup table

create table cars_bkp
as 
select * from cars where 1=2;

insert into cars_bkp
select *
from cars
where id in (select  min(id)
			 from cars
			 group by model,brand);

drop table cars;

alter table cars_bkp  rename to cars;

# 6. Using backup table withput dropping the original table

create table cars_bkp
as 
select * from cars where 1=2;

insert into cars_bkp
select *
from cars
where id in (select  min(id)
			 from cars
			 group by model,brand);

truncate table cars;

insert into cars
select * from cars_bkp;

drop table cars_bkp;

#DELETE DUPLICATE DATA - id is duplicated 

# 7. Delete using CTID - postgre, rowid on oracle

select *, ctid
from cars;

delete from cars
where ctid in 
(select max(ctid)
from cars
group by model, brand
having count(*) > 1);

# 8. By creating a remporary unique id column 

alter table cars
add column row_num int generated always as identity; 

delete from cars
where row_num in 
(select max(row_num)
from cars
group by model, brand
having count(*) > 1);

alter table cars drop column  row_num;

# 9. By creating backup table

create table cars_bkp as
select distinct * from cars;

drop table cars;

alter table cars_bkp rename to cars;

# 10.By creating a back up table without droping the original table

create table cars_bkp as
select distinct * from cars;

truncate table cars;

insert into cars
select * from cars_bkp;

drop table cars_bkp;

