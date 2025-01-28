library(dplyr)
car_data <- read.csv("C:\\Users\\pranavi\\Downloads\\CarValues.csv")
# Check the structure of the dataset
str(car_data)

# summary of the dataset
summary(car_data)

#Histogram of value score
library(ggplot2)
hist(car_data$Value.Score, main = "Histogram of Value Score", xlab = "Value Score", ylab = "Frequency")

# Bar chart of the number of cars by size category.
ggplot(car_data, aes(x = Size)) + 
  geom_bar(fill = "#333333") + 
  theme_bw() + 
  labs(title = "Bar Chart of Number of Cars by Size Category", 
       x = "Size Category",
       y = "Number of Cars")


# Scatter plot of car price versus value score.
ggplot(car_data, aes(x = Price, y = Value.Score)) + 
  geom_point() + 
  theme_bw() + 
  labs(title = "Scatter Plot of Car Price vs Value Score", 
       xlab = "Car Price", 
       ylab = "Value Score")



# Calculate SD
Price <- car_data$Price
Cost.Mile <- car_data$Cost.Mile
Road.Test.Score <- car_data$Road.Test.Score
Predicted.Reliability <- car_data$Predicted.Reliability
Value.Score <- car_data$Value.Score
sd(Price)
sd(Cost.Mile)
sd(Road.Test.Score)
sd(Predicted.Reliability)
sd(Value.Score)

# Convert 'Size' column to a factor
car_data$Size <- as.factor(car_data$Size)

# Create dummy variables for 'Size' column
car_data$Small_Sedan <- ifelse(car_data$Size == "Small Sedan", 1, 0)
car_data$Family_Sedan <- ifelse(car_data$Size == "Family Sedan", 1, 0)
car_data$Upscale_Sedan <- ifelse(car_data$Size == "Upscale Sedan", 1, 0)

# Correlation analysis
correlation_matrix <- cor(car_data[c("Price", "Cost.Mile", "Road.Test.Score", "Predicted.Reliability", "Small_Sedan", "Family_Sedan", "Upscale_Sedan", "Value.Score")])
print(correlation_matrix)

# Plot correlation matrix
library(corrplot)
corrplot(correlation_matrix, method = "color")

# Split the dataset into training and testing sets
set.seed(123) # for reproducibility
train_idx <- sample(nrow(car_data), 0.8*nrow(car_data)) # 80% for training
test_idx <- setdiff(1:nrow(car_data), train_idx) # 20% for testing

# Create separate datasets for training and testing
train_data <- car_data[train_idx,]
test_data <- car_data[test_idx,]

#Build linear regression model
model <- lm(Value.Score ~ Price + Cost.Mile + Road.Test.Score + Predicted.Reliability + Upscale_Sedan, data = train_data)
summary(model)

# Evaluate the model on the training data
training_predictions <- predict(model, newdata = train_data)
training_mae <- mean(abs(training_predictions - train_data$value))
summary(model)

# Evaluate the model on the testing data
test_predictions <- predict(model, newdata = test_data)
test_mae <- mean(abs(test_predictions - test_data$value))
summary(model)
