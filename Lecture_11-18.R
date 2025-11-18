#######################
## Lecture 11/18/25 ###
#######################

# --- Week 12: Linear Models 3: Generalized Linear Models --- #

## Why do we need GLMs? ##

# Linear model
# -> Y = B0 + B1X1 + B2X2 + ... + Error

# What if your data isn't normally distributed?
# -> Estimates of Betas (intercept and coefficients) may still be OK
# --> Gauss-Markov theorem still holds
# ---> The best linear unbiased estimator (BLUE) for a linear regression is the OLS estimator
#      provided that residuals are homoscedastic, uncorrelated, mean zero
# -> BUT predictions and CIs may be nonsensical

# What to do if your response variable is not normally distributed?
# -> Log transform the response variable
# --> Arcsin transformation for proportion data:
#     y' = arcsin(sqrt(y))

# Typical types of non-normal response data in ecological studies:
# - Count data (e.g., number of individuals observed)
# - Binary data (e.g., presence/absence)
# - Proportion data (e.g., proportion of seeds germinated)
# - Ordinal data (e.g., ranks)
# - Multinomial data (e.g., species composition)
# - Time-to-event data (e.g., survival times)
# - Categorical data (e.g., habitat types)

# Example:
# Number of individuals infected / Number of individuals tested = X1, X2
# Move denominator to the right side:
# Poisson regression -> Number of individuals infected = B0 + B1X1 + B2X2 + ... + log(Number of individuals tested) + Error

# Each of these data types has a typical probability distribution associated with it
# -> Count data -> Poisson distribution
# -> Binary data -> Binomial distribution -> variance changes with the mean: mean = np, variance = np(1-p)
# -> Proportion data -> Binomial distribution
# --> Discrete probability distribution -> integer values from 0 to infinity
# --> Single parameter: mean = variance = λ (lambda)
# --> Clumped data give rise to overdispersion: (variance > mean)

## glm() function in R ##
# -> glm(formula, family = familytype(link="linkfunction"), data = )
# --> Formula: y~x1 + x2... or y~x1*x2
# ---> Family - default = Gaussian

# -> Line - each family has a default link function
# --> Link function - specifies the relationship between the linear predictor and the mean of the distribution function

# -> Data for binomial - three options for y:
# --> 1) Two column matrix of "successes" and "failures": cbind(successes, failures)
# --> 2) Factor with two levels
# --> 3) Numeric vector of 0s and 1s

# What are "link functions"?
# -> Nead a linear predictor: η = B0 + B1X1 + B2X2 + ...
# -> Link functions link your data to this linear predictor
# -> Binomial defined by parameters p
# --> Logit link: log(p/(1-p)) = η

# -> Logit = η = log(p/(1-p))
# --> Inverse logit: p = exp(η) / (1 + exp(η))

# The glm() model object
# -> Analogous to lm() object
# -> summary() function works similarly

# Plotting logistic regression output
# -> plot(damage/6 ~ temp, orings, xlim = c(25,85), ylim = c(0,1))
# -> temp.seq <- seq(25,85,1); x_frame = as.data.frame(temp)
# -> lines(x, predict.glm(model, newdata - x_frame, type="response")
# -> type="response" gives predictions on the scale of the response variable (i.e., probabilities for binomial data)

# -> Can also use ggplot2 for plotting glm outputs
# -> ggplot(orings, aes(x=temp, y=damage/6)) + geom_point() +
#    stat_smooth(method="glm", method.args=list(family=binomial), se=TRUE)

# Prediction intervals for logistic regression
# -> Can we get a 95% confidence interval for p(damage) at 50 degrees?
# -> Not normal on the scale of the response, but the errors around the linear predictor are
# -> So, use predict.glm and the type= "link" option to get CIs on the linear predictor scale
# -> Then back-transform to the response scale using the inverse logit function
# -> +/- 1.96*SE on the link scale, then back-transform







