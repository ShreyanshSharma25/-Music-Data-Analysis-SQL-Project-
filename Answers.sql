-- Senior most employee based on job title


select * from employee
order by "levels" desc
limit 1


-- Country with the most invoices


select count ("billing_country") as "bcount", "billing_country"
from invoice
group by "billing_country"
order by "billing_country" desc


-- Top 3 Invoice values


select * from invoice
order by "total" desc
limit 3


-- City with the best customers on the basis of invoice total


select sum ("total") as "invoice_total", "billing_city" 
from invoice
group by "billing_city"
order by "invoice_total" desc


-- best customer on the basis of amount spent 


select customer."customer_id", customer."first_name", customer."last_name", sum (invoice."total") as "Total"
from customer
join invoice on customer."customer_id" = invoice."customer_id"
group by customer."customer_id"
order by "Total" desc
limit 1


-- Email, firstname, lastname and Genre of all rock music listeners (return list alphabeticallly by email)


select distinct "email", "first_name", "last_name" 
from customer
join invoice on customer."customer_id" = invoice."customer_id"
join invoice_line on invoice."invoice_id" = invoice_line."invoice_id"
join track on invoice_line."track_id" = track."track_id"
join genre on track."genre_id" = genre."genre_id"
where genre."name" = 'Rock'
order by "email" asc


-- Top 10 Rock genre artists with their total songs


select artist."artist_id", artist."name", count(artist."artist_id") as "songs"
from artist
join album on artist."artist_id" = album."artist_id"
join track on album."album_id" = track."album_id"
join genre on track."genre_id" = genre."genre_id"
where genre."name" = 'Rock'
group by artist."artist_id"
order by "songs" desc
limit 10


-- Track names that have song length than average song length. Return the Name, Milliseconds, order by song length in descending order


select "name", "milliseconds" from track
where "milliseconds" > (select avg("milliseconds") from track)
order by "milliseconds" desc


-- Amount spent by each customer on respective artists


select customer."customer_id", customer."first_name" as "Customer's Name" , artist."name" as "Artist_Name", sum (invoice_line."unit_price" * invoice_line."quantity") as "Total_Spent"
from customer
join invoice on customer."customer_id" = invoice."customer_id"
join invoice_line on invoice."invoice_id" = invoice_line."invoice_id"
join track on invoice_line."track_id" = track."track_id"
join album on track."album_id" = album."album_id"
join artist on album."artist_id" = artist."artist_id" 
group by artist."name", customer."customer_id", customer."first_name"
order by "Total_Spent" desc

--- Most popular music genre for each country on the basis of quantity sold.

with my_cte as (
select count (invoice_line."quantity") as "Highest_Purchases", customer."country", genre."name" as "genre_name", genre."genre_id",
row_number() over (partition by customer."country" order by count (invoice_line."quantity") desc) as "Row_no"
from invoice_line
join invoice on invoice_line."invoice_id" = invoice."invoice_id"
join customer on invoice."customer_id" = customer."customer_id"
join track on invoice_line."track_id" = track."track_id"
join genre on track."genre_id" = genre."genre_id"
group by 2,3,4
order by 2 asc, 1 desc
)
select * from my_cte 
where "Row_no" <= 1


-- Customer that has spent the most on music for each country 


with my_cte as (
select customer."customer_id", customer."first_name", customer."last_name", invoice."billing_country", sum (invoice."total") as "Total_Spent",
row_number() over (partition by invoice."billing_country" order by sum (invoice."total") desc) as "Row_no"
from invoice
join customer on invoice."customer_id" = customer."customer_id"
group by 1,2,3,4
order by 4 asc, 5 desc 
)
select * from my_cte 
where "Row_no" <= 1


