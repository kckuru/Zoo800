######################
## Lecture 10/21/25 ##
######################

install.packages("DBI")
install.packages("RMariaDB")
install.packages("RPostgres")
install.packages("repurrrsive")
install.packages("jsonlite")

library(DBI)
library(dbplyr)
library(tidyverse)
library(RMariaDB)
library(tidyverse)
library(repurrrsive)
library(jsonlite)

# --- Work from Wickham --- #

x1 <- list(1:4, "a", TRUE)
x1

x2 <- list(a = 1:2, b = 1:3, c = 1:4)
x2

str(x1)
str(x2)

x3 <- list(list(1, 2), list(3, 4))
str(x3)

c(c(1, 2), c(3, 4))

x4 <- c(list(1, 2), list(3, 4))
str(x4)

x5 <- list(1, list(2, list(3, list(4, list(5)))))
str(x5)

## --- EDI data work --- ##

################################################################################
## North Temperate Lakes LTER: Major Ions in Trout Bog (1981–Present)
## Dataset: knb-lter-ntl.2.41
## Source: https://pasta.edirepository.org
################################################################################

# Libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(patchwork)

# Download data directly from EDI
options(HTTPUserAgent = "EDI_CodeGen")

inUrl1 <- "https://pasta.lternet.edu/package/data/eml/knb-lter-ntl/2/41/0701a84081989bb1ff37d621a6c4560a"
infile1 <- tempfile()

try(download.file(inUrl1, infile1, method = "curl",
                  extra = paste0(' -A "', getOption("HTTPUserAgent"), '"')))
if (is.na(file.size(infile1))) download.file(inUrl1, infile1, method = "auto")

# Read in data
dt1 <- read.csv(infile1, header = FALSE, skip = 1, sep = ",", quote = '"',
                col.names = c("lakeid","year4","daynum","sampledate","depth","rep","sta","event",
                              "cl","so4","ca","mg","na","k","fe","mn","cond",
                              "flagcl","flagso4","flagca","flagmg","flagna","flagk",
                              "flagfe","flagmn","flagcond"), check.names = TRUE)

unlink(infile1)

# Convert date
dt1$sampledate <- as.Date(dt1$sampledate, format = "%Y-%m-%d")
if (any(is.na(dt1$sampledate))) {
  dt1$sampledate <- as.Date(dt1$sampledate, format = "%m/%d/%Y")
}

# Type conversions
num_cols <- c("year4","daynum","depth","cl","so4","ca","mg","na","k","fe","mn","cond")
dt1[num_cols] <- lapply(dt1[num_cols], function(x) as.numeric(as.character(x)))
dt1$lakeid <- as.factor(dt1$lakeid)

################################################################################
## Filter for Trout Bog (TB)
################################################################################
tb <- dt1 %>%
  filter(lakeid == "TB") %>%
  mutate(year = year(sampledate))

################################################################################
## Summarize annual means for major ions
################################################################################
tb_summary <- tb %>%
  group_by(year) %>%
  summarise(
    Cl = mean(cl, na.rm = TRUE),
    SO4 = mean(so4, na.rm = TRUE),
    Ca = mean(ca, na.rm = TRUE),
    Mg = mean(mg, na.rm = TRUE),
    Na = mean(na, na.rm = TRUE),
    K = mean(k, na.rm = TRUE),
    Conductivity = mean(cond, na.rm = TRUE)
  ) %>%
  pivot_longer(-year, names_to = "Ion", values_to = "Concentration")

################################################################################
## Plot: Long-Term Trends in Trout Bog Major Ions
################################################################################
ggplot(tb_summary, aes(x = year, y = Concentration, color = Ion)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Long-Term Trends in Major Ions — Trout Bog, WI",
    x = "Year",
    y = "Concentration (mg/L)",
    color = "Ion"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", hjust = 0.5)
  )


## --- Demo work from Lecture --- ##
install.packages("EDIutils")
library(EDIutils)
library(readr)
library(ggplot2)

scope <- "knb-lter-ntl"
identifier <- "2"
revision <- "41"

package_id <- paste(scope, identifier, revision, sep = ".")
package_id







