######################
## Lecture 11/4/25 ###
######################

# --- Week 10: Linear Models 1 --- #

## History and theory of regression
# -> Galton's peas and "regression to mediocrity"
# --> Plotted pea weights of offspring vs. those of their parents
# --> Found that extreme values tend to be closer to the mean in the next generation
# ---> Noticed that they were positively related but less than one-to-one
# ----> Offspring of very small peas tended to be larger, 
# ----> and offspring of very large peas tended to be smaller
# -----> A positive relationship but not a one-to-one relationship
# ------> The best regression line should go through the MEAN of the data

## Pearson's "product-moment" correlation
# -> A measure of linear association between two variables
# --> Ranges from -1 to 1
# ---> 1 means perfect positive linear relationship
# ----> -1 means perfect negative linear relationship
# -----> 0 means no linear relationship
# ------> Not the same as slope of regression line, but related
# --------> r^2 is the proportion of variance explained by the linear model

# Adding variation in the x or y direction gives same correlation but different regression lines

## Spearman rank correlation
# -> Pearson correlation of the observations' ranks
# --> Less sensitive to outliers and non-linear relationships
# ---> Can calculate a p value
# ----> cor.test() function in R, "spearman" argument
# -----> Example: cor.test(x, y, method = "spearman")

## Formal Statement of the Model
# -> Beta 0 is the intercept
# -> Beta 1 is the slope
# -> Epsilon is the error term, assumed to be normally distributed with mean 0 and constant variance
# -> X is the predictor variable
# -> Y is the response variable

Y = (β0) + (β1)X + ε

# -> Deviations epsilon are independent and identically distributed normal random variables with mean 0 and variance sigma^2

## Linear regression: the analytical solution
# where i represents one of m observations and j one of n+1 covariates:
# -> yi = β0 + β1xi + εi for i = 1 to n
# -> y = X(Beta)
# -> Beta = (X^T X)^-1 X^T y

## Linear regression: assumptions
# -> LINEARITY: The relationship between X and Y is linear
# -> INDEPENDENCE: The errors are independent and identically distributed ~N(0, sigma^2)
# --> Normally distributed
# --> Independent (No autocorrelation)
# --> Homoscedasticity (constant variance)

## Assumption checking
# car_mod2 <- lm(mtscars$mpg ~ hp, data=mtcars)
# -> lm is the function to fit linear models in R
# -> specify data frame with "data=" argument
# -> first argument is the formula: response ~ predictor(s)

# ggforitfy::autoplot(car_mod2)
# -> ggfortify package has a function to make diagnostic plots with ggplot2
# -> Four plots:
# --> Residuals vs Fitted: check for linearity and homoscedasticity
# --> Normal Q-Q: check for normality of residuals -> Vital for checking for normality
# --> Scale-Location: check for homoscedasticity
# --> Residuals vs Leverage: check for influential points -> Large residuals but small leverage are less influential


# hist(car_mod2$residuals)

## Prediction
# predict(object, newdata, interval = "prediction")
# -> object: the lm() object
# -> newdata: a data frame with the predictor variable(s)
# -> interval: "confidence" for mean prediction, "prediction" for individual prediction
# --> Prediction intervals vs confidence intervals
# ---> Prediction intervals are wider because they account for both the uncertainty in the mean prediction
# ---> and the variability of individual observations around that mean
# ----> Prediction: 95% of observations should fall within this interval
# ----> Confidence: 95% of mean predictions should fall within this interval


# Exercise: Is this true?

# 1. Observation error in your predictor variable can cause you to underestimate the slope parameter
# of a linear regression. This is called the regression dilution effect.

# Load libraries
library(ggplot2)
library(dplyr)
library(tidyr)

# Set seed for reproducibility
set.seed(123)

# Define constants
alpha <- 5
beta <- 8
n <- 100

# Generate x values
x <- runif(n, min = 0, max = 10)

# Create a function to generate y with a given sigma
generate_y <- function(sigma) {
  y <- alpha + beta*x + rnorm(n, mean = 0, sd = sigma)
  return(y)
}

# Generate y for three different sigma values
sigma_values <- c(1, 10, 25)

data <- data.frame(
  x = rep(x, times = length(sigma_values)),
  sigma = factor(rep(sigma_values, each = n)),
  y = unlist(lapply(sigma_values, generate_y))
)

head(data)

p1 <- ggplot(data, aes(x = x, y = y)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  facet_wrap(~ sigma, nrow = 1) +
  labs(
    title = "Effect of Increasing Observation Error on Linear Regression",
    x = "Predictor (x)",
    y = "Response (y)"
  ) +
  theme_minimal()

p1

# 1a. Using your code above, add observation error to your X values.
# Note: this shouldn't change the Y values since this is observation error not process error.

set.seed(123)

data_with_x_error <- data %>%
  group_by(sigma) %>%
  mutate(
    x_observed = x + rnorm(n(), mean = 0, sd = as.numeric(as.character(sigma)))
  ) %>%
  ungroup()

head(data_with_x_error)

p2 <- ggplot(data_with_x_error, aes(x = x_observed, y = y)) +
  geom_point(color = "red") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  facet_wrap(~ sigma, nrow = 1) +
  labs(
    title = "Effect of Observation Error in X on Linear Regression",
    x = "Observed Predictor (x with error)",
    y = "Response (y)"
  ) +
  theme_minimal()

p2

# 1b. How does your estimated slope compare to the true slope as observation error in X increases?
# -> As observation error in X increases, the estimated slope tends to be biased towards zero
# -> This demonstrates the regression dilution effect, where measurement error in the predictor variable

# 1c. Plot a series of figures (ggplot2, facet wrap option) with the true and estimated regression lines
# as observation error increases

combined_plot <- ggplot() +
  geom_point(data = data, aes(x = x, y = y), color = "blue", alpha = 0.5) +
  geom_smooth(data = data, aes(x = x, y = y), method = "lm", se = FALSE, color = "black") +
  geom_point(data = data_with_x_error, aes(x = x_observed, y = y), color = "red", alpha = 0.5) +
  geom_smooth(data = data_with_x_error, aes(x = x_observed, y = y), method = "lm", se = FALSE, color = "black") +
  facet_wrap(~ sigma, nrow = 1) +
  labs(
    title = "True vs Estimated Regression Lines with Observation Error in X",
    x = "Predictor",
    y = "Response"
  ) +
  theme_minimal()

combined_plot

# -> The blue points and line represent the true relationship without observation error
# -> The red points and line represent the estimated relationship with observation error in X
# -> As observation error increases, the estimated regression line (red) deviates more from the true line (black)
# -> The slope of the estimated line becomes flatter as observation error increases, illustrating regression dilution
# increases, the estimated slope becomes biased towards zero.
# -> This demonstrates the regression dilution effect, where measurement error in the predictor variable
# leads to an underestimation of the true slope of the relationship.




