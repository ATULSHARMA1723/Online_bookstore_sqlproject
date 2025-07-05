-- create database
create database OnlineBookstore;

--switch to the database
\c OnlineBookstore;

--create table
drop table if exists Books;
create table Books (
		Book_ID serial primary key,
		Title Varchar(100),
		Author varchar(100),
		Genre varchar(50),
		Published_Year int,
		Price numeric(10, 2),
		Stock int
);


drop table if exists customers;
create table Customers (
		Customer_ID serial primary key,
		Name varchar(100),
		Email varchar(100),
		Phone varchar(15),
		City varchar(50),
		Country varchar(150)		
);

drop table if exists Orders;
create table Orders (
		Order_ID serial primary key,
		Customer_ID int references Customers(Customer_ID),
		Book_ID int references Books(Book_ID),
		Order_date date,
		Quantity int,
		Total_Amount numeric(10, 2)		
);

select * from Books;
select * from Customers;
select * from Orders;

--import data into books table
copy Books(book_ID, title, author, genre, published_year, price, stock)
from '‪D:/files/All Excel Practice Files/Books.csv'
csv header;

--import data into Customers table
copy Customers(customer_ID, name, email, phone, city, country)
from ‪'D:/files/All Excel Practice Files/Customers.csv'
csv header;

--import data into Orders table
copy Orders(order_ID, customer_ID, book_ID, order_date, quantity, total_amount)
from 'D:/files/All Excel Practice Files/Orders.csv'
csv header;

--1) retrieve all books in the "fiction" genre:
select * from Books 
where Genre='Fiction';

--2) find books published after the year 1950:
select * from Books
where published_year>1950;

--3) list all customers from the canada:
select * from Customers
where country= 'Canada';

--4) show orders placed in november 2023:
select * from Orders
where order_date between '2023-11-01' and '2023-11-30';

--5)retrieve the total stock of books available:
select sum(stock) as Total_stock
from Books;

--6) find the details of the most expensive book:
select * from Books
order by price desc
limit 1;

--7) show all customers who ordered more than 1 quantity of a book
select * from Orders
where quantity>1;

--8) retrieve all orders where the total amount exceeds $20:
select * from Orders
where total_amount>20;

--9) list all genres available in the books table:
select distinct genre from Books;

--10) find the book with the lowest stock:
select * from Books
order by stock
limit 1;

--11) calculate the total revenue generated from all orders:
select sum(total_amount) as revenue
from Orders;


-- Advance Questions

--1) retrieve the total number of books sold for each genre:
select * from Orders;
select b.genre, sum(o.quantity) as total_books_sold
from orders o
join Books b on o.book_id = b.book_id
group by b.genre;

--2) find the average price of books in the "Fantasy" genre:
select avg(price) as avg_price
from Books
where genre='Fantasy';

--3) list customers who have placed at least 2 orders:
select o.customer_id, c.name, count(o.order_id) as order_count
from Orders o
join Customers c on  o.customer_id= c.customer_id
group by o.customer_id, c.name
having count(order_id) >=2;

--4) find the most frequently ordered book:
select o.book_id, b.title, count(o.order_id) as order_count
from Orders o
join books b on o.book_id=b.book_id
group by o.book_id, b.title
order by order_count desc
limit 1;

--5) show the top 3 most expensive books of 'Fantasy' genre:
select * from Books
where genre='Fantasy'
order by price desc
limit 3;

--6) retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id=b.book_id
group by b.author;

--7) list the cities where customers spent over $30 are located:
select distinct c.city, total_amount 
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount>30;

--8) find the customers who spent the most on orders:
select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by total_spent desc
limit 1;

--9) calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
		 b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;























