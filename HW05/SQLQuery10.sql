/*
1. —оздать базу данных.
*/
CREATE DATABASE test
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = test2, FILENAME = N'D:\OTUS SQL\test.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 255MB )
 LOG ON 
( NAME = test2_log, FILENAME = N'D:\OTUS SQL\test_log.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = 5GB , 
	FILEGROWTH = 255MB )
GO

/*
2. —оздать 3-4 основные таблицы дл¤ своего проекта.
*/
--
use test;
GO

/*
drop TABLE People
drop TABLE Model
drop TABLE Orders

drop DATABASE test
*/
use test;
GO
CREATE TABLE People(
	id 	int not null identity(1, 1)  primary key, --первичный ключ
	fio	nvarchar(50) ,
	d_r	datetime2,
	tel	nvarchar(20)
)
CREATE TABLE Model(
	id 			int not null identity(1, 1)  primary key,		--первичный ключ
	ModelName 	nvarchar(100) ,
	Autor 		nvarchar(50)  ,
	Price 		money 
);

CREATE TABLE Orders (
	id 	int not null identity(1, 1)  primary key,--первичный ключ
	id_people 		int not null ,
	id_Model 		int not null ,
	OrderName  		nvarchar(100) ,
	OrderDate		datetime2,
	Purshage		int  
)

/*
3. Первичные и внешние ключи для всех созданных таблиц.
*/

--первичные ключи создал в скрипте создания таблиц
USE [test]
GO
--создание внешнего ключа между [Orders] и [Model]
ALTER TABLE Orders  WITH CHECK ADD  CONSTRAINT FK_Orders_Model FOREIGN KEY(id_Model)
REFERENCES Model (id)
GO
--создание внешнего ключа между [Orders] и [People]
ALTER TABLE Orders  WITH CHECK ADD  CONSTRAINT FK_Orders_People FOREIGN KEY(id_people)
REFERENCES People (id)
GO

/*
4. 1-2 индекса на таблицы.
*/
create index idx_fio on People (fio);--индекс по фио
ALTER TABLE People --уникальный индекс по мылу
	ADD e_mail varchar(50) constraint e_mail_un unique;

create index idx_Model on Model (ModelName);

create index idx_OrderDate on Orders (OrderDate);

/*
5. Наложите по одному ограничению в каждой таблице на ввод данных.
*/
USE [test]
GO
--ограничение, дефолтное значение на Purshage в Orders
ALTER TABLE Orders ADD  CONSTRAINT v_pursage DEFAULT (0) FOR Purshage;
--установка параметра цена в 0
ALTER TABLE Model ADD  CONSTRAINT v_price DEFAULT (0) FOR Price;
--установка возраста заказчика не менее 18
ALTER TABLE People 
	ADD CONSTRAINT constr_dr 
		CHECK (datediff(yy, d_r, getdate()) >=18);