--2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders). Сделать через JOIN, с подзапросом задание принято не будет.
--Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
use WideWorldImporters
select s.SupplierName
	from Purchasing.PurchaseOrders t
	  right join Purchasing.Suppliers s 
		on t.SupplierID = s.SupplierID
	where t.SupplierID is null


