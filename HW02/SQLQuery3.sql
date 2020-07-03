--3. Заказы (Orders) с ценой товара более 100$ либо количеством единиц товара более 20 штук и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
--Вывести:
--* OrderID
--* дату заказа в формате ДД.ММ.ГГГГ
--* название месяца, в котором была продажа
--* номер квартала, к которому относится продажа
--* треть года, к которой относится дата продажи (каждая треть по 4 месяца)
--* имя заказчика (Customer)
--Добавьте вариант этого запроса с постраничной выборкой, пропустив первую 1000 и отобразив следующие 100 записей. Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).
--Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.

use WideWorldImporters
select   
		o.OrderID,
		o.OrderDate,
		DATEPART(YEAR,o.OrderDate) as YearOfOrfer,
		DATEPART(month,o.OrderDate) as MonthOfOrder,
		DATEPART(quarter, o.OrderDate) as Quartal,
		CAST(ROUND(DATEPART(month,o.OrderDate)/5,0)+1 as int) as Triple,
		--UnitPrice,
		--ol.Quantity,
		--ol.PickingCompletedWhen,
		c.CustomerName
	from Sales.Orders o
	join Sales.OrderLines ol
		on ol.OrderID = o.OrderID
	join Sales.Customers c
		on c.CustomerID = o.CustomerID 
	where (UnitPrice > 100 or ol.Quantity>20) and ol.PickingCompletedWhen is not null  --and DATEPART(quarter, o.OrderDate)>3
	order by Quartal asc, CAST(ROUND(DATEPART(month,o.OrderDate)/4,0)+1 as int) asc, o.OrderDate asc
	OFFSET 1000 ROW FETCH NEXT 100 ROWS ONLY
