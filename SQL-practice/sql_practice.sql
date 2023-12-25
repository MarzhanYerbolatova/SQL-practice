# 1a. Выбрать все столбцы из таблицы actor (ограничить по 100 строкам).

select * 
from actor
limit 100

# 1b. Выбрать только last_name из таблицы actor.

select last_name 
from actor

# 1c. Выбрать только следующие столбцы из таблицы film:

# COLUMN NAME           Note
# title                 Exists in film table.
# description           Exists in film table.
# rental_duration       Exists in film table.
# rental_rate           Exists in film table.
# total_rental_cost     rental_duration * rental_rate (нужно перемножить два столбца, чтобы получить необходимый)


select title, 
       description,
       rental_duration,
       rental_rate,
       (rental_duration * rental_rate) as total_rental_cost 
from film

# ---------------------------------------------------------#

# 2a. Выбрать различные/уникальные фамилии из таблицы actor.

select distinct last_name 
from actor

# 2b. Выбрать различные/уникальные почтовые коды из таблицы address.

select distinct postal_code
from address

# 2c. Выбрать различные/уникальные рейтинги из таблицы film.

select distinct rating
from film

# ---------------------------------------------------------#

# 3a. Выбрать столбцы title, description, rating, length из таблицы film, которые длятся более 3 часа или более.

select title,
       description,
       rating, 
       length
from film
where (length / 60) >= 3

# 3b. Выбрать столбцы payment_id, amount, payment_date из таблицы payment, где платежи были сделаны 05/27/2005 или позднее.

select payment_id, amount, payment_date
from payment
where payment_date >= '2005-05-27'

# 3c. Выбрать все столбцы из таблицы customer, где фамилии начинаются на S и имена заканчиваются на N.

select * 
from customer
where last_name like 'S%' and first_name like '%N'


# 3d. Выбрать все столбцы из таблицы customer, где клиент является неактивным или его фамилия начинается на M.

select * 
from customer
where active = 0 and last_name like 'M%'

# 3e. Выбрать все столбцы из таблицы category, где первичный ключ больше 4 и столбец name начинается на C, S или T.

select *
from category 
where category_id > 4 and (name like 'C%' or name like 'S%' or name like 'T%')

# 3f. Выбрать все столбцы за исключением столбца password из таблицы staff, где имеется значение password.

select *
from staff
where password is null

# ---------------------------------------------------------#

# 4a. Выбрать столбцы phone, district из таблицы address, которые находятся в California, England, Taipei, или West Java.

select phone, district
from address
where district in ('California', 'England', 'Taipei', 'West Java')

# 4b. Выбрать столбцы payment_id, amount, и payment_date из таблицы payment, где платежи были выполнены 05/25/2005, 05/27/2005, 05/29/2005.

select payment_id, amount, payment_date
from payment
where payment_date in ('2005-05-25','2005-05-27','2005-05-29')

# 4c. Выбрать все столбцы из таблицы film, где рейтинг фильма является G, PG-13 или NC-17.

select *
from film
where rating in ('G', 'PG-13', 'NC-17')

# ---------------------------------------------------------#

# 5a. Выбрать все столбцы из таблицы payment, где платежи были выполнены между 05/25/2005 и 05/26/2005.

select *
from payment
where payment_date between '2005-05-25' and '2005-05-26'

# 5b. Выбрать только следующие столбцы из таблицы film, для фильмов у которых длина description между 100 и 120:
#
# COLUMN NAME           Note
# title                 Exists in film table.
# description           Exists in film table.
# release_year          Exists in film table.
# total_rental_cost     rental_duration * rental_rate (нужно перемножить два столбца, чтобы получить необходимый)

select title, 
       description,
       rental_duration,
       rental_rate,
       (rental_duration * rental_rate) as total_rental_cost 
from film
where length(description) between 100 and 120

# ---------------------------------------------------------#

# 6a. Выбрать только следующие столбцы из таблицы film, где description начинается на "A Thoughtful":
# Title, Description, Release Year

select title, description, release_year
from film
where description like 'A Thoughtful%'


# 6b. Выбрать только следующие столбцы из таблицы film, где description заканчивается на слово "Boat".
# Title, Description, Rental Duration

select title, description, rental_duration
from film
where description like '%Boat'


# 6c. Выбрать только следующие столбцы из таблицы film, где description содержит слово "Database" и длина фильма больше 3-х часов.
# Title, Length, Description, Rental Rate

select title, length, description, rental_rate
from film
where description like '%Database%' and (length / 60) > 3

# ---------------------------------------------------------#

# 7a. Выбрать все столбцы из таблицы film и упорядочить строки относительно столбца length по возрастанию.

select *
from film
order by length asc


# 7b. Выбрать различные (уникальные) рейтинги из таблицы film, отсортированный по столбцу rating по убыванию.

select distinct rating
from film
order by rating desc

# 7c. Выбрать столбцы payment_date, amount из таблицы payment (первые 20 строк) отсортированные по столбцу amount по убыванию.

select payment_date, amount
from payment 
order by amount desc
limit 20

# ---------------------------------------------------------#

# 8a. Выбрать столбцы customer first_name/last_name и actor first_name/last_name используя /left join/ 
# между таблицами customer и actor (ON имена и фамилии соответсвенных таблиц) 
# Переименуйте столбцы customer first_name/last_name как customer_first_name/customer_last_name
# Переименуйте столбцы actor first_name/last_name в том же стиле как сверху
# Должно быть 599 строк

select c.first_name as customer_first_name, c.last_name as customer_last_name,
       a.first_name as actor_first_name, a.last_name as actor_last_name
from customer c
left join actor a on c.first_name = a.first_name and c.last_name = a.last_name

# 8b. Выполните тоже самое что и в 8а, только используйте /right join/ и посмотрите на разницу
# Должно быть 200 строк


select c.first_name as customer_first_name, c.last_name as customer_last_name,
       a.first_name as actor_first_name, a.last_name as actor_last_name
from customer c
right join actor a on c.first_name = a.first_name and c.last_name = a.last_name


# 8c. Выбрать те же столбцы что и в 8а, только используйте /inner join/ через фамилию (без имени)
# Должно быть 43 строки

select c.first_name as customer_first_name, c.last_name as customer_last_name,
       a.first_name as actor_first_name, a.last_name as actor_last_name
from customer c
inner join actor a on c.last_name = a.last_name


# 8d. Выбрать столбцы city, country из таблицы city, используя left join с таблицей country.
# Должно быть 600 строк

select c.city, ct.country 
from city c
left join country ct on c.country_id = ct.country_id


# 8e. Выбрать столбцы title, description, release_year, и language_name из таблицы film, используя left join с таблицей language.
# Должно быть 1000 строк

select f.title, 
       f.description, 
       f.release_year, 
       l.name as language_name
from film f
join language l on f.language_id = l.language_id


# 8f. Выбрать столбцы first_name, last_name, address, address2, city name, district, и postal code из таблицы staff, используя 2 left join с таблицей address, а потом также с таблицей city.
# Должно быть 2 строки

select s.first_name, 
       s.last_name, 
       a.address, 
       a.address2, 
       a.district, 
       a.postal_code,
       c.city as city_name
from staff s
left join address a on s.address_id = a.address_id 
left join city c on a.city_id = c.city_id
