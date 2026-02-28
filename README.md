# 🕵️‍♀️ Bank Transaction Fraud Detection with Isolation Forest

This project aims to identify potential fraud cases by detecting anomalies within bank transaction data.

Based on the logic of isolation: suspicious transactions are not just abnormal; they are transactions with a "missing story." I am capturing these incomplete narratives.

## 📊 Dataset

* **Source:** Bank Transaction Dataset for Fraud Detection
* **Size:** 2,512 transactions, 16 features

**Example variables:**
`TransactionAmount`, `AccountBalance`, `TransactionType`, `TransactionDuration`, `Location`, `DeviceID`, `LoginAttempts`, `PreviousTransactionDate`

This dataset provides behavioral traces of bank transactions. The features encompass both numerical and categorical information, allowing the model to evaluate fraud from multiple angles.

## 🧹 Data Preprocessing & Feature Engineering

Data is not just numbers; it is a behavioral story. To make this story more readable, the following operations were performed:

* 📅 **Date conversions** and calculation of time differences between transactions.
* 📊 **Z-score based anomalies** (for amount & duration).
* 💰 **Balance ratio:** transaction amount / account balance ratio.
* 🔑 **Login attempt analysis** + device/location changes.
* 👥 **Age-based transaction amount comparisons**.
* 🌙 **Time of day (night/day) behavioral analysis**.

Thanks to these steps, variables that carry no meaning alone were combined, allowing behavioral patterns behind transactions to be seen more clearly.

## 🌲 Modeling

* **Algorithm:** Isolation Forest (`solitude` package)
* **Parameters:**
    * `sample_size` = 100
    * `num_trees` = 200

**Performance:**
* **ROC AUC:** 0.9568

📌 **Interpretation:**
An ROC AUC value above 0.95 indicates that the model distinguishes fraudulent transactions with **very high accuracy**. In other words, when a randomly selected fraudulent transaction is compared with a normal transaction, there is a over 95% probability that the model correctly separates them.

## 🎯 Threshold Optimization

A threshold based on the 85th quantile was determined.

* **Precision:** 0.71
* **Recall:** 0.73
* **F1-score:** 0.72

📌 **Interpretation:**
* **Precision 71%** → 71% of the transactions the model flags as "suspicious" are actually fraud.
* **Recall 73%** → 73% of actual fraudulent transactions are caught.
* **F1-score 72%** → A **balanced performance** between accuracy (precision) and detection power (recall) is achieved.

These values demonstrate that the model limits false alarms that would disrupt customer experience while catching the majority of actual fraud cases.

## ✅ Results

* The model can distinguish fraudulent transactions with high accuracy.
* Especially, **multi-feature anomaly engineering** significantly improved performance.

📌 **Interpretation:**
Looking only at transaction amount or location was not sufficient; evaluating many features together played a critical role in understanding fraud. This shows that the model operates with a "behavioral" rather than a "one-dimensional" perspective.

## 🔮 Future Steps

* 🔍 Alternative algorithms: LOF, Autoencoder
* ⚙️ Finer threshold tuning
* 🧾 Explainability: SHAP, LIME
* ⚡ Real-time detection mechanisms
* 🔗 Integration with operational systems (e.g., banking alert systems)







# 🕵️‍♀️ Isolation Forest ile Bank Transaction Fraud Detection 

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




