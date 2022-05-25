go
use tembdb
go
DROP DATABASE OnlajnProdavnicaOdece
go
CREATE DATABASE OnlajnProdavnicaOdece
go
USE OnlajnProdavnicaOdece
go



/***************Kreiranje tabela***************/
go
CREATE TABLE Slika
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Ref NVARCHAR(MAX)
)
go
CREATE TABLE Korisnik
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Ime NVARCHAR(50)NOT NULL,
	Prezime NVARCHAR(50) NOT NULL,
	Telefon NVARCHAR(15) NOT NULL,
	Mejl NVARCHAR(50) NOT NULL,
	Lozinka NVARCHAR(50) NOT NULL,
	jeAdmin BIT NOT NULL DEFAULT('FALSE')
)
go
CREATE TABLE Proizvod
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Naziv NVARCHAR(100) NOT NULL,
	Opis NVARCHAR(1000),
	Cena FLOAT NOT NULL,
	Kolicina INT NOT NULL DEFAULT(0),
	DatumNastanka DATE,
	SlikaRef NVARCHAR(MAX)
)
go
CREATE TABLE Tag
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Naziv NVARCHAR(50) NOT NULL,
	Opis NVARCHAR(100),
)
go
CREATE TABLE ProizvodTag
(
	ProizvodId INT FOREIGN KEY REFERENCES Proizvod(Id) NOT NULL,
	TagId INT FOREIGN KEY REFERENCES Tag(Id) NOT NULL,
	PRIMARY KEY (ProizvodId, TagId)
)
go
CREATE TABLE Narudzbina
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	KorisnikId INT FOREIGN KEY REFERENCES Korisnik(Id) NOT NULL,
	StatusNarudzbine NVARCHAR(50) NOT NULL DEFAULT('U obradi'),
	Adresa NVARCHAR(100) NOT NULL,
	Grad NVARCHAR(50) NOT NULL,
	Drzava NVARCHAR(50) NOT NULL,
	Datum DATE NOT NULL,
	Komentar NVARCHAR(1000),
	ProizvodId INT FOREIGN KEY REFERENCES Proizvod(Id) NOT NULL
)
go
/**/
go



/***************Stored procedure***************/
/**********Slika**********/
go
CREATE PROC SlikaInsert
@Ref NVARCHAR(MAX)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	INSERT INTO Slika(Ref)
	VALUES(@Ref)
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/*SlikaUpdate nema*/
go
CREATE PROC SlikaDelete
@Ref NVARCHAR(MAX)
AS
BEGIN TRY
	DELETE FROM Slika WHERE Ref = @Ref
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**********Korisnik**********/
go
CREATE PROC KorisnikEmailProvera
@Mejl NVARCHAR(50),
@Lozinka NVARCHAR(50)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 Mejl FROM Korisnik
	WHERE Mejl = @Mejl AND Lozinka = @Lozinka)
	BEGIN
		RETURN 0;
	END
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC KorisnikInsert
@Ime NVARCHAR(50),
@Prezime NVARCHAR(50),
@Telefon NVARCHAR(15),
@Mejl NVARCHAR(50),
@Lozinka NVARCHAR(50)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 Mejl FROM Korisnik
	WHERE Mejl = @Mejl)
		RETURN 1;
	ELSE
		INSERT INTO Korisnik(Ime, Prezime, Telefon, Mejl, Lozinka)
		VALUES(@Ime, @Prezime, @Telefon, @Mejl, @Lozinka)
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC KorisnikUpdate
@Id INT,
@Ime NVARCHAR(50),
@Prezime NVARCHAR(50),
@Telefon NVARCHAR(15),
@Mejl NVARCHAR(50),
@Lozinka NVARCHAR(50)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 Mejl FROM Korisnik
	WHERE Id = @Id)
	BEGIN
		UPDATE Korisnik SET
		Mejl = @Mejl,
		Lozinka = @Lozinka,
		Ime = @Ime,
		Prezime = @Prezime,
		Telefon = @Telefon
		WHERE Id = @Id 
		RETURN 0;
	END
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC KorisnikDelete
@Mejl NVARCHAR(50)
AS
BEGIN TRY
	DELETE FROM Korisnik WHERE Mejl = @Mejl
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**********Tag***********/
go
CREATE PROC TagInsert
@Naziv NVARCHAR(50),
@Opis NVARCHAR(100) = NULL
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 Naziv FROM Tag
	WHERE Naziv = @Naziv)
		RETURN 1;
	ELSE
		INSERT INTO Tag(Naziv, Opis)
		VALUES(@Naziv, @Opis)
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC TagUpdate
@Naziv NVARCHAR(50),
@Opis NVARCHAR(100) = NULL
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 Naziv FROM Tag
	WHERE Naziv = @Naziv)
	BEGIN
		UPDATE Tag SET Opis = @Opis WHERE Naziv = @Naziv
		RETURN 0;
	END
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC TagDelete
@Naziv NVARCHAR(50)
AS
BEGIN TRY
	DELETE FROM Tag WHERE Naziv = @Naziv
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**********Proizvod**********/
go
CREATE PROC ProizvodInsert
@Naziv NVARCHAR(100),
@Opis NVARCHAR(1000),
@Cena FLOAT,
@Kolicina INT,
@SlikaRef NVARCHAR(MAX) = NULL
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	INSERT INTO Proizvod(Naziv, Opis, Cena, Kolicina, DatumNastanka, SlikaRef)
	VALUES(@Naziv, @Opis, @Cena, @Kolicina, CONVERT(date, GETDATE()), @SlikaRef)
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC ProizvodUpdate
@Id INT,
@Naziv NVARCHAR(100),
@Opis NVARCHAR(1000) = NULL,
@Cena FLOAT,
@Kolicina INT,
@SlikaRef NVARCHAR(MAX) = NULL
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 Naziv FROM Proizvod
	WHERE Id = @Id)
	BEGIN
		UPDATE Proizvod
		SET
		Naziv = @Naziv,
		Opis = @Opis,
		Cena = @Cena,
		Kolicina = @Kolicina,
		SlikaRef = @SlikaRef
		WHERE Id = @Id
		RETURN 0;
	END
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC ProizvodDelete
@Id INT
AS
BEGIN TRY
	DELETE FROM Proizvod WHERE Id = @Id
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**********ProizvodTag**********/
go
CREATE PROC ProizvodTagInsert
@ProizvodId INT,
@TagId INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 * FROM ProizvodTag
	WHERE ProizvodId = @ProizvodId AND TagId = @TagId)
		RETURN 1;
	ELSE
		INSERT INTO ProizvodTag(ProizvodId, TagId)
		VALUES(@ProizvodId, @TagId)
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
/*ProizvodTagUpdate nema*/
go
/**/
go
CREATE PROC ProizvodTagDelete
@ProizvodId INT,
@TagId INT
AS
BEGIN TRY
	DELETE FROM ProizvodTag 
	WHERE ProizvodId = @ProizvodId AND TagId = @TagId
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**********Narudzbina**********/
go
CREATE PROC NarudzbinaInsert
@KorisnikId INT,
@Adresa NVARCHAR(100),
@Grad NVARCHAR(50),
@Drzava NVARCHAR(50),
@Komentar NVARCHAR(1000) = NULL,
@ProizvodId INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	INSERT INTO Narudzbina(KorisnikId, Adresa, Grad, Drzava, Komentar, Datum, StatusNarudzbine, ProizvodId)
	VALUES(@KorisnikId, @Adresa, @Grad, @Drzava, @Komentar, CONVERT(date, GETDATE()), 'U obradi', @ProizvodId)
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
/*NarudzbinaUpdate nema*/
go
/**/
go
CREATE PROC NarudzbinaDelete
@Id INT
AS
BEGIN TRY
	DELETE FROM Narudzbina WHERE Id = @Id
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**********isAdmin**********/
go
CREATE PROC isAdmin
@Mejl NVARCHAR(50)
AS
BEGIN TRY
	IF ((SELECT TOP 1 jeAdmin FROM Korisnik
	WHERE Mejl = @Mejl) = 0)
		RETURN 0;
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC KorisnikPostoji
@Mejl NVARCHAR(50)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 Id FROM Korisnik
	WHERE Mejl = @Mejl)
	BEGIN
		RETURN 0;
	END
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC ProizvodSlikaUpdate
@Id INT,
@SlikaRef NVARCHAR(MAX)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 Naziv FROM Proizvod
	WHERE Id = @Id)
	BEGIN
		UPDATE Proizvod
		SET
		SlikaRef = @SlikaRef
		WHERE Id = @Id
		RETURN 0;
	END
	RETURN 1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC ProizvodSvi
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	SELECT * FROM Proizvod
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC ProizvodSlikaDefault
@SlikaRef NVARCHAR(MAX)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	UPDATE Proizvod
	SET
	SlikaRef = '/uploads/default.png'
	WHERE SlikaRef = @SlikaRef
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
go
CREATE PROC ProizvodSviFilter
@TagId INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	SELECT P.* FROM Proizvod AS P
	INNER JOIN ProizvodTag AS PT
	ON P.Id = PT.ProizvodId
	INNER JOIN Tag AS T
	ON PT.TagID = T.Id
	WHERE PT.TagId = @TagID
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
CREATE PROC GetKorisnikId
@Mejl NVARCHAR(50)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	SELECT TOP 1 Id FROM Korisnik
	WHERE Mejl = @Mejl
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go
/**/
CREATE PROC KolMinus
@Id INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	UPDATE Proizvod
	SET
	Kolicina = Kolicina - 1
	WHERE Id = @Id
	RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
go



/**********Dodavanje admina**********/
go
INSERT INTO Korisnik (Ime, Prezime, Telefon, Mejl, Lozinka, jeAdmin)
VALUES ('Admin', '1', 'N/A', 'admin@gmail.com', '123', 'TRUE')
go

/**********Default vrednosti**********/
go
INSERT INTO Slika (Ref)
VALUES ('/uploads/default.png')
go
INSERT INTO Proizvod (Naziv, Cena, Kolicina, DatumNastanka, SlikaRef)
VALUES ('Test', 1000, 10, GETDATE(), '/uploads/default.png')
go
INSERT INTO Tag (Naziv)
VALUES ('Test')
go
INSERT INTO ProizvodTag (ProizvodId, TagId)
VALUES (1, 1)
go
