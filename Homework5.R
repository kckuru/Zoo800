##########################
####### Homework 5 #######
##########################

# Group members: Keeley Kuru, Joseph Munoz and Lonnie Parry
# Date: 10/2/25

# -- Objective 1 -- #

library(readxl)
library(here)

fish.xlsx <- read_excel(here("fish.xlsx"))
fish.csv  <- read.csv(here("fish.csv"))
fish.rds  <- readRDS(here("fish.rds"))


# Print first 5 rows of each dataset
cat("First 5 rows of fish.xlsx:\n")
print(head(fish.xlsx, 5))

cat("\nFirst 5 rows of fish.csv:\n")
print(head(fish.csv, 5))

cat("\nFirst 5 rows of fish.rds:\n")
print(head(fish.rds, 5))


# -- Objective 2 -- #

# Create output folder
if (!dir.exists("output")) {
  dir.create("output")
}

fish_dataset <- fish.csv

# 1. Save in three formats

# Save as CSV
write.csv(fish_dataset, "output/fish_saved.csv", row.names = FALSE)

# Save as Excel
library(writexl)  # install.packages("writexl") if needed
write_xlsx(fish_dataset, "output/fish_saved.xlsx")

# Save as RDS
saveRDS(fish_dataset, "output/fish_saved.rds")

# 2. Compare file sizes
file_sizes <- file.info(list.files("output", full.names = TRUE))
print(file_sizes[, c("size", "ctime")])

# 3. Note: best format for sharing and storage
cat("\nNote:\n")
cat("CSV format is best for sharing because it is widely readable,\n")
cat("Excel (.xlsx) is good for compatibility with spreadsheets,\n")
cat("and RDS is best for compact storage and preserving R object structure.\n")


# -- Objective 3 -- #

library(dplyr)
library(writexl)

if (!dir.exists("output")) dir.create("output")

fish_output <- fish.csv %>%
  # Filter and select
  filter(Species %in% c("Walleye", "Yellow Perch", "Smallmouth Bass"),
         Lake %in% c("Erie", "Michigan")) %>%
  select(Species, Lake, Year, Length_cm, Weight_g) %>%
  # Creating variables
  mutate(Length_mm = Length_cm * 10,
         Length_group = cut(Length_mm,
                            breaks = c(-Inf, 200, 400, 600, Inf),
                            labels = c("≤200", "200–400", "400–600", ">600"))) %>%
  group_by(Species, Year) %>%
  # Summarise
  summarise(mean_weight = mean(Weight_g, na.rm = TRUE),
            median_weight = median(Weight_g, na.rm = TRUE),
            sample_size = n(),
            .groups = "drop")

# Save result as Excel file
write_xlsx(fish_output, "output/fish_output.xlsx")


# -- Objective 4 -- #

library(dplyr)
library(readr)
library(purrr)
library(here)

# Path to Multiple_files inside your project
data_path <- here("Multiple_files")

# List all CSV files
files <- list.files(data_path, pattern = "\\.csv$", full.names = TRUE)
if (length(files) == 0) stop("No CSV files found in ", data_path)

# Read and combine all CSV files into one data frame
fish_all <- map_dfr(files, ~ read_csv(.x) %>% mutate(filename = basename(.x)))

# Extract year from filename
fish_all <- fish_all %>%
  mutate(year = as.integer(gsub(".*_(\\d{4})\\.csv$", "\\1", filename)))

# Save combined data
write_csv(fish_all, here("output", "fish_all_combined.csv"))

# View first rows
head(fish_all)
