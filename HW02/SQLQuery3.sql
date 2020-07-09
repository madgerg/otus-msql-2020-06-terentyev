--3. ������ (Orders) � ����� ������ ����� 100$ ���� ����������� ������ ������ ����� 20 ���� � �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
--�������:
--* OrderID
--* ���� ������ � ������� ��.��.����
--* �������� ������, � ������� ���� �������
--* ����� ��������, � �������� ��������� �������
--* ����� ����, � ������� ��������� ���� ������� (������ ����� �� 4 ������)
--* ��� ��������� (Customer)
--�������� ������� ����� ������� � ������������ ��������, ��������� ������ 1000 � ��������� ��������� 100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).
--�������: Sales.Orders, Sales.OrderLines, Sales.Customers.

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
