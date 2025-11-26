# install.packages('dplyr')
library(dplyr)

q_gva_2020 <- read.csv(
  file = '/Users/danielfaltynowski/Documents/Repositories/time-series-labs/labs/02_base_versus_real_prices/data/nanq.csv',
  sep = ';'
)

q_gva_2020$YEAR <- as.numeric(q_gva_2020$YEAR)
q_gva_2020$QUARTER <- as.numeric(q_gva_2020$QUARTER)
q_gva_2020$QGVA <- as.numeric(q_gva_2020$QGVA)

a_gva_2020 <- read.csv(
  file = '/Users/danielfaltynowski/Documents/Repositories/time-series-labs/labs/02_base_versus_real_prices/data/nana.csv',
  sep = ';'
)

a_gva_2020$Poland <- as.numeric(a_gva_2020$Poland)

q_gva_2020
a_gva_2020

q_gva_2020 <- dplyr::mutate(
  q_gva_2020,
  CHAIN_INDEX = NA
)

q_gva_2020

for (i in 2:length(q_gva_2020$CHAIN_INDEX)) {
  q_gva_2020$CHAIN_INDEX[i] <- q_gva_2020$QGVA[i] / q_gva_2020$QGVA[i - 1]
  q_gva_2020$CHAIN_INDEX[i] <- round(
    x = q_gva_2020$CHAIN_INDEX[i], 
    digits = 2)
}

q_gva_2020

q_gva_2020 <- dplyr::mutate(
  q_gva_2020,
  Q_REAL_GVA_2020_2024 = NA
)

q_gva_2020

q_gva_2020$Q_REAL_GVA_2020_2024[q_gva_2020$YEAR == 2024 & q_gva_2020$QUARTER == 1] <- 500000

q_gva_2020

for (i in 118:120) {
  q_gva_2020$Q_REAL_GVA_2020_2024[i] <- q_gva_2020$Q_REAL_GVA_2020_2024[i - 1] * q_gva_2020$CHAIN_INDEX[i]
}

q_gva_2020

adj <- 500000

while (abs(sum(q_gva_2020$Q_REAL_GVA_2020_2024[117:120]) - a_gva_2020$Poland[which(a_gva_2020$TIME == 2024)]) < 0.01) {
  if (abs(sum(q_gva_2020$Q_REAL_GVA_2020_2024[117:120]) < a_gva_2020$Poland[which(a_gva_2020$TIME == 2024)])) {
    q_gva_2020$Q_REAL_GVA_2020_2024[117] <- q_gva_2020$Q_REAL_GVA_2020_2024[117]
  }
}

for (i in 118:length(q_gva_2020$Q_REAL_GVA_2020_2024)) {
  q_gva_2020$Q_REAL_GVA_2020_2024[i] <- q_gva_2020$Q_REAL_GVA_2020_2024[i - 1] * q_gva_2020$CHAIN_INDEX[i]
}

q_gva_2020

for (i in rev(1:116)) {
  q_gva_2020$Q_REAL_GVA_2020_2024[i] <- q_gva_2020$Q_REAL_GVA_2020_2024[i + 1] / q_gva_2020$CHAIN_INDEX[i + 1]
}

q_gva_2020

