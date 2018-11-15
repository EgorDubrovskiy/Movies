USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetGenres') IS NOT NULL BEGIN DROP PROCEDURE GetGenres END
GO
CREATE PROCEDURE GetGenres(@Limit int)
AS
SELECT TOP(@Limit) Id, Name FROM Genre
GO

IF object_id('SearchGenres') IS NOT NULL BEGIN DROP PROCEDURE SearchGenres END
GO
CREATE PROCEDURE SearchGenres(@Limit int, @Name varchar(30))
AS
SELECT TOP(@Limit) Id, Name FROM Genre WHERE Name LIKE '%'+@Name+'%'
GO

--POST Ч создание ресурса
IF object_id('AddGenre') IS NOT NULL BEGIN DROP PROCEDURE AddGenre END
GO
CREATE PROCEDURE AddGenre(@Name varchar(30))
AS
INSERT INTO Genre(Name) VALUES(@Name)
GO

--PUT Ч обновление ресурса
IF object_id('UpdateGenre') IS NOT NULL BEGIN DROP PROCEDURE UpdateGenre END
GO
CREATE PROCEDURE UpdateGenre(@Id int, @NewName varchar(30))
AS
UPDATE Genre
SET Name = @NewName
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteGenre') IS NOT NULL BEGIN DROP PROCEDURE DeleteGenre END
GO
CREATE PROCEDURE DeleteGenre(@Id int)
AS
DELETE FROM Genre WHERE Id = @Id
GO