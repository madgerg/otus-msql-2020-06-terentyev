/*
4. 1-2 индекса на таблицы.
*/
create index idx_fio on People (fio);--индекс по фио
ALTER TABLE People --уникальный индекс по мылу
	ADD e_mail varchar(50) constraint e_mail_un unique;

create index idx_Model on Model (ModelName);

create index idx_OrderDate on Orders (OrderDate);
