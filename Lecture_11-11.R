#######################
## Lecture 11/11/25 ###
#######################

# --- Week 11: Linear Models 2 --- #

## Extending the linear model to categorical variables
# Dummy variables 
# -> Created automatically when a factor is included in lm()
# -> or can be specified using factor()
# -> Reference level is the first level of the factor (alphabetically by default) 
# -> Compared to a reference level in lm() summary
# --> Example: mean of reference level = 114
# --> mean of treatment level = 124
# --> difference = 10
# --> Interpretation: treatment group has on average 10 units higher than reference group

## Combining categorical and continuous variables Analysis of Covariance (ANCOVA)
# Understand the effect of treatment (categorical) while controlling for a continuous variable (covariate)
# -> Example: effect of fertilizer type on plant growth while controlling for initial plant size

## Interpreting ANCOVA output
# Example 1: Mod1 <- lm(Y ~ Xcon * Xfac)
# -> Xcon is a continuous predictor, Xfac is a categorical predictor
# -> Y is the response variable
# -> The asterisk (*) indicates inclusion of both main effects and their interaction
# --> Main effect of Xfac: difference in Y between levels of Xfac when Xcon = 0
# --> Main effect of Xcon: change in Y for a one-unit increase in Xcon when Xfac is at reference level
# --> Interaction effect: how the effect of Xcon on Y changes across levels of Xfac

# Example 2: Mod2 <- lm( Y ~ Xcon + Xfac)
# -> Main effect of Xfac: difference in Y between levels of Xfac, averaged over all values of Xcon
# -> Main effect of Xcon: change in Y for a one-unit increase in Xcon, averaged over all levels of Xfac
# -> No interaction effect included

## -- One factor, multiple levels - Analysis of Variance (ANOVA) -- ##
# Also fits the lm() linear model framework

# Why generate a boxplot first beforehand?
# -> Visualize data distribution across groups
# -> Identify potential outliers !!
# -> Assess homogeneity of variances assumption
# -> Check for normality of residuals assumption

# Example: Mod3 <- lm(Y ~ Xfac)
# -> Xfac has more than two levels (e.g., A, B, C)
# -> ANOVA tests if there are significant differences in Y among the levels of Xfac

# Pair-wise contrasts
# -> Post-hoc tests (e.g., Tukey's HSD) to identify which specific groups differ
# --> Interpreting becomes difficult with many levels... why?
# ---> Increases the number of comparisons, raising the risk of Type I errors
# ---> Adjustments for multiple comparisons reduce statistical power

# Multiple comparison corrections
# -> Tukey's HSD, Bonferroni correction, etc.
# -> Control the family-wise error rate when conducting multiple pair-wise tests
# -> Important to avoid false positives in identifying significant differences
# -> Example in R: TukeyHSD(aov(Mod3))

# Estimate the means and CIs for each level
# -> Use emmeans package in R
# -> Example: emmeans(Mod3, ~ Xfac)
# -> Provides estimated marginal means and confidence intervals for each group
# -> Useful for visualizing group differences and uncertainty

# Checking ANOVA assumptions
# -> Normal distribution of residuals: Shapiro-Wilk test, Q-Q plots
# -> Homogeneity of variances: Levene's test, Bartlett's test, CARS package leveneTest()
# -> Independence of observations: study design consideration

# Data limitations
# -> What if we have two factors, each with multiple levels, and only one observation for each combination?
# -> Can we fit a model with interactions?
# --> No, we cannot estimate interaction effects with only one observation per combination
# -> What if we treat laser as a continuous numeric variable?
# --> Yes, you are reducing the number of parameters the model needs to estimate
# --> But be cautious, as this assumes a linear relationship!

# Exercise: simulation and estimation of linear models with one categorical and one continuous predictor
# 1a. Using code from last week's homework, add a two level categorical X value and simulate sufficient data
# -> (say 100 observations total, split evenly between the two levels) to estimate the parameters of an
# -> ANCOVA model. You can decide whether there is an interaction or not (same slopes but different intercepts
# -> vs. different slopes and intercepts) or even whether the categorical variable matters at all.

# 1b. Write a brief (2-3 sentences) ecological scenario for these data and give the variables related names and units.
# -> Finish with an ecological question that fits the ANCOVA format.

# ===== Exercise 1a: ANCOVA Simulation ===== #
# Exercise: Simulation and estimation of linear models with one categorical and one continuous predictor
# Adapted for Trout Bog Lake: Epilimnion vs. Hypolimnion

# Ecological scenario:
# These simulated data represent mean water color (absorbance normalized to a 1 cm path length)
# measured in the epilimnion (surface layer) and hypolimnion (deep layer) of Trout Bog Lake, WI
# from 1990–2020. The hypolimnion is more isolated and often contains more dissolved organic matter,
# leading to darker color. We ask: does the rate of browning (increase in color) differ between layers?

set.seed(123)

# Continuous predictor: year (1990–2020)
year <- rep(seq(1990, 2020, length.out = 50), times = 2) # 50 observations per depth zone, total 100

# Categorical predictor: depth zone
depth_zone <- rep(c("Epilimnion", "Hypolimnion"), each = 50) # layers of lake, 50 observations each

# Define true model parameters
# Hypothesis: both zones are browning, but the hypolimnion is darker overall and increasing faster
intercept_epi <- -3.7      # Baseline intercept for epilimnion (chosen so predictions ≈ 0.25–0.35 absorbance)
slope_epi <- 0.0020        # Rate of increase in color per year for the epilimnion
intercept_hypo <- intercept_epi - 0.8   # Hypolimnion starts darker (lower intercept)
slope_hypo <- slope_epi + 0.0010        # Hypolimnion color increases faster (steeper slope)

# Simulate data with noise
mean_absorbance <- ifelse(
  depth_zone == "Epilimnion",
  intercept_epi + slope_epi * year + rnorm(50, 0, 0.02), # epilimnion, lighter and slower increase
  intercept_hypo + slope_hypo * year + rnorm(50, 0, 0.02) # hypolimnion, darker and faster increase
)

# Combine into dataframe
ancova_data <- data.frame(year, depth_zone, mean_absorbance)

# Fit ANCOVA model (with interaction term)
ancova_model <- lm(mean_absorbance ~ year * depth_zone, data = ancova_data)
summary(ancova_model)

# Plot simulated ANCOVA results
library(ggplot2)

ggplot(ancova_data, aes(x = year, y = mean_absorbance, color = depth_zone)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  scale_color_manual(values = c("#2C7BB6", "#D7191C")) +
  labs(
    title = "Simulated Long-Term Browning of Trout Bog Lake (1990–2020)",
    subtitle = "Comparison of Epilimnion and Hypolimnion Mean Absorbance",
    x = "Year",
    y = "Mean Absorbance (1 cm)",
    color = "Depth Zone"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

# ===== Exercise 1b: Ecological scenario ===== #
# This simulated data represents mean water color (absorbance, normalized to a 1 cm pathlength) 
# measured in the epilimnion and hypolimnion of Trout Bog Lake, Wisconsin, between 1990 and 2020. 
# Because the hypolimnion is permanently anoxic and rich in dissolved organic matter,
# it tends to have darker color than the epilimnion.

# Ecological Question: 
# -> Has water color (browning) increased over time in Trout Bog Lake,
# -> and does the rate of increase differ between the epilimnion and hypolimnion?
