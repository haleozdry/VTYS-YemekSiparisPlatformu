/*
================================================================================
VTYS-1 DÖNEM PROJESİ: ÇEVRİMİÇİ YEMEK SİPARİŞ PLATFORMU VERİTABANI TASARIMI
================================================================================
*/

CREATE DATABASE YemekSiparisVT;
GO
USE YemekSiparisVT;
GO

-- -----------------------------------------------------------------------------
-- [BÖLÜM 1] VERİ TANIMLAMA VE KISITLAMALAR (DDL & CONSTRAINTS)
-- -----------------------------------------------------------------------------

CREATE TABLE Kullanici (
    KullaniciID INT IDENTITY(1,1) PRIMARY KEY,
    AdSoyad VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefon VARCHAR(15) UNIQUE,
    KullaniciTipi VARCHAR(20) NOT NULL, -- 'Standart', 'Hayirsever', 'IhtiyacSahibi'
    IsActive BIT DEFAULT 1
);

CREATE TABLE Restoran (
    RestoranID INT IDENTITY(1,1) PRIMARY KEY,
    RestoranAdi VARCHAR(100) NOT NULL,
    Adres VARCHAR(255) NOT NULL,
    Puan DECIMAL(3,1) CHECK (Puan BETWEEN 1 AND 5), -- KISITLAMA 1
    ToplamCiro DECIMAL(10,2) DEFAULT 0,
    IsActive BIT DEFAULT 1
);

CREATE TABLE Kategori (
    KategoriID INT IDENTITY(1,1) PRIMARY KEY,
    KategoriAdi VARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1
);

CREATE TABLE Kurye (
    KuryeID INT IDENTITY(1,1) PRIMARY KEY,
    AdSoyad VARCHAR(100) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NOT NULL,
    IsActive BIT DEFAULT 1
);

CREATE TABLE AskidaYemekHavuzu (
    HavuzID INT PRIMARY KEY,
    ToplamBakiye DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE Urun (
    UrunID INT IDENTITY(1,1) PRIMARY KEY,
    RestoranID INT FOREIGN KEY REFERENCES Restoran(RestoranID),
    KategoriID INT FOREIGN KEY REFERENCES Kategori(KategoriID),
    UrunAdi VARCHAR(100) NOT NULL,
    Fiyat DECIMAL(8,2) NOT NULL CHECK (Fiyat > 0), -- KISITLAMA 2
    IsActive BIT DEFAULT 1
);

CREATE TABLE BagisHareketi (
    BagisID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciID INT FOREIGN KEY REFERENCES Kullanici(KullaniciID),
    Tutar DECIMAL(10,2) NOT NULL CHECK (Tutar > 0), -- KISITLAMA 3
    Tarih DATETIME DEFAULT CURRENT_TIMESTAMP,
    GizliMi BIT DEFAULT 0
);

CREATE TABLE Siparis (
    SiparisID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciID INT FOREIGN KEY REFERENCES Kullanici(KullaniciID),
    KuryeID INT FOREIGN KEY REFERENCES Kurye(KuryeID),
    SiparisTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    ToplamTutar DECIMAL(10,2) NOT NULL,
    SiparisDurumu VARCHAR(20) DEFAULT 'Alındı',
    OdemeYontemi VARCHAR(30) NOT NULL -- 'Nakit', 'Kredi Kartı', 'Askıda Yemek'
);

CREATE TABLE SiparisDetay (
    SiparisDetayID INT IDENTITY(1,1) PRIMARY KEY,
    SiparisID INT FOREIGN KEY REFERENCES Siparis(SiparisID),
    UrunID INT FOREIGN KEY REFERENCES Urun(UrunID),
    Adet INT NOT NULL CHECK (Adet > 0), -- KISITLAMA 4
    BirimFiyat DECIMAL(8,2) NOT NULL
);
GO

-- -----------------------------------------------------------------------------
-- [BÖLÜM 2] VERİ MANİPÜLASYONU (DML - MOCK DATA)
-- -----------------------------------------------------------------------------

INSERT INTO Kullanici (AdSoyad, Email, Telefon, KullaniciTipi) VALUES 
('Ali Veli', 'ali@mail.com', '5550001101', 'Standart'),
('Ayşe Kaya', 'ayse@mail.com', '5550001102', 'Standart'),
('Mehmet Öz', 'mehmet@mail.com', '5550001103', 'Standart'),
('Fatma Demir', 'fatma@mail.com', '5550001104', 'Standart'),
('Canan Çelik', 'canan@mail.com', '5550001105', 'Standart'),
('Burak Şahin', 'burak@mail.com', '5550001106', 'Standart'),
('Selin Yılmaz', 'selin@mail.com', '5550001107', 'Standart'),
('Hakan Öztürk', 'hakan@mail.com', '5550001108', 'Standart'),
('Merve Aydın', 'merve@mail.com', '5550001109', 'Standart'),
('Oğuz Arslan', 'oguz@mail.com', '5550001110', 'Standart'),
('Zeynep Koç', 'zeynep@mail.com', '5550001111', 'Standart'),
('Emre Can', 'emre@mail.com', '5550001112', 'Standart'),
('Cemre Işık', 'cemre@mail.com', '5550001113', 'Hayirsever'),
('Tarık Tekin', 'tarik@mail.com', '5550001114', 'Hayirsever'),
('Gizem Kurt', 'gizem@mail.com', '5550001115', 'Hayirsever'),
('Kaan Doğan', 'kaan@mail.com', '5550001116', 'Hayirsever'),
('Bahar Şen', 'bahar@mail.com', '5550001117', 'Hayirsever'),
('İhtiyaç Sahibi 1', 'ihtiyac1@mail.com', '5550001118', 'IhtiyacSahibi'),
('İhtiyaç Sahibi 2', 'ihtiyac2@mail.com', '5550001119', 'IhtiyacSahibi'),
('İhtiyaç Sahibi 3', 'ihtiyac3@mail.com', '5550001120', 'IhtiyacSahibi');

INSERT INTO Restoran (RestoranAdi, Adres, Puan) VALUES 
('Burger Kralı', 'Merkez Cad. No:1', 4.5),
('Tarihi Kebapçı', 'Lezzet Sok. No:12', 4.8),
('Pizza Dünyası', 'Gül Bulvarı No:3', 4.2),
('Yeşil Salata', 'Fit Cad. No:5', 4.9),
('Tatlıcı Kardeşler', 'Şeker Sok. No:22', 4.6);

INSERT INTO Kategori (KategoriAdi) VALUES 
('Burgerler'), ('Kebaplar'), ('Pizzalar'), ('Salatalar'), ('Tatlılar'), ('İçecekler');

INSERT INTO Kurye (AdSoyad, Telefon) VALUES 
('Hasan Hızlı', '5559990001'), ('Kamil Yolda', '5559990002'), 
('Cemal Uçar', '5559990003'), ('Süleyman Koşar', '5559990004'), ('Rıza Gider', '5559990005');

INSERT INTO AskidaYemekHavuzu (HavuzID, ToplamBakiye) VALUES (1, 0);

INSERT INTO Urun (RestoranID, KategoriID, UrunAdi, Fiyat) VALUES 
(1, 1, 'Klasik Burger', 150.00), (1, 1, 'Cheese Burger', 170.00), (1, 6, 'Kola', 30.00),
(2, 2, 'Adana Kebap', 250.00), (2, 2, 'Urfa Kebap', 240.00), (2, 6, 'Ayran', 25.00),
(3, 3, 'Margarita Pizza', 200.00), (3, 3, 'Karışık Pizza', 280.00), (3, 6, 'Soğuk Çay', 35.00),
(4, 4, 'Sezar Salata', 180.00), (4, 4, 'Ton Balıklı Salata', 220.00), (4, 6, 'Maden Suyu', 20.00),
(5, 5, 'Sütlaç', 80.00), (5, 5, 'Baklava (Porsiyon)', 150.00), (5, 6, 'Çay', 15.00),
(1, 1, 'Mantar Burger', 160.00), (1, 1, 'Barbekü Burger', 175.00), (1, 1, 'Fit Tavuk Burger', 140.00), 
(1, 1, 'Double Cheese Burger', 220.00), (1, 6, 'Şekersiz Kola', 30.00), (1, 6, 'Sarımsaklı Mayonez', 15.00),
(2, 2, 'İskender Kebap', 280.00), (2, 2, 'Beyti Sarma', 260.00), (2, 2, 'Izgara Tavuk Göğsü', 190.00), 
(2, 2, 'Ali Nazik', 270.00), (2, 2, 'Kuzu Şiş', 300.00), (2, 6, 'Şalgam Suyu', 20.00),
(3, 3, 'Sucuklu Pizza', 210.00), (3, 3, 'Dört Peynirli Pizza', 240.00), (3, 3, 'Vegetaryen Pizza', 190.00), 
(3, 3, 'Kavurmalı Pizza', 260.00), (3, 3, 'Tavuklu Mantarlı Pizza', 230.00), (3, 6, 'Limonata', 35.00),
(4, 4, 'Makro Dengeli Tavuk Kase', 210.00), (4, 4, 'Izgara Somon Salata', 290.00), (4, 4, 'Kinoa Salatası', 170.00), 
(4, 4, 'Lor Peynirli Cevizli Salata', 160.00), (4, 4, 'Düşük Karb. Akdeniz Salata', 150.00), (4, 6, 'Bigjoy Protein Shake', 65.00),
(4, 6, 'Filtre Kahve', 45.00), (4, 6, 'Taze Portakal Suyu', 50.00),
(5, 5, 'Fırın Sütlaç', 85.00), (5, 5, 'Kazandibi', 75.00), (5, 5, 'Künefe', 130.00), 
(5, 5, 'Fıstık Ezmeli Yulaf Kasesi', 95.00), (5, 5, 'Trileçe', 90.00), (5, 5, 'Profiterol', 110.00),
(5, 6, 'Türk Kahvesi', 40.00), (5, 6, 'Yeşil Çay', 25.00), (5, 6, 'Su', 10.00);

-- Soft Delete Örneği:
UPDATE Urun SET IsActive = 0 WHERE UrunID = 5;

-- Döngüsel Sipariş Girişleri (90 Adet)
DECLARE @Sayac INT = 1;
DECLARE @YeniSiparisID INT;
WHILE @Sayac <= 90
BEGIN
    INSERT INTO Siparis (KullaniciID, KuryeID, ToplamTutar, SiparisDurumu, OdemeYontemi)
    VALUES (((@Sayac % 10) + 1), ((@Sayac % 5) + 1), 150.00 + (@Sayac * 2), 'Teslim Edildi', 'Kredi Kartı');
    SET @YeniSiparisID = SCOPE_IDENTITY();
    INSERT INTO SiparisDetay (SiparisID, UrunID, Adet, BirimFiyat)
    VALUES (@YeniSiparisID, ((@Sayac % 40) + 1), 1, 150.00 + (@Sayac * 2));
    SET @Sayac = @Sayac + 1;
END;

-- Manuel Test Kayıtları:
INSERT INTO BagisHareketi (KullaniciID, Tutar, GizliMi) VALUES (13, 1000.00, 0), (14, 500.00, 1);
INSERT INTO Siparis (KullaniciID, KuryeID, ToplamTutar, SiparisDurumu, OdemeYontemi) VALUES (1, 1, 350.00, 'Teslim Edildi', 'Kredi Kartı');
INSERT INTO SiparisDetay (SiparisID, UrunID, Adet, BirimFiyat) VALUES (91, 1, 2, 150.00);
GO

-- -----------------------------------------------------------------------------
-- [BÖLÜM 3] GELİŞMİŞ NESNELER (VIEWS & TRIGGERS & INDEXES)
-- -----------------------------------------------------------------------------

CREATE VIEW vw_AktifRestoranMenuleri AS
SELECT r.RestoranAdi, k.KategoriAdi, u.UrunAdi, u.Fiyat
FROM Urun u
INNER JOIN Restoran r ON u.RestoranID = r.RestoranID
INNER JOIN Kategori k ON u.KategoriID = k.KategoriID
WHERE u.IsActive = 1 AND r.IsActive = 1;
GO

CREATE VIEW vw_AskidaYemekHavuzDurumu AS
SELECT 
    (SELECT ToplamBakiye FROM AskidaYemekHavuzu WHERE HavuzID = 1) AS AnlikMevcutBakiye,
    (SELECT ISNULL(SUM(Tutar), 0) FROM BagisHareketi) AS ToplamYapilanBagisMiktari,
    (SELECT COUNT(*) FROM BagisHareketi) AS ToplamBagisIslemSayisi;
GO

CREATE TRIGGER trg_BagisYapildigindaHavuzuArtir ON BagisHareketi AFTER INSERT AS
BEGIN
    UPDATE AskidaYemekHavuzu SET ToplamBakiye = ToplamBakiye + (SELECT SUM(Tutar) FROM inserted) WHERE HavuzID = 1;
END;
GO

CREATE TRIGGER trg_AskidaYemekKullanildigindaHavuzuDusur ON Siparis AFTER INSERT AS
BEGIN
    DECLARE @OdemeYontemi VARCHAR(30), @SiparisTutari DECIMAL(10,2), @MevcutBakiye DECIMAL(10,2);
    SELECT @OdemeYontemi = OdemeYontemi, @SiparisTutari = ToplamTutar FROM inserted;
    SELECT @MevcutBakiye = ToplamBakiye FROM AskidaYemekHavuzu WHERE HavuzID = 1;
    IF (@OdemeYontemi = 'Askıda Yemek')
    BEGIN
        IF (@MevcutBakiye >= @SiparisTutari)
            UPDATE AskidaYemekHavuzu SET ToplamBakiye = ToplamBakiye - @SiparisTutari WHERE HavuzID = 1;
        ELSE
        BEGIN
            RAISERROR('İşlem Başarısız: Askıda Yemek Havuzunda yeterli bakiye bulunmamaktadır!', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO

CREATE TRIGGER trg_SiparisTeslimEdildigindeCiroArtir ON Siparis AFTER UPDATE AS
BEGIN
    IF UPDATE(SiparisDurumu)
    BEGIN
        UPDATE r SET r.ToplamCiro = r.ToplamCiro + t.KazanilanTutar
        FROM Restoran r INNER JOIN (
            SELECT u.RestoranID, SUM(sd.BirimFiyat * sd.Adet) as KazanilanTutar
            FROM inserted i INNER JOIN SiparisDetay sd ON i.SiparisID = sd.SiparisID
            INNER JOIN Urun u ON sd.UrunID = u.UrunID WHERE i.SiparisDurumu = 'Teslim Edildi' GROUP BY u.RestoranID
        ) t ON r.RestoranID = t.RestoranID;
    END
END;
GO

CREATE NONCLUSTERED INDEX IX_Kullanici_Email ON Kullanici(Email);
CREATE NONCLUSTERED INDEX IX_Siparis_SiparisTarihi ON Siparis(SiparisTarihi DESC);
GO

-- -----------------------------------------------------------------------------
-- [BÖLÜM 4] İLERİ DÜZEY SORGULAR (DQL & ANALİTİK)
-- -----------------------------------------------------------------------------

-- Rapor 1: Detaylı Sipariş Fişi (JOIN)
SELECT s.SiparisID, k.AdSoyad AS Musteri, r.RestoranAdi, u.UrunAdi, sd.Adet, sd.BirimFiyat, (sd.Adet * sd.BirimFiyat) AS ToplamSatirTutari
FROM Siparis s
INNER JOIN Kullanici k ON s.KullaniciID = k.KullaniciID
INNER JOIN SiparisDetay sd ON s.SiparisID = sd.SiparisID
INNER JOIN Urun u ON sd.UrunID = u.UrunID
INNER JOIN Restoran r ON u.RestoranID = r.RestoranID;

-- Rapor 2: Agregasyon ve Gruplama (GROUP BY & HAVING)
SELECT r.RestoranAdi, COUNT(DISTINCT s.SiparisID) AS ToplamSiparisSayisi, AVG(s.ToplamTutar) AS OrtalamaSepetTutari, SUM(sd.Adet * sd.BirimFiyat) AS GerceklesenCiro
FROM Restoran r INNER JOIN Urun u ON r.RestoranID = u.RestoranID INNER JOIN SiparisDetay sd ON u.UrunID = sd.UrunID
INNER JOIN Siparis s ON sd.SiparisID = s.SiparisID GROUP BY r.RestoranAdi HAVING COUNT(DISTINCT s.SiparisID) > 5;

-- Rapor 3: Alt Sorgu (NOT EXISTS)
SELECT k.KullaniciID, k.AdSoyad, k.Email FROM Kullanici k
WHERE k.IsActive = 1 AND k.KullaniciTipi = 'Standart' AND NOT EXISTS (SELECT 1 FROM BagisHareketi b WHERE b.KullaniciID = k.KullaniciID);
GO