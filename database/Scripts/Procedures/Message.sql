USE MoviesDB
GO

--MessageInfo{id, Name, Email, Text, Date, AdminLogin, AdminEmail}

--GET Ч получение ресурса
IF object_id('GetMessages') IS NOT NULL BEGIN DROP PROCEDURE GetMessages END
GO
CREATE PROCEDURE GetMessages(@Limit int)
AS
SELECT TOP(@Limit) Message.Id, Message.Name, Message.Email, Text, Date, [User].Login AS AdminLogin, [User].Email AS AdminEmail FROM Message
JOIN [User] ON [User].Id =  Message.IdAdmin
GO
--EXEC GetMessages 10

IF object_id('SearchMessages') IS NOT NULL BEGIN DROP PROCEDURE SearchMessages END
GO
CREATE PROCEDURE SearchMessages(@Limit int, @UserName varchar(30), @UserEmail varchar(50), @DateFrom date, @DateTo date, @AdminLogin varchar(30), @AdminEmail varchar(50))
AS
SELECT TOP(@Limit) Message.Id, Message.Name, Message.Email, Text, Date, [User].Login AS AdminLogin, [User].Email AS AdminEmail FROM Message
JOIN [User] ON [User].Id =  Message.IdAdmin AND Message.Name LIKE '%'+@UserName+'%' AND Message.Email LIKE '%'+@UserEmail+'%'
AND (@DateFrom IS NULL or Message.Date >= @DateFrom) AND (@DateTo IS NULL or Message.Date <= @DateTo) 
AND [User].Login LIKE '%'+@AdminLogin+'%' AND [User].Email LIKE '%'+@AdminEmail+'%'
GO

--POST Ч создание ресурса
IF object_id('AddMessage') IS NOT NULL BEGIN DROP PROCEDURE AddMessage END
GO
CREATE PROCEDURE AddMessage(@Name varchar(30), @Email varchar(50), @Text text)
AS
INSERT INTO Message(Name,Email,Text,IdAdmin) VALUES(@Name,@Email,@Text,(SELECT TOP(1) Id FROM [User] WHERE IdRole = (SELECT Id FROM Role WHERE Name = 'јдмин')))
GO
--example
--EXEC AddMessage '1','1', '1'
--SELECT * FROM Message

--PUT Ч обновление ресурса
IF object_id('UpdateMessage') IS NOT NULL BEGIN DROP PROCEDURE UpdateMessage END
GO
CREATE PROCEDURE UpdateMessage(@Id int, @NewText text)
AS
UPDATE Message
SET Text = @NewText
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteMessage') IS NOT NULL BEGIN DROP PROCEDURE DeleteMessage END
GO
CREATE PROCEDURE DeleteMessage(@Id int)
AS
DELETE FROM Message WHERE Id = @Id
GO