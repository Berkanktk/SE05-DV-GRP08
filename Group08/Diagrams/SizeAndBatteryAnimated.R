library(tidyverse)
library(ggplot2)
library(gganimate)

# Loading dataset
data <- read_csv("Data_Only_Year.csv")

# Cleanup
dataFiltered <- data %>% select(c("Brand", "Battery", "Display_Size", "Release_Date"))
dataCleaned <- drop_na(dataFiltered)

# Animation
a <- ggplot(dataCleaned, aes(x=Display_Size, y=Battery)) +
      theme_bw() +
      geom_point(alpha = 0.4, show.legend = FALSE) +
      transition_states(Release_Date) +
      labs(title = "Screen size and battery capacity",
          subtitle = "Year: {closest_state}", 
          x = "Screen Size (inches)", 
          y = "Battery capacity (maH)")

animate(a, duration = 15, fps = 20)

# Save as gif:
anim_save("ScreenAndBattery.gif_color")