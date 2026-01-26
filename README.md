# 🕵️‍♀️ Bank Transaction Fraud Detection with Isolation Forest

Bu proje, **banka işlem verileri** üzerinden anomalileri tespit ederek potansiyel dolandırıcılık vakalarını belirlemeyi amaçlamaktadır.  
İzolasyon mantığına göre: **şüpheli işlemler yalnızca anormal değil, aynı zamanda hikâyesi eksik işlemlerdir.**  
Bende bu eksik hikâyeleri yakalıyorum.  

---

## 📊 Veri Seti
- **Kaynak:** Bank Transaction Dataset for Fraud Detection  
- **Boyut:** 2.512 işlem, 16 özellik  
- **Örnek değişkenler:**  
  - `TransactionAmount`, `AccountBalance`, `TransactionType`, `TransactionDuration`  
  - `Location`, `DeviceID`, `LoginAttempts`, `PreviousTransactionDate`  

Bu veri seti, banka işlemlerinin davranışsal izlerini sunar. Özellikler, hem sayısal hem de kategorik bilgileri kapsayarak modelin dolandırıcılığı çok yönlü değerlendirmesine imkân tanır.  

---

## 🧹 Veri Ön İşleme & Özellik Mühendisliği
Veri sadece sayı değil, **bir davranış hikâyesi**dir. Bu hikâyeyi daha okunabilir hale getirmek için yapılan işlemler:  

- 📅 **Tarih dönüşümleri** ve işlem zaman farklarının hesaplanması  
- 📊 **Z-score bazlı anomaliler** (tutar & süre)  
- 💰 **Balance ratio:** `işlem tutarı / bakiye oranı`  
- 🔑 **Login attempt analizi** + cihaz/lokasyon değişimi  
- 👥 **Yaş-temelli işlem tutarı karşılaştırmaları**  
- 🌙 **Günün saati (gece/gündüz) davranış analizi**  

Bu adımlar sayesinde, tek başına anlam taşımayan değişkenler birleştirilerek işlemlerin ardındaki davranış kalıpları daha net görülebildi.  

---

## 🌲 Modelleme
- **Algoritma:** Isolation Forest (`solitude` paketi)  
- **Parametreler:**  
  - `sample_size = 100`  
  - `num_trees = 200`  
- **Performans:**  
  - ROC AUC: **0.9568**  

📌 **Yorum:**  
ROC AUC değerinin 0.95 üzerinde olması, modelin dolandırıcılık işlemlerini **çok yüksek doğrulukla** ayırt ettiğini gösteriyor. Yani, rastgele seçilen bir dolandırıcılık işlemi ile normal işlem karşılaştırıldığında, modelin bunları doğru ayırma ihtimali %95’in üzerinde.  

---

## 🎯 Eşik Optimizasyonu
- %85 quantile bazlı eşik belirlendi  
- **Precision:** 0.71  
- **Recall:** 0.73  
- **F1-score:** 0.72  

📌 **Yorum:**  
- Precision %71 → Modelin “şüpheli” dediği işlemlerin %71’i gerçekten dolandırıcılık.  
- Recall %73 → Gerçek dolandırıcılık işlemlerinin %73’ü yakalanabiliyor.  
- F1-score %72 → Doğruluk ile yakalama gücü arasında **dengeli bir performans** sağlanıyor.  

Bu değerler, modelin hem müşteri deneyimini bozacak yanlış alarmları sınırladığını hem de gerçek dolandırıcılıkların çoğunu yakalayabildiğini ortaya koyuyor.  

---

## ✅ Sonuçlar
- Model, dolandırıcılık işlemlerini **yüksek doğrulukla ayırabiliyor**.  
- Özellikle çoklu özellik mühendisliği (multi-feature anomaly engineering) performansı ciddi ölçüde artırdı.  

📌 **Yorum:**  
Yalnızca işlem tutarına veya lokasyona bakmak yeterli olmadı; birçok özelliğin birlikte değerlendirilmesi dolandırıcılığı anlamada kritik rol oynadı. Bu da modelin “tek boyutlu değil, davranışsal” bakış açısıyla çalıştığını gösteriyor.  

---

## 🔮 Gelecek Adımlar
- 🔍 Alternatif algoritmalar: **LOF**, **Autoencoder**  
- ⚙️ Daha hassas **eşik tuning**  
- 🧾 Açıklanabilirlik: **SHAP**, **LIME**  
- ⚡ **Gerçek zamanlı tespit** mekanizmaları  
- 🔗 **Operasyonel sistemlere entegrasyon** (örneğin bankacılık uyarı sistemleri)  

---

## 🚀 Kullanım
```r
# Gerekli kütüphaneler
library(tidyverse)
library(lubridate)
library(solitude)
library(pROC)
library(caret)

# Proje dosyasını çalıştırarak:
# - Feature engineering adımları uygulanır
# - Isolation Forest modeli eğitilir ve değerlendirilir




