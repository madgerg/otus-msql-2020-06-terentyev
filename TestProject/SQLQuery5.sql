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