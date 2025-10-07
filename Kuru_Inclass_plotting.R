library(tidyverse)
library(palmerpenguins)

# Remove NA values
penguins_clean <- penguins %>%
  filter(!is.na(flipper_length_mm), !is.na(sex), !is.na(species))

# Violin + jitter plot
ggplot(penguins_clean, aes(x = species, y = flipper_length_mm, fill = sex)) +
  # violin plot
  geom_violin(position = position_dodge(width = 0.8), trim = FALSE, alpha = 0.7) +
  # jitter plot
  geom_jitter(
    position = position_jitterdodge(jitter.width = 0.15, dodge.width = 0.8),
    size = 1.5, alpha = 0.5, shape = 21
  ) +
  # labels (title, x, y, fill)
  labs(
    title = "Average Penguin Flipper Length by Species and Sex",
    x = "Penguin species",
    y = "Flipper length (mm)",
    fill = "Sex"
  ) +
  scale_fill_manual(values = c("female" = "darkmagenta", "male" = "deepskyblue")) +
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12)
  )

# Save as PNG
ggsave("penguin_violin_jitter.png", width = 8, height = 6, dpi = 300)
