use sarika;

create table Customer3(CustomerID int primary key,CustomerName varchar(30),PhoneNo bigint,City varchar(20),
AccountType varchar(20),AccountNo int);
insert into Customer3 values(1,'Rahul Sharma',5363457336,'Pune','Savings',1001),
(2,'Sneha Patil',9988776655,'Mumbai','Current',1002),
(3,'Aman Verma',9123456780,'Nagpur','Savings',1003),
(4,'Priya Singh',9012345678,'Delhi','Current',1004),
(5,'Karan Mehta',9871203456,'Hyderabad','Savings',1005),
(6,'Neha Joshi',8653212458,'Pune','Current',1006),
(7,'Rohit Kumar',5576865224,'Banglore','Savings',1007),
(8,'Pooja Sharma',6784523234,'Chennai','Savings',1008),
(9,'Vivek Shah',7652127532,'Ahmedabad','Current',1009),
(10,'Anjali Verma',7653753537,'Jaipur','Savings',1010);

create table Accounts(AccountID int primary key,CustomerID int,Balance int,OpenDate date
foreign key (CustomerID) references Customer3(CustomerID));
insert into Accounts values(1001,1,55000,'2025-01-10'),
(1002,2,120000,'2024-11-20'),
(1003,3,35000,'2025-03-15'),
(1004,4,98000,'2025-02-01'),
(1005,5,75000,'2025-01-25'),
(1006,6,150000,'2025-12-18'),
(1007,7,42000,'2025-04-10'),
(1008,8,88000,'2025-05-05'),
(1009,9,200000,'2024-09-30'),
(1010,10,67000,'2025-03-22');

create table transactions(TransactionID int primary key,AccountID int,TransactionType varchar(20),Amount int,TransactionDate date
foreign key (AccountID) references Accounts(AccountID));
insert into transactions values(1,1001,'Deposit',10000,'2026-06-01'),
(2,1001,'Withdraw',5000,'2026-06-02'),
(3,1002,'Deposit',25000,'2026-06-02'),
(4,1003,'Withdraw',3000,'2026-06-03'),
(5,1004,'Deposit',15000,'2026-06-04'),
(6,1005,'Deposit',12000,'2026-06-05'),
(7,1006,'Withdraw',7000,'2026-06-05'),
(8,1007,'Deposit',9000,'2026-06-06'),
(9,1008,'Withdraw',4500,'2026-06-06'),
(10,1009,'Deposit',30000,'2026-06-07'),
(11,1010,'Withdraw',2000,'2026-06-07'),
(12,1002,'Withdraw',10000,'2026-06-08'),
(13,1003,'Deposit',5000,'2026-06-08'),
(14,1005,'Withdraw',3500,'2026-06-09'),
(15,1007,'Deposit',15000,'2026-06-09');

create table loans(LoanID int primary key,CustomerID int,LoanAmount int,LoanType varchar(20)
foreign key (CustomerID) references Customer3(CustomerID));
insert into loans values(1,1,500000,'Home loan'),
(2,2,200000,'Car loan'),
(3,4,100000,'Education loan'),
(4,5,300000,'Business loan'),
(5,6,150000,'Personal loan'),
(6,8,250000,'Home loan'),
(7,9,400000,'Business loan'),
(8,10,180000,'Car loan');

select * from Customer3;
select * from Accounts;
select * from transactions;
select * from loans;

---Display customer names,account numbers,and account balances using inner join.
select c.CustomerName,c.AccountNo,a.Balance from 
Customer3 c inner join Accounts a
on c.CustomerID = a.CustomerID;

---Find the top 3 customers with the highest account balances.
select top(3) * from Accounts
order by Balance desc;

---Show all customers who have taken loans along with loan amount and loan type.
select c.CustomerName,l.LoanAmount,l.LoanType from 
Customer3 c inner join loans l
on c.CustomerID = l.CustomerID;

---Find the total deposited amount and total withdrawn amounts separately.
select TransactionType,sum(Amount) as total_amount from transactions
where TransactionType in ('Deposit','Withdraw')
group by TransactionType;

*---Display customer-wise total transaction amount using group by.
select c.CustomerID,c.CustomerName,sum(t.Amount) as 
total_transaction from Accounts a inner join transactions t
on a.AccountID = t.AccountID inner join Customer3 c
on a.CustomerID = c.CustomerID 
group by c.CustomerID,c.CustomerName;

*---Find customers whose balances are greater than the average bank balance.
select c.CustomerName,avg(a.Balance) as Bank_balance from 
Customer3 c inner join Accounts a
on c.CustomerID = a.CustomerID
where a.Balance > (select avg(a.Balance) from Accounts a)
group by c.CustomerName,a.Balance;

---Show the highest transaction amount performed by each customer.
select c.CustomerID,c.CustomerName,max(t.Amount) as highest_transaction from
transactions t inner join Accounts a
on t.AccountID = a.AccountID inner join Customer3 c 
on a.CustomerID = c.CustomerID
group by c.CustomerID,c.CustomerName;
use sarika;
---Display all customers who have not taken any loans using left join.
select c.CustomerName,l.LoanAmount from 
Customer3 c left join loans l
on c.CustomerID = l.CustomerID;

---Find the total numbers of transactions performed by each customer.
select c.CustomerName,count(t.AccountID) as total_transactions from
transactions t inner join Accounts a
on t.AccountID = a.AccountID inner join Customer3 c
on a.CustomerID = c.CustomerID
group by c.CustomerName;

---Rank customers based on their account balances using rank() window function.
select c.CustomerName,a.Balance,
rank() over(order by a.Balance desc) as rank_no
from Customer3 c inner join Accounts a
on c.CustomerID = a.CustomerID;

---Display dense ranking of customers according to balance using DENSE_RANK()
select c.CustomerName,a.Balance,
dense_rank() over(order by a.Balance desc) as dense_rank_no
from Customer3 c inner join Accounts a 
on c.CustomerID = a.CustomerID;

---Show previous transaction amount using LAG() function.
select c.CustomerName,t.Amount,
lag(t.Amount) over(order by t.Amount ) as lag_function
from transactions t inner join Accounts a 
on t.AccountID = a.AccountID inner join Customer3 c 
on a.CustomerID = c.CustomerID
group by c.CustomerName,t.Amount;

---Show the next transaction amounts using LEAD() function.
select c.CustomerName,t.Amount,
lead(t.Amount) over (order by t.Amount) as lead_function
from transactions t inner join Accounts a
on t.AccountID = a.AccountID inner join Customer3 c
on a.CustomerID = c.CustomerID
group by c.CustomerName,t.Amount;

---Calculate running total of transaction amounts using SUM() OVER().
select c.CustomerName,t.Amount,
Sum(t.Amount) over (order by t.Amount desc) as total_transaction 
from transactions t inner join Accounts a 
on t.AccountID = a.AccountID inner join Customer3 c
on a.CustomerID = c.CustomerID;

---Find the second highest account balance using subquery or window function.
select c.CustomerName,min(a.Balance) as second_highest_balance from
Accounts a inner join Customer3 c
on a.CustomerID = c.CustomerID
where (a.Balance) > (select min(a.Balance) from Accounts a)
group by c.CustomerID,c.CustomerName;

-*-Find the customers who performed more than 2 transactions.
select c.CustomerName,count(t.AccountID) as count_of_persons from
transactions t inner join Accounts a
on t.AccountID = a.AccountID inner join Customer3 c
on c.CustomerID = a.CustomerID
group by c.CustomerName
having  (select count(t.AccountID) from transactions t) > 2;

---Display customer-wise minimum and maximum transaction amounts.
select c.CustomerName,max(t.Amount) as maximum_transaction,
min(t.Amount) as minimum_transaction 
from transactions t inner join Accounts a
on a.AccountID = t.AccountID inner join Customer3 c
on c.CustomerID = a.CustomerID
group by c.CustomerName;

