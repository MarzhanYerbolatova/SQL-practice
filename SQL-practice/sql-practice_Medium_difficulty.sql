
# https://www.sql-practice.com/ Medium difficulty 

# 1. Show unique birth years from patients and order them by ascending.

SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC

# 2.Show unique first names from the patients table which only occurs once in the list.

SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1

# 3.Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 'S____%s'

# 4.Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. 
#Primary diagnosis is stored in the admissions table.

SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia'

# 5.Display every patient's first_name. Order the list by the length of each name and then by alphabetically.

SELECT first_name
FROM patients
ORDER BY LEN(first_name) , first_name

# 6.Show the total amount of male patients and the total amount of female patients in the patients table.
#Display the two results in the same row.

SELECT 
    (SELECT COUNT(*) FROM patients WHERE gender = 'M') AS male_count,
    (SELECT COUNT(*) FROM patients WHERE gender = 'F') AS female_count;
    
# 7.Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. 
#Show results ordered ascending by allergies then by first_name then by last_name.

SELECT first_name, last_name, allergies
FROM patients
WHERE allergies = 'Penicillin' OR allergies = 'Morphine'
ORDER BY allergies , first_name , last_name

# 8.Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1

# 9.Show the city and the total number of patients in the city.
#Order from most to least patients and then by city name ascending.

SELECT city, COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city

# 10.Show first name, last name and role of every person that is either patient or doctor.
#The roles are either "Patient" or "Doctor"

select first_name,last_name, 'Patient' as role
from patients
union ALL
select first_name,last_name, 'Doctor' as role
from doctors

# 11.Show all allergies ordered by popularity. Remove NULL values from query.

select allergies, count(*) as total_diagnosis
from patients
where allergies is not null
group by allergies
order by total_diagnosis desc

# 12. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
#Sort the list starting from the earliest birth_date.

select first_name, last_name, birth_date
from patients
where year(birth_date) between 1970 and 1979
order by birth_date asc

# 13. We want to display each patient's full name in a single column. 
#Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
#Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane

select concat(upper(last_name), ',', lower(first_name)) as new_name_format
from patients
order by first_name desc

# 14. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

select province_id, sum(height) as sum_height
from patients
group by province_id
having sum_height > 7000

# 15. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

select (max(weight) - min(weight)) as weight_delta
from patients
where last_name = 'Maroni'

# 16. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
#Sort by the day with most admissions to least admissions.

select day(admission_date), count(*) as num_of_admissions
from admissions
group by day(admission_date)
order by num_of_admissions desc

# 17. Show all columns for patient_id 542's most recent admission_date.

select *
from admissions
where patient_id = 542 and admission_date = (select max(admission_date) from admissions where patient_id = 542)

# 18. Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
#1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
#2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

select patient_id, attending_doctor_id, diagnosis
from admissions
where (patient_id % 2 = 1 and attending_doctor_id in (1,5,19)) OR 
      (attending_doctor_id like '%2%' and len(patient_id) = 3)
      
# 19. Show first_name, last_name, and the total number of admissions attended for each doctor.
# Every admission has been attended by a doctor.

select d.first_name, d.last_name, count(admission_date) as admissions_total
from doctors d
join admissions a on d.doctor_id = a.attending_doctor_id
group by d.doctor_id
having a.attending_doctor_id is not null

# 20. For each doctor, display their id, full name, and the first and last admission date they attended.

select doctor_id, 
       concat(first_name, ' ', last_name) as full_name,
	   min(admission_date) as first_admission_date, 
	   max(admission_date) as last_admission_date
from doctors
join admissions on doctors.doctor_id = admissions.attending_doctor_id
group by doctor_id
        
# 21. Display the total amount of patients for each province. Order by descending.

select province_name, count(patient_id) as patient_count
from province_names
join patients on province_names.province_id = patients.province_id
group by province_name 
order by patient_count desc

# 22. For every admission, display the patient's full name, their admission diagnosis, 
# and their doctor's full name who diagnosed their problem.

select concat(p.first_name, ' ', p.last_name) as patient_name,
       a.diagnosis,
       concat(d.first_name, ' ', d.last_name) as doctor_name
from patients p 
join admissions a on p.patient_id = a.patient_id
join doctors d on a.attending_doctor_id = d.doctor_id


# 23. Display the first name, last name and number of duplicate patients based on their first name and last name. 
# Ex: A patient with an identical name can be considered a duplicate.

select first_name,last_name, count(*) as num_of_duplicates
from patients
group by first_name, last_name
having count(*) > 1

# 24. Display patient's full name, height in the units feet rounded to 1 decimal, 
# weight in the unit pounds rounded to 0 decimals, birth_date,gender non abbreviated.
# Convert CM to feet by dividing by 30.48.
# Convert KG to pounds by multiplying by 2.205.

SELECT
  concat(first_name, ' ', last_name) as full_name,
  round(height/30.48, 1) as height,
  round(weight*2.205, 0) as weight,
  birth_date,
  CASE
    WHEN gender = 'M' THEN 'MALE'
    WHEN gender = 'F' THEN 'FEMALE'
  END AS gender_type
FROM patients


# 25. Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
# (Their patient_id does not exist in any admissions.patient_id rows.)
 
select patient_id, first_name, last_name
from patients
where patient_id not in (select distinct patient_id
                         from admissions)
