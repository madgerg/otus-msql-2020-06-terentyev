/*
Insert, Update, Merge
1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
2. удалите 1 запись из Customers, которая была вами добавлена
3. изменить одну запись, из добавленных через UPDATE
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/
USE WideWorldImporters;

--1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers--

INSERT INTO Sales.Customers --d какую таблицу вставлять. Далее идет перечисление полей, которые должны быть заполнены
	(CustomerID
	,CustomerName
	,LastEditedBy
	,BillToCustomerID
	,CustomerCategoryID
	,PrimaryContactPersonID
	,DeliveryMethodID
	,DeliveryCityID
	,PostalCityID
	,AccountOpenedDate
	,StandardDiscountPercentage
	,IsStatementSent
	,IsOnCreditHold
	,PaymentDays
	,PhoneNumber
	,FaxNumber
	,WebsiteURL
	,DeliveryAddressLine1
	,DeliveryPostalCode
	,PostalAddressLine1
	,PostalPostalCode
	)
VALUES --указываем, какие должны принять значения поля, указанные выше
	(NEXT VALUE FOR --1 value
	Sequences.CustomerID
	, 'Thulle'
	, 1
	,1
	,3
	,1199
	,3
	,34584
	,34584
	,'2020-08-01'
	,0
	,0
	,0
	,3
	,'(215) 555-0100'
	,'(215) 555-0100'
	,'http://www.tailspintoys.com/Thulle1'
	,'Shop 666'
	,'90788'
	,'PO Box 666'
	,90788
	)
	,(NEXT VALUE FOR --2 value
	Sequences.CustomerID
	, 'Thulle2'
	, 1
	,1
	,3
	,1199
	,3
	,34584
	,34584
	,'2020-08-01'
	,0
	,0
	,0
	,3
	,'(215) 555-0100'
	,'(215) 555-0100'
	,'http://www.tailspintoys.com/Thulle2'
	,'Shop 667'
	,'90788'
	,'PO Box 667'
	,90788
	)
		,(NEXT VALUE FOR --3 value
	Sequences.CustomerID
	, 'Thulle3'
	, 1
	,1
	,3
	,1199
	,3
	,34584
	,34584
	,'2020-08-01'
	,0
	,0
	,0
	,3
	,'(215) 555-0100'
	,'(215) 555-0100'
	,'http://www.tailspintoys.com/Thulle3'
	,'Shop 668'
	,'90788'
	,'PO Box 668'
	,90788
	)
		,(NEXT VALUE FOR --4 value
	Sequences.CustomerID
	, 'Thulle4'
	, 1
	,1
	,3
	,1199
	,3
	,34584
	,34584
	,'2020-08-01'
	,0
	,0
	,0
	,3
	,'(215) 555-0100'
	,'(215) 555-0100'
	,'http://www.tailspintoys.com/Thulle4'
	,'Shop 668'
	,'90788'
	,'PO Box 668'
	,90788
	)
		,(NEXT VALUE FOR --5 value
	Sequences.CustomerID
	, 'Thulle5'
	, 1
	,1
	,3
	,1199
	,3
	,34584
	,34584
	,'2020-08-01'
	,0
	,0
	,0
	,3
	,'(215) 555-0100'
	,'(215) 555-0100'
	,'http://www.tailspintoys.com/Thulle5'
	,'Shop 667'
	,'90788'
	,'PO Box 667'
	,90788
	)
drop table if exists #TempCustumers

	select * 
	INTO #TempCustumers	
	from Sales.Customers
	where AccountOpenedDate ='2020-08-01'

	select * --скопирую данные вставленные, чтобы потом использовать в мерже.
	from #TempCustumers	--во временную таблицу

--2. удалите 1 запись из Customers, которая была вами добавлена--

delete  
from Sales.Customers
where CustomerName = 'Thulle'

--ну и проверка, что удалилось значение. не должно быть строки с CustomerName = 'Thulle'
	select * 
	from Sales.Customers
	where AccountOpenedDate ='2020-08-01'

--	3. изменить одну запись, из добавленных через UPDATE
Update Sales.Customers
SET 
	BillToCustomerID =	2
	,CustomerCategoryID = 5
OUTPUT --сразу показываю старые значения и чем заменил, удобно ведь )
	inserted.BillToCustomerID as NewBillToCustomerID
	, deleted.BillToCustomerID as OldBillToCustomerID
	, inserted.CustomerCategoryID as NewCustomerCategoryID
	, deleted.CustomerCategoryID as OldCustomerCategoryID
WHERE CustomerName = 'Thulle2';

--ну и проверка, что изменились значения строки с CustomerName = 'Thulle2' у полей BillToCustomerID =2, CustomerCategoryID = 5
	select * 
	from Sales.Customers
	where AccountOpenedDate ='2020-08-01'

--4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
	MERGE Sales.Customers AS target 
	USING (SELECT 	CustomerID
					,CustomerName
					,LastEditedBy
					,BillToCustomerID
					,CustomerCategoryID
					,PrimaryContactPersonID
					,DeliveryMethodID
					,DeliveryCityID
					,PostalCityID
					,AccountOpenedDate
					,StandardDiscountPercentage
					,IsStatementSent
					,IsOnCreditHold
					,PaymentDays
					,PhoneNumber
					,FaxNumber
					,WebsiteURL
					,DeliveryAddressLine1
					,DeliveryPostalCode
					,PostalAddressLine1
					,PostalPostalCode
					
			FROM #TempCustumers	 
			--where AccountOpenedDate ='2020-08-01'
			--GROUP BY CustomerID
			) 
			AS source (CustomerID
						,CustomerName
						,LastEditedBy
						,BillToCustomerID
						,CustomerCategoryID
						,PrimaryContactPersonID
						,DeliveryMethodID
						,DeliveryCityID
						,PostalCityID
						,AccountOpenedDate
						,StandardDiscountPercentage
						,IsStatementSent
						,IsOnCreditHold
						,PaymentDays
						,PhoneNumber
						,FaxNumber
						,WebsiteURL
						,DeliveryAddressLine1
						,DeliveryPostalCode
						,PostalAddressLine1
						,PostalPostalCode
						) ON
		 (target.CustomerID = source.CustomerID) 
	WHEN MATCHED 
		THEN UPDATE SET LastEditedBy = source.LastEditedBy
	WHEN NOT MATCHED 
		THEN INSERT (CustomerID
						,CustomerName
						,LastEditedBy
						,BillToCustomerID
						,CustomerCategoryID
						,PrimaryContactPersonID
						,DeliveryMethodID
						,DeliveryCityID
						,PostalCityID
						,AccountOpenedDate
						,StandardDiscountPercentage
						,IsStatementSent
						,IsOnCreditHold
						,PaymentDays
						,PhoneNumber
						,FaxNumber
						,WebsiteURL
						,DeliveryAddressLine1
						,DeliveryPostalCode
						,PostalAddressLine1
						,PostalPostalCode
						) 
			 VALUES (source.CustomerID
						,source.CustomerName
						,source.LastEditedBy
						,source.BillToCustomerID
						,source.CustomerCategoryID
						,source.PrimaryContactPersonID
						,source.DeliveryMethodID
						,source.DeliveryCityID
						,source.PostalCityID
						,source.AccountOpenedDate
						,source.StandardDiscountPercentage
						,source.IsStatementSent
						,source.IsOnCreditHold
						,source.PaymentDays
						,source.PhoneNumber
						,source.FaxNumber
						,source.WebsiteURL
						,source.DeliveryAddressLine1
						,source.DeliveryPostalCode
						,source.PostalAddressLine1
						,source.PostalPostalCode
					) 
		OUTPUT $action, deleted.*,  inserted.*;

--5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
--конфигурирую и устанавливаю bcp и bulk
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

SELECT @@SERVERNAME --узнаю имя своей тачки и имя сервера.
--делаю копию таблицы Sales.Customers в текстовый файл Customers.txt
exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.Customers" out  "D:\OTUS SQL\Customers.txt" -T -w -t"@eu&$1&", -S UFA-TERENTYEVMY\SQL2017'

drop table if exists Sales.CustomersBAK

	select * 
	INTO Sales.CustomersBAK	
	from Sales.Customers
	where AccountOpenedDate ='2020-08-01'
 delete  
 from Sales.CustomersBAK	
 	where AccountOpenedDate ='2020-08-01'
 select * 
	from Sales.CustomersBAK	
	

BULK INSERT [WideWorldImporters].Sales.CustomersBAK	
				   FROM "D:\OTUS SQL\Customers.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '@eu&$1&',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );