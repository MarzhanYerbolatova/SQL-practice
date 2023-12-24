select * from corona_test

-- Find the number of corona patients who faced shortness of breath.

select count(*) as count_shortness_of_breath
from corona_test
where Shortness_of_breath = 'TRUE'

-- Find the number of negative corona patients who have fever and sore_throat.

select count(*) as count_negative
from corona_test
where Fever = 'TRUE' and Sore_throat = 'TRUE' and Corona = 'positive'

-- Find the female negative corona patients who faced cough and headache

select *
from corona_test
where Cough_symptoms = 'TRUE' and Headache = 'TRUE' and Corona = 'negative' and Sex = 'female'

-- How many elderly corona patients have faced breathing problems?

select count(*) as elderly_with_breathing_problems
from corona_test
where Shortness_of_breath = 'TRUE' and Age_60_above = 'Yes' and corona = 'positive'

-- Which three symptoms were more common among COVID positive patients?

select * from 
(select 'Cough_symptoms' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and cough_symptoms = 'TRUE'
union all
select 'Fever' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Fever = 'TRUE'
union all
select 'Sore_throat' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Sore_throat = 'TRUE'
union all
select 'Shortness_of_breath' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Shortness_of_breath = 'TRUE'
union all
select 'Headache' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Headache = 'TRUE') a
order by count_of_sympt desc
limit 3


-- Which symptom was less common among COVID negative people?

select * from 
(select 'Cough_symptoms' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'negative' and cough_symptoms = 'TRUE'
union all
select 'Fever' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'negative' and Fever = 'TRUE'
union all
select 'Sore_throat' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'negative' and Sore_throat = 'TRUE'
union all
select 'Shortness_of_breath' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'negative' and Shortness_of_breath = 'TRUE'
union all
select 'Headache' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'negative' and Headache = 'TRUE') a
order by count_of_sympt
limit 1

-- What are the most common symptoms among COVID positive males whose known contact was abroad? 

select * from 
(select 'Cough_symptoms' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and cough_symptoms = 'TRUE' and Sex = 'male' and Known_contact = 'Abroad'
union all
select 'Fever' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Fever = 'TRUE' and Sex = 'male' and Known_contact = 'Abroad'
union all
select 'Sore_throat' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Sore_throat = 'TRUE' and Sex = 'male' and Known_contact = 'Abroad'
union all
select 'Shortness_of_breath' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Shortness_of_breath = 'TRUE' and Sex = 'male' and Known_contact = 'Abroad'
union all
select 'Headache' as symptom, count(*) as count_of_sympt from corona_test where Corona = 'positive' and Headache = 'TRUE' and Sex = 'male' and Known_contact = 'Abroad') a
order by count_of_sympt desc
