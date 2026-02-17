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

Q1. 
