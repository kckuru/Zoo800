library(tidyverse)
library(palmerpenguins)

# --- Prepare summary data: mean and standard error of flipper length (mm) by species & sex ---
summary_df <- penguins %>%
  filter(!is.na(flipper_length_mm), !is.na(sex), !is.na(species)) %>%
  group_by(species, sex) %>%
  summarise(
    n = n(),
    mean_flipper = mean(flipper_length_mm, na.rm = TRUE),
    se_flipper = sd(flipper_length_mm, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

# Preview
print(summary_df)

p <- ggplot(summary_df, aes(x = species, y = mean_flipper, fill = sex)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7, colour = NA) +
  geom_errorbar(aes(ymin = mean_flipper - se_flipper, ymax = mean_flipper + se_flipper),
                position = position_dodge(width = 0.75),
                width = 0.2, size = 0.6) +
  # Informative, legible labels
  labs(
    title = "Mean Flipper Length by Species and Sex",
    subtitle = "Means shown ± 1 SE; data from the palmerpenguins package",
    x = "Penguin species",
    y = "Mean flipper length (mm)",
    fill = "Sex"
  ) +
  # Clean publication-style theme: no ggplot gray background
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 12, margin = margin(b = 8)),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11)
  ) +
  # Optional: colorblind-friendly palette (two distinct colors for sex)
  scale_fill_manual(values = c("female" = "#0072B2", "male" = "#D55E00"))

