/* Rui Guo
   rug009@eng.ucsd.edu
   A53100114
*/

--A
/*
create table sailor (sname CHAR(50), rating INT, PRIMARY KEY (sname));
create table boat (bname CHAR(50), color CHAR(50), rating INT, PRIMARY KEY (bname));
create table reservation (sname CHAR(50) NOT NULL, bname CHAR(50) NOT NULL, day CHAR(50), FOREIGN KEY (bname) REFERENCES boat(bname),FOREIGN KEY (sname) REFERENCES sailor(sname));
*/

--B1
/* List all boats reserved on Wednesday and their color */
SELECT x.bname, y.color FROM reservation x, boat y WHERE x.day = 'Wednesday' AND x.bname = y.bname;

--B2
/* List all pairs of sailors who have reserved boats on the same day */
SELECT distinct x.sname as sname1, y.sname as sname2 FROM reservation x, reservation y WHERE x.day = y.day AND x.sname < y.sname;

--B3
/* For each day, list the number of red boats reserved on that day */
create table weekday (day);
insert into weekday values ('Monday');
insert into weekday values ('Tuesday');
insert into weekday values ('Wednesday');
insert into weekday values ('Thursday');
insert into weekday values ('Friday');
insert into weekday values ('Saturday');
insert into weekday values ('Sunday');

SELECT y.day, COUNT(*) AS number FROM reservation x, weekday y, boat b WHERE x.day = y.day AND x.bname = b.bname AND b.color = 'red' GROUP BY y.day UNION SELECT yy.day, 0 AS NUMSHIP FROM weekday yy WHERE yy.day NOT IN (SELECT r.day FROM reservation r, boat b WHERE yy.day = r.day AND r.bname = b.bname AND b.color = 'red');

--B4
/* List the days appearing in the reservation table for which only
red boats are reserved */
--(1)
/* using NOT IN */
SELECT distinct x.day FROM reservation x WHERE x.day NOT IN (SELECT distinct y.day FROM reservation y, boat b WHERE x.day = y.day AND y.bname = b.bname AND b.color <> 'red');
--(2)
/* using NOT EXIST */
SELECT distinct x.day FROM reservation x WHERE NOT EXISTS (SELECT * FROM reservation y WHERE x.day = y.day AND NOT EXISTS (SELECT * FROM boat b WHERE y.bname = b.bname AND b.color = 'red'));
--(3)
/* using COUNT */
SELECT distinct x.day FROM reservation x WHERE (SELECT COUNT (*) FROM reservation y, boat b WHERE x.day = y.day AND y.bname = b.bname AND b.color <> 'red') = 0 AND (SELECT COUNT (*) FROM reservation y, boat b WHERE x.day = y.day AND y.bname = b.bname AND b.color = 'red') > 0;

--B5
/* List the days on which no red boats are reserved */
SELECT distinct x.day FROM reservation x WHERE NOT EXISTS (SELECT * FROM reservation y WHERE x.day = y.day AND NOT EXISTS (SELECT * FROM boat b WHERE b.bname = y.bname AND b.color <> 'red')) UNION SELECT yy.day FROM weekday yy WHERE yy.day NOT IN (SELECT xx.day FROM reservation xx);

--B6
/* For each day of the week occurring in the reservation relation,
list the average rating of sailors having reserved boats that day */
SELECT distinct x.day, avg(s.rating) as 'ave-rating' FROM reservation x, sailor s WHERE x.sname = s.sname GROUP BY x.day;

--B7
/* List the busiest days, i.e. the days with the largest number of
reservations */
SELECT a.day FROM reservation b, weekday a WHERE b.day = a.day GROUP BY a.day HAVING COUNT(*) = (SELECT MAX(NUMSHIP) FROM (SELECT COUNT(*) AS NUMSHIP FROM reservation x, weekday y WHERE x.day = y.day GROUP BY y.day));

--C
/* Formulate and run a query to verify that all sailors having reservations
are qualified to sail the boats they reserved. */
SELECT s.sname, s.rating as srating, b.bname, b.rating as brating, r.day FROM sailor s, boat b, reservation r WHERE r.bname = b.bname AND r.sname = s.sname AND s.rating < b.rating;

--D
--(1)
/* Switch all Wednesday and Monday reservations */
update reservation set day = 'x' where day = 'Monday';
update reservation set day = 'Monday' where day = 'Wednesday';
update reservation set day = 'Wednesday' where day = 'x';
--(2)
/* Delete all reservations violating the constraint in (c) */
delete from reservation where (reservation.sname, reservation.bname) in (SELECT r.sname, r.bname FROM sailor s, boat b, reservation r WHERE r.bname = b.bname AND r.sname = s.sname AND s.rating < b.rating);