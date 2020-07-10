/*Подзапросы и CTE
Для всех заданий, где возможно, сделайте два варианта запросов:
1) через вложенный запрос
2) через WITH (для производных таблиц)
*/
/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE).
*/


use WideWorldImporters
select * from Application.People where PersonID in (
select 
		CustomerID 
	from Sales.CustomerTransactions
	where TransactionAmount in (
		select top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc ))

select cust.TransactionAmount, Cust.CustomerID, pe.PersonID,pe.FullName
from Application.People pe
right join ( --проверил, кто сделал ещё 3 платежа максимальных, но их нет в бд
	select 
			CustomerID,  TransactionAmount
		from Sales.CustomerTransactions
		where TransactionAmount in (
			select top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc )) as Cust
on Cust.CustomerID = pe.PersonID

;with Cust
as (
select 
		CustomerID 
	from Sales.CustomerTransactions
	where TransactionAmount in (
		select top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc ))

select * from Cust join Application.People pe on Cust.CustomerID = pe.PersonID
			
