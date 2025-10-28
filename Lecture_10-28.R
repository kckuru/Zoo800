######################
## Lecture 10/28/25 ##
######################

# --- Week 9: Probability and Distributions --- #

## Distributions in Ecology

# Central Limit Theorem
# -> The distribution of sample means (means of whatever value you are measuring) 
# -> converges to a normal distribution as the sample size increases
# --> As sample sizes increases, the distribution of averages becomes MORE NORMAL and NARROWER (bunny video)
# ---> This is true regardless of the shape of the underlying distribution

# Types of non-normal response data in ecological studies
# 1. Counts (quadrats, line transects) -> normal distribution must be CONTINUOUS
# 2. Proportions (number of individuals that have a characteristic / total number of individuals)
# 3. Categorical (male/female, benthic/pelagic)

# Each data type has a typical probability distribution associated with it
# -> Counts of events within a given sampling unit are POISSON distributed if the rate (density) is constant,
# -> and they are independent (not clumped in space or time or spread out)
# --> Discrete probability distribution (integer values from 0 to inf)
# ---> Single parameter: mean = variance = lambda (λ)
# ----> Clumped data give rise to overdispersion: variance > mean
# -----> Negative binomial can be a better option for overdispersed count data

# Poisson (counts) examples
# -> As mean gets larger, variance gets larger
# -> Count data with a large enough mean can be approximated with a normal distribution

# Binomial distribution used for total number of "sucesses" in a fixed number of trials
# -> Discrete probability distribution (integer values from 0 to n)
# -> Two parameters: number of trials (n) and probability of success (p)
# --> Variance = n*p*(1-p)
# ---> When n is large and p is not close to 0 or 1, can be approximated with a normal distribution
# ----> 0.5 is p when the variance is maximized (according to the equation)

# Each of these data types has a typical probability distribution
# -> The distribution of p can be defined based on the results of n independent trials
# -> using the beta distribution
# --> Continuous probability distribution (values between 0 and 1) and parameters alpha and beta
# ---> Distribution of p is a beta with alpha-1 "sucesses" and beta-1 "failures"

# Beta distribution examples
# -> As alpha and beta get larger, the distribution gets more normal
# -> When alpha = beta, the distribution is symmetric around 0.5
# -> When alpha > beta, the distribution is skewed right
# -> When alpha < beta, the distribution is skewed left
# -> When alpha and beta are both less than 1, the distribution is U-shaped

# Exponential family
# -> Normal (Gaussian), Poisson, Binomial, Gamma, Inverse Gaussian
# --> Can be expressed in a common mathematical form
# ---> Allows for a unified approach to statistical modeling (Generalized Linear Models)

# Distributions in R
# -> rnorm() -> draw random variables from the specified distribution
# -> dnorm() -> the probability density ar any point
# -> pnorm() -> tail probabilities to the left or right of the specified point
# -> Similar r-, d-, and p- syntax for other distributions: ex: rpois, runif, etc.

# How can our results be replicable if they involve generating random observations?
# -> Set a seed before generating random numbers using set.seed()
# --> This ensures that the same sequence of random numbers is generated each time the code is run

# Using random numbers in R to select a random subset of observations
# -> create a new column in your df
# --> fill with random numbers drawn from a uniform distribution
# ---> sort the df by the random number column
# ----> select the first n rows for your random sample

# Fitting distributions and distribution tests
# -> MASS and fitdistrplus packages
# --> denscomp() plot function

# In-class exercise:

# 1. Is this true?
# --> The accumulation (sum) of many small random errors from any distribution is normally distributed.
# ---> Yes, according to the Central Limit Theorem.

# 2. Is this true?
# --> What if the process is multiplicative rather than additive?
# ---> No, the Central Limit Theorem applies to additive processes. Multiplicative processes often lead to log-normal distributions.

# 3. Is this true?
# --> Use fitdistrplus to compare distributions from 1. and 2.
# ---> Yes, fitdistrplus can be used to compare how well different distributions fit the data.
hist(rnorm(1000, mean = 0, sd = 1), main = "Normal Distribution")
install.packages("fitdistrplus")
library(fitdistrplus)

x <- rnorm(1000, mean = 0, sd = 1)
fit_norm <- fitdist(x, "norm")
denscomp(list(fit_norm), main = "Density Comparison")

x2 <- rnorm(500, mean = 0, sd = 1)
fit_norm2 <- fitdist(x2, "norm")
denscomp(list(fit_norm2), main = "Density Comparison")

x3 <- rnorm(200, mean = 0, sd = 1)
fit_norm3 <- fitdist(x3, "norm")
denscomp(list(fit_norm3), main = "Density Comparison")

# 4. Coin flip example
# Don Corleone challenges you to flip a coin three times. Each time the loser owes the winner a favor.
# -> After four heads, you owe him four favors. And you’re wondering if the game is rigged
# --> What is the probability that the probability of heads is > 0.5
# ---> Use the beta distribution to model the probability of heads given the number of heads and tails observed
# ----> Use the pbeta() function to calculate the cumulative probability of heads > 0.5
# Answer: 0.96875
# Why?
# -> We observed 4 heads and 0 tails
# -> So we use a beta distribution with alpha = 4 + 1 = 5 and beta = 0 + 1 = 1
# --> We want to find P(p > 0.5) = 1 - P(p <= 0.5)
# ---> P(p <= 0.5) = pbeta(0.5, shape1 = 5, shape2 = 1)
# ----> P(p > 0.5) = 1 - pbeta(0.5, shape1 = 5, shape2 = 1) = 0.96875

P(p > 0.5) = 1 - P(p ≤ 0.5)
1 - pbeta(0.5, shape1 = 5, shape2 = 1)
= 1 - (0.5)^5
= 1 - 0.03125
= 0.96875

# After seeing 4 heads in a row, you're 96.875% confident the coin is biased toward heads.


