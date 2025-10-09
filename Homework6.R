##########################
####### Homework 5 #######
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




