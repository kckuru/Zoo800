#######################
#### Homework 4 #######
#######################

# Group members: Keeley Kuru, Joseph Munoz and Lonnie Parry
# Date: 9/25/25

# -- Objective 1 -- #

install.packages("palmerpenguins")
library(palmerpenguins)
data("penguins")
penguins

# 1a.
# Convert a continuous variable into a binary variable
convert_to_binary <- function(variable, breakpoint, labels) {
  ifelse(variable <= breakpoint, labels[1], labels[2])
}

# 1b.
# I want to use the median body mass as a breakpoint since we are looking at small and large penguins
median_breakpoint <- median(penguins$body_mass_g, na.rm = TRUE)

# Sort penguins into large and small
penguins$body_mass_binary <- convert_to_binary(
  penguins$body_mass_g,
  breakpoint = median_breakpoint,
  labels = c("Small", "Large")
)

table(penguins$body_mass_binary, useNA = "ifany")


# -- Objective 2 -- #

# 2a. Generalize your function from Objective 1 to be able to accommodate
# any number of break points
convert_to_categories <- function(variable, breakpoints, labels) {
  cut(variable,
      breaks = c(-Inf, breakpoints, Inf),
      labels = labels)
}

# 2b.
# Breakpoints for body mass; divide data into thirds
bodymass_breakpoints <- quantile(penguins$body_mass_g, probs = c(1/3, 2/3), na.rm = TRUE)

# Apply the function
penguins$body_mass_category <- convert_to_categories(
  penguins$body_mass_g,
  breakpoints = bodymass_breakpoints,
  labels = c("Small", "Medium", "Large")
)

# Check results
table(penguins$body_mass_category, useNA = "ifany")


# -- Objective 3 -- #

# 3a. Use the quantile function (or something similar) to determine sensible
# breakpoints for each species
library(palmerpenguins)
unique(penguins$species)

quantile(penguins$body_mass_g[penguins$species == "Adelie"], probs = c(1/3, 2/3), na.rm = TRUE)

# 3b. Modify the functions in Objective 2 to discretize body mass conditional
# on species

# creating an empty result column
penguins$body_mass_category <- NA

# for loop, each species
penguins$body_mass_category <- NA_character_   # make it a character column

for (sp in unique(penguins$species)) {
  # logical vector (TRUE/FALSE) marking rows for the current species
  species_rows <- penguins$species == sp
  # two breakpoints
  bp <- quantile(penguins$body_mass_g[species_rows], probs = c(1/3, 2/3), na.rm = TRUE)
  penguins$body_mass_category[species_rows] <- as.character(
    cut(penguins$body_mass_g[species_rows],
        breaks = c(-Inf, bp, Inf),
        labels = c("Small", "Medium", "Large"),
        include.lowest = TRUE)
  )
}

table(penguins$species, penguins$body_mass_category, useNA = "ifany")


# 3c. Use your function to convert body mass into a categorical variable with
# three levels with different breakpoints for each species

categorize_mass <- function(masses) {
  bp <- quantile(masses, probs = c(1/3, 2/3), na.rm = TRUE)
  
  cut(masses,
      breaks = c(-Inf, bp, Inf),
      labels = c("Small", "Medium", "Large"),
      include.lowest = TRUE)
}

# Make an empty column
penguins$body_mass_category <- NA_character_

# for loop 
for (sp in unique(penguins$species)) {
  rows <- penguins$species == sp
  penguins$body_mass_category[rows] <- as.character(
    categorize_mass(penguins$body_mass_g[rows])
  )
}

table(penguins$species, penguins$body_mass_category, useNA = "ifany")


# -- Objective 4 -- #

library(ggplot2)

plot_by_species_size <- function(data, mass_var, species_var, category_var) {
  ggplot(data, aes_string(x = category_var, y = mass_var, fill = category_var)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.7) + 
    geom_jitter(width = 0.2, alpha = 0.4, size = 1) + # you are able to see individual points
    facet_wrap(as.formula(paste("~", species_var))) +
    labs(
      title = "Penguin Body Mass by Species and Size Category",
      x = "Size Category",
      y = "Body Mass (g)"
    ) +
    theme_minimal(base_size = 14) +
    scale_fill_brewer(palette = "Set2") +
    theme(legend.position = "none")
}


plot_by_species_size(
  data = penguins,
  mass_var = "body_mass_g",
  species_var = "species",
  category_var = "body_mass_category"
)

