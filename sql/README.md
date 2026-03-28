# Introduction 
This project demonstrates a relational database design for a club facilities booking system. The database manages member information, facility details, and booking records, showcasing how real-world data relationships 
are structured using SQL. The database models core entites such as members, facilities, and bookings, allowing the organization to track member information, facility usage, and reservation history. This project was a great learning activity, allowing me to learn SQL and RDBMS by solving SQL Queries. 

## SQL Queries 
SQL DDL Statements to create the following tables (PK -- Primary Key; FK -- Foreign Key)

CREATE TABLE cd.members (
	memid integer PRIMARY KEY, 
	surname varchar(200) NOT NULL, 
	firstname varchar(200) NOT NULL , 
	address varchar(300) NOT NULL, 
	zipcode integer NOT NULL, 
	telephone varchar(20) NOT NULL,
	Recommendedby integer REFERENCES cd.members (memid),
	joindate timestamp NOT NULL
);

CREATE TABLE cd.facilities ( 
  Facid integer PRIMARY KEY, 
  name varchar(100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  Monthlymaintenance numeric NOT NULL
);

CREATE TABLE cd.bookings (
  bookid INTEGER PRIMARY KEY, 
  facid INTEGER REFERENCES cd.facilities(facid),
  memid INTEGER REFERENCES cd.members(memid),
  starttime timestamp,
  slots integer 
); 

## Practice SQL Queries 
#### Modifying Data 
Q1. The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

INSERT INTO cd.facilities 
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES 
(9, 'Spa', 20, 30, 100000, 800); 

Q2. Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

INSERT INTO cd.facilities 
(facid, Name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES 
(9,'Spa', 20, 30, 100000, 800); 

Q3. We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid =1;

Q4. We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.

update cd.facilities
    set
        membercost = (select membercost * 1.1 from cd.facilities where facid = 0),
        guestcost = (select guestcost * 1.1 from cd.facilities where facid = 0)
    where facid = 1;        

 Q5. As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?

DELETE FROM cd.bookings;

Q7. We want to remove member 37, who has never made a booking, from our database. How can we achieve that?

DELETE FROM cd. members
WHERE memid =37;

#### Basics
Q8. How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question. 

SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0
AND membercost < (monthlymaintenance / 50);

Q9. How can you produce a list of all facilities with the word 'Tennis' in their name?

SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';

Q10. How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

SELECT * FROM cd.facilities
WHERE facid IN (1,5);

Q11. How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

SELECT memid, surname, firstname, joindate FROM cd.members
WHERE joindate >= '2012-09-01';  

Q12. You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list!

SELECT surname FROM cd.members
UNION 
SELECT name FROM cd.facilities;

-- Note: UNION helps us combine two different SELECT Statements

#### Joins 

Q13. How can you produce a list of the start times for bookings by members named 'David Farrell'?

SELECT starttime
FROM cd.bookings 
JOIN cd.members
ON cd.bookings.memid = cd.members.memid
WHERE firstname = 'David' AND surname = 'Farrell';

Q14. How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT starttime, name
FROM cd.bookings
JOIN cd.facilities
ON cd.bookings.facid = cd.facilities.facid
WHERE starttime >= '2012-09-21' AND starttime < '2012-09-22' AND Name LIKE '%Tennis Court%'
ORDER BY Starttime;

Q15. How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

SELECT m.firstname, m.surname, r.firstname, r.surname
FROM cd.members m
LEFT JOIN cd.members r
ON m.recommendedby = r.memid
ORDER BY m.surname, m.firstname;

Q16. How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

select distinct recs.firstname as firstname, recs.surname as surname
	from 
		cd.members mems
		inner join cd.members recs
			on recs.memid = mems.recommendedby
order by surname, firstname;

Q17. How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.

select distinct mems.firstname || ' ' ||  mems.surname as member,
	(select recs.firstname || ' ' || recs.surname as recommender 
		from cd.members recs 
		where recs.memid = mems.recommendedby
	)
	from 
		cd.members mems
order by member;

#### Aggregation

Q18. Produce a count of the number of recommendations each member has made. Order by member ID.

SELECT recommendedby, COUNT(memid) FROM cd.members
GROUP BY recommendedby
ORDER BY recommendedby;

-- I know this is wrong, I have to revisit this. 

Q19. Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id. 

SELECT facid, SUM(slots) 
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

Q20. Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT facid, SUM(slots)
FROM cd.bookings
WHERE cd.bookings.starttime >= '2012-09-01' AND cd.bookings.starttime < '2012-10-01'
GROUP BY facid 
ORDER BY SUM(slots);

Q21. Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.

SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(Slots)
FROM cd.bookings 
WHERE starttime >= '2012-01-01' AND starttime < '2013-01-01'
GROUP BY facid, month
ORDER BY facid, month;

Q22. Find the total number of members (including guests) who have made at least one booking.

SELECT COUNT(DISTINCT memid)
FROM cd.bookings;

Q23. Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.

SELECT cd.members.surname, cd.members.firstname, cd.members.memid, MIN(cd.bookings.starttime)
FROM cd.members 
JOIN cd.bookings
ON cd.members.memid = cd.bookings.memid 
WHERE cd.bookings.starttime >= '2012-09-01' 
GROUP BY cd.members.surname, cd.members.firstname, cd.members.memid
ORDER BY cd.members.memid;

Q24. Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.

SELECT COUNT(*) OVER(), firstname, surname
FROM cd.members 
ORDER BY joindate;

Q25. Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.

select row_number() over(order by joindate), firstname, surname
	from cd.members
order by joindate      

Q26. Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.

select facid, total from (
	select facid, sum(slots) total, rank() over (order by sum(slots) desc) rank
        	from cd.bookings
		group by facid
	) as ranked
	where rank = 1
	
#### String 

Q27. Output the names of all members, formatted as 'Surname, Firstname' 

SELECT CONCAT(surname, ', ' , firstname) AS Name FROM cd.members

Q28. You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.

SELECT memid, telephone FROM cd.members
WHERE telephone LIKE '%(%'
ORDER BY memid;

Q29. You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.

SELECT SUBSTRING(surname, 1, 1), COUNT(memid)
FROM cd.members
GROUP BY SUBSTRING(surname, 1, 1)
ORDER BY SUBSTRING(surname, 1, 1)





