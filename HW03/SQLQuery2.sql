/*Подзапросы и CTE
Для всех заданий, где возможно, сделайте два варианта запросов:
1) через вложенный запрос
2) через WITH (для производных таблиц)
*/
/*
2. Выберите товары с минимальной ценой (подзапросом). 
Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

use WideWorldImporters
select 
	StockItemID, 
	StockItemName, 
	UnitPrice 
from Warehouse.StockItems 
where UnitPrice <=(
	select 
		min(unitprice) as MinPrice 
	from Warehouse.StockItems)

;with ListofStock
as (
	select 
	StockItemID, 
	StockItemName, 
	UnitPrice 
from Warehouse.StockItems 
where UnitPrice <=(
	select 
		min(unitprice) as MinPrice 
	from Warehouse.StockItems)
) 

select * from ListofStock;