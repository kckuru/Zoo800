#####################
## Lecture 9/30/25 ##
#####################


# -- Part 1. Importing Data -- #

# R can read almost any format you will encounter:
# Text files (CSV), Excel spreadsheets, R-native formats (.RDS), spatial data (Shapefiles)
# No matter where your data lives, there is likely an R package that can bring it in!


setwd("D:/yourpath/")

# How to make R read an Excel file
library(readxl)
filename <- read_excel("Data/filename")
filename

# How to make R read a specific sheet in an Excel file
library(readxl)
filename.xlsx <- read_excel("Data/filename.xlsx", sheet = 2)
filename.xlsx

# NOTE: you must close the Excel file first before you can read it into R
# This is not the same for CSV files

# Read a CSV file
filename.csv <- read.csv(filename.csv)
filename.csv

# read R-specific format (.rds)
filename.rds <- readRDS ("Data/filename.rds")
filename.rds

# read Shapefile
install.packages("sf") # install package to read Shapefiles
library(sf)
filename.shapefile <- st_read("Data/filename.shp")
class(filename.shapefile)
View(filename.shapefile)
plot(filename.shapefile) # plot a shape, ex: Lake Erie shape

# read nc
install.packages("ncdf4") # install package to read nc data
library(ncdf4)
filename.nc <- nc_open("Data/filename.nc")
print(filename.nc)









