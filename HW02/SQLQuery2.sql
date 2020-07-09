--2. ����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders). ������� ����� JOIN, � ����������� ������� ������� �� �����.
--�������: Purchasing.Suppliers, Purchasing.PurchaseOrders.
use WideWorldImporters
select s.SupplierName
	from Purchasing.PurchaseOrders t
	  right join Purchasing.Suppliers s 
		on t.SupplierID = s.SupplierID
	where t.SupplierID is null


