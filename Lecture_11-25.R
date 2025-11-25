#######################
## Lecture 11/25/25 ###
#######################

# --- Week 13: Likelihood and Maximum Likelihood Estimation --- #

## Three ways of fitting a simple linear regression ##

# Analytical versus numerical solutions to estimation of meodel parameters
# -> Analytical
# --> an equation: [quantity of interest]  = f(data)
# --> only possible for relatively simple problems
# -> Numerical
# --> an algorithm: [quantity of interest]  ~ f(data)
# --> can be used for complex problems

# Linear regression: the analytical solution
# -> yi = Xbeta
# -> beta_hat = (X'X)^(-1) * X'y 
# --> y is a vector of observed values
# --> X' is the transpose of matrix X
# --> beta_hat is the vector of estimated parameters
# --> X is the matrix of covariates (including a column of 1s for the intercept)

# How to solve for beta_hat
# -> b <- solve(t(X) %*% X) %*% t(X) %*% y)
# -> t () is the transpose function
# -> %*% is the matrix multiplication operator

# Linear regression: the least squares solution
# -> minimize the sum of squared residuals (SSR)
# --> SSR = sum((yi - y_hat_i)^2)
# -> write a function that returns the sum of squared errors
# -> find the values of beta (the vector) that minimizes the sum of squared errors

# Two approaches #
# 1) brute force - grid search
# --> loop over a range of plausible values of the intercept and (in a nested loop) the slope
# --> save the sum of squared errors for each pair of values in a matrix
# --> find the cell in the matrix with the minimum value and extract the corresponding values of the intercept and slope
# --> if greater precision is needed, repeat the process over a smaller range of values centered on the previous estimates

# 2) optimization function - optim()
# --> help(optim)

# grid search --> SLOW
# -> try all combinations of plausible values for the parameters
# -> calculate the negative log-likelihood for each combination
# -> find the parameter combination that gives the highest likelihood (or lowest negative log-likelihood)

# optim() approach --> FAST
# -> takes an objective function, data, and initial parameters as arguments
# -> tries different values of each parameter until it finds those that minimize the objective function
# -> can use different algorithms for optimization (default is "Nelder-Mead")
# -> more efficient than grid search, especially for models with many parameters

# Example of optim() for linear regression
# Sample data
dat <- data.frame(x = c(1, 2, 3, 4, 5, 6),
                  y = c(1, 3, 5, 6, 8, 12))
# Objective function (minimize RSS for a linear model)
min_RSS <- function(par, data) {
  with(data, sum((par[1] + par[2] * x - y)^2))
}
# Initial parameter values
initial_params <- c(0, 1)  # intercept = 0, slope = 1
# Run optim
optim_results <- optim(par = initial_params,
                       fn = min_RSS,
                       data = dat)
optim_results

# Linear regression: the maximum likelihood solution
# -> find the values of beta (the vector) that maximize the likelihood of the data given the model
# -> grid search or optim() can be used here as well
# -> Normal: lnl = -n/2 * log(2 * pi) - n * log(sigma) - 1/(2 * sigma^2) * sum((yi - y_hat_i)^2)

# Example of optim() for maximum likelihood estimation
# Sample data
dat <- data.frame(x = c(1, 2, 3, 4, 5, 6),
                  y = c(1, 3, 5, 6, 8, 12))
# Objective function (negative log-likelihood for a linear model with normal errors)
neg_log_likelihood <- function(par, data) {
  intercept <- par[1]
  slope <- par[2]
  sigma <- par[3]
  y_hat <- intercept + slope * data$x
  n <- nrow(data)
  -(-n/2 * log(2 * pi) - n * log(sigma) - 1/(2 * sigma^2) * sum((data$y - y_hat)^2))
}
# Initial parameter values
initial_params <- c(0, 1, 1)  # intercept = 0, slope = 1, sigma = 1
# Run optim
optim_results_mle <- optim(par = initial_params,
                           fn = neg_log_likelihood,
                           data = dat,
                           method = "L-BFGS-B",
                           lower = c(-Inf, -Inf, 0.0001))  # sigma must be positive
optim_results_mle
# Note: In practice, you would compare the results from the different methods to ensure consistency.

# $value is sum of squared errors (RSS) or negative log-likelihood (NLL)
# $par is the estimated parameters
# $counts is the number of function evaluations
# $convergence is 0 if successful
# $message is NULL if successful


# Diagnostics for MLE
# 1) convergence - did you find the real global maximum?
# --> did you find a maximum? - convergence criteria
# --> did you find the global maximum? - sensitivity to starting values
# 2) parameter confounding
# --> are your parameter estimates correlated?
# --> do you get nearly as good a fit with very different parameter values?
# 3) plotting
# --> do the fitted values make sense ecologically?





