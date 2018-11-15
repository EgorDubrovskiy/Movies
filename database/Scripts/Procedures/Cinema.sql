USE MoviesDB
GO

--GET — получение ресурса
--Obj CinemaInfo{
--String Name, string OriginalName, int AgeLimit, date DateAdded, int Year, time MovieLength, int Rating, string SrcPoster, string SeasonName, string SeasonOriginalName
--}

IF type_id('ListName') IS NULL 
BEGIN 
CREATE TYPE ListName
AS TABLE (Name varchar(30));
END

IF type_id('ListNameAndLastName') IS NULL 
BEGIN 
CREATE TYPE ListNameAndLastName
AS TABLE (Id int, Number tinyint, Name varchar(30),LastName varchar(30));
END

IF object_id('QuickSearchCinema') IS NOT NULL BEGIN DROP PROCEDURE QuickSearchCinema END
GO
CREATE PROCEDURE QuickSearchCinema(@Name varchar(30), @CountDataInView int, @NumView int)
AS
SELECT TOP(@CountDataInView) Cinema.Name, Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
WHERE CONCAT(Cinema.Name,' ',Cinema.OriginalName,' ', Season.Name,' ',Season.OriginalName) LIKE '%'+@Name+'%' AND Cinema.Id >= (@CountDataInView * @NumView) - @NumView
ORDER BY Cinema.Id DESC
GO

IF object_id('AdvancedSearchCinema') IS NOT NULL BEGIN DROP PROCEDURE AdvancedSearchCinema END
GO
CREATE PROCEDURE AdvancedSearchCinema(@Name varchar(30), @Genres varchar(max), @Country varchar(30), @Year int, @CountDataInView int, @NumView int)
AS
SET NOCOUNT ON
--convert string to table
DECLARE @GenresTable table(Name varchar(max)) 
INSERT INTO @GenresTable(Name) (select * from GetStrTable(@Genres))
SELECT TOP(@CountDataInView) Cinema.Name,Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
JOIN GenresToSeason ON Season.Id = GenresToSeason.IdSeason
JOIN Genre ON Genre.Id = GenresToSeason.IdGenre
JOIN Country ON Country.Id = Season.IdCountry
WHERE CONCAT(Cinema.Name,' ',Cinema.OriginalName,' ', Season.Name,' ',Season.OriginalName) LIKE '%'+@Name+'%' AND Cinema.Id >= (@CountDataInView * @NumView) - @NumView
AND Genre.Name IN((select * from GetStrTable(@Genres)))
AND Country.Name LIKE '%'+@Country+'%' AND (@Year IS NULL OR Season.Year = @Year)
ORDER BY Cinema.Id DESC
GO
--EXEC AdvancedSearchCinema 'Ф', 'Детектив,Мелодрама', 'С', 2000, 10,1

IF object_id('GetTop50Cinema') IS NOT NULL BEGIN DROP PROCEDURE GetTop50Cinema END
GO
CREATE PROCEDURE GetTop50Cinema(@CountDataInView int, @NumView int)
AS
SELECT TOP(@CountDataInView) Cinema.Name,Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
WHERE Cinema.Id >= (@CountDataInView * @NumView) - @NumView
ORDER BY Season.NumOfViews DESC, Season.Rating DESC, Cinema.Id DESC
GO
--EXEC GetTop50Cinema 10, 1

IF object_id('GetNoveltiesCinema') IS NOT NULL BEGIN DROP PROCEDURE GetNoveltiesCinema END
GO
CREATE PROCEDURE GetNoveltiesCinema(@CountDataInView int, @NumView int)
AS
SELECT TOP(@CountDataInView) Cinema.Name, Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
WHERE Cinema.Id >= (@CountDataInView * @NumView) - @NumView
ORDER BY Season.DateAdded DESC, Cinema.Id DESC
GO
--EXEC GetNoveltiesCinema 10, 1

IF object_id('SearchNoveltiesCinema') IS NOT NULL BEGIN DROP PROCEDURE SearchNoveltiesCinema END
GO
CREATE PROCEDURE SearchNoveltiesCinema(@CountDataInView int, @NumView int, @Genres varchar(max))
AS
SET NOCOUNT ON
--convert string to table
DECLARE @GenresTable table(Name varchar(max)) 
INSERT INTO @GenresTable(Name) (select * from GetStrTable(@Genres))
SELECT TOP(@CountDataInView) Cinema.Name, Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
JOIN GenresToSeason ON Season.Id = GenresToSeason.IdSeason
JOIN Genre ON Genre.Id = GenresToSeason.IdGenre
WHERE Genre.Name IN((SELECT Name FROM @GenresTable)) AND Cinema.Id >= (@CountDataInView * @NumView) - @NumView
ORDER BY Season.DateAdded DESC, Cinema.Id DESC
GO
--example
--exec SearchNoveltiesCinema 10, 2, 'Боевик'

IF object_id('GetAnnouncementsCinema') IS NOT NULL BEGIN DROP PROCEDURE GetAnnouncementsCinema END
GO
CREATE PROCEDURE GetAnnouncementsCinema(@CountDataInView int, @NumView int)
AS
SELECT TOP(@CountDataInView) Cinema.Name, Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
WHERE NOT EXISTS(SELECT Id FROM VideosToSeason WHERE IdSeason = Season.Id) AND Cinema.Id >= (@CountDataInView * @NumView) - @NumView
ORDER BY Cinema.Id DESC
GO
--EXEC GetAnnouncementsCinema 10, 1

IF object_id('SearchAnnouncementsCinema') IS NOT NULL BEGIN DROP PROCEDURE SearchAnnouncementsCinema END
GO
CREATE PROCEDURE SearchAnnouncementsCinema(@CountDataInView int, @NumView int, @Genres varchar(max))
AS
SET NOCOUNT ON
--convert string to table
DECLARE @GenresTable table(Name varchar(max)) 
INSERT INTO @GenresTable(Name) (select * from GetStrTable(@Genres))
SELECT TOP(@CountDataInView) Cinema.Name, Cinema.OriginalName, Season.AgeLimit, DateAdded, Year, MovieLength,
Rating, SrcPoster, Season.Name AS SeasonName, Season.OriginalName AS SeasonOriginalName FROM Cinema 
JOIN SeasonsToCinema ON SeasonsToCinema.IdCinema = Cinema.Id
JOIN Season ON Season.Id = SeasonsToCinema.IdSeason
JOIN GenresToSeason ON Season.Id = GenresToSeason.IdSeason
JOIN Genre ON Genre.Id = GenresToSeason.IdGenre
WHERE NOT EXISTS(SELECT Id FROM VideosToSeason WHERE IdSeason = Season.Id) AND Genre.Name IN((SELECT Name FROM @GenresTable)) AND Cinema.Id >= (@CountDataInView * @NumView) - @NumView
ORDER BY Cinema.Id DESC
GO
--example
--exec SearchAnnouncementsCinema 10, 1, 'Боевик'

--POST — создание ресурса
IF object_id('CreateCinema') IS NOT NULL BEGIN DROP PROCEDURE CreateCinema END
GO
CREATE PROCEDURE CreateCinema(@TypeOfCinema varchar(30), @CinemaName varchar(30), @CinemaOriginalName varchar(30), @SeasonName varchar(30), @SeasonOriginalName varchar(30), @AgeLimit numeric(2), @Year numeric(4), @Country varchar(30),
@TagLine varchar(100), @SrcTrailer varchar(100), @MovieLengh time, @SrcPoster varchar(100), @Description varchar(500),
@Directors varchar(max), @Actors varchar(max), @Genres varchar(max))
AS
SET NOCOUNT ON
--convert strings to tables
DECLARE @DirectorsTable table(Name varchar(max), LastName varchar(max))
INSERT INTO @DirectorsTable(Name,LastName) (select * from Get2StrTable(@Directors))
DECLARE @ActorsTable table(Name varchar(max), LastName varchar(max))
INSERT INTO @ActorsTable(Name,LastName) (select * from Get2StrTable(@Actors))
--convert string to table
DECLARE @GenresTable table(Name varchar(max))
INSERT INTO @GenresTable(Name) (select * from GetStrTable(@Genres))

INSERT INTO Cinema(Name, IdTypeOfCinema,OriginalName) VALUES(@CinemaName, (SELECT Id FROM TypeOfCinema WHERE Name = @TypeOfCinema),@CinemaOriginalName)
DECLARE @IdCinema int = @@IDENTITY
INSERT INTO Season(Name,OriginalName,AgeLimit,Year,IdCountry,Tagline,SrcTrailer,MovieLength,SrcPoster,Description) 
VALUES(@SeasonName,@SeasonOriginalName,@AgeLimit,@Year,(SELECT Id FROM Country WHERE Name = @Country), @TagLine,@SrcTrailer,@MovieLengh,@SrcPoster,@Description)
DECLARE @IdSeason int = @@IDENTITY
INSERT INTO SeasonsToCinema(IdCinema,IdSeason) VALUES(@IdCinema,@IdSeason)
WHILE (SELECT COUNT(*) FROM @GenresTable) > 0
BEGIN 
INSERT INTO GenresToSeason(idGenre,idSeason)
VALUES((SELECT id FROM Genre WHERE name = (SELECT TOP(1) name FROM @GenresTable)),@IdSeason)
DELETE TOP(1) FROM @GenresTable
END
--insert actors begin
WHILE (SELECT COUNT(*) FROM @ActorsTable) > 0
BEGIN
DECLARE @ActorName varchar(30) = (SELECT TOP(1) Name FROM @ActorsTable)
DECLARE @ActorLastName varchar(30) = (SELECT TOP(1) LastName FROM @ActorsTable)
INSERT INTO ActorsToSeason(IdActor,IdSeason)
VALUES((SELECT Id FROM Actor WHERE Name = @ActorName AND LastName = @ActorLastName),@IdSeason)
DELETE TOP(1) FROM @ActorsTable
END
--insert actors end
--insert directors begin
WHILE (SELECT COUNT(*) FROM @DirectorsTable) > 0
BEGIN
DECLARE @DirectorName varchar(30) = (SELECT TOP(1) Name FROM @DirectorsTable)
DECLARE @DirectorLastName varchar(30) = (SELECT TOP(1) LastName FROM @DirectorsTable)
INSERT INTO DirectorsToSeason(IdDirector,IdSeason)
VALUES((SELECT Id FROM Director WHERE Name = @DirectorName AND LastName = @DirectorLastName), @IdSeason)
DELETE TOP(1) FROM @DirectorsTable
END
--insert directors end
GO

--PUT — обновление ресурса
--Obj UpdateCinemaProps{string Name, string TypeOfCinema}

IF object_id('UpdateCinema') IS NOT NULL BEGIN DROP PROCEDURE UpdateCinema END
GO
CREATE PROCEDURE UpdateCinema(@Name varchar(30), @NewName varchar(30), @NewOriginalName varchar(30), @NewTypeOfCinema varchar(30))
AS
UPDATE Cinema
SET Name = @NewName, OriginalName = @NewOriginalName, IdTypeOfCinema = (SELECT Id FROM TypeOfCinema WHERE Name = @NewTypeOfCinema)
WHERE Name = @Name
GO

--DELETE — удаление ресурса
IF object_id('DeleteCinema') IS NOT NULL BEGIN DROP PROCEDURE DeleteCinema END
GO
CREATE PROCEDURE DeleteCinema(@Id int)
AS
DELETE FROM Cinema WHERE Id = @Id
GO
