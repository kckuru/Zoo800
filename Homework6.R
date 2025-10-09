##########################
####### Homework 6 #######
##########################

# Group members: Keeley Kuru and Elizabeth Braatz
# Date: 10/9/25

# -- Objective 1 -- #

library(ggplot2)

# A. 
# Parameters
N0 <- 50
r <- 0.2
K <- 1000
years <- 10

# Create vector
N <- numeric(years + 1)
N[1] <- N0

# Loop over years
for (t in 1:years) {
  N[t + 1] <- N[t] + r * N[t] * (1 - N[t] / K)
}

# Create a dataframe for ggplot2
df <- data.frame(
  Year = 0:years,
  Population = N
)

# B. 
# Plot the time series using ggplot2
ggplot(df, aes(x = Year, y = Population)) +
  geom_line(color = "black", size = 1) +
  geom_point(size = 2) +
  labs(title = "Logistic Growth of Hellbender Population",
       x = "Years",
       y = "Population Size") +
  theme_minimal()

# -- Objective 2 -- #

# A. Simulate 50 different population size time series using the model above
# Parameters
N0 <- 50
K <- 1000
years <- 10
mean_r <- 0.2
sd_r <- 0.03
n_sims <- 50

# Generate random r values
r_values <- rnorm(n_sims, mean = mean_r, sd = sd_r)

# Run the logistical model
sim_results <- data.frame()

for (i in 1:n_sims) {
  N <- numeric(years + 1)
  N[1] <- N0
  r <- r_values[i]
  
  for (t in 1:years) {
    N[t + 1] <- N[t] + r * N[t] * (1 - N[t] / K)
  }
  
  temp_df <- data.frame(
    Year = 0:years,
    Population = N,
    Simulation = paste0("Sim_", i)
  )
  
  sim_results <- rbind(sim_results, temp_df)
}

# Expected (mean) trajectory using mean r
N_mean <- numeric(years + 1)
N_mean[1] <- N0
for (t in 1:years) {
  N_mean[t + 1] <- N_mean[t] + r * N_mean[t] * (1 - N_mean[t] / K)
}
mean_df <- data.frame(Year = 0:years, Population = N_mean)

# B.
# create a new figure (using ggplot2) that shows both the expected population time series
# as well as a range of plausible alternatives
library(ggplot2)

ggplot() +
  geom_line(data = sim_results, aes(x = Year, y = Population, group = Simulation),
            color = "lightskyblue", alpha = 0.4, size = 0.7) +
  geom_line(data = mean_df, aes(x = Year, y = Population),
            color = "blue", size = 1.2) +
  labs(title = "Hellbender Population Growth with Uncertainty in r",
       subtitle = "50 simulated trajectories (light blue) and mean trajectory (dark blue)",
       x = "Years",
       y = "Population Size") +
  theme_minimal()
  

# -- Objective 3 -- #

library(ggplot2)

# Parameters
N0 <- 50
K <- 1000
target <- 0.8 * K
years <- 25
mean_r <- 0.2
sd_r <- 0.03
n_sims <- 50

# Generate r values and simulate 25-year trajectories
r_values <- rnorm(n_sims, mean = mean_r, sd = sd_r)
sim_results <- data.frame()
final_pop <- numeric(n_sims)

for (i in 1:n_sims) {
  N <- numeric(years + 1)
  N[1] <- N0
  r <- r_values[i]
  
  for (t in 1:years) {
    N[t + 1] <- N[t] + r * N[t] * (1 - N[t] / K)
  }
  
  final_pop[i] <- N[years + 1]
  temp_df <- data.frame(Year = 0:years,
                        Population = N,
                        Simulation = paste0("Sim_", i))
  sim_results <- rbind(sim_results, temp_df)
}

# Mean trajectory (for reference)
N_mean <- numeric(years + 1)
N_mean[1] <- N0
for (t in 1:years) {
  N_mean[t + 1] <- N_mean[t] + mean_r * N_mean[t] * (1 - N_mean[t] / K)
}
mean_df <- data.frame(Year = 0:years, Population = N_mean)

# Plot all trajectories + target line
p1 <- ggplot() +
  geom_line(data = sim_results, aes(x = Year, y = Population, group = Simulation),
            color = "lightskyblue", alpha = 0.4, size = 0.7) +
  geom_line(data = mean_df, aes(x = Year, y = Population),
            color = "blue", size = 1.2) +
  geom_hline(yintercept = target, linetype = "dashed", color = "red", size = 1) +
  labs(title = "Hellbender Population Growth (25 years)",
       subtitle = "50 simulated trajectories; red dashed = target (800 individuals)",
       x = "Year", y = "Population Size") +
  theme_minimal()

p1

# Histogram of final populations
frac_meeting_target <- mean(final_pop >= target)

p2 <- ggplot(data.frame(FinalPop = final_pop), aes(x = FinalPop)) +
  geom_histogram(binwidth = 50, fill = "skyblue", color = "white") +
  geom_vline(xintercept = target, linetype = "dashed", color = "red", size = 1) +
  annotate("text", x = target + 50, 
           y = max(hist(final_pop, plot = FALSE)$counts), 
           label = paste0("Fraction ≥ target = ", round(frac_meeting_target, 2)),
           hjust = 0, vjust = 1.2, color = "black", size = 4.5) +
  labs(title = "Distribution of Final Population Sizes after 25 Years",
       x = "Population Size in Year 25",
       y = "Count of Simulations") +
  theme_minimal()

p2
