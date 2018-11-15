USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetRating') IS NOT NULL BEGIN DROP PROCEDURE GetRating END
GO
CREATE PROCEDURE GetRating(@IdUser int, @IdSeason int)
AS
SELECT Rating FROM RatingToSeason
WHERE IdUser = @IdUser AND IdSeason = @IdSeason
GO

--POST Ч создание ресурса
IF object_id('AddRating') IS NOT NULL BEGIN DROP PROCEDURE AddRating END
GO
CREATE PROCEDURE AddRating(@IdUser int, @IdSeason int, @Rating tinyint)
AS
INSERT INTO RatingToSeason(IdUser,IdSeason,Rating) VALUES(@IdUser,@IdSeason,@Rating)
GO

--PUT Ч обновление ресурса
IF object_id('UpdateRating') IS NOT NULL BEGIN DROP PROCEDURE UpdateRating END
GO
CREATE PROCEDURE UpdateRating(@IdUser int, @IdSeason int, @NewRating tinyint)
AS
UPDATE RatingToSeason
SET Rating = @NewRating
WHERE IdUser = @IdUser AND IdSeason = @IdSeason
GO

IF object_id('UpdateAllRating') IS NOT NULL BEGIN DROP PROCEDURE UpdateAllRating END
GO
CREATE PROCEDURE UpdateAllRating(@IdSeason int)
AS
DECLARE @Rating float = CAST((SELECT SUM(Rating) FROM RatingToSeason WHERE IdSeason = @IdSeason) as float) / CAST((SELECT COUNT(*) FROM RatingToSeason WHERE IdSeason = @IdSeason) AS float)
UPDATE Season
SET Rating = @Rating
WHERE Id = @IdSeason
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteRating') IS NOT NULL BEGIN DROP PROCEDURE DeleteRating END
GO
CREATE PROCEDURE DeleteRating(@IdUser int, @IdSeason int)
AS
DELETE FROM RatingToSeason 
WHERE IdUser = @IdUser AND IdSeason = @IdSeason
GO
