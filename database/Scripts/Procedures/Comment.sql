USE MoviesDB
GO

--GET Ч получение ресурса
--Comment{int IdComment, string UserLogin, string CinemaName, int SeasonNumber, string Text, Date Date}

IF object_id('SearchComments') IS NOT NULL BEGIN DROP PROCEDURE SearchComments END
GO
CREATE PROCEDURE SearchComments(@UserLogin varchar(30), @CinemaName varchar(30), @SeasonNumber numeric(2), @DateFrom date, @DateTo date)
AS
DECLARE @IdSeason int = (SELECT Season.Id FROM Season JOIN SeasonsToCinema ON Season.Id = SeasonsToCinema.IdSeason 
WHERE Season.Number = @SeasonNumber AND SeasonsToCinema.IdCinema = (SELECT Id FROM Cinema WHERE Name = @CinemaName))
SELECT Comment.Id AS IdComment, [User].Login AS UserLogin, Cinema.Name AS CinemaName, Season.Number AS SeasonNumber, Comment.Text, Comment.Date FROM Comment
JOIN [User] ON [User].Id = Comment.IdUser
JOIN Season On Season.Id = Comment.IdSeason
JOIN SeasonsToCinema ON SeasonsToCinema.IdSeason = Season.Id
JOIN Cinema ON Cinema.Id = SeasonsToCinema.IdCinema
WHERE [User].Login LIKE '%'+@UserLogin+'%' AND Cinema.Name LIKE '%'+@CinemaName+'%' AND (@SeasonNumber IS NULL OR Season.Number = @SeasonNumber)
AND (@DateFrom IS NULL OR Date >= @DateFrom) AND (@DateTo IS NULL OR Date <= @DateTo)
GO
--example
--exec SearchComments '1', '2', 1, '2008-03-06', '2010-03-06'

IF object_id('GetComments') IS NOT NULL BEGIN DROP PROCEDURE GetComments END
GO
CREATE PROCEDURE GetComments(@CinemaName varchar(30), @SeasonNumber numeric(2), @CountDataInView int, @NumView int)
AS
DECLARE @IdSeason int = (SELECT Season.Id FROM Season JOIN SeasonsToCinema ON Season.Id = SeasonsToCinema.IdSeason 
WHERE Season.Number = @SeasonNumber AND SeasonsToCinema.IdCinema = (SELECT Id FROM Cinema WHERE Name = @CinemaName))
SELECT TOP(@CountDataInView) Comment.Id AS IdComment, [User].Login AS UserLogin, Cinema.Name AS CinemaName, Season.Number AS SeasonNumber, Comment.Text, Comment.Date FROM Comment
JOIN [User] ON [User].Id = Comment.IdUser
JOIN Season On Season.Id = Comment.IdSeason
JOIN SeasonsToCinema ON SeasonsToCinema.IdSeason = Season.Id
JOIN Cinema ON Cinema.Id = SeasonsToCinema.IdCinema
WHERE Comment.Id >= (@CountDataInView*@NumView) - @CountDataInView
ORDER BY Comment.Id DESC
GO

--POST Ч создание ресурса
IF object_id('CreateComment') IS NOT NULL BEGIN DROP PROCEDURE CreateComment END
GO
CREATE PROCEDURE CreateComment(@UserLogin varchar(30), @CinemaName varchar(30), @SeasonNumber numeric(2), @Text text)
AS
DECLARE @IdSeason int = (SELECT Season.Id FROM Season JOIN SeasonsToCinema ON Season.Id = SeasonsToCinema.IdSeason 
WHERE Season.Number = @SeasonNumber AND SeasonsToCinema.IdCinema = (SELECT Id FROM Cinema WHERE Name = @CinemaName)),
@IdUser int = (SELECT Id FROM [User] WHERE Login = @UserLogin)
INSERT INTO Comment(IdUser,IdSeason,Text) VALUES(@IdUser,@IdSeason,@Text)
GO

--PUT Ч обновление ресурса
IF object_id('UpdateComment') IS NOT NULL BEGIN DROP PROCEDURE UpdateComment END
GO
CREATE PROCEDURE UpdateComment(@Id int, @NewText text)
AS
UPDATE Comment
SET Text = @NewText
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteComment') IS NOT NULL BEGIN DROP PROCEDURE DeleteComment END
GO
CREATE PROCEDURE DeleteComment(@Id int)
AS
DELETE FROM Comment WHERE Id = @Id
GO