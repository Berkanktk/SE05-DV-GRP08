library(tidyverse)
library(ggplot2)
library(gganimate)
dat <- read_csv("Data_Only_Year.csv")

#Brand
datBrand <- dat %>% select(c("Brand", "Release_Date"))
datBrand <- drop_na(datBrand)

brandCount <- datBrand %>%
  count(Brand)

#barplot(brandCount$n)

#Large Brands
brandCount <- brandCount %>%
  filter(n >= 35)

#ggplot(data=brandCount, aes(x=Brand, y=n, fill=Brand)) +
#  geom_bar(stat="identity", width=0.5)

brandCountByYear <- datBrand %>%
  count(Brand, Release_Date)

sortedData <- data.frame(Brand=character(), Release_Date=integer(), n=integer())

i = 1
for(i in 1:nrow(brandCountByYear) ) {
  j = 1
  for(j in 1:nrow(brandCount)){
    if(brandCountByYear$Brand[i] == brandCount$Brand[j]){
      sortedData[nrow(sortedData) + 1,] <- brandCountByYear[i,]
    }
  }
}

#Static
sortedDataInYear <- sortedData %>% filter(Release_Date <= 2004)

ggplot(sortedDataInYear, aes(x=Brand, y=n)) + 
  geom_bar(aes(fill = (Brand == "Samsung"), group = Brand),stat='identity') +
  theme_bw() +
  labs(title="Phones released each year by brand",
       x = "Brands",
       y = "Amount") +
  coord_flip() +
  theme(legend.position = "none")
  

#Animate
ggplot(sortedData, aes(x=Brand, y=n, fill=Brand)) + 
  geom_bar(stat='identity') +
  theme_bw() +
  labs(title="Phones produced each year by brand",
       x = "Brands",
       y = "Models Produced") +
  coord_flip() + 
  # gganimate specific bits:
  transition_states(
    Release_Date,
    transition_length = 2,
    state_length = 3
  ) +
  labs(subtitle="Year:  {closest_state}")+
  ease_aes('sine-in-out')

# Save at gif:
anim_save("288-animated-barplot-transition.gif_color")
