#https://www.sql-practice.com - HOSPITAL DATABSE - HARD

# Show all of the patients grouped into weight groups.
#Show the total amount of patients in each weight group.
#Order the list by the weight group decending.
# For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT
  COUNT(1) AS patients_in_group,
  CASE
    WHEN weight BETWEEN 0 AND 9 THEN 0
    WHEN weight BETWEEN 10 AND 19 THEN 10
    WHEN weight BETWEEN 20 AND 29 THEN 20
    when weight between 30 and 39 then 30 
    when weight between 40 and 49 then 40 
    when weight between 50 and 59 then 50 
    when weight between 60 and 69 then 60 
    when weight between 70 and 79 then 70 
    when weight between 80 and 89 then 80 
    when weight between 90 and 99 then 90 
    when weight between 100 and 109 then 100 
    when weight between 110 and 119 then 110 
    when weight between 120 and 129 then 120 
    when weight between 130 and 139 then 130 
    when weight between 140 and 149 then 140 
  ELSE null
  END AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

SELECT
  count(patient_id),
  weight - weight % 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

#Show patient_id, weight, height, isObese from the patients table.
#Display isObese as a boolean 0 or 1.
#Obese is defined as weight(kg)/(height(m)2) >= 30.
#weight is in units kg.
#height is in units cm.

SELECT patient_id, weight, height, 
  (CASE WHEN weight/(POWER(height/100.0,2)) >= 30 THEN 1 ELSE 0 END) AS isObese
FROM patients;

#Show patient_id, first_name, last_name, and attending doctor's specialty.
#Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

select p.patient_id, p.first_name, p.last_name, d.specialty
from patients p 
join admissions a on p.patient_id = a.patient_id
join doctors d on a.attending_doctor_id = d.doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name = 'Lisa'; 


#All patients who have gone through admissions, can see their medical documents on our site. 
#Those patients are given a temporary password after their first admission. 
#Show the patient_id and temp_password. 

#The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date

select distinct p.patient_id, 
concat(p.patient_id,"", len(p.last_name),"", year(birth_date)) as temp_password
from patients p 
join admissions a on p.patient_id = a.patient_id
where p.patient_id in (select a.patient_id
                      From admissions);
                      
#Each admission costs $50 for patients without insurance, 
#and $10 for patients with insurance. All patients with an even patient_id have insurance. 
#Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. 
#Add up the admission_total cost for each has_insurance group.

with cte as (SELECT 
    CASE WHEN patient_id % 2 = 0 THEN 'Yes' ELSE 'No' END as has_insurance,
    CASE WHEN patient_id % 2 = 0 THEN 10 ELSE 50 END as insurance_cost
  FROM admissions)
select has_insurance, sum(insurance_cost) as cost_after_insurance
from cte
group by has_insurance;

#Show the provinces that has more patients identified as 'M' than 'F'.
# Must only show full province_name

SELECT province_name
FROM (
    SELECT
      province_name,
      SUM(gender = 'M') AS n_male,
      SUM(gender = 'F') AS n_female
    FROM patients p
      JOIN province_names pm ON p.province_id = pm.province_id
    GROUP BY province_name
  )
WHERE n_male > n_female;

#We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'
  
SELECT *
FROM patients
WHERE
  first_name LIKE '__r%' 
  AND gender = 'F' 
  AND MONTH(birth_date) IN (2, 5, 12)
  AND (weight BETWEEN 60 AND 80)
  AND patient_id % 2 != 0
  AND city = 'Kingston';
  
  #Show the percent of patients that have 'M' as their gender. 
  -- Round the answer to the nearest hundreth number and in percent form.
  
SELECT CONCAT(ROUND(SUM(gender='M') / CAST(COUNT(*) AS float), 4) * 100, '%')
FROM patients;

#For each day display the total amount of admissions on that day. 
-- Display the amount changed from the previous date.

select admission_date, count(1) as admissions_day,
count(1) -  LAG(count(1)) OVER (order by admission_date) as admission_count_change 
from admissions
group by admission_date;

#Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

SELECT province_name
FROM province_names
ORDER BY
  CASE WHEN province_name = 'Ontario' THEN 0 ELSE 1 END,
  province_name ASC;
  
#We need a breakdown for the total amount of admissions each doctor has started each year. 
-- Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

SELECT
  d.doctor_id,
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  d.specialty,
  YEAR(a.admission_date) AS selected_year,
  COUNT(a.admission_date) AS total_admissions
FROM
  doctors d
JOIN
  admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY
  d.doctor_id, doctor_name, selected_year;