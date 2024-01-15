create database eda_project;

select * 
from hospital;

#Update date coulumn format
update hospital
set date = STR_TO_DATE(date, '%c/%e/%Y %k:%i');

alter table hospital
modify date datetime;

# Number of rows
select count(*) as num_rows
from hospital; -- 9216

# Number of columns
select count(*) as num_col
from information_schema.columns
where table_name = 'hospital'; -- 11

# Number of admission s by year

select year(date), count(*) as num_admissions, round((count(*) / (select count(*) from hospital)) * 100, 1) as pct
from hospital
group by year(date); -- 2020 - 4878(52.9), 2019 - 4338(47.1)

#Visits by day of the week

select dayname(date) as day_of_week,
       count(*) as num_of_visits
from hospital
group by day_of_week
order by num_of_visits desc; -- monday - 1377 (max), friday - 1260 (min)

select dayname(date) as day_of_week, year(date) as year,
       count(*) as num_of_visits
from hospital
group by  year, day_of_week
order by num_of_visits desc;

#Visits by hour of the day

select hour(date) as hour_of_day, count(*) as num_of_visits
from hospital
group by hour_of_day
order by num_of_visits desc; -- 11 pm - 436 (max), 10 am - 349 (min)

# Distribution by Gender

select distinct patient_gender
from hospital; -- M, F, NC

select patient_gender, count(*) as num_of_patients, round((count(*) / (select count(*) from hospital)) * 100, 1) as pct
from hospital
group by patient_gender;  -- M 4705, F - 4487, NC -24

# Min, max, avg age 

select min(patient_age) as min_age,
       max(patient_age) as max_age,
       round(avg(patient_age)) as avg_age
from hospital; -- 1, 79, 40

# Distribution by race

select distinct patient_race
from hospital; 

select patient_race, count(*) as num_of_patients, round((count(*) / (select count(*) from hospital)) * 100, 1) as pct
from hospital
group by patient_race
order by pct desc;

# Min, Max, Abg wating time

select min(patient_waittime) as min_waittime,
       max(patient_waittime) as max_waittime,
       round(avg(patient_waittime)) as avg_waittime
from hospital; -- 10, 60, 35

#Distirbution by referral department

select department_referral, count(*) as num_of_patients, round((count(*) / (select count(*) from hospital)) * 100, 1) as pct
from hospital
group by department_referral
order by pct desc;

# Patient satiscation score

select distinct patient_sat_score
from hospital;

select count(*)
from hospital
where patient_sat_score = ''; -- 6699

select count(*) - (select count(*)
from hospital
where patient_sat_score = '')
from hospital; -- 2517

select round(avg(patient_sat_score))
from hospital;  -- 1

select patient_sat_score, count(*)
from hospital
group by patient_sat_score
order by  patient_sat_score desc;

