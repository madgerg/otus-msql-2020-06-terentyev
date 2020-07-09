--4. ������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� � ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
--�������:
--* ������ �������� (DeliveryMethodName)
--* ���� ��������
--* ��� ����������
--* ��� ����������� ���� ������������ ����� (ContactPerson)
--�������: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.

use WideWorldImporters
select   
	dm.DeliveryMethodName,
	po.ExpectedDeliveryDate,
	s.SupplierName,
	p.FullName
	from Purchasing.PurchaseOrders po
	join Purchasing.Suppliers s
		on po.SupplierID = s.SupplierID
	join Application.DeliveryMethods dm
		on po.DeliveryMethodID = dm.DeliveryMethodID
	join Application.People p
		on p.PersonID = s.PrimaryContactPersonID
where 
dm.DeliveryMethodName like '%Air Freight' and 
--dm.DeliveryMethodName = 'Air Freight' or dm.DeliveryMethodName = 'Refrigerated Air Freight' and
--����� ���� �� ������� ������� (dm.DeliveryMethodName = 'Air Freight' or dm.DeliveryMethodName = 'Refrigerated Air Freight' ), �� ��� ������� �������� ��� �� ���� �� ��������� ������� � �����
po.ExpectedDeliveryDate between '2014-01-01' and '2014-01-31'
--�� ������ ������, �.�. � ������ ����������� ��� ������� (���� � 2013 ���� ������, ���� ������ ������ �������� ������������)