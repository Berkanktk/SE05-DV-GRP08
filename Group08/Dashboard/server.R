library(tidyverse)
library(dplyr)
library(shiny)
library(ggplot2)
library(gganimate)

####
# Battery and Display Size
####
# Importing csv file
dat <- read.csv("../Smartphone_updated_dates.csv")   

# Filtering data
dat <- dat %>% select(c("Battery", "Display_Size"))

# Dropping NA values
dat <- drop_na(dat)
# Creating variables
datBattery <- dat$Battery
datSize <- dat$Display_Size

####
# Brand releases per year
####
dat <- read_csv("../Data_Only_Year.csv")

#Brand
datBrand <- dat %>% select(c("Brand", "Release_Date"))
datBrand <- drop_na(datBrand)

brandCount <- datBrand %>%
  count(Brand)

#Large Brands
brandCount <- brandCount %>%
  filter(n >= 35)

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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$brandRelease <- renderPlot({
        sortedDataInYear <- sortedData %>% filter(Release_Date <= input$year)
        selectedBrand <- input$brand
        
        ggplot(sortedDataInYear, aes(x=Brand, y=n)) + 
          geom_bar(aes(fill = (Brand == selectedBrand), group = Brand),stat='identity') +
          theme_bw() +
          labs(title="Phones released each year by brand since 2003",
               x = "Brands",
               y = "Amount") +
          coord_flip() +
          theme(legend.position = "none")
    })
    
    output$batteryDisplayPlot <- renderPlot({
      # Plotting them in a graph
      plot(datSize, datBattery, 
           xlab = "Screen Size", 
           ylab = "Battery Capacity", 
           main = "Screen size and battery capacity")
      abline(lm(dat$Battery ~ dat$Display_Size))
    })

})
