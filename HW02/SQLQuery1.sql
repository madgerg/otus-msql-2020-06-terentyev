--1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal"
--�������: Warehouse.StockItems.
use WideWorldImporters
select StockItemName
	from Warehouse.StockItems
	where StockItemName like '%urgent%'or StockItemName like 'Animal%'