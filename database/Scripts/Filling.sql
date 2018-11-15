USE MoviesDB
GO

--Заполнение рандомными данными начало

INSERT INTO TypeOfCinema(Name) VALUES('Сериалы'),('Фильмы')
INSERT INTO Country(Name) VALUES('Япония'),('США'),('Россия'),('Китай')
INSERT INTO Genre(Name) VALUES('Боевик'),('Гангстерский фильм'),('Детектив'),('Исторический фильм'),('Комедия'),('Мелодрама')
INSERT INTO Role(Name) VALUES('Админ'),('Пользователь')

DECLARE @DataFrom INT = 1,@DataTo INT = 30;
--Новинки
WHILE @DataFrom <= @DataTo
BEGIN
INSERT INTO Cinema(IdTypeOfCinema, Name, OriginalName) VALUES(dbo.RandomInRange(1,(SELECT COUNT(*) FROM TypeOfCinema)), CONCAT('ФильмНовинка№', @DataFrom), dbo.RandAngStr(10))
DECLARE @IdC int = @@identity
INSERT INTO Season(Name,OriginalName,Number,Year,IdCountry,Tagline,SrcTrailer,MovieLength,SrcPoster,Description,NumOfViews, ageLimit) VALUES(
'Сезон1', dbo.RandAngStr(10),1, dbo.RandomInRange(1990,2018),
dbo.RandomInRange(1,(SELECT MAX(Id) FROM Country)),
'Слоган1',NULL, '01:10:21', 'Trailer.png', 'Описание1', dbo.RandomInRange(1, 1000), dbo.RandomInRange(1, 18))
DECLARE @IdS int = @@identity
INSERT INTO SeasonsToCinema(idCinema,idSeason) VALUES(@IdC,@IdS)
INSERT INTO GenresToSeason(IdGenre,IdSeason) VALUES(dbo.RandomInRange(1,(SELECT MAX(Id) FROM Genre)),@IdS)
SET @DataFrom = @DataFrom + 1
END

SET @DataFrom = 1

INSERT INTO [User](Login,Email,Password,IdRole) VALUES('LoginAdmin', 'Email', '123', 1)

WHILE @DataFrom <= @DataTo
BEGIN

INSERT INTO Cinema(IdTypeOfCinema, Name, OriginalName) VALUES(dbo.RandomInRange(1,(SELECT COUNT(*) FROM TypeOfCinema)), CONCAT('Фильм№', @DataFrom), dbo.RandAngStr(10))
DECLARE @IdCinema int = @@identity

DECLARE @RandIndexName INT = dbo.RandomInRange(1,(SELECT COUNT(*) FROM FirstNames)),
@RandIndexLastName INT = dbo.RandomInRange(1,(SELECT COUNT(*) FROM LastNames))
INSERT INTO Actor(Name, LastName) VALUES((select name from FirstNames where id = @RandIndexName),(select name from LastNames where id = @RandIndexLastName))

SET @RandIndexName = dbo.RandomInRange(1,(SELECT COUNT(*) FROM FirstNames))
SET @RandIndexLastName = dbo.RandomInRange(1,(SELECT COUNT(*) FROM LastNames))
INSERT INTO Director(Name, LastName) VALUES((select name from FirstNames where id = @RandIndexName),(select name from LastNames where id = @RandIndexLastName))

INSERT INTO [User](Login,Email,Password,IdRole) VALUES(CONCAT('Login',@DataFrom), CONCAT('Email',@DataFrom),'123', dbo.RandomInRange(1,2))

SET @RandIndexName = dbo.RandomInRange(1,(SELECT COUNT(*) FROM FirstNames))
INSERT INTO Message(Name, Email, Text, Date, IdAdmin) VALUES(
(select name from FirstNames where id = @RandIndexName),CONCAT('Email',@DataFrom),CONCAT('Текст',@DataFrom),
dbo.RandDate(), (SELECT TOP(1) Id FROM [User] WHERE IdRole = 1))

DECLARE @iBegin int = 1, @iEnd int = dbo.RandomInRange(1,5)
WHILE @iBegin <= @iEnd
BEGIN
--Сезоны
INSERT INTO Season(Name,OriginalName,Number,Year,IdCountry,Tagline,SrcTrailer,MovieLength,SrcPoster,Description,NumOfViews, ageLimit) VALUES(
CONCAT('Сезон',@iBegin),dbo.RandAngStr(10),@iBegin,dbo.RandomInRange(1990,2018),
dbo.RandomInRange(1,(SELECT MAX(Id) FROM Country)),
CONCAT('Слоган',@iBegin),NULL, '01:10:21', 'Trailer.png', CONCAT('Описание',@iBegin), dbo.RandomInRange(1, 1000), dbo.RandomInRange(1, 18))
DECLARE @IdSeason int = @@identity
--Сезон к фильму
INSERT INTO SeasonsToCinema(IdCinema,IdSeason) VALUES(@IdCinema,@IdSeason)
--Актёры к сезону
INSERT INTO ActorsToSeason(IdActor,IdSeason) VALUES(dbo.RandomInRange(1,(SELECT MAX(Id) FROM Actor)),@IdSeason)
--жанры к сезону
INSERT INTO GenresToSeason(IdGenre,IdSeason) VALUES(dbo.RandomInRange(1,(SELECT MAX(Id) FROM Genre)),@IdSeason)
--Режисёры к сезону
INSERT INTO DirectorsToSeason(IdDirector,IdSeason) VALUES(dbo.RandomInRange(1,(SELECT MAX(Id) FROM Director)),@IdSeason)
--Комментарии к сезону
INSERT INTO Comment(IdUser,IdSeason,Text,Date) VALUES(dbo.RandomInRange(1,(SELECT MAX(Id) FROM [User])),@IdSeason,CONCAT('Комментарий',@iBegin),dbo.RandDate())
SET @iBegin = @iBegin + 1
DECLARE @VideoBeginI int = 1, @VideoEndI int = dbo.RandomInRange(1,10)
WHILE @VideoBeginI <= @VideoEndI
BEGIN
--Видео
INSERT INTO Video(Src,Number) VALUES(CONCAT((SELECT MAX(Id) FROM Video),'.png'), @VideoBeginI)
--Видео к сезону
INSERT INTO VideosToSeason(IdSeason,IdVideo) VALUES(@IdSeason, @@identity)
--Рейтинг к сезону
INSERT INTO RatingToSeason(IdSeason,IdUser,Rating) VALUES(@IdSeason, dbo.RandomInRange(1,(SELECT MAX(Id) FROM [User])), dbo.RandomInRange(1,10))
SET @VideoBeginI = @VideoBeginI + 1
END
END

SET @DataFrom = @DataFrom + 1
END
--Заполнение рандомными данными конец