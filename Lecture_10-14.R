######################
## Lecture 10/14/25 ##
######################

### Data Exploration and Visualization II ###

## -- Notes from HMWK -- ##

# Transparency is good when you have a lot of data --> alpha = 0.4 
# Reference lines --> geom_hline or geom_vline
# Wide to long format --> ggplot looks for long format
# --> pivot_longer function can help here
# Generating random numbers from a distribution --> use rnorm to make random values
# Vectorized operations --> no need for nested for-loop

## -- Lecture notes -- ##

# Infer process from pattern
# Spatial dependence --> exogenous (ex: animals grouped around a resource) versus endogenous (ex: animals clumped together in a herd) processes

# Three classes of spatial data:
# --> Points
# --> Gridded or raster
# --> Lattice or polygon

# Points
# --> Spatial point pattern or spatial event data

# Raster
# --> Gridded representation of a spatially continuous process
# --> Data interpolation!

# Lattice
# --> Regular (grid) or irregular lattices
# --> Every location inside some polygon which are all different shapes/sizes (ex: census data)

# -- Exercise 1 -- #
# Install/load necessary libraries
packages <- c("sf", "sp", "classInt", "RColorBrewer", "ggplot2", "dplyr")
new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(sf)
library(sp)
library(classInt)
library(RColorBrewer)
library(ggplot2)
library(dplyr)

# Read shapefile (relative path)
philly <- st_read("Philly3/Philly3.shp")

names(philly)
plot(philly)

# Convert to sp object for spplot()
philly_sp <- as(philly, "Spatial")

pal <- brewer.pal(5, "OrRd")

# Quantile breaks
br_HOMIC <- classIntervals(philly_sp$HOMIC_R, n = 5, style = "quantile")$brks
# Add small offsets for symmetry
offs <- 1e-07
br_HOMIC[1] <- br_HOMIC[1] - offs
br_HOMIC[length(br_HOMIC)] <- br_HOMIC[length(br_HOMIC)] + offs

# Plot map
spplot(philly_sp, "HOMIC_R",
       col.regions = pal,
       at = br_HOMIC,
       main = "Philadelphia Homicide Rate per 100,000")

