/*
3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц.
Группировка должна быть по году, месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/
use WideWorldImporters -- переключаемся на нашу бд

 select	--выводим данные
 --условия замены вывода
  CASE grouping(year(i.InvoiceDate)) 
    WHEN 1 THEN CAST('ALL total' as NCHAR(10))
    ELSE CAST(year(i.InvoiceDate) as NCHAR(5))
  END as 'Год продажи',

    CASE grouping(month(i.InvoiceDate)) 
    WHEN 1 THEN 'Total month'
    ELSE CAST(month(i.InvoiceDate) as NCHAR(5))
  END as 'Месяц продажи',

    CASE  --если продажи больше определенного кол-ва, то пишем, что хорошие продажи, иначе - Плохие продажи
	when SUM(il.Quantity)>50 then CAST('Good' as NCHAR(10))
	else CAST('bad sales' as NCHAR(10))
  END as 'Кол-во проданого',
		s.StockItemName as 'Наименование товара',
		SUM(il.UnitPrice) as '—Сумма продаж',
		min(InvoiceDate) as 'Дата первой продажи',
		SUM(il.Quantity) as 'Кол-во проданого'
 from Sales.Invoices i --откуда берем данные
		 join sales.InvoiceLines il --джойним строки по продажам
		 on il.InvoiceID = i.InvoiceID
		 join Warehouse.StockItems s --джойним данные по позициям заказа для выяснения цены товара
		 on s.StockItemID = il.StockItemID
 group by ROLLUP(DATEPART(YYYY,i.InvoiceDate), DATEPART(MM,i.InvoiceDate),s.StockItemName) --группируем в разрезе даты
 -- HAVING SUM(il.Quantity) <= 50 --выводим только те, где продажно товара менее 50 ед в месяц
 order by DATEPART(YYYY,i.InvoiceDate), DATEPART(MM,i.InvoiceDate),s.StockItemName --выводим в разрезе даты