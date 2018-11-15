USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetActors') IS NOT NULL BEGIN DROP PROCEDURE GetActors END
GO
CREATE PROCEDURE GetActors(@Limit int)
AS
SELECT TOP(@Limit) Id, Name, LastName FROM Actor
GO

IF object_id('SearchActors') IS NOT NULL BEGIN DROP PROCEDURE SearchActors END
GO
CREATE PROCEDURE SearchActors(@Limit int, @Name varchar(30), @LastName varchar(30))
AS
SELECT TOP(@Limit) Id, Name, LastName FROM Actor
WHERE Name LIKE '%'+@Name+'%' AND LastName LIKE '%'+@LastName+'%'
GO

--POST Ч создание ресурса
IF object_id('AddActor') IS NOT NULL BEGIN DROP PROCEDURE AddActor END
GO
CREATE PROCEDURE AddActor(@Name varchar(30), @LastName varchar(30))
AS
INSERT INTO Actor(Name,LastName) VALUES(@Name,@LastName)
GO

--PUT Ч обновление ресурса
IF object_id('UpdateActor') IS NOT NULL BEGIN DROP PROCEDURE UpdateActor END
GO
CREATE PROCEDURE UpdateActor(@Id int, @NewName varchar(30), @NewLastName varchar(30))
AS
UPDATE Actor
SET Name = @NewName, LastName = @NewLastName
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteActor') IS NOT NULL BEGIN DROP PROCEDURE DeleteActor END
GO
CREATE PROCEDURE DeleteActor(@Id int)
AS
DELETE FROM Actor WHERE Id = @Id
GO
