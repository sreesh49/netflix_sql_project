
----Netflix Project

create table netflix(

   show_id	varchar(5),
   type     varchar(10),
   title    varchar(120),
   director varchar(210),
   casts     varchar(1000),
   country  varchar(123),
   date_added varchar(19),
   release_year  int,
   rating     varchar(10),
   duration   varchar(10),
   listed_in  varchar(80),
   description varchar(250)

)

select * from netflix

select count(*) as total_content from netflix

select distinct type from netflix

---15 Business Problems

---1.Count the number of Movies vs Tv shows.

select type,count(*) as total_content  from netflix
group by type

--2.Find the most common rating for movies and tv shows
select type,rating from
    (select type,rating, count(*),
     rank() over(partition by type order by count(*) desc) as ranking from netflix
     group by type,rating) as t1
	 
where ranking =1

--3.List all movies released in a specific year(eg-2020)

select * from netflix
where type='Movie' and release_year=2020

--4.Find the top 5 countries with the most content on netflix.

select unnest(string_to_array(country,',')),count(show_id) as total_count
from netflix 
group by country
order by total_count desc
limit 5


--5.Identify the longest movie

select * from netflix
where type='Movie' and 
duration = (select max(duration) from netflix)


--6.Find content added in the last 5 years

select * from netflix
where to_date(date_added,'Month dd,yyyy') >= current_date - interval '5 years'


--7.Find all the movies/Tv shows by director 'Rajiv Chilaka'


select * from netflix
where director ilike '%Rajiv Chilaka%'

---8.List all Tv shows with more than 5 sessions

select * from netflix
where type = 'TV Show'
And
split_part(duration,' ',1)::numeric>5


--9.Count the number of content items in each genre

select * from netflix


select unnest(string_to_array(listed_in,',')) as genre,
count(show_id) as total_count
from netflix
group by genre
order by total_count desc

--10.Find each year and average numbers of content release by india on netflix
--return top 5 year with highest avg content release.

select 
extract(Year from to_date(date_added, 'Month DD,YYYY')) as year,
count(*) as yearly_content,
round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100 ,2) as avg_content_per_year
from netflix
group by year

--11.List all movies that are documentaries

select * from netflix
where listed_in ilike '%documentaries%'
	 
--12.Find all content without a director

select * from netflix 
where director is null

--13.Find how many movies actor 'salman khan' appeared in last 10 years.

select * from netflix
where casts ilike '%salman Khan%'
and release_year>extract(year from current_date)-10

--14.Find the top 10 actors who have appeared in the highest number of movies produced in india.

select unnest(string_to_array(casts,',')) as actors,
count(*) as total_count
from netflix
where country ilike '%India%'
group by actors
order by total_count desc
limit 10

--15..Categorize the content based on the presence of the keywords 'kill' and 'violence'
--in the description field.Labelcontent containing these keywords as 'Bad' and all other
---content as 'Good'.Count how many items fall into each category.



with new_table as (
select *,
      case when description ilike '%kill%' or 
	  description  ilike '%violence%' then 'Bad_content'
	  else 'Good Content'
	  end category
from netflix
)

select category,count(*) as total_content
from new_table
group by category





