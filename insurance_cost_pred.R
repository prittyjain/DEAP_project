library(readxl)
library(dplyr)
library(ggplot2)
library(Hmisc)
install.packages("cowplot")
install.packages("WVPlots")
library(cowplot)
library(WVPlots)
library(e1071)
library(caret)

describe(insurance)
sum(is.na(insurance))

#Correlation betweem charges and age/bmi
x <- ggplot(insurance, aes(age, charges)) +
  geom_jitter(color = "blue", alpha = 0.5) +
  theme_light()

y <- ggplot(insurance, aes(bmi, charges)) +
  geom_jitter(color = "green", alpha = 0.5) +
  theme_light()

p <- plot_grid(x, y) 
title <- ggdraw() + draw_label("1. Correlation between Charges and Age / BMI", fontface='bold')
plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1))


#Correlation betweem charges and sex/ children covered by insurance

x <- ggplot(insurance, aes(sex, charges)) +
  geom_jitter(aes(color = sex), alpha = 0.7) +
  theme_light()

y <- ggplot(insurance, aes(children, charges)) +
  geom_jitter(aes(color = children), alpha = 0.7) +
  theme_light()

p <- plot_grid(x, y) 

title <- ggdraw() + draw_label("2. Correlation between Charges and Sex / Children covered by insurance", fontface='bold')
plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1))

#Correlation betweem charges and smoker/region
x <- ggplot(insurance, aes(smoker, charges)) +
  geom_jitter(aes(color = smoker), alpha = 0.7) +
  theme_light()

y <- ggplot(insurance, aes(region, charges)) +
  geom_jitter(aes(color = region), alpha = 0.7) +
  theme_light()

p <- plot_grid(x, y)

title <- ggdraw() + draw_label("3. Correlation between Charges and Smoker / Region", fontface='bold')
plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1))

#split to train and test dataset
n_train <- round(0.8 * nrow(insurance))
train_indices <- sample(1:nrow(insurance), n_train)
Data_train <- insurance[train_indices, ]
Data_test <- insurance[-train_indices, ]

formula_0 <- as.formula("charges ~ age + sex + bmi + children + smoker + region")


#linear regression
model_0 <- lm(formula_0, data = Data_train)
summary(model_0)


formula_1 <- as.formula("charges ~ age + bmi + children + smoker + region")

model_1 <- lm(formula_1, data = Data_train)
summary(model_1)

#Saving R-squared
r_sq_1 <- summary(model_1)$r.squared
#predict data on test set
prediction_1 <- predict(model_1, newdata = Data_test)
#calculating the residuals
residuals_1 <- Data_test$charges - prediction_1
#calculating Root Mean Squared Error
rmse_1 <- sqrt(mean(residuals_1^2))


Data_test$prediction <- predict(model_1, newdata = Data_test)
ggplot(Data_test, aes(x = prediction, y = charges)) + 
  geom_point(color = "blue", alpha = 0.7) + 
  geom_abline(color = "red") +
  ggtitle("Prediction vs. Real values")



Data_test$residuals <- Data_test$charges - Data_test$prediction
ggplot(data = Data_test, aes(x = prediction, y = residuals)) +
  geom_pointrange(aes(ymin = 0, ymax = residuals), color = "blue", alpha = 0.7) +
  geom_hline(yintercept = 0, linetype = 3, color = "red") +
  ggtitle("Residuals vs. Linear model prediction")


ggplot(Data_test, aes(x = residuals)) + 
  geom_histogram(bins = 15, fill = "blue") +
  ggtitle("Histogram of residuals")


GainCurvePlot(Data_test, "prediction", "charges", "Model")

Dennis <- data.frame(age = 25,
                     bmi = 30.9,
                     children = 0,
                     smoker = "no",
                     region = "northwest")
print(paste0("Health care charges for Dennis: ", round(predict(model_1, Dennis), 2)))
