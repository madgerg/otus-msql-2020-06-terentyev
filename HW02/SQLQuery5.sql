--5. Десять последних продаж (по дате) с именем клиента и именем сотрудника, который оформил заказ (SalespersonPerson).

use WideWorldImporters
select  
	s.OrderDate,
	ps.FullName as Prodovan,
	po.CustomerName as Client
	from Sales.Orders s
	join Application.People ps
		on ps.PersonID = s.SalespersonPersonID
	join Sales.Customers po
		on po.CustomerID = s.CustomerID
order by s.OrderDate desc
	OFFSET 0 ROW FETCH NEXT 10 ROWS ONLY