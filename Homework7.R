##########################
####### Homework 7 #######
##########################
# Group members: Keeley Kuru, Nathan Lin, Victoria Salerno
# Date: 10/16/25

# Load required libraries
library(sf)
library(ggplot2)
library(ggspatial)
library(rnaturalearth)
library(rnaturalearthdata)
library(readr)
library(dplyr)
library(stringr)
library(cowplot)

# ==============================================================================
# DATA IMPORT AND CLEANING
# ==============================================================================
ticks <- read_csv("nathan_spring_2025_tick_collecting.csv", show_col_types = FALSE)

# Parse coordinate strings into separate latitude and longitude columns
ticks_clean <- ticks %>%
  mutate(
    # Extract latitude (numbers before the comma)
    lat = as.numeric(str_extract(Coords, "^[0-9\\.\\-]+")),
    # Extract longitude (numbers after the comma and space)
    lon = as.numeric(str_extract(Coords, "(?<=, )[-0-9\\.]+"))
  ) %>%
  # Remove any rows with missing coordinates
  filter(!is.na(lat) & !is.na(lon))

# ==============================================================================
# SPATIAL DATA PREPARATION
# ==============================================================================

# Convert cleaned data to spatial features object
ticks_sf <- st_as_sf(ticks_clean, coords = c("lon", "lat"), crs = 4326)

# Add jittered coordinates to separate overlapping collection points
# Multiple collections at same location need slight offset for visualization
set.seed(123)
ticks_jittered <- ticks_clean %>%
  mutate(
    # Add random offset of ~1.5km in each direction
    # 0.015 degrees ≈ 1.5 km at this latitude
    lon_jitter = lon + rnorm(n(), 0, 0.015),
    lat_jitter = lat + rnorm(n(), 0, 0.015)
  )

# Convert jittered coordinates to spatial object for plotting
ticks_sf_jitter <- st_as_sf(ticks_jittered, coords = c("lon_jitter", "lat_jitter"), crs = 4326)

# Load base map data for United States
# scale = "medium" provides appropriate detail level for state boundaries
usa <- ne_states(country = "united states of america", returnclass = "sf")

# ==============================================================================
# DEFINE COLOR SCHEME
# ==============================================================================

color_scheme <- c("Ixodes" = "#d95f02",
                  "Dermacentor" = "#1b9e77",
                  "Ixodes + Dermacentor" = "#7570b3",             
                  "Ixodes keiransi (keyed out and confirmed)" = "#e7298a")

# Create simplified labels for legend (shorter text for better readability)
label_scheme <- c("Ixodes" = "Ixodes",
                  "Dermacentor" = "Dermacentor",
                  "Ixodes + Dermacentor" = "Ixodes + Dermacentor",
                  "Ixodes keiransi (keyed out and confirmed)" = "I. keiransi")

# ==============================================================================
# CALIFORNIA INSET MAP (Detailed view of Bay Area collection sites)
# ==============================================================================

# Define bounding box for California detail map
# Coordinates focus on San Francisco Bay Area where most collections occurred
ca_bbox <- c(xmin = -122.65, xmax = -122.1, ymin = 37.78, ymax = 37.88)

# Create polygon from bounding box to show on main map
inset_bbox_poly <- st_as_sfc(st_bbox(ca_bbox, crs = 4326))

# Build California inset map with zoomed detail
inset_map <- ggplot() +
  # Add US state boundaries as base layer
  geom_sf(data = usa, fill = "grey98", color = "grey70", linewidth = 0.4) +
  # Plot collection points with jitter to separate overlapping locations
  geom_sf(data = ticks_sf_jitter, aes(color = `Specimen(s)`), 
          size = 4.5, alpha = 0.85, stroke = 1) +
  # Set map extent to California bounding box
  coord_sf(xlim = c(ca_bbox["xmin"], ca_bbox["xmax"]), 
           ylim = c(ca_bbox["ymin"], ca_bbox["ymax"]), 
           expand = FALSE) +
  # Apply color scheme (no legend needed - shown on main map)
  scale_color_manual(values = color_scheme, guide = "none") +
  # Add subtitle to identify region
  labs(subtitle = "San Francisco Bay Area") +
  # Minimal theme with custom styling for inset appearance
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.major = element_line(color = "gray92", linewidth = 0.25),
    panel.background = element_rect(fill = "aliceblue"),          # Light blue for water
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1.2),
    axis.text = element_text(size = 9, color = "gray20"),
    axis.title = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    plot.subtitle = element_text(hjust = 0.5, face = "bold", size = 10)
  )

# ==============================================================================
# MAIN MAP (Continental US showing all collection sites)
# ==============================================================================

main_map <- ggplot() +
  # Base layer: US state boundaries
  geom_sf(data = usa, fill = "grey98", color = "grey70", linewidth = 0.4) +
  # Add red box showing location of California inset
  geom_sf(data = inset_bbox_poly, fill = NA, color = "red", 
          linewidth = 1.2, linetype = "solid") +
  # Plot all collection points with specimen type colors
  geom_sf(data = ticks_sf_jitter, aes(color = `Specimen(s)`), 
          size = 5, alpha = 0.85, stroke = 1) +
  # Set map extent to continental US
  # xlim: -125°W (Pacific coast) to -66°W (Atlantic coast)
  # ylim: 24.5°N (Florida Keys) to 49.5°N (Canadian border)
  coord_sf(xlim = c(-125, -66), ylim = c(24.5, 49.5), expand = FALSE) +
  # Apply color scheme with legend
  scale_color_manual(
    name = "Specimen",
    values = color_scheme,
    labels = label_scheme
  ) +
  # Add scale bar in bottom left
  # width_hint = 0.3 means scale bar is 30% of plot width
  annotation_scale(
    location = "bl", 
    width_hint = 0.3,
    text_cex = 1.1,                 
    bar_cols = c("black", "white"),         
    line_width = 1,
    pad_x = unit(0.6, "cm"),                 
    pad_y = unit(0.6, "cm")
  ) +
  # Add north arrow in top left
  annotation_north_arrow(
    location = "tl",
    which_north = "true",                     
    style = north_arrow_fancy_orienteering,
    pad_x = unit(0.6, "cm"),
    pad_y = unit(0.6, "cm"),
    height = unit(1.5, "cm"),
    width = unit(1.5, "cm")
  ) +
  # Apply minimal theme with custom modifications
  theme_minimal(base_size = 15) +
  theme(
    # Light grid for reference without overwhelming map
    panel.grid.major = element_line(color = "gray92", linewidth = 0.3),
    panel.background = element_rect(fill = "aliceblue"),  # Ocean color
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
    # Position legend in lower right, inside plot area
    legend.position = c(0.87, 0.3),
    legend.background = element_rect(fill = "white", color = "gray40", linewidth = 0.8),
    legend.title = element_text(size = 13, face = "bold"),
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.9, "cm"),        # Size of color boxes
    legend.margin = margin(8, 8, 8, 8),       # Internal legend padding
    # Remove axis titles (coordinates are self-explanatory)
    axis.title = element_blank(),
    axis.text = element_text(size = 12, color = "gray30"),
    plot.margin = margin(5, 5, 5, 5)
  )

# ==============================================================================
# COMBINE MAPS AND DISPLAY
# ==============================================================================

# Combine main map and inset using cowplot
# ggdraw() creates blank canvas, draw_plot() adds layers
final_map <- ggdraw() +
  # Draw main map as base layer (fills entire canvas)
  draw_plot(main_map) +
  # Overlay California inset in upper left corner
  # x, y = position (0,0 is bottom-left, 1,1 is top-right)
  # width, height = size as fraction of total plot
  draw_plot(inset_map, x = 0.02, y = 0.68, width = 0.32, height = 0.30)

# Display combined map
final_map
