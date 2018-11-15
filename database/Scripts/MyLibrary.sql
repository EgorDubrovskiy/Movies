USE MoviesDB
GO

SELECT TOP 8000 Number = IDENTITY(int, 1, 1)
   INTO   Numbers
   FROM   sysobjects t1, sysobjects t2, sysobjects t3
GO

IF object_id('GetStrTable') IS NOT NULL BEGIN DROP FUNCTION [dbo].[GetStrTable] END
GO
CREATE FUNCTION GetStrTable (@param varchar(max)) RETURNS TABLE AS
   RETURN(SELECT substring(',' + @param + ',', Number + 1,
                    charindex(',', ',' + @param + ',', Number + 1) - Number - 1)
                 AS Str
          FROM   Numbers
          WHERE  Number <= len(',' + @param + ',') - 1
            AND  substring(',' + @param + ',', Number, 1) = ',')
go
--example
--DECLARE @t table(Value varchar(max)) 
--INSERT INTO @t(Value) (select * from GetStrTable('Country7,Лилиляндия2,Лилиляндия5'))
--SELECT * FROM @t

IF object_id('Get2StrTable') IS NOT NULL BEGIN DROP FUNCTION [dbo].[Get2StrTable] END
GO
CREATE FUNCTION Get2StrTable (@str varchar(max)) RETURNS TABLE AS
   RETURN
   (
   SELECT SUBSTRING (
					substring(',' + @str + ',', Number + 1,charindex(',', ',' + @str + ',', Number + 1) - Number - 1),--from string between ","
					1,--beginning at first char after ","
					charindex('.',substring(',' + @str + ',', Number + 1,charindex(',', ',' + @str + ',', Number + 1) - Number - 1))-1--finish at last char before "."
					)
					AS Str1,
		  SUBSTRING (
					substring(',' + @str + ',', Number + 1,charindex(',', ',' + @str + ',', Number + 1) - Number - 1),--from string between ","
					charindex('.',substring(',' + @str + ',', Number + 1,charindex(',', ',' + @str + ',', Number + 1) - Number - 1))+1,--beginning at first char after "."
					charindex(',', ',' + @str + ',', Number + 1)--finish at last char before ","
					) 
					AS Str2
     FROM   Numbers
     WHERE  Number <= len(',' + @str + ',') - 1 AND  substring(',' + @str + ',', Number, 1) = ','
	)
GO
--example
--DECLARE @t table(Str1 varchar(max), Str2 varchar(max))
--declare @param varchar(7998) = 'Егор.Дубровский,Петр.Васин,Клавдий.Альбертов,Егор.Дубровский,Петр.Васин,Клавдий.Альбертов,Егор.Дубровский,Петр.Васин,Клавдий.Альбертов'
--INSERT INTO @t(Str1,Str2) (select * from Get2StrTable(@param))
--SELECT * FROM @t

--Для генерации даты внутри функции
IF EXISTS(select * FROM sys.views where name = 'vRand') DROP VIEW vRand
go
CREATE VIEW dbo.vRand(V) AS SELECT RAND();
go

IF object_id('getRandom') IS NOT NULL BEGIN DROP FUNCTION [dbo].[getRandom] END
GO
CREATE FUNCTION 
    [dbo].[getRandom]()
RETURNS FLOAT
AS
BEGIN
 Return (SELECT V FROM dbo.vRand)
END
go
--select dbo.getRandom()

--Случайное число в диапазоне
--drop function RandomInRange
IF object_id('RandomInRange') IS NOT NULL BEGIN DROP FUNCTION [dbo].[RandomInRange] END
GO
CREATE FUNCTION RandomInRange(@lower float, @upper float)
RETURNS INT
AS
BEGIN
	RETURN ROUND(((@upper - @lower) * dbo.getRandom() + @lower), 0)
END;
GO
--print dbo.RandomInRange(2,5,rand());

--Генерация рандомной даты
--Пояснение
--http://bd-subd.ru/ms-sql-server/sluchaynaya-data.htm
--Даты генерируются в пределах от 1 до 31, месяцы от 1 до 12, а год от 2000 до 2016
--DROP FUNCTION RandDate
IF object_id('RandDate') IS NOT NULL BEGIN DROP FUNCTION [dbo].[RandDate] END
GO
CREATE FUNCTION RandDate()
RETURNS SmallDateTime
AS
BEGIN
	DECLARE @Date smallint,@Month smallint,@Year smallint; 
      SET @Date = Round(1 + dbo.getRandom()*27, 0);
       SET @Month = Round(1 + dbo.getRandom()*11, 0); 
       SET @Year = Round(1 + dbo.getRandom()*16, 0) + 2000; 
	RETURN CAST(LTRIM(STR(@Date))+'-'+LTRIM(STR(@Month))+'-'+LTRIM(STR(@Year)) AS SmallDateTime);
END;
GO
--select dbo.RandDate()

--Генерация рандомной русской строки
IF object_id('RandStr') IS NOT NULL BEGIN DROP FUNCTION [dbo].[RandStr] END
GO
CREATE FUNCTION RandStr(@Length INT)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @CharPool nvarchar(max), @PoolLength INT, @LoopCount INT, @RandomString nvarchar(max);

	SET @CharPool = N'абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ.,-!';
	SET @PoolLength = Len(@CharPool)

	SET @LoopCount = 0
	SET @RandomString = ''

	WHILE (@LoopCount < @Length) BEGIN
		SELECT @RandomString = @RandomString + 
			SUBSTRING(@Charpool, CONVERT(int, dbo.getRandom() * @PoolLength), 1)
		SELECT @LoopCount = @LoopCount + 1
	END

	RETURN @RandomString;
END;
GO

--Генерация рандомной английской строки
IF object_id('RandAngStr') IS NOT NULL BEGIN DROP FUNCTION [dbo].[RandAngStr] END
GO
CREATE FUNCTION RandAngStr(@Length INT)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @CharPool nvarchar(max), @PoolLength INT, @LoopCount INT, @RandomString nvarchar(max);

	SET @CharPool = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
	SET @PoolLength = Len(@CharPool)

	SET @LoopCount = 0
	SET @RandomString = ''

	WHILE (@LoopCount < @Length) BEGIN
		SELECT @RandomString = @RandomString + 
			SUBSTRING(@Charpool, CONVERT(int, dbo.getRandom() * @PoolLength), 1)
		SELECT @LoopCount = @LoopCount + 1
	END

	RETURN @RandomString;
END;
GO

IF OBJECT_ID(N'FirstNames','U') IS NOT NULL
BEGIN DROP TABLE FirstNames END
GO
CREATE TABLE FirstNames (id int identity(1,1), name nvarchar(30))
INSERT FirstNames(name) VALUES
	(N'Иван'),
	(N'Петр'),
	(N'Андрей'),
	(N'Геннадий'),
	(N'Дмитрий'),
	(N'Михаил'),
	(N'Константин'),
	(N'Василий'),
	(N'Виктор'),
	(N'Стас'),
	(N'Александр'),
	(N'Олег');

IF OBJECT_ID(N'LastNames','U') IS NOT NULL
BEGIN DROP TABLE LastNames END
GO
CREATE TABLE LastNames (id int identity(1,1), name nvarchar(30))
INSERT LastNames(name) VALUES
	(N'Иванов'),
	(N'Петров'),
	(N'Андреев'),
	(N'Геннадиев'),
	(N'Дмитриев'),
	(N'Михаилов'),
	(N'Константинов'),
	(N'Василиев'),
	(N'Викторов'),
	(N'Стасов'),
	(N'Александров'),
	(N'Олеговов');
-- Filling cities table