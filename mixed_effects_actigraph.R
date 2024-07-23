install.packages('lme4')
install.packages('Matrix')
library(ggplot2)
library(lme4)
library(Matrix)
library("lme4")
library("tidyverse")



data <- read.csv("C:/Users/anshi/Downloads/depression/all_data.csv")
View(data)


data$sqrt_activity <- sqrt(data$mean_activity_segment + 1)
data$group <- as.factor(data$group)


model_linear <- lm(sqrt_activity ~ day+avg_age+gender+group, data=data)
summary(model_linear)


# Filter data to include only 'condition'
condition_data <- data[grepl("^condition", data$number), ]

# Filter data to include only 'control'
control_data <- data[grepl("^control", data$number), ]

##checking if random slopes are required at day level 

# Create a ggplot with facet_wrap
ggplot(condition_data, aes(x = day, y = mean_activity_segment)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +  # Add linear line
  scale_x_continuous(breaks = seq(0, 23, by=5)) +  # Adjust breaks as needed
  facet_wrap(~ number, ncol = 5)  # Creates a separate plot for each day, arranged in 4 columns

# Create a ggplot with facet_wrap
ggplot(control_data, aes(x = day, y = mean_activity_segment)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +  # Add linear line
  scale_x_continuous(breaks = seq(0, 35, by=5)) +  # Adjust breaks as needed
  facet_wrap(~ number, ncol = 5)  # Creates a separate plot for each day, arranged in 4 columns


model<- lmer(sqrt_activity ~  group+day+avg_age+gender+(1 + day | number), data = data)
summary(model)


ggplot(data, aes(x = fitted(model), y = residuals(model))) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red") +
  ggtitle("Residuals vs Fitted")



model_dep<- lmer(sqrt_activity ~  day+avg_madrs+avg_edu+work+marriage+inpatient+avg_age+gender+(1 | number/day), data = data)
summary(model_dep)

coeffs <- coef(summary(model_dep))
p <- pnorm(abs(coeffs[, "t value"]), lower.tail = FALSE) * 2 
cbind(coeffs, "p value" = round(p,3))



