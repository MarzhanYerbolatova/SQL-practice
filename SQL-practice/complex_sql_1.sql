# 1.fetch duplicated records

select user_id, user_name, email
from
(select *,
row_number() over(partition by user_name order by user_id) as rn
from users
order by user_id) x
where x.rn > 1;

# 2. fetch the doctors who in same hospital but in different specialty

select d1.*
from doctors d1
join doctors d2
on d1.id <> d2.id and d1.hospital = d2.hospital and d1.specialty <> d2.specialty;

# 3. from the login_deatial table, fetch the users who logged in consecutively 3 or more times.

select distinct user_name
from (
select *,
case when user_name  = lead(user_name) over(order by login_id)
     and user_name = lead(user_name, 2) over(order by login_id)
     then user_name
     else null
     end as repeted_users
from login_details) x
where x.repeted_users is not null;

# 4. from the weather table, fetch all the records when London had extremely cold temp for 3 consecutive days or more

select id, city, temperature, day
from
(select *,  
case when temperature < 0 
          and lead(temperature) over(order by id) < 0
          and lead(temperature, 2) over(order by id) < 0
          then 'yes'
	  when temperature < 0 
          and lag(temperature) over(order by id) < 0
          and lead(temperature) over(order by id) < 0
          then 'yes'
	  when temperature < 0 
          and lag(temperature) over(order by id) < 0
          and lag(temperature, 2) over(order by id) < 0
          then 'yes'
          else null
          end flag
from weather) x
where x.flag = 'yes' ;

# 5. find the top 2 accounts with the maximum number of unique patients on a mobthly baisi

select month, account_id, no_of_patients
from
(select *,
rank() over(partition by month order by no_of_patients desc, account_id) rnk
from 
(select month, account_id, count(1) as no_of_patients
from
      (select distinct to_char(date, 'month') as months, account_id, patinet_id
	   from patient_logs) pl
 group by month, account_id) x ) temp
 where temp.rnk in (1,2) ;
 

 
