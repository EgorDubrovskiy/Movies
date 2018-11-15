USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetSeasons') IS NOT NULL BEGIN DROP PROCEDURE GetSeasons END
GO
CREATE PROCEDURE GetSeasons(@CinemaName varchar(30), @CinemaOriginalName varchar(30))
AS
IF @CinemaName IS NULL AND @CinemaOriginalName IS NULL RETURN
DECLARE @IdCinema int = (SELECT Id FROM Cinema WHERE (@CinemaName IS NULL OR Name = @CinemaName)
AND (@CinemaOriginalName IS NULL OR OriginalName = @CinemaOriginalName))
SELECT Name, OriginalName, Number FROM Season
JOIN SeasonsToCinema ON SeasonsToCinema.IdSeason = Season.Id
WHERE SeasonsToCinema.IdCinema = @IdCinema
GO
--EXEC GetSeasons null, 'CIBcpwSWDU'

IF object_id('GetSeasonsForAdmin') IS NOT NULL BEGIN DROP PROCEDURE GetSeasonsForAdmin END
GO
CREATE PROCEDURE GetSeasonsForAdmin(@CinemaName varchar(30), @CinemaOriginalName varchar(30))
AS
IF @CinemaName IS NULL AND @CinemaOriginalName IS NULL RETURN
DECLARE @IdCinema int = (SELECT Id FROM Cinema WHERE (@CinemaName IS NULL OR Name = @CinemaName)
AND (@CinemaOriginalName IS NULL OR OriginalName = @CinemaOriginalName))
SELECT Season.Id, Season.Name, Season.OriginalName, Season.AgeLimit, Number, Year, Country.Name AS Country, Tagline, SrcTrailer,
MovieLength, SrcPoster, Description, Rating FROM Season
JOIN SeasonsToCinema ON SeasonsToCinema.IdSeason = Season.Id
JOIN Country ON Country.Id = Season.IdCountry
WHERE SeasonsToCinema.IdCinema = @IdCinema
GO

IF object_id('GetSeasonInfo') IS NOT NULL BEGIN DROP PROCEDURE GetSeasonInfo END
GO
CREATE PROCEDURE GetSeasonInfo(@CinemaName varchar(30), @CinemaOriginalName varchar(30), @SeasonNumber numeric(2))
AS
IF @CinemaName IS NULL AND @CinemaOriginalName IS NULL RETURN
DECLARE @IdCinema int = (SELECT Id FROM Cinema WHERE (@CinemaName IS NULL OR Name = @CinemaName)
AND (@CinemaOriginalName IS NULL OR OriginalName = @CinemaOriginalName))
SELECT Season.Id, Season.Name, Season.OriginalName, Season.AgeLimit, Number, Year, Country.Name AS Country, Tagline, SrcTrailer,
MovieLength, SrcPoster, Description, Rating FROM Season
JOIN SeasonsToCinema ON SeasonsToCinema.IdSeason = Season.Id
JOIN Country ON Country.Id = Season.IdCountry
WHERE SeasonsToCinema.IdCinema = @IdCinema AND Season.Number = @SeasonNumber
GO

--POST Ч создание ресурса
IF object_id('CreateSeason') IS NOT NULL BEGIN DROP PROCEDURE CreateSeason END
GO
CREATE PROCEDURE CreateSeason(@Name varchar(30), @OriginalName varchar(30), @CinemaName varchar(30), @CinemaOriginalName varchar(30), @AgeLimit numeric(2), @Year int, @Country varchar(30), @Tagline varchar(100), @SrcTrailer varchar(100),
@MovieLength time, @SrcPoster varchar(100), @Description varchar(500))
AS
IF @CinemaName IS NULL AND @CinemaOriginalName IS NULL RETURN
DECLARE @IdCinema int = (SELECT Id FROM Cinema WHERE (@CinemaName IS NULL OR Name = @CinemaName)
AND (@CinemaOriginalName IS NULL OR OriginalName = @CinemaOriginalName))
INSERT INTO Season(Name,OriginalName,AgeLimit,Year,IdCountry,Tagline,SrcTrailer,MovieLength,SrcPoster,Description) 
VALUES(@Name,@OriginalName,@AgeLimit,@Year,(SELECT Id FROM Country WHERE Name = @Country),@Tagline,@SrcTrailer,@MovieLength,@SrcPoster,@Description)
INSERT INTO SeasonsToCinema(IdSeason,IdCinema) VALUES(@@IDENTITY, @IdCinema)
GO

IF object_id('AddViewToSeason') IS NOT NULL BEGIN DROP PROCEDURE AddViewToSeason END
GO
CREATE PROCEDURE AddViewToSeason(@CinemaName varchar(30), @CinemaOriginalName varchar(30), @SeasonNumber numeric)
AS
IF @CinemaName IS NULL AND @CinemaOriginalName IS NULL RETURN
DECLARE @IdCinema int = (SELECT Id FROM Cinema WHERE (@CinemaName IS NULL OR Name = @CinemaName)
AND (@CinemaOriginalName IS NULL OR OriginalName = @CinemaOriginalName))
DECLARE @IdSeason int = (
SELECT Season.id FROM SeasonsToCinema
JOIN Season ON Season.id = SeasonsToCinema.idSeason
WHERE IdCinema = @IdCinema AND  Season.Number = @SeasonNumber
)
UPDATE Season
SET NumOfViews = (SELECT NumOfViews FROM Season WHERE Id = @IdSeason) + 1
WHERE Id = @IdSeason
GO

--PUT Ч обновление ресурса
IF object_id('UpdateSeason') IS NOT NULL BEGIN DROP PROCEDURE UpdateSeason END
GO
CREATE PROCEDURE UpdateSeason(@Id int, @Name varchar(30), @OriginalName varchar(30), @AgeLimit numeric(2), @Year int, @Country varchar(30), @Tagline varchar(100), @SrcTrailer varchar(100),
@MovieLength time, @SrcPoster varchar(100), @Description varchar(500))
AS
UPDATE Season
SET Name = @Name, OriginalName = @OriginalName, AgeLimit = @AgeLimit, Year = @Year,IdCountry = (SELECT Id FROM Country WHERE Name = @Country),Tagline = @Tagline, 
SrcTrailer = @SrcTrailer, MovieLength = @MovieLength, SrcPoster = @SrcPoster, Description = @Description
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteSeason') IS NOT NULL BEGIN DROP PROCEDURE DeleteSeason END
GO
CREATE PROCEDURE DeleteSeason(@Id int)
AS
DELETE FROM Season WHERE Id = @Id
GO
