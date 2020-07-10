/*Подзапросы и CTE
Для всех заданий, где возможно, сделайте два варианта запросов:
1) через вложенный запрос
2) через WITH (для производных таблиц)
*/
/*
4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, 
а также имя сотрудника, который осуществлял упаковку заказов (PackedByPersonID).
*/


use WideWorldImporters
--в какой-то момент сломался мозг удерживать подзапросы и перевел всё в представления
--помогли построить запросы списки зависимостей таблиц и диаграммы для визуализации связей.


;with ListofStock --формируем список самых дорогих товаров/ Топ 3
as (
	select 
	DISTINCT(StockItemID), 
	StockItemName, 
	UnitPrice 
from Warehouse.StockItems 
where UnitPrice in (
	select 
		 top 3 (unitprice) as MaxPrice 
	from Warehouse.StockItems order by UnitPrice desc)
), 
ListOfTransaction --формируем список транзакций с этими товарами
as 
(
select CustomerID, InvoiceID from Warehouse.StockItemTransactions stit
	join ListofStock lsi on lsi.StockItemID = stit.StockItemID
),
ListOfCustomer -- формируем список клиентов, купивших эти товары
as
(
select DeliveryCityID, InvoiceID
from sales.Customers cust 
join ListOfTransaction on ListOfTransaction.CustomerID = cust.CustomerID
)
,ListOfPackage --формируем список упаковщиков
as
(
select DeliveryCityID, sales.Invoices.InvoiceID, PackedByPersonID
from sales.Invoices
	join ListOfCustomer on ListOfCustomer.InvoiceID = sales.Invoices.InvoiceID
)
--финальный запрос не стал разбивать на подзапросы, и так видно, что творится
select CityID,CityName,PreferredName
from  ListOfPackage 
	join Application.Cities city on ListOfPackage.DeliveryCityID=city.CityID --выводим список город из доставки
	join Application.People pe on ListOfPackage.PackedByPersonID=pe.PersonID --выводим имя упаковщика