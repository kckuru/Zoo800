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

# read coordinate (dimension) variables
depth <- ncvar_get(filename.nc , "depth")  # numeric (m)
time <- ncvar_get(filename.nc , "time")    # seconds
lake <- ncvar_get(filename.nc , "lake")


## Reading multiple files at once
# You can:
# List all files needed in a folder
# Loop over the list
# Combine into one dataset

# Key functions:
list.files # list file names
lapply() # read them
dplyr::bind_rows() # combine

all.files <- list.files("Data/filename", full.names = TRUE) # full.names = TRUE will show the entire file path including folder
all.files

# List files with specific first part
specific.files <- list.files("Data/filename", pattern = specific, full.names = TRUE)
specific.files

# Read them all into a list
specific.files <- lapply(specific.files, read.csv)

# Combine into one data frame
specific.files <- dplyr::bind_rows(specific.files)


# -- Part 2. Wrangling Data -- #

## Some very useful verbs (dplyr):
# filter() -> keep rows
# selectr() -> pick columns
# mutate() -> create new variables
# summarize() + group_by() -> calculate summaries

## The Pipe Operator %>%
# Passes the result of one step into the next
# Makes code read like a recipe

library(dplyr)

fish <- read.csv("Data/filename.csv") # from Luoliang's file

head(fish)

# keep Walleye from Lake Erie and just a few columns
fish_1 <- fish %>%
  filter(Species == "Walleye", Lake == "Erie") %>%
  select(Species, Lake, Year, Length_cm, Weight_g)
head(fish_1) # list all Walleye in Lake Erie excluding the column "Age_years"

# mutate creating new variables
fish_2 <- fish %>%
  mutate(
    Weight_kg = Weight_g / 1000
  ) %>%
  select(Species, Lake, Length_cm, Weight_g, Weight_kg)
head(fish_2)

# mean length by lake
fish_3 <- fish %>%
  group_by(Lake) %>%
  summarise(
    mean_len = mean (Length_cm, na.rm = TRUE),
    n = n()
  )
fish_3

# mean length by Lake x Species
fish_4 <- fish %>%
  group_by(Lake, Species) %>%
  summarise(
    mean_len = mean (Length_cm, na.rm = TRUE),
    n = n()
  )
fish_4


