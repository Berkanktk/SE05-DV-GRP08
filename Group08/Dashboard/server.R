library(tidyverse)
library(dplyr)
library(shiny)
library(ggplot2)
library(gganimate)
library(plotly)

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

brandCountMain <- datBrand %>%
  count(Brand)

limit <- 30

#Large Brands
brandCount <- brandCountMain %>%
  filter(n >= limit)

brandWrong <- brandCountMain %>%
  filter(n < limit)

brandCountByYear <- datBrand %>%
  count(Brand, Release_Date)

sortedData <- data.frame(Brand=character(), Release_Date=integer(), n=integer())

i = 1
for(i in 1:nrow(brandCountByYear) ) {
  j = 1
  for(j in 1:nrow(brandCount)){
    if(brandCountByYear$Brand[i] == brandCount$Brand[j]){
      sortedData[nrow(sortedData) + 1,] <- brandCountByYear[i,]
      break;
    }
  }
}

sortedDataOther <- data.frame(Brand=character(), Release_Date=integer(), n=integer())

for(i in 1:nrow(brandCountByYear) ) {
  j = 1
  for(j in 1:nrow(brandWrong)){
    if(brandCountByYear$Brand[i] == brandWrong$Brand[j]){
      sortedDataOther[nrow(sortedDataOther) + 1,] <- c("Other", brandCountByYear[j,][2], brandCountByYear[j,][3])
      break;
    }
  }
}

grouped <- sortedDataOther %>% group_by(Brand, Release_Date) %>% summarise(n = sum(n))

sortedData <- rbind(sortedData, grouped)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$brandRelease <- renderPlotly({
        titleText <- paste("Phones released by brand from 2003 to", input$year)
        if(input$cumulativeCheckbox){
          sortedDataInYear <- sortedData %>% filter(Release_Date <= input$year)
        } else {
          sortedDataInYear <- sortedData %>% filter(Release_Date == input$year)
          titleText <- paste("Phones released by brand in", input$year)
        }
        selectedBrand <- input$brand
        
        ggplotly(ggplot(sortedDataInYear, aes(x=Brand, y=n, text=paste("Brand:", Brand, "\nCount:", n, "\nYear:", Release_Date),)) + 
          geom_bar(aes(fill = (Brand == selectedBrand), group = Brand),stat='identity') +
          theme_bw() +
          labs(title=titleText,
               x = "Brands",
               y = "Amount") +
          coord_flip() +
          theme(legend.position = "none"), tooltip = "text")
    })
    
    output$heatmapRelease <- renderPlotly({
      datH <- read_csv("../Smartphone_updated_dates.csv")
      dat_datesH <- read_csv("../formatted_dates_full.csv")
      datH[4] <- dat_datesH[1]
      
      datH <- datH %>% select(c("Brand", "Release_Date"))
      datH <- drop_na(datH)
      
      datH <- datH %>% filter(Brand == input$brand) %>% count(Release_Date)
      
      datH$year<-as.numeric(as.POSIXlt(datH$Release_Date)$year+1900)
      datH$month<-as.numeric(as.POSIXlt(datH$Release_Date)$mon+1)
      
      datH$monthf<-factor(datH$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)
      
      datH$date <- as.numeric(format(datH$Release_Date,"%d"))
      
      query <- datH %>% filter(year >= 2003) %>% filter(year <= 2022)  %>% select(c(year, monthf, n))
      grouped <- query %>% group_by(monthf, year) %>% summarise(n=sum(n))
      
      p <- ggplot(grouped, aes(year, monthf, fill = n)) + 
        geom_tile(colour = "white") + 
        scale_fill_gradient2(low="blue", high="red") +
        ggtitle(paste("Release dates year/month for", input$brand)) +  xlab("Year") + ylab("Month") + 
        xlim(2003, 2022)
      
      ggplotly(p)
    })
    
    
    output$lineReleaseChart <- renderPlotly({
      datH <- read_csv("../Smartphone_updated_dates.csv")
      dat_datesH <- read_csv("../formatted_dates_full.csv")
      datH[4] <- dat_datesH[1]
      
      datH <- datH %>% select(c("Brand", "Release_Date"))
      datH <- drop_na(datH)
      
      datH <- datH %>% filter(Brand == input$brand) %>% count(Release_Date)
      
      datH$year<-as.numeric(as.POSIXlt(datH$Release_Date)$year+1900)
      datH$month<-as.numeric(as.POSIXlt(datH$Release_Date)$mon+1)
      
      datH$monthf<-factor(datH$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)
      
      datH$date <- as.numeric(format(datH$Release_Date,"%d"))
      
      query <- datH %>% filter(year >= 2003) %>% filter(year <= 2022)  %>% select(c(year, n))
      grouped <- query %>% group_by(year) %>% summarise(n=sum(n))
      
      if(input$cumulativeCheckbox){
        grouped[,2] <- cumsum(grouped[, 2])
      }

      ggplot(grouped, aes(x=year, n)) + geom_line() + ylim(0, NA) + xlim(2003, 2022) +
      ggtitle(paste("Phones Released by", input$brand))  +
      ylab("Phones released")
      
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
