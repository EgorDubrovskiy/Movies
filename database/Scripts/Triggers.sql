USE MoviesDB
GO

--тригеры
IF object_id('AfterInsert_SeasonsToCinema') IS NOT NULL BEGIN DROP TRIGGER AfterInsert_SeasonsToCinema END
GO
CREATE TRIGGER AfterInsert_SeasonsToCinema
ON SeasonsToCinema
AFTER INSERT
AS
DECLARE @NumOfSeason numeric = (SELECT COUNT(*) FROM SeasonsToCinema JOIN inserted ON inserted.IdCinema = SeasonsToCinema.IdCinema)
--Cinema.NumOfSeason
UPDATE Cinema
SET NumOfSeason = @NumOfSeason
WHERE Id = (SELECT IdCinema FROM inserted)
--Season.Number
DECLARE @NumberOfSeason int = (SELECT COUNT(*) FROM SeasonsToCinema WHERE IdCinema = (SELECT IdCinema FROM inserted))
UPDATE Season SET Number = @NumberOfSeason WHERE Id = (SELECT IdSeason FROM inserted)
GO

IF object_id('AfterInsert_VideosToSeason') IS NOT NULL BEGIN DROP TRIGGER AfterInsert_VideosToSeason END
GO
CREATE TRIGGER AfterInsert_VideosToSeason
ON VideosToSeason
AFTER INSERT
AS
--Video.Number
DECLARE @CountVideo int = (SELECT COUNT(*) FROM VideosToSeason WHERE IdSeason = (SELECT IdSeason FROM inserted))
UPDATE Video 
SET Number = @CountVideo
WHERE Id = (SELECT IdVideo FROM inserted)
--Season.NumofVideos,ApdateDate
UPDATE Season
SET NumOfVideos = @CountVideo, ApdateDate = GETDATE()
WHERE Id = (SELECT IdSeason FROM inserted)
GO

IF object_id('AfterDelete_VideosToSeason') IS NOT NULL BEGIN DROP TRIGGER AfterDelete_VideosToSeason END
GO
CREATE TRIGGER AfterDelete_VideosToSeason
ON VideosToSeason
AFTER DELETE
AS
DECLARE @CountVideo int = (SELECT NumOfVideos FROM Season WHERE Id = (SELECT IdSeason FROM deleted))
--Season.NumofVideos
UPDATE Season
SET NumOfVideos = @CountVideo
WHERE Id = (SELECT IdSeason FROM deleted)
GO

--Rating bigin
IF object_id('AfterInsert_RatingToSeason') IS NOT NULL BEGIN DROP TRIGGER AfterInsert_RatingToSeason END
GO
CREATE TRIGGER AfterInsert_RatingToSeason
ON RatingToSeason
AFTER INSERT
AS
DECLARE @IdSeason int = (SELECT IdSeason FROM inserted)
EXEC UpdateAllRating @IdSeason
GO

IF object_id('AfterUpdate_RatingToSeason') IS NOT NULL BEGIN DROP TRIGGER AfterUpdate_RatingToSeason END
GO
CREATE TRIGGER AfterUpdate_RatingToSeason
ON RatingToSeason
AFTER UPDATE
AS
DECLARE @IdSeason int = (SELECT IdSeason FROM inserted)
EXEC UpdateAllRating @IdSeason
GO

IF object_id('AfterDelete_RatingToSeason') IS NOT NULL BEGIN DROP TRIGGER AfterDelete_RatingToSeason END
GO
CREATE TRIGGER AfterDelete_RatingToSeason
ON RatingToSeason
AFTER DELETE
AS
DECLARE @IdSeason int = (SELECT IdSeason FROM deleted)
EXEC UpdateAllRating @IdSeason
GO
--Rating end