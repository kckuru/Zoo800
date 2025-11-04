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












