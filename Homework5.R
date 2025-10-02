##########################
####### Homework 5 #######
##########################

# Group members: Keeley Kuru, Joseph Munoz and Lonnie Parry
# Date: 10/2/25

# -- Objective 1 -- #
setwd("/Users/keeleykuru/Documents/Kuru_Classwork/Zoo800/Kuru_Homework5")

# Make R read an Excel file
library(readxl)
fish.xlsx <- read_excel("/Users/keeleykuru/Documents/Kuru_Classwork/Zoo800/Kuru_Homework5/fish.xlsx")
fish.xlsx

# Read a CSV file
fish.csv <- read.csv("/Users/keeleykuru/Documents/Kuru_Classwork/Zoo800/Kuru_Homework5/fish.csv")
fish.csv

# Read R-specific format (.rds)
fish.rds <- readRDS ("/Users/keeleykuru/Documents/Kuru_Classwork/Zoo800/Kuru_Homework5/fish.rds")
fish.rds

# Print first 5 rows of each dataset
cat("First 5 rows of fish.xlsx:\n")
print(head(fish.xlsx, 5))

cat("\nFirst 5 rows of fish.csv:\n")
print(head(fish.csv, 5))

cat("\nFirst 5 rows of fish.rds:\n")
print(head(fish.rds, 5))


# -- Objective 2 -- #






