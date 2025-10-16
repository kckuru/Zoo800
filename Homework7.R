##########################
####### Homework 7 #######
##########################

# Group members: Keeley Kuru, Nathan Lin, Victoria Salerno
# Date: 10/15/25

# Libraries
library(sf)
library(ggplot2)
library(ggspatial)
library(rnaturalearth)
library(rnaturalearthdata)
library(readr)
library(dplyr)
library(stringr)
library(cowplot)

# Read and clean data
ticks <- read_csv("nathan_spring_2025_tick_collecting.csv", show_col_types = FALSE)

# Split the Coords column into latitude and longitude
ticks_clean <- ticks %>%
  mutate(
    lat = as.numeric(str_extract(Coords, "^[0-9\\.\\-]+")),
    lon = as.numeric(str_extract(Coords, "(?<=, )[-0-9\\.]+"))
  ) %>%
  filter(!is.na(lat) & !is.na(lon))

# Convert to sf object
ticks_sf <- st_as_sf(ticks_clean, coords = c("lon", "lat"), crs = 4326)

# Base map data
world <- ne_countries(scale = "medium", returnclass = "sf")
usa <- ne_states(country = "united states of america", returnclass = "sf")

# Define extent around the sites
bbox_sites <- st_bbox(ticks_sf)
buffer_deg <- 0.05  # small padding
bbox_expanded <- bbox_sites + c(-buffer_deg, -buffer_deg, buffer_deg, buffer_deg)

# Main map
main_map <- ggplot() +
  geom_sf(data = usa, fill = "grey95", color = "grey70", linewidth = 0.3) +
  geom_sf(data = world, fill = NA, color = "grey80", linewidth = 0.3) +
  geom_sf(data = ticks_sf, aes(color = `Specimen(s)`), size = 3, alpha = 0.8) +
  coord_sf(
    xlim = c(bbox_expanded["xmin"], bbox_expanded["xmax"]),
    ylim = c(bbox_expanded["ymin"], bbox_expanded["ymax"]),
    expand = FALSE
  ) +
  scale_color_brewer(palette = "Dark2", name = "Specimen") +
  annotation_scale(location = "bl", width_hint = 0.4, text_cex = 0.8) +
  annotation_north_arrow(
    location = "tl",
    which_north = "true",
    style = north_arrow_fancy_orienteering
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major = element_line(color = "gray85", linewidth = 0.2),
    legend.position = c(0.85, 0.2),
    legend.background = element_rect(fill = "white", color = "gray80"),
    axis.title = element_blank(),
    axis.text = element_text(size = 10)
  )

# Inset map
usa_bbox <- st_bbox(usa)
inset_map <- ggplot() +
  geom_sf(data = usa, fill = "grey95", color = "grey70", linewidth = 0.3) +
  geom_sf(data = world, fill = NA, color = "grey80", linewidth = 0.3) +
  geom_sf(data = ticks_sf, color = "red", size = 1.2) +
  coord_sf(
    xlim = c(-125, -114),
    ylim = c(32, 42),
    expand = FALSE
  ) +
  theme_void()

# Combine inset and main map
final_map <- ggdraw() +
  draw_plot(main_map) +
  draw_plot(inset_map, x = 0.65, y = 0.65, width = 0.3, height = 0.3)

final_map


ggsave("tick_sites_map.png", final_map, width = 8, height = 6, dpi = 300)

