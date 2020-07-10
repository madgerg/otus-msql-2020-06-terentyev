/*
1. —оздать базу данных.
*/
CREATE DATABASE [test]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = test2, FILENAME = N'D:\OTUS SQL\test.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 65536KB )
 LOG ON 
( NAME = test2_log, FILENAME = N'D:\OTUS SQL\test_log.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = 5GB , 
	FILEGROWTH = 65536KB )
GO
