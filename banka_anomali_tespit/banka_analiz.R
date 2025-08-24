library(tidyverse)
library(data.table)

df <- bank_transactions_data_2
dim(df)
names(df)
head(df)
glimpse(df)
colSums(is.na(df))


library(lubridate)

# 1. Tarih değişkenlerini düzeltme
df <- df %>%
  mutate(
    TransactionDate = as.POSIXct(TransactionDate),
    PreviousTransactionDate = as.POSIXct(PreviousTransactionDate),
    
    # Zaman farkı (şüpheli hızlı işlemler)
    time_since_last_tx = as.numeric(difftime(TransactionDate, PreviousTransactionDate, units = "mins"))
  )

# 2. Çoklu anomali göstergeleri oluşturma
df <- df %>%
  mutate(
    # 1. Amount bazlı anomaliler
    amount_zscore = scale(TransactionAmount),
    amount_anomaly = as.numeric(abs(amount_zscore) > 3),
    
    # 2. Balance-Amount oranı (hesap bakiyesine göre büyük işlemler)
    balance_ratio = TransactionAmount / AccountBalance,
    balance_anomaly = as.numeric(balance_ratio > 0.5),  # Bakiyenin %50'sinden fazla
    
    # 3. Zaman bazlı anomaliler (çok hızlı ardışık işlemler)
    time_anomaly = as.numeric(time_since_last_tx < 5),  # 5 dakikadan az
    
    # 4. Location bazlı anomaliler (farklı lokasyonlarda hızlı işlem)
    # Bu örnek için basit tutuyorum
    
    # 5. Login attempts (çok fazla deneme)
    login_anomaly = as.numeric(LoginAttempts > 3),
    
    # 6. Transaction duration (çok kısa/uzun işlemler)
    duration_zscore = scale(TransactionDuration),
    duration_anomaly = as.numeric(abs(duration_zscore) > 2.5),
    
    # 7. Age bazlı anomaliler (yaşa göre anormal işlemler)
    age_group = cut(CustomerAge, breaks = c(0, 25, 40, 60, 100)),
    avg_amount_by_age = ave(TransactionAmount, age_group, FUN = mean),
    amount_vs_age = TransactionAmount / avg_amount_by_age,
    age_anomaly = as.numeric(amount_vs_age > 3)
  )

# 3. Toplam anomali skoru oluşturma
df <- df %>%
  mutate(
    total_anomaly_score = rowSums(select(., contains("_anomaly")), na.rm = TRUE),
    is_fraud = as.numeric(total_anomaly_score >= 2)  # 2+ anomali flag'i olanlar fraud
  )

# Fraud oranını hesapla
fraud_rate <- mean(df$is_fraud) * 100
cat("OLUŞTURULAN FRAUD ORANI:", round(fraud_rate, 2), "%\n")
cat("DAĞILIM:\n")
print(table(df$is_fraud))



# Daha fazla anlamlı özellik oluştur
df <- df %>%
  mutate(
    # Transaction frequency (son 24 saatteki işlem sayısı)
    transaction_frequency = ave(TransactionID, AccountID, 
                                FUN = function(x) length(x)),
    
    # Location change anomaly (farklı şehirlerde hızlı işlem)
    location_change = ifelse(duplicated(AccountID) & 
                               !duplicated(Location), 1, 0),
    
    # Device anomaly (aynı hesap, farklı cihaz)
    device_change = ifelse(duplicated(AccountID) & 
                             !duplicated(DeviceID), 1, 0),
    
    # Time of day anomalies
    transaction_hour = hour(TransactionDate),
    is_night = as.numeric(transaction_hour < 6 | transaction_hour > 22),
    
    # Amount to balance ratio (daha hassas)
    amount_balance_ratio = TransactionAmount / (AccountBalance + 1),
    high_amount_ratio = as.numeric(amount_balance_ratio > 0.3)
  )


# Final feature selection
final_features <- df %>%
  select(
    TransactionAmount,
    AccountBalance,
    TransactionDuration,
    LoginAttempts,
    CustomerAge,
    time_since_last_tx,
    balance_ratio,
    amount_zscore,
    duration_zscore,
    transaction_frequency,
    location_change,
    device_change,
    is_night,
    amount_balance_ratio,
    high_amount_ratio
  )

# Manuel ölçeklendirme 
manual_scale <- function(x) {
  if(is.numeric(x)) {
    return(scale(x))
  } else {
    return(x)  
  }
}

# Her sütunu ayrı ayrı ölçeklendir
final_features_scaled <- as.data.frame(lapply(final_features, function(col) {
  if(is.numeric(col)) {
    scaled_col <- scale(col)
    # NaN değerleri ortalama ile doldur
    scaled_col[is.na(scaled_col)] <- 0
    scaled_col[is.infinite(scaled_col)] <- 0
    return(scaled_col)
  } else {
    # Sayısal olmayanları sayısala dönüştür
    return(as.numeric(as.factor(col)))
  }
}))

# Son kontrol
cat("SON DURUM:\n")
cat("Satır sayısı:", nrow(final_features_scaled), "\n")
cat("Sutun sayısı:", ncol(final_features_scaled), "\n")
cat("NaN deger sayısı:", sum(is.na(final_features_scaled)), "\n")
cat("Inf deger sayısı:", sum(is.infinite(as.matrix(final_features_scaled))), "\n")



library(solitude)
library(pROC)
library(caret)

# 1. Isolation Forest modelini eğit
iso_forest <- isolationForest$new(
  sample_size = 100,    # Küçük sample = daha iyi anomali tespiti
  num_trees = 200,      # Daha çok ağaç = daha stabil sonuç
  seed = 123
)

iso_forest$fit(final_features_scaled)

# 2. Tahmin yap
predictions <- iso_forest$predict(final_features_scaled)
df$anomaly_score <- predictions$anomaly_score  # Tüm veriye ekle

# 3. Performans değerlendirme
cat("FRAUD DETECTION PERFORMANSI:\n")

# ROC analizi
roc_curve <- roc(df$is_fraud, df$anomaly_score)
cat("AUC SCORE:", round(auc(roc_curve), 4), "\n")

# Eşik değeri optimizasyonu
threshold <- quantile(df$anomaly_score, 0.85)  # %85 eşik
df$predicted_fraud <- ifelse(df$anomaly_score > threshold, 1, 0)

# Karışıklık matrisi
conf_matrix <- confusionMatrix(
  as.factor(df$predicted_fraud),
  as.factor(df$is_fraud),
  positive = "1"
)

print("KARISIKLIK MATRISI:")
print(conf_matrix$table)
print("PERFORMANS METRIKLERI:")
print(conf_matrix$byClass[c("Precision", "Recall", "F1")])





















