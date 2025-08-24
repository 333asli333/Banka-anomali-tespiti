🕵️‍♀️ Bank Transaction Fraud Detection with Isolation Forest

Bu proje, banka işlem verileri üzerinden anomalileri tespit ederek potansiyel dolandırıcılık vakalarını belirlemeyi amaçlamaktadır. İzole edilmiş davranışlar, yalnızca şüpheli değil—hikâyesi eksik işlemlerdir. Biz de bu eksik hikâyeleri yakalıyoruz.

📊 Veri Seti
- Toplam 2.512 işlem, 16 özellik
- Örnek değişkenler:
- TransactionAmount, AccountBalance, TransactionType, TransactionDuration
- Location, DeviceID, LoginAttempts, PreviousTransactionDate

🧹 Veri Ön İşleme & Özellik Mühendisliği
Veri, sadece sayı değil—zamanda ve bağlamda anlam taşıyan bir hikâyedir. Bu hikâyeyi daha okunabilir hale getirmek için:
- Tarih dönüşümleri ve işlem zaman farkları
- Z-score ile tutar ve süre anomalileri
- Balance ratio: işlem tutarı / bakiye oranı
- Login attempt analizi + cihaz/lokasyon değişimi
- Yaş-temelli işlem tutarı karşılaştırmaları
- Günün saati (gece/gündüz) bazlı davranış analizi

🌲 Modelleme
- Algoritma: Isolation Forest (solitude paketi)
- Parametreler:
- sample_size = 100
- num_trees = 200
- Performans:
- ROC AUC: 0.9568

🎯 Eşik Optimizasyonu
- %85 quantile bazlı eşik belirlendi
- Karışıklık Matrisi:
|  |  |  | 
|  |  |  | 
|  |  |  | 


- Precision: 0.71
- Recall: 0.73
- F1-score: 0.72

✅ Sonuçlar
- Model, dolandırıcılık işlemlerini yüksek doğrulukla ayırabiliyor.
- Özellikle çoklu özellik mühendisliği (multi-feature anomaly engineering) performansı ciddi şekilde artırdı.

🔮 Gelecek Adımlar
- Alternatif algoritmalar: LOF, Autoencoder
- Eşik ayarı için daha hassas tuning
- Açıklanabilirlik: SHAP, LIME ile model içgörüsü

🚀 Kullanım
# Gerekli kütüphaneler
library(tidyverse)
library(lubridate)
library(solitude)
library(pROC)
library(caret)

# Proje dosyasını çalıştırarak:
# - Feature engineering adımları uygulanır
# - Isolation Forest modeli eğitilir ve değerlendirilir




