# VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu

Bu depo, Veritabanı Yönetim Sistemleri-1 dersi kapsamında 3. Normal Form (3NF) ilişkisel modelleme standartlarına uygun olarak tasarlanmış dönem projesini içermektedir.

## 📦 Teslim Dosyaları ve İçerikleri
* **`Proje_Kodlari.sql`**: Veritabanının sıfırdan kurulum kodlarını (DDL), hocanın istediği alt sınırları karşılayan test verilerini ve döngüsel veri simülasyonunu (DML) ve gelişmiş veritabanı nesnelerini (View, Trigger, Index, Analitik Sorgular) içeren tekil ana kod dosyası.
* **`ER_Diyagrami.png`**: SQL Server Management Studio (SSMS) üzerinden üretilmiş, tablolar arası ilişkileri ve referans bütünlüğü kısıtlamalarını (Primary/Foreign Key) gösteren Varlık-İlişki diyagramı.
* **`VTYS_Proje_Raporu_Dokumantasyon.pdf`**: Projenin iş kurallarını (Business Rules), "Askıda Yemek" havuz modülünün arka planda çalışan Trigger mimarisini ve Yapay Zeka (AI) Kullanım Beyan raporunu içeren resmi dokümantasyon belgesi.

## ⚙️ Özel Modül (Askıda Yemek) ve Önemli İş Kuralları
- **Bakiye Havuzu Algoritması:** Sistem, hantal sipariş askılama yöntemleri yerine esnek bir "Global Kumbara" mantığıyla çalışır. Hayırseverler havuza bakiye aktarır, doğrulanmış ihtiyaç sahipleri ise bu bakiyeyi kullanarak ücretsiz sipariş verebilir.
- **Trigger Güvenliği:** Sipariş anında havuzda yeterli bakiye olup olmadığı tetikleyiciler (`Trigger`) ile kontrol edilir. Bakiye yetersizse sistem `RAISERROR` fırlatır ve işlemi güvenli bir şekilde geri alır (`ROLLBACK`).
- **Veri Koruma (Soft Delete):** Sistem genelinde fiziksel silme yapılmaz; silinen öğeler `IsActive = 0` bayrağı ile pasife çekilerek veri arşivi korunur.
