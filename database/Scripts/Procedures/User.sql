USE MoviesDB
GO

--GET Ч получение ресурса
IF object_id('GetUserInfo') IS NOT NULL BEGIN DROP PROCEDURE GetUserInfo END
GO
CREATE PROCEDURE GetUserInfo(@Login varchar(30))
AS
SELECT Email, Role.Name AS Role FROM [User]
JOIN Role ON [User].IdRole = Role.Id
WHERE Login = @Login
GO

IF object_id('GetUsers') IS NOT NULL BEGIN DROP PROCEDURE GetUsers END
GO
CREATE PROCEDURE GetUsers
AS
SELECT [User].Id, Login, Email, Role.Name AS Role FROM [User]
JOIN Role ON [User].IdRole = Role.Id
GO

IF object_id('SearchUsers') IS NOT NULL BEGIN DROP PROCEDURE SearchUsers END
GO
CREATE PROCEDURE SearchUsers(@Login varchar(30), @Email varchar(50), @Role varchar(30))
AS
SELECT [User].Id, Login, Email, Role.Name AS Role FROM [User]
JOIN Role ON [User].IdRole = Role.Id
WHERE Login LIKE '%'+@Login+'%' AND Email LIKE '%'+@Email+'%' AND Role.Name LIKE '%'+@Role+'%'
GO

--POST Ч создание ресурса
IF object_id('CreateUser') IS NOT NULL BEGIN DROP PROCEDURE CreateUser END
GO
CREATE PROCEDURE CreateUser(@Login varchar(30), @Email varchar(50), @Password varchar(500), @SecretKey varchar(500))
AS
INSERT INTO [User](Login,Email,Password,SecretKey) VALUES(@Login,@Email,@Password,@SecretKey)
GO

--PUT Ч обновление ресурса
IF object_id('SaveSecretKey') IS NOT NULL BEGIN DROP PROCEDURE SaveSecretKey END
GO
CREATE PROCEDURE SaveSecretKey(@UserEmail varchar(50), @SecretKey varchar(500))
AS
UPDATE [User]
SET SecretKey = @SecretKey
WHERE Email = @UserEmail
GO

IF object_id('UpdateUserRole') IS NOT NULL BEGIN DROP PROCEDURE UpdateUserRole END
GO
CREATE PROCEDURE UpdateUserRole(@Id int, @NewRole varchar(30))
AS
UPDATE [User]
SET IdRole = (SELECT Id FROM Role WHERE Name = @NewRole)
WHERE Id = @Id
GO

IF object_id('BlockingUser') IS NOT NULL BEGIN DROP PROCEDURE BlockingUser END
GO
CREATE PROCEDURE BlockingUser(@Id int, @Blocking bit)
AS
UPDATE [User]
SET Blocking = @Blocking
WHERE Id = @Id
GO

--DELETE Ч удаление ресурса
IF object_id('DeleteUser') IS NOT NULL BEGIN DROP PROCEDURE DeleteUser END
GO
CREATE PROCEDURE DeleteUser(@Id int)
AS
DELETE FROM [User] WHERE Id = @Id
GO