--1. Все товары, в названии которых есть "urgent" или название начинается с "Animal"
--Таблицы: Warehouse.StockItems.
use WideWorldImporters
select StockItemName
	from Warehouse.StockItems
	where StockItemName like '%urgent%'or StockItemName like 'Animal%'
