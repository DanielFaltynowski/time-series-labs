# Load the dplyr library for data manipulation
# install.packages("dplyr")
library(dplyr)

# Read the GVA dataset from CSV
data <- read.csv(file = 'r/q_gva_2020_2024.csv', sep = ',')

# Transform current dataset to script from Labs 01
data$GVA <- data$Q_REAL_GVA_2020_2024

# Convert columns to numeric
data$YEAR <- as.numeric(data$YEAR)
data$GVA <- as.numeric(data$GVA)

# Inspect the dataset
data

# Initialize column for GVA with trend removed
data <- dplyr::mutate(data, GVA_no_trend = NA)

# View updated dataset
data

# Remove trend using first differences
for (i in 1:length(data$GVA_no_trend)) {
  if (i == 1) {
    data$GVA_no_trend[i] <- NA
  } else {
    data$GVA_no_trend[i] <- data$GVA[i] - data$GVA[i - 1]
  }
}

# Inspect data after detrending
data

# Calculate raw quarterly indicators for seasonality
raw_indicator_q1 <- mean(dplyr::filter(data, QUARTER == 1)$GVA_no_trend, na.rm = TRUE)
raw_indicator_q2 <- mean(dplyr::filter(data, QUARTER == 2)$GVA_no_trend, na.rm = TRUE)
raw_indicator_q3 <- mean(dplyr::filter(data, QUARTER == 3)$GVA_no_trend, na.rm = TRUE)
raw_indicator_q4 <- mean(dplyr::filter(data, QUARTER == 4)$GVA_no_trend, na.rm = TRUE)

raw_indicator_q1
raw_indicator_q2
raw_indicator_q3
raw_indicator_q4

# Calculate overall average of raw indicators
average_raw_indicator <- mean(c(raw_indicator_q1, raw_indicator_q2, raw_indicator_q3, raw_indicator_q4))

average_raw_indicator

# Compute cleaned quarterly indicators
cleaned_indicator_q1 <- raw_indicator_q1 - average_raw_indicator
cleaned_indicator_q2 <- raw_indicator_q2 - average_raw_indicator
cleaned_indicator_q3 <- raw_indicator_q3 - average_raw_indicator
cleaned_indicator_q4 <- raw_indicator_q4 - average_raw_indicator

cleaned_indicator_q1
cleaned_indicator_q2
cleaned_indicator_q3
cleaned_indicator_q4

# Initialize column for GVA with trend and seasonality removed
data <- dplyr::mutate(data, GVA_no_trend_seasonality = NA)

# Inspect dataset
data

# Remove seasonality by subtracting cleaned quarterly indicators
for (i in 1:length(data$GVA_no_trend_seasonality)) {
  if (data$QUARTER[i] == 1) {
    data$GVA_no_trend_seasonality[i] <- data$GVA_no_trend[i] - cleaned_indicator_q1
  } else if (data$QUARTER[i] == 2) {
    data$GVA_no_trend_seasonality[i] <- data$GVA_no_trend[i] - cleaned_indicator_q2
  } else if (data$QUARTER[i] == 3) {
    data$GVA_no_trend_seasonality[i] <- data$GVA_no_trend[i] - cleaned_indicator_q3
  } else if (data$QUARTER[i] == 4) {
    data$GVA_no_trend_seasonality[i] <- data$GVA_no_trend[i] - cleaned_indicator_q4
  }
}

# View data after removing trend and seasonality
data

# Filter dataset to include only observations from 2017 onwards
data <- dplyr::filter(data, data$YEAR >= 2017)

# Plot GVA at different stages of data cleaning
y_min <- min(data$GVA, data$GVA_no_trend, data$GVA_no_trend_seasonality, na.rm = TRUE)
y_max <- max(data$GVA, data$GVA_no_trend, data$GVA_no_trend_seasonality, na.rm = TRUE)

plot(1:length(data$GVA), data$GVA, type = "l", col = "blue", lwd = 2, 
     ylim = c(y_min, y_max), xlab = "Time", ylab = "Value", 
     main = "Gross Value Added – Different Stages of Data Cleaning", xaxt = "n")

axis(1, at = 1:length(data$TIME), labels = data$TIME)

par(new = TRUE)
plot(1:length(data$GVA_no_trend), data$GVA_no_trend, type = "l", col = "darkorange", 
     lwd = 2, ylim = c(y_min, y_max), axes = FALSE, xlab = "", ylab = "")

par(new = TRUE)
plot(1:length(data$GVA), data$GVA_no_trend_seasonality, type = "l", col = "darkgreen", 
     lwd = 2, ylim = c(y_min, y_max), axes = FALSE, xlab = "", ylab = "")

legend("topleft", legend = c("GVA (raw)", "GVA (no trend)", "GVA (no trend + seasonality)"), 
       col = c("blue", "darkorange", "darkgreen"), lwd = 2, bty = "n")

