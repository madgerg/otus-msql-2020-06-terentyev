/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам

Вывести:
* Год продажи
* Месяц продажи
* Средняя цена за месяц по всем товарам
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

use WideWorldImporters -- переключаемс¤ на нашу бд

 select	--выводим данные
  --услови¤ замены вывода
  CASE grouping(year(i.InvoiceDate)) 
    WHEN 1 THEN CAST('ALL total' as NCHAR(10))
    ELSE CAST(year(i.InvoiceDate) as NCHAR(5))
  END as 'Год продажи',
    CASE grouping(month(i.InvoiceDate)) 
    WHEN 1 THEN 'Total month'
    ELSE CAST(month(i.InvoiceDate) as NCHAR(5))
  END as 'Месяц продажи',
		AVG(s.UnitPrice) as 'Средняя цена за месяц по всем товарам',
		SUM(il.UnitPrice*il.Quantity) as 'Общая сумма продаж'
 from Sales.Invoices i --откуда берем данные
		 join sales.InvoiceLines il --ждойним строки по продажам
		 on il.InvoiceID = i.InvoiceID
		 join Warehouse.StockItems s --джойним данные по позици¤м заказа дл¤ вы¤снени¤ цены товара
		 on s.StockItemID = il.StockItemID
 group by ROLLUP(DATEPART(YYYY,i.InvoiceDate), DATEPART(MM,i.InvoiceDate)) --группируем в разрезе даты
 order by DATEPART(YYYY,i.InvoiceDate), DATEPART(MM,i.InvoiceDate) --выводим в разоезе даты