#########################
#### WEEK 3 Homework ####
#########################

# Group members : Keeley Kuru, Lonnie Parry and Joseph Munoz
# Date: 9/18/25
# Class: Zoo800

## --------------------------------------- ##

## Part 1: Basic Syntax and Variables ##
#1.1
temp_C <- 18.5
#1.2
temp_F <- temp_C * (9/5) + 32
#1.3
print(paste("The water temperature is", temp_C,"°C,", temp_F, "°F"))

## Part 2: Vectors and Arrays
#2.1 Find the total number of fish counted
total_fish <- sum(species_counts)
cat("Total number of fish counted:", total_fish, "\n")

#2.2 Find the species with the highest count
most_common_species <- names(species_counts[which.max(species_counts)])
cat("Species with the highest count:", most_common_species, "\n")

#2.3 Create a 3×3 array (matrix) ...
chlorophyll_concentrations <- matrix(c(15, 10, 8,
                                       22, 18, 14,
                                       30, 25, 20),
                                     nrow = 3,
                                     ncol = 3,
                                     byrow = TRUE)

colnames(chlorophyll_concentrations) <- c("Day 1", "Day 2", "Day 3")
rownames(chlorophyll_concentrations) <- c("Surface", "Middle", "Bottom")

cat("Chlorophyll Concentrations at 3 Depths Over 3 Days\n")
print(chlorophyll_concentrations)

#2.4 
chloro_conc_average <- rowMeans(chlorophyll_concentrations)
print(chloro_conc_average)

## Part 3: Data Frames
#3.1 
lakes <- data.frame(
  Lake = c("Mendota", "Wingra","Monona","Waubesa","Kegonsa"), # lake names
  Temp_C = c(22.4, 25.1, 23.7, 24.6, 26.0),
  DO_mgL = c(8.3, 6.7, 7.5, 7.9, 6.2)
)
lakes

#3.2 Calculate the mean temperature and mean dissolved oxygen across all lakes.
mean_temp <- mean(lakes$Temp_C)
mean_DO   <- mean(lakes$DO_mgL)
mean_temp
mean_DO

#3.3 Add a new column called Temp_F with values converted to Fahrenheit.
lakes$Temp_F <- lakes$Temp_C * 9/5 + 32
lakes

#3.4
install.packages("LakeMetabolizer")
library(LakeMetabolizer)
tempC_units <- set.units(lakes$Temp_C, "degC")
lakes$DO_eq <- o2.at.sat(tempC_units, altitude = 0)
lakes$DO_percent <- (lakes$DO_mgL / lakes$DO_eq) * 100
#I don't think I can figure out how to do this, apparently this package has a lot of problems 
#I was getting errors left and right. 


## Part 4: For loops ##

#4.1
for (i in 1:10) {
  print(i^2)
}


#4.2
N0 <- 10
r <- 0.3
time_steps <- 10

pop <- numeric(time_steps)
for (t in 0:(time_steps - 1)) {
  pop[t + 1] <- N0 * exp(r * t)
}
pop

#4.3
phosphorus <- list(
  Lake1 = c(12.5, 15.3, 14.7, 13.2),
  Lake2 = c(25.4, 27.1, 30.2, 29.8),
  Lake3 = c(7.5, 9.2, 6.8, 8.1),
  Lake4 = c(18.0, 20.5, 19.3, 17.8),
  Lake5 = c(35.2, 32.9, 38.1, 36.5)
)
phosphorus

#4.4 
lake_means <- numeric(length(phosphorus))

for (i in 1:length(phosphorus)) {
  mean_value <- mean(phosphorus[[i]])
  lake_means[i] <- mean_value
  cat(paste0("Lake", i, " mean phosphorus = ", mean_value, " µg/L\n"))
}

#4.5 
print(lake_means)


## Part 5: Apply Functions ##

#5.1. Revisit your chlorophyll array from Part 2. Use apply() to calculate:

    #depth mean concentration
depth_means <- apply(chlorophyll_concentrations, 1, mean)
print(depth_means)

    #day mean concentration
day_means <- apply(chlorophyll_concentrations, 2, mean)
print(day_means)

#5.2

#I am going to make a new dataset with just the numeric data to make it easier on myself
numeric_lakes <- lakes[sapply(lakes, is.numeric)]
column_ranges <- apply(numeric_lakes, 2, function(x) max(x) - min(x))
print(column_ranges)

#5.3
pop_sapply <- sapply(time_steps, function(t) N0 * exp(r * t))
print(pop_sapply)

#I would say that the sapply function is better because you get the same results as for loops with less code.




