/*
2. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи
* Месяц продажи
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

use WideWorldImporters

 select	
  --услови¤ замены вывода
  CASE grouping(year(i.InvoiceDate)) 
    WHEN 1 THEN CAST('ALL total' as NCHAR(10))
    ELSE CAST(year(i.InvoiceDate) as NCHAR(5))
  END as 'Год продажи',
    CASE grouping(month(i.InvoiceDate)) 
    WHEN 1 THEN 'Total month'
    ELSE CAST(month(i.InvoiceDate) as NCHAR(5))
  END as 'Месяц продажи',
		SUM(il.UnitPrice*il.Quantity) as 'Общая сумма продаж'
 from Sales.Invoices i
		inner join sales.InvoiceLines il
		 on il.InvoiceID = i.InvoiceID
 group by ROLLUP( DATEPART(YYYY,i.InvoiceDate), DATEPART(MM,i.InvoiceDate))
 HAVING SUM(il.UnitPrice) > 10000 --выводим только те, где сумма продажи > 10000
 order by DATEPART(YYYY,i.InvoiceDate), DATEPART(MM,i.InvoiceDate)