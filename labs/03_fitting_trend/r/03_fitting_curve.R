data <- read.csv(
  file = './../data/gva_processed.csv',
  sep = ';'
)

gva <- data$POLAND

t <- 2:(length(gva) + 1)

linear_model <- lm(gva ~ t)

summary(linear_model)

power_model <- lm(log(gva) ~ log(t))

summary(power_model)

exponential_model <- lm(log(gva) ~ t)

summary(exponential_model)

gva_linear <- linear_model$coefficients[1] + linear_model$coefficients[2] * t
gva_power <- exp(power_model$coefficients[1]) * t^power_model$coefficients[2]
gva_exponential <- exp(exponential_model$coefficients[1] + exponential_model$coefficients[2] * t)

plot(
  t, gva,
  type = "l",
  col = "black",
  lwd = 2,
  xlab = "t",
  ylab = "GVA",
  main = "Regression: Real Data vs. Forecasting"
)

lines(t, gva_linear, col = "blue", lwd = 2)
lines(t, gva_power, col = "red", lwd = 2)
lines(t, gva_exponential, col = "darkgreen", lwd = 2)

legend(
  "topleft",
  legend = c("GVA (data)", "Linear Model", "Power Model", "Exponential Model"),
  col = c("black", "blue", "red", "darkgreen"),
  lwd = 2
)

