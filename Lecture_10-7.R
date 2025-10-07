#####################
## Lecture 10/7/25 ##
#####################

## --- Notes from Homework 5 last week --- ##
# filtering using ,,, --> and
# filtering using == | == --> or

## -- Notes for today!! -- ##
# ggplot2 and the "grammar of graphics"

# Geom is synonymous with the type of plot you are asking ggplot2 to make

# Aesthetics go inside first set of parentheses
ggplot(data = patients_clean, aes(y = Weight, x = Height, color = Sex,
                                  size = BMI, shape = Pet)) + geom_point()

library(palmerpenguins)
summary(penguins)

plot1 <- ggplot(data=penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

plot1

# examine the ggplot object --> ways of checking that ggplot2 understands what you are asking
plot1$data[1:4, ]

plot1$mapping

plot1$geom

plot1$layers

# add a variable to distinguish the different species by color (color = species)
plot2 <- ggplot(data=penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point()

plot2

# use facet wrapping instead --> multi-panel figure or grids
# for each of the levels in the factor "species", create one plot
# keep going until you reach 3 columns (ncol = 3), then make a new row
plot3 <- plot2 + facet_wrap(~species, ncol = 3)

plot3

# add trend lines
# fitting statistical models in the background and adding trendlines
# make sure you do the underlying stats as well
# lm is linear model; it gives confidence band by default
plot4 <- plot3 + geom_smooth(method = "lm")

plot4

# explore other geometries --> boxplot
plot5 <- ggplot(data=penguins, mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot()

plot5

# stack geometries
# geom_jitter adds the points and jitters them off the lines
plot6 <- ggplot(data=penguins, mapping = aes(x = species, y = body_mass_g)) +
  geom_violin() + geom_jitter()

plot6

#explore other themes
plot7 <- plot5 + theme_bw()

plot7

# Change the plotting order of species: Gentoo, Adelie, Chinstrap
# You have to hop out of ggplot2 to change the order of species
# Must make sure the variable is a factor, first
# Specify what those letters are and organize in the way you want them plotted
penguins$species <- factor(penguins$species, levels = c("Gentoo", "Adelie", "Chinstrap"))

plot8 <- ggplot(data=penguins, mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot() + theme_bw()

plot8

#Change the color palette
plot9 <- plot2 + scale_color_brewer(palette = "Set2")

plot9

