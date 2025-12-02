#######################
## Lecture 12/2/25 ###
#######################

# --- Week 14: Linear Model Selection --- #

## Goal
# Compare the relative support for different alternative - but not mutually exclusive - hypotheses

## Principals
# -> A model is well supported if it makes good predictions
# -> A model has good predictive ability if the data are highly likely given the model

## Likelihood ratio test
# -> f(x) is the simpler model - a special case of g(x)
# -> g(x) is the more complex model
# --> For example, if f(x) is a linear model w/ explanatory variable X1, g(x) has X1 plus at least
#     one additional variable. When the coefficient(s) of the additional variable = 0, then g(x) = f(x)
# --> The log likelihood ratio (R) has a chi-square distribution with df = # of additional parameters in g(x)

## For non-nested models: AIC
# -> Akaike Information Criterion (AIC) provides a way to compare non-nested models
# -> What is the expected log-likelihood when applying the model to new observations?
# --> Model will not perform quite as well on new observations because it has "done its best" to
#     predict the data it was fit to, including the observation error (noise) in those data points
# ---> Lower AIC is better

# -> To estimate the expected log likelihood when applying the model to new data, adjust the log-likelihood
#    of the model based on the number of parameters in it
# --> That is, penalize models that are overly flexible
# ---> AIC = 2*(-Lmax-K) where 
# ---- Lmax = maximum log-likelihood of the model
# ---- K = number of parameters in the model
# ---- AIC is Akaike Information Criterion

# -> When comparing models, the one with the lowest AIC is preferred
# --> The difference in AIC between models (ΔAIC) indicates the strength of evidence for one model over another

## Rules of thumb for comparing AIC among models
# -> ΔAIC < 2: models have similar support from the data
# -> 4 < ΔAIC < 7: less support for the model with higher AIC
# -> ΔAIC > 10: essentially no support for the model with higher AIC



