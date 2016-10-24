.mode columns
.headers on
create table sailor (sname CHAR(50), rating INT, PRIMARY KEY (sname));
create table boat (bname CHAR(50), color CHAR(50), rating INT, PRIMARY KEY (bname));
create table reservation (sname CHAR(50) NOT NULL, bname CHAR(50) NOT NULL, day CHAR(50), FOREIGN KEY (bname) REFERENCES boat(bname),FOREIGN KEY (sname) REFERENCES sailor(sname));

insert into sailor values ('Brutus', 1);
insert into sailor values  ('Andy', 8);
insert into sailor values ('Horatio', 7);
insert into sailor values ('Rusty', 8);
insert into sailor values ('Bob', 1);

insert into boat values ('SpeedQueen', 'white', 9);
insert into boat values ('Interlake', 'red', 8);
insert into boat values ('Marine', 'blue', 7);
insert into boat values ('Bay', 'red', 3);

insert into reservation values ('Andy', 'Interlake', 'Monday');
insert into reservation values ('Andy', 'Bay', 'Wednesday');
insert into reservation values ('Andy', 'Marine', 'Saturday');
insert into reservation values ('Rusty', 'Bay', 'Sunday');
insert into reservation values ('Rusty', 'Interlake', 'Wednesday');
insert into reservation values ('Rusty', 'Marine', 'Wednesday');
insert into reservation values ('Bob', 'Bay', 'Monday');

--B1
SELECT x.bname, y.color FROM reservation x, boat y WHERE x.day = 'Wednesday' AND x.bname = y.bname;

--B2
SELECT distinct x.sname, y.sname FROM reservation x, reservation y WHERE x.day = y.day AND x.sname < y.sname;

--B3
create table weekday (day);
insert into weekday values ('Monday');
insert into weekday values ('Tuesday');
insert into weekday values ('Wednesday');
insert into weekday values ('Thursday');
insert into weekday values ('Friday');
insert into weekday values ('Saturday');
insert into weekday values ('Sunday');

SELECT x.day, COUNT(*) AS NUMSHIP FROM reservation x, weekday y, boat b WHERE x.day = y.day AND x.bname = b.bname AND b.color = 'red' GROUP BY x.day UNION SELECT yy.day, 0 AS NUMSHIP FROM weekday yy WHERE yy.day NOT IN (SELECT xx.day FROM reservation xx);

--B4
--(1)
SELECT distinct x.day FROM reservation x WHERE x.day NOT IN (SELECT distinct y.day FROM reservation y, boat b WHERE x.day = y.day AND y.bname = b.bname AND b.color <> 'red');
--(2)
SELECT distinct x.day FROM reservation x WHERE NOT EXISTS (SELECT * FROM reservation y WHERE x.day = y.day AND NOT EXISTS (SELECT * FROM boat b WHERE y.bname = b.bname AND b.color = 'red'));
--(3)
SELECT distinct x.day FROM reservation x WHERE (SELECT COUNT (*) FROM reservation y, boat b WHERE x.day = y.day AND y.bname = b.bname AND b.color <> 'red') = 0 AND (SELECT COUNT (*) FROM reservation y, boat b WHERE x.day = y.day AND y.bname = b.bname AND b.color = 'red') > 0;

--B5
SELECT distinct x.day FROM reservation x WHERE NOT EXISTS (SELECT * FROM reservation y WHERE x.day = y.day AND NOT EXISTS (SELECT * FROM boat b WHERE b.bname = y.bname AND b.color <> 'red')) UNION SELECT yy.day FROM weekday yy WHERE yy.day NOT IN (SELECT xx.day FROM reservation xx);

--B6
SELECT distinct x.day, avg(s.rating) FROM reservation x, sailor s WHERE x.sname = s.sname GROUP BY x.day;

--B7
SELECT a.day FROM reservation b, weekday a WHERE b.day = a.day GROUP BY a.day HAVING COUNT(*) = (SELECT MAX(NUMSHIP) FROM (SELECT COUNT(*) AS NUMSHIP FROM reservation x, weekday y WHERE x.day = y.day GROUP BY y.day));

--C
SELECT s.sname, s.rating, b.bname, b.rating, r.day FROM sailor s, boat b, reservation r WHERE r.bname = b.bname AND r.sname = s.sname AND s.rating < b.rating;

--D
--(1)
update reservation set day = 'x' where day = 'Monday';
update reservation set day = 'Monday' where day = 'Wednesday';
update reservation set day = 'Wednesday' where day = 'x';
--(2)
delete from reservation where reservation.day in (SELECT r.day FROM sailor s, boat b, reservation r WHERE r.bname = b.bname AND r.sname = s.sname AND s.rating < b.rating);





