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