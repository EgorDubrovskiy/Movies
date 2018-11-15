USE MoviesDB
GO

--GET � ��������� �������
IF object_id('GetAllCountries') IS NOT NULL BEGIN DROP PROCEDURE GetAllCountries END
GO
CREATE PROCEDURE GetAllCountries
AS
SELECT Id, Name FROM Country
GO

--POST � �������� �������
IF object_id('CreateCountry') IS NOT NULL BEGIN DROP PROCEDURE CreateCountry END
GO
CREATE PROCEDURE CreateCountry(@Name varchar(30))
AS
INSERT INTO Country(Name) VALUES(@Name)
GO

--PUT � ���������� �������
IF object_id('UpdateCountry') IS NOT NULL BEGIN DROP PROCEDURE UpdateCountry END
GO
CREATE PROCEDURE UpdateCountry(@Id int, @NewName varchar(30))
AS
UPDATE Country
SET Name = @NewName WHERE Id = @Id
GO

--DELETE � �������� �������
IF object_id('DeleteCountry') IS NOT NULL BEGIN DROP PROCEDURE DeleteCountry END
GO
CREATE PROCEDURE DeleteCountry(@Id int)
AS
DELETE FROM Country WHERE Id = @Id
GO

