# install.packages('dplyr')
library(dplyr)

# Load quarterly GVA data (at 2020 prices) from CSV file
q_gva_2020 <- read.csv(
  file = '/Users/danielfaltynowski/Documents/Repositories/time-series-labs/labs/02_base_versus_real_prices/data/nanq.csv',
  sep = ';'
)

# Convert selected columns to numeric type
q_gva_2020$YEAR <- as.numeric(q_gva_2020$YEAR)
q_gva_2020$QUARTER <- as.numeric(q_gva_2020$QUARTER)
q_gva_2020$QGVA <- as.numeric(q_gva_2020$QGVA)

# Load annual GVA data (for controlling the quarterly sums)
a_gva_2020 <- read.csv(
  file = '/Users/danielfaltynowski/Documents/Repositories/time-series-labs/labs/02_base_versus_real_prices/data/nana.csv',
  sep = ';'
)

# Convert Poland column to numeric
a_gva_2020$Poland <- as.numeric(a_gva_2020$Poland)

# Preview datasets
q_gva_2020
a_gva_2020

# Add an empty column for chain indices
q_gva_2020 <- dplyr::mutate(
  q_gva_2020,
  CHAIN_INDEX = NA
)

q_gva_2020

# Compute quarterly chain indices:
# CHAIN_INDEX[t] = QGVA[t] / QGVA[t-1]
for (i in 2:length(q_gva_2020$CHAIN_INDEX)) {
  q_gva_2020$CHAIN_INDEX[i] <- q_gva_2020$QGVA[i] / q_gva_2020$QGVA[i - 1]
  
  # Round to 2 decimal places
  q_gva_2020$CHAIN_INDEX[i] <- round(
    x = q_gva_2020$CHAIN_INDEX[i], 
    digits = 2
  )
}

q_gva_2020

# Create a new empty column for real quarterly GVA (chained to 2020 prices)
q_gva_2020 <- dplyr::mutate(
  q_gva_2020,
  Q_REAL_GVA_2020_2015 = NA
)

q_gva_2020

# Set the reference quarter value:
# Real GVA for 2015 Q1 (base for forward/backward chaining)
q_gva_2020$Q_REAL_GVA_2020_2015[q_gva_2020$YEAR == 2015 & q_gva_2020$QUARTER == 1] <- 372704.21 

q_gva_2020

# Forward chaining for 2015 Q2–Q4 using CHAIN_INDEX
for (i in 82:84) {
  q_gva_2020$Q_REAL_GVA_2020_2015[i] <- q_gva_2020$Q_REAL_GVA_2020_2015[i - 1] * q_gva_2020$CHAIN_INDEX[i]
}

q_gva_2020

# Forward chaining for all following quarters based on CHAIN_INDEX
for (i in 82:length(q_gva_2020$Q_REAL_GVA_2020_2015)) {
  q_gva_2020$Q_REAL_GVA_2020_2015[i] <- q_gva_2020$Q_REAL_GVA_2020_2015[i - 1] * q_gva_2020$CHAIN_INDEX[i]
}

q_gva_2020

# Backward chaining for all earlier quarters (1 to 116)
for (i in rev(1:80)) {
  q_gva_2020$Q_REAL_GVA_2020_2015[i] <- q_gva_2020$Q_REAL_GVA_2020_2015[i + 1] / q_gva_2020$CHAIN_INDEX[i + 1]
}

q_gva_2020

# Save the dataset to a CSV file
write.csv(
  x = q_gva_2020,
  file = "q_gva_2020_2015.csv",
  sep=';'
)

