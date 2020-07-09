--6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g. 
--��� ������ �������� � Warehouse.StockItems.
use WideWorldImporters
select  
		client.CustomerID,
		client.CustomerName,
		client.PhoneNumber
	from sales.Orders s
	join sales.OrderLines ol
		on ol.OrderID = s.OrderID
	join Warehouse.StockItems ws
		on ws.StockItemID = ol.StockItemID
	join Sales.Customers client
		on client.CustomerID = s.CustomerID
where ws.StockItemName = 'Chocolate frogs 250g'