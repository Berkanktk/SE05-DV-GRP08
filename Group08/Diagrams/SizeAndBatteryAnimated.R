library(tidyverse)
library(ggplot2)
library(gganimate)
library(transformr)


# Loading dataset
data <- read_csv("Data_Only_Year.csv")

# Cleanup
dataFiltered <- data %>% select(c("Brand", "Battery", "Display_Size", "Release_Date"))
dataCleaned <- drop_na(dataFiltered)

# Animation
a <- ggplot(dataCleaned, aes(x=Display_Size, y=Battery)) +
      theme_bw() +
      scale_fill_brewer(palette = "Paired") +
      geom_point(alpha = 0.4, show.legend = FALSE, position = position_jitter(width = 0.5, height = 0.5)) +
      transition_states(Release_Date) +
      geom_smooth(method='lm', size=.5, se = FALSE) +
      labs(title = "Screen size and battery capacity",
          subtitle = "Year: {closest_state}", 
          x = "Screen Size (inches)", 
          y = "Battery capacity (maH)")

animate(a, duration = 15, fps = 20, width = 600, height = 600)

# Save as gif:
anim_save("ScreenAndBattery.gif")
