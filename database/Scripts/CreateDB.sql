IF db_id('MoviesDB') IS NOT NULL
BEGIN drop database MoviesDB END
GO
create database MoviesDB
ALTER DATABASE MoviesDB SET RECOVERY FULL;
GO
USE MoviesDB
GO

--create my types and rules
create rule SrcRule as @a like '%.png' or @a like '%.jpg' or @a like '%.jpeg'
go
create type Src from varchar(100)
go

--create tables
create table TypeOfCinema(
id int not null identity primary key,
name varchar(30) not null UNIQUE)

--Некласторизованный индекс
CREATE INDEX TypeOfCinemaIndex ON TypeOfCinema (Name)

create table Cinema(
id int not null identity primary key,
name varchar(30) not null UNIQUE,
originalName varchar(30) null,
numOfSeason numeric not null default 0,
idTypeOfCinema int null foreign key references TypeOfCinema(Id) on delete set null)

CREATE INDEX CinemaIndex ON Cinema (Name)

create table Actor(
id int not null identity primary key,
name varchar(30) not null,
lastName varchar(30) not null)

CREATE INDEX ActorIndex ON Actor (Name, LastName)

create table Genre(
id int not null identity primary key,
name varchar(30) not null UNIQUE)

CREATE INDEX GenreIndex ON Genre (Name)

create table Director(
id int not null identity primary key,
name varchar(30) not null,
lastName varchar(30) not null)

CREATE INDEX DirectorIndex ON Director (Name, LastName)

create table Country(
id int not null identity primary key,
name varchar(30) not null UNIQUE)

CREATE INDEX CountryIndex ON Country (Name)

create table Video(
id int not null identity primary key,
number numeric null default 1,
src Src not null)

create table Role(
id int not null identity primary key,
name varchar(30) not null UNIQUE)

CREATE INDEX RoleIndex ON Role (Name)

create table [User](
id int not null identity primary key,
login varchar(30) not null UNIQUE,
email varchar(50) not null UNIQUE,
password varchar(500) not null,
secretKey varchar(500) null,
remember_token nvarchar(100) null,
email_verified_at timestamp null,
idRole int null foreign key references Role(Id) on delete set null,
blocking bit not null default 0)

CREATE INDEX UserIndex ON [User] (Login, Email, Password, Blocking)

create table Message(
id int not null identity primary key,
name varchar(30) not null,
email varchar(50) not null,
text text not null,
date date not null default getdate(),
idAdmin int null foreign key references [User](Id) on delete set null)

CREATE INDEX MessageIndex ON Message (Name, Email, Date)

create table Season(
id int not null identity primary key,
name varchar(30) not null,
originalName varchar(30) null,
ageLimit numeric(2) null check (AgeLimit <= 18),
number numeric(2) null,
year numeric(4) not null,
idCountry int null foreign key references Country(Id) on delete set null,
tagline varchar(100) null,
srcTrailer Src null,
movieLength time not null,
srcPoster Src not null,
numOfVideos numeric not null default 0,
description varchar(500) not null,
rating float null check (Rating <= 10),
dateAdded date not null default getdate(),
numOfViews numeric not null default 0,
apdateDate datetime not null default getdate())

create table RatingToSeason(
id int not null identity primary key,
rating tinyint null check (Rating <= 10),
idUser int null foreign key references [User](Id) on delete set null,
idSeason int null foreign key references Season(Id) on delete cascade)

CREATE INDEX SeasonIndex ON Season (Name, Number, Year,Rating,DateAdded,NumOfViews)

create table SeasonsToCinema(
id int not null identity primary key,
idSeason int null foreign key references Season(Id) on delete cascade,
idCinema int null foreign key references Cinema(Id) on delete cascade)

create table ActorsToSeason(
id int not null identity primary key,
idSeason int null foreign key references Season(Id) on delete cascade,
idActor int null foreign key references Actor(Id) on delete cascade)

create table VideosToSeason(
id int not null identity primary key,
idSeason int null foreign key references Season(Id) on delete cascade,
idVideo int null foreign key references Video(Id) on delete cascade)

create table GenresToSeason(
id int not null identity primary key,
idSeason int null foreign key references Season(Id) on delete cascade,
idGenre int null foreign key references Genre(Id) on delete cascade)

create table DirectorsToSeason(
id int not null identity primary key,
idSeason int null foreign key references Season(Id) on delete cascade,
idDirector int null foreign key references Director(Id) on delete cascade)

create table Comment(
id int not null identity primary key,
idUser int null foreign key references [User](Id) on delete cascade,
idSeason int null foreign key references Season(Id) on delete cascade,
text text not null,
date date default getdate())

CREATE INDEX CommentIndex ON Comment (Date)

--Запускаем др. скрипты
:r MyLibrary.sql
--Хранимки начало
:r Procedures\Actor.sql
:r Procedures\Cinema.sql
:r Procedures\Comment.sql
:r Procedures\Country.sql
:r Procedures\Director.sql
:r Procedures\Genre.sql
:r Procedures\Message.sql
:r Procedures\Rating.sql
:r Procedures\Season.sql
:r Procedures\User.sql
:r Procedures\Video.sql
--Хранимки конец
:r Triggers.sql
:r Filling.sql