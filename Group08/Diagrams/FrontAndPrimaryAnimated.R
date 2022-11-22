library(tidyverse)
library(ggplot2)
library(gganimate)
library(transformr)

# Loading dataset
data <- read_csv("Data_Only_Year.csv")

# Cleanup
dataFiltered <- data %>% select(c("Brand", "Front_Camera", "Primary_Camera", "Release_Date"))
dataCleaned <- drop_na(dataFiltered)
# Remove non numerical front camera
dataCleaned <- dataCleaned[!is.na(as.numeric(as.character(dataCleaned$Front_Camera))),]
missingYears <- data.frame(
  Brand = c(NA, NA),
  Front_Camera = c(NA, NA),
  Primary_Camera = c(NA, NA),
  Release_Date = c(2007, 2008)
)

completeData <- rbind(dataCleaned, missingYears)

# Animation
a <- ggplot(completeData, aes(x=as.numeric(Front_Camera), y=Primary_Camera)) +
  theme_bw() +
  geom_point(alpha = 0.4, show.legend = FALSE, position = position_jitter(seed = 0.5)) +
  geom_smooth(method=lm, size=0.5, se=FALSE, color="red") +
  transition_states(Release_Date) +
  labs(title = "Front camera and Primary camera resolution",
       subtitle = "Year: {closest_state}", 
       x = "Front camera resolution (Megapixels)", 
       y = "Primary camera resolution (Megapixels)")

animate(a, duration = 15, fps = 20)

# Save as gif:
anim_save("Camera_evolution.gif")
