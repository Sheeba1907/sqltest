create database library;

use library;

create table Publishers(
publisherId int primary key,
publisherName varchar(100) unique not null,
location varchar(50) not null);

create table Books(
bookId int primary key,
title varchar(100) not null,
author varchar(100),
price int check(price>0),
publisherId int,
foreign key (publisherId) references Publishers(publisherId));

create table Members(
memberId int primary key,
name varchar(100),
email varchar(50) unique,
joinDate date Default getdate());

create table Borrowings(
borrowId int primary key,
memberId int,
bookId int,
borrowDate date not null,
returnDate date null,
foreign key (bookId) references Books(bookID),
foreign key (memberId) references Members(memberID));

insert into Publishers(PublisherId, PublisherName, Location)
values(1, 'Pearson', 'New York'),
(2, 'O Reily', 'San Francisco'),
(3, 'Springer', 'Berlin')

insert into Books(bookId, Title, Author, Price, PublisherID)
values (101, 'Data Science Handbook', 'Jake', 750.00, 1),
       (103, 'Learning SQL', 'Alan', 500.00, 2),
       (105, 'AI for Beginners', 'Martin', 900.00, 3),
       (107, 'Advanced Databases', 'Martin', 1200.00, 1),
       (109, 'Python Tricks', 'John', 650.00, 2);

insert into Members(memberId, Name, Email, JoinDate)
values (1, 'Alice', 'alice@mail.com', '2023-01-15'),
       (2, 'Bob', 'bob@mail.com', '2024-02-20'),
       (3, 'Charlie', 'charlie@mail.com', '2024-07-10');

insert into Borrowings(borrowId, MemberID, BookID, BorrowDate, ReturnDate)
values (3050, 1, 101, '2024-02-01', '2024-02-15'),
       (3051, 2, 103, '2024-08-01', NULL);

select * from Publishers;
select * from Books;
select * from Members;
select * from Borrowings;

--Update the price of all books by author “Martin” by increasing 15%.--
update Books set Price = price*1.15 where author = 'Martin';

--Delete a member who has never borrowed a book.--
delete from Members 
where memberId not in(select memberId from borrowings);

truncate table borrowings;

select * from books where price>500;

--List all members who joined after 2023-01-01.--
select * from Members where joinDate > '2023-01-01';

--Show all books along with their publisher names.--
select b.title, p.PublisherName from
Books b join Publishers p
on b.PublisherId = p.publisherId

--Find the number of books each publisher has published.--
select p.publisherName, count(b.bookId) as Total_Books
from Publishers p
left join books b 
on p.PublisherId = b.publisherId
group by publisherName;

--Find the total books borrowed by each member.--
select m.Name, count(bo.borrowId) as Books_got  --bookId can also be used--
from members m 
right join Borrowings bo
on m.memberId = bo.memberId
group by Name;

--List members who haven’t returned their books yet (ReturnDate IS NULL).--
select m.Name
from members m 
join Borrowings bo
on m.memberId = bo.memberId
where bo.returnDate is null;

--Show the most expensive book per publisher--
select p.publisherName, max(b.price) as Expensive_book
from books b
join Publishers p
on p.PublisherId = b.PublisherId
group by p.publisherName;

-- LEFT JOIN Books with Borrowings
select b.title, bo.BorrowDate
from Books b
LEFT JOIN Borrowings bo ON b.BookID = bo.BookID;

--To return all columns from borrowings
select *
from Books b
left join Borrowings bo ON b.BookID = bo.BookID;

-- RIGHT JOIN Books with Borrowings
select b.title, bo.BorrowDate
from Books b
right join Borrowings bo ON b.BookID = bo.BookID;

-- FULL JOIN Books and Members (who borrowed)
select b.bookId, b.title, m.name
from Books b
full join Borrowings bo
on b.BookId = bo.bookId
full join Members m
on bo.memberId = m.memberId;

-- CROSS JOIN : All possible Member-Book combinations
select m.Name, b.title
from Members m
cross join Books b;

insert into Books(bookId, Title, Author, Price, PublisherID)
values (102, 'Python for beginners', 'Alfred', 800.00, 3);

insert into Borrowings(borrowId, MemberID, BookID, BorrowDate, ReturnDate)
values (3052, 1, 102, '2024-04-01', '2024-06-15');

select * from books;

--TCL
--rollback
begin transaction;

update Books set Title = 'Java' WHERE bookId = 109;

rollback;

--Commit
begin transaction;

update Books set Title = 'Java for beginners' WHERE bookId = 109;

commit;

--Use a SELF JOIN on Members (assume we add a ReferredBy column pointing to another 
--MemberID) to show members and who referred them.

alter table Members
add ReferredBy int NULL;

select * from Members;

-- Assume Alice referred Bob
update Members set ReferredBy = NULL where MemberID = 1; -- Alice was not referred by anyone
update Members set ReferredBy = 1 where MemberID = 2;   -- Bob was referred by Alice

select m1.Name AS Member,
       m2.Name AS ReferredBy
from Members m1
left join Members m2
    ON m1.ReferredBy = m2.MemberID;
