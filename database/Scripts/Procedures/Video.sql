USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetVideos') IS NOT NULL BEGIN DROP PROCEDURE GetVideos END
GO
CREATE PROCEDURE GetVideos(@CinemaName varchar(30), @SeasonNumber numeric(2))
AS
SELECT Src, Video.Number FROM Video
JOIN VideosToSeason ON Video.Id = VideosToSeason.IdVideo
JOIN Season ON Season.Id = VideosToSeason.IdSeason
JOIN SeasonsToCinema On Season.Id = SeasonsToCinema.IdSeason
JOIN Cinema ON Cinema.Id = SeasonsToCinema.IdCinema
WHERE Cinema.Name = @CinemaName AND Season.Number = @SeasonNumber
GO

IF object_id('GetVideosForAdmin') IS NOT NULL BEGIN DROP PROCEDURE GetVideosForAdmin END
GO
CREATE PROCEDURE GetVideosForAdmin(@CinemaName varchar(30), @SeasonNumber numeric(2))
AS
SELECT Video.Id, Src, Video.Number FROM Video
JOIN VideosToSeason ON Video.Id = VideosToSeason.IdVideo
JOIN Season ON Season.Id = VideosToSeason.IdSeason
JOIN SeasonsToCinema On Season.Id = SeasonsToCinema.IdSeason
JOIN Cinema ON Cinema.Id = SeasonsToCinema.IdCinema
WHERE Cinema.Name = @CinemaName AND Season.Number = @SeasonNumber
GO

--POST Ч создание ресурса
IF object_id('CreateVideo') IS NOT NULL BEGIN DROP PROCEDURE CreateVideo END
GO
CREATE PROCEDURE CreateVideo(@IdSeason smallint, @Src varchar(100))
AS
INSERT INTO Video(Src) VALUES(@Src)
INSERT INTO VideosToSeason(IdSeason,IdVideo) VALUES(@IdSeason,@@IDENTITY)
GO

--PUT Ч обновление ресурса
IF object_id('UpdateVideo') IS NOT NULL BEGIN DROP PROCEDURE UpdateVideo END
GO
CREATE PROCEDURE UpdateVideo(@IdVideo smallint, @NewSrc varchar(100))
AS
UPDATE Video
SET Src = @NewSrc
WHERE Id = @IdVideo
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteVideo') IS NOT NULL BEGIN DROP PROCEDURE DeleteVideo END
GO
CREATE PROCEDURE DeleteVideo(@Id smallint)
AS
DELETE FROM Video WHERE Id = @Id
GO