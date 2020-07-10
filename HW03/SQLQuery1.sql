/*Подзапросы и CTE
Для всех заданий, где возможно, сделайте два варианта запросов:
1) через вложенный запрос
2) через WITH (для производных таблиц)
*/
/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

use WideWorldImporters

select PersonID, FullName 
from Application.People 
where IsSalesperson = '1'
and PersonID not in (
select SalespersonPersonID
from Sales.Invoices sal
where InvoiceDate = '2015-07-04');

;with PersonInv
as (
	select PersonID 
		from Application.People 
		where IsSalesperson = '1'
except
	select SalespersonPersonID
		from Sales.Invoices sal
		where InvoiceDate = '2015-07-04'
)
select pe.PersonID, pe.FullName  
	from PersonInv pi
	join Application.People pe 
	on pe.PersonID=pi.PersonID