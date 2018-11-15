USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetDirectors') IS NOT NULL BEGIN DROP PROCEDURE GetDirectors END
GO
CREATE PROCEDURE GetDirectors(@Limit int)
AS
SELECT TOP(@Limit) Id, Name, LastName FROM Director
GO

IF object_id('SearchDirectors') IS NOT NULL BEGIN DROP PROCEDURE SearchDirectors END
GO
CREATE PROCEDURE SearchDirectors(@Limit int, @Name varchar(30), @LastName varchar(30))
AS
SELECT TOP(@Limit) Id, Name, LastName FROM Director
WHERE Name LIKE '%'+@Name+'%' AND LastName LIKE '%'+@LastName+'%'
GO

--POST Ч создание ресурса
IF object_id('AddDirector') IS NOT NULL BEGIN DROP PROCEDURE AddDirector END
GO
CREATE PROCEDURE AddDirector(@Name varchar(30), @LastName varchar(30))
AS
INSERT INTO Director(Name,LastName) VALUES(@Name,@LastName)
GO

--PUT Ч обновление ресурса
IF object_id('UpdateDirector') IS NOT NULL BEGIN DROP PROCEDURE UpdateDirector END
GO
CREATE PROCEDURE UpdateDirector(@Id int, @NewName varchar(30), @NewLastName varchar(30))
AS
UPDATE Director
SET Name = @NewName, LastName = @NewLastName
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteDirector') IS NOT NULL BEGIN DROP PROCEDURE DeleteDirector END
GO
CREATE PROCEDURE DeleteDirector(@Id int)
AS
DELETE FROM Director WHERE Id = @Id
GO