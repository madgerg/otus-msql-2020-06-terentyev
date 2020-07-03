--4. Заказы поставщикам (Purchasing.Suppliers), которые были исполнены в январе 2014 года с доставкой Air Freight или Refrigerated Air Freight (DeliveryMethodName).
--Вывести:
--* способ доставки (DeliveryMethodName)
--* дата доставки
--* имя поставщика
--* имя контактного лица принимавшего заказ (ContactPerson)
--Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.

use WideWorldImporters
select   
	dm.DeliveryMethodName,
	po.ExpectedDeliveryDate,
	s.SupplierName,
	p.FullName
	from Purchasing.PurchaseOrders po
	join Purchasing.Suppliers s
		on po.SupplierID = s.SupplierID
	join Application.DeliveryMethods dm
		on po.DeliveryMethodID = dm.DeliveryMethodID
	join Application.People p
		on p.PersonID = s.PrimaryContactPersonID
where 
dm.DeliveryMethodName like '%Air Freight' and 
--dm.DeliveryMethodName = 'Air Freight' or dm.DeliveryMethodName = 'Refrigerated Air Freight' and
--можно было бы сделать выборку (dm.DeliveryMethodName = 'Air Freight' or dm.DeliveryMethodName = 'Refrigerated Air Freight' ), но при текущем варианте так же ищет по стоимости запроса в плане
po.ExpectedDeliveryDate between '2014-01-01' and '2014-01-31'
--не выдаст ничего, т.к. с такими параметрами нет записей (либо в 2013 году искать, либо другие методы доставки использовать)