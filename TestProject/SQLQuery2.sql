/*
2. —оздать 3-4 основные таблицы дл¤ своего проекта.
*/

use test;
GO

--drop TABLE People


CREATE TABLE People(
	id 	int not null identity(1, 1)  primary key, --первичный ключ
	fio	varchar(50) ,
	d_r	date,
	tel	varchar(20)
)
CREATE TABLE Model(
	id 			int not null identity(1, 1)  primary key,		--первичный ключ
	ModelName 	varchar(100) ,
	Autor 		varchar(50)  ,
	Price 		money 
);

CREATE TABLE Orders (
	id 	int not null identity(1, 1)  primary key,--первичный ключ
	id_people 		int not null ,
	id_Model 		int not null ,
	OrderName  		varchar(100) ,
	OrderDate		datetime,
	Purshage		int  
)