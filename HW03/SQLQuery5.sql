/*Подзапросы и CTE
Для всех заданий, где возможно, сделайте два варианта запросов:
1) через вложенный запрос
2) через WITH (для производных таблиц)
*/
/*
Опционально:

5. Объясните, что делает и оптимизируйте запрос:
SELECT
Invoices.InvoiceID,
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL
AND Orders.OrderId = Invoices.OrderId)
) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
Можно двигаться как в сторону улучшения читабельности запроса, так и в сторону упрощения плана\ускорения. 
Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
Напишите ваши рассуждения по поводу оптимизации.
*/
use WideWorldImporters
SET STATISTICS IO, TIME ON
--исходный текст запроса, с отступами для удобства чтения
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 31 ms, elapsed time = 55 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(затронуто строк: 8)
Table 'OrderLines'. Scan count 16, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 508, lob physical reads 3, lob read-ahead reads 790.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'InvoiceLines'. Scan count 16, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 502, lob physical reads 3, lob read-ahead reads 778.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Orders'. Scan count 9, logical reads 725, physical reads 3, read-ahead reads 667, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 9, logical reads 11994, physical reads 3, read-ahead reads 10711, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'People'. Scan count 6, logical reads 28, physical reads 1, read-ahead reads 2, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(затронута одна строка)

 SQL Server Execution Times:
   CPU time = 345 ms,  elapsed time = 390 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Время выполнения: 2020-07-16T23:55:29.0047511+05:00
*/
SELECT
Invoices.InvoiceID,
Invoices.InvoiceDate,
	(SELECT People.FullName --тут выводит полное имя клиента. можно перевести в join 
	FROM Application.People
	WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice,
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) --дублируется с секцией в join SUM(Quantity*UnitPrice)
	FROM Sales.OrderLines
	WHERE OrderLines.OrderId = 
		(SELECT Orders.OrderId
		FROM Sales.Orders
		WHERE Orders.PickingCompletedWhen IS NOT NULL
		AND Orders.OrderId = Invoices.OrderId)
	) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC



--текст поправленный
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 15 ms, elapsed time = 40 ms.

(затронуто строк: 8)
Table 'InvoiceLines'. Scan count 16, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 502, lob physical reads 3, lob read-ahead reads 778.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Invoices'. Scan count 9, logical reads 11994, physical reads 3, read-ahead reads 10399, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'People'. Scan count 9, logical reads 28, physical reads 1, read-ahead reads 2, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(затронута одна строка)

 SQL Server Execution Times:
   CPU time = 249 ms,  elapsed time = 336 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Время выполнения: 2020-07-16T23:56:49.4435910+05:00

*/
;with 
SalesTotals as
(
SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
)

select 
Invoices.InvoiceID,
Invoices.InvoiceDate,
Application.People.FullName AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice
	from  Sales.Invoices
	JOIN SalesTotals ON Invoices.InvoiceID = SalesTotals.InvoiceID
	join Application.People on Application.People.PersonID = Invoices.SalespersonPersonID