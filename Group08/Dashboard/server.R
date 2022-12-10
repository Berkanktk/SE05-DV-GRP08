library(tidyverse)
library(dplyr)
library(shiny)
library(ggplot2)
library(gganimate)
library(plotly)
library(RColorBrewer)

####
# Battery and Display Size
####
# Importing csv file
dat <- read.csv("./Smartphone_updated_dates.csv")   

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
dat <- read_csv("./Data_Only_Year.csv")

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

i = 1
for(i in 1:nrow(brandCountByYear) ) {
  j = 1
  for(j in 1:nrow(brandWrong)){
    if(brandCountByYear$Brand[i] == brandWrong$Brand[j]){
      sortedDataOther[nrow(sortedDataOther) + 1,] <- c("Other", brandCountByYear[i,][2], brandCountByYear[i,][3])
      break;
    }
  }
}

grouped <- sortedDataOther %>% group_by(Brand, Release_Date) %>% summarise(n = sum(n))

sortedData <- rbind(sortedData, grouped)

####
# Treemap for Processor marketshare
####
# library
library(treemap)
library(tidyverse)
library(ggplot2)
library(treemapify) # install.packages("treemapify")

# Loading dataset
data <- read.csv("./Smartphone_updated_dates.csv")   

# Stripping processor names
data$Processor <- word(data$Processor, 1)

# Selecting columns
datBrand <- data %>% select(c("Brand", "Processor"))
datBrand$Processor <- replace(datBrand$Processor, datBrand$Processor == "Mediatek", "MediaTek")

# Dropping NA values
datBrand <- drop_na(datBrand)

# Filtering processors
processCount <- datBrand %>% count(Processor)
processCount <- processCount %>% filter(n >= 35)

# Create data
group <- processCount$Processor
value <- processCount$n
data <- data.frame(group,value)

####
# OS and Processor distribution
####

myPalette <- brewer.pal(8, "Paired") # Yellow color is a problem, easy fix tho

# Loading dataset
data <- read.csv("./Smartphone_updated_dates.csv")   

# Stripping OS names
data$OS <- word(data$OS, 1)

# Selecting columns
datBrand <- data %>% select(c("Brand", "OS"))

# Dropping NA values
datBrand <- drop_na(datBrand)

# Getting unique values 
OSCount <- datBrand %>% count(OS)

# Filtering out small values
otherVal <- OSCount %>% filter(n < 13)
otherValSum <- sum(otherVal$n)
OSCount[nrow(OSCount) + 1,] = list("Other", otherValSum)

# Filtering data to show
OSCount <- OSCount %>% filter(n >= 21)

####
# Line charts for general evolution
####

datLines <- read_csv("./Smartphone_updated_dates.csv")
datLines$Year<-as.numeric(as.POSIXlt(datLines$Release_Date)$year+1900)

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
          scale_fill_brewer(palette = "Paired") + 
          labs(title=titleText,
               x = "Brands",
               y = "Amount") +
          coord_flip() +
          theme_minimal() +
          theme(legend.position = "none"), tooltip = "text")
    })
    
    output$heatmapRelease <- renderPlotly({
      datH <- read_csv("./Smartphone_updated_dates.csv")
      dat_datesH <- read_csv("./formatted_dates_full.csv")
      datH[4] <- dat_datesH[1]
      
      datH <- datH %>% select(c("Brand", "Release_Date"))
      datH <- drop_na(datH)
      
      selectedBrand <- input$brand
      
      if(selectedBrand != "All"){
        datH <- datH %>% filter(Brand == selectedBrand) %>% count(Release_Date)
      } else {
        datH <- datH %>% count(Release_Date)
      }
      
      datH$year<-as.numeric(as.POSIXlt(datH$Release_Date)$year+1900)
      datH$month<-as.numeric(as.POSIXlt(datH$Release_Date)$mon+1)
      
      datH$monthf<-factor(datH$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)
      
      datH$date <- as.numeric(format(datH$Release_Date,"%d"))
      
      query <- datH %>% filter(year >= 2003) %>% filter(year <= 2022)  %>% select(c(year, monthf, n))
      grouped <- query %>% group_by(monthf, year) %>% summarise(n=sum(n))
      
      p <- ggplot(grouped, aes(year, monthf, fill = n)) + 
        geom_tile(colour = "white") + 
        scale_fill_gradient(low="#EBF3F8", high="#1F78B4") +
        ggtitle(paste("Release dates year/month for", input$brand)) +  xlab("Year") + ylab("Month") + 
        xlim(2003, 2022) +
        theme_minimal()
      
      ggplotly(p)
    })
    
    
    output$lineReleaseChart <- renderPlotly({
      datH <- read_csv("./Smartphone_updated_dates.csv")
      dat_datesH <- read_csv("./formatted_dates_full.csv")
      datH[4] <- dat_datesH[1]
      
      datH <- datH %>% select(c("Brand", "Release_Date"))
      datH <- drop_na(datH)
      
      selectedBrand <- input$brand
      
      if(selectedBrand != "All"){
        datH <- datH %>% filter(Brand == selectedBrand) %>% count(Release_Date)
      } else {
        datH <- datH %>% count(Release_Date)
      }
      
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
      ylab("Phones released") +
      xlab("Year") + 
        theme_minimal()
      
    })
    
    output$batteryDisplayPlot <- renderPlot({
      # Plotting them in a graph
      plot(datSize, datBattery,
           xlab = "Screen Size", 
           ylab = "Battery Capacity", 
           main = "Screen size and battery capacity")
      abline(lm(dat$Battery ~ dat$Display_Size))
    })
    
    output$ProcessorTreemap <- renderPlot({
      
      ggplot(data=processCount, aes(area = n, fill = Processor, label = paste(Processor, n, sep = "\n"))) +
        geom_treemap() +
        geom_treemap_text(colour = "black",
                          place = "centre",
                          size = 15) +
        ggtitle("Processor Marketshare") +
        theme(plot.title = element_text(hjust = 0.5, size = 20)) +
        scale_fill_brewer(palette = "Paired")
    })
    
    output$OSPieChart <- renderPlot({
      myPaletteCustom <- c("#A6CEE3","#1F78B4","#B2DF8A","#FB9A99","#E31A1C","#33A02C")
      pie(OSCount$n , 
          labels = OSCount$OS, 
          col = myPaletteCustom, 
          border = "white", 
          edges = 1000, 
          radius = 1, 
          main = "OS Distributions",
          cex=0.7
      )
    })

    output$OSBarChart <- renderPlot({
      ggplot(data=OSCount, aes(x=reorder(OS, -n), y=n, fill=OS)) +
        scale_fill_brewer(palette = "Paired") +
        geom_bar(stat="identity", color="white") +
        ggtitle("OS Distribution for models") + 
        theme(plot.title = element_text(hjust = 0.5)) + 
        xlab("OS") + 
        ylab("Total Models") + 
        ylim(0, 4000) +
        geom_text(aes(label=n), vjust=-0.3, size=3.5) +
        theme_minimal()
    })
    
    output$EvolutionChart <- renderPlotly({
      selectedChart <- input$chart
      
      if(selectedChart == "Display size"){
        datSizeOverTime <- datLines %>% select(c("Display_Size", "Year"))
        
        datSizeOverTime <- drop_na(datSizeOverTime)
        
        group <- datSizeOverTime %>% group_by(Year) %>% summarise(Display_Size = mean(Display_Size))
        
        p <- ggplot(group, aes(x=Year, y=Display_Size)) +
          geom_line() +
          ylab("Display Size (Inches)") +
          ggtitle("Mean display size in inches over year") +
          theme_minimal()
        
      } else if(selectedChart == "Battery capacity"){
        datBatteryOverTime <- datLines %>% select(c("Battery", "Year"))
        
        datBatteryOverTime <- drop_na(datBatteryOverTime)
        
        group <- datBatteryOverTime %>% group_by(Year) %>% summarise(Battery = mean(Battery))
        
        p <- ggplot(group, aes(x=Year, y=Battery)) +
          geom_line() +
          ylab("Battery(maH)") +
          ggtitle("Mean battery size in MaH over year") +
          theme_minimal()
      } else if(selectedChart == "Primary camera resolution"){
        datCameraOverTime <- datLines %>% select(c("Primary_Camera", "Year"))
        
        datCameraOverTime <- drop_na(datCameraOverTime)
        
        group <- datCameraOverTime %>% group_by(Year) %>% summarise(Primary_Camera = mean(Primary_Camera))
        
        p <- ggplot(group, aes(x=Year, y=Primary_Camera, )) +
          geom_line() +
          ylab("Camera (megapixels)") + 
          ggtitle("Mean primary camera resolution over year") +
          theme_minimal()
      } else {
        datFCameraOverTime <- datLines %>% select(c("Front_Camera", "Year"))
        
        datFCameraOverTime <- drop_na(datFCameraOverTime)
        datFCameraOverTime <- datFCameraOverTime[!is.na(as.numeric(as.character(datFCameraOverTime$Front_Camera))),]
        
        datFCameraOverTime$Front_Camera <- word(datFCameraOverTime$Front_Camera, 1)
        
        group <- datFCameraOverTime %>% group_by(Year) %>% summarise(Front_Camera = mean(as.double(Front_Camera)))
        
        p <- ggplot(group, aes(x=Year, y=Front_Camera, )) +
          geom_line() +
          ylab("Camera (megapixels)") +
          ggtitle("Mean front camera resolution over year") +
          theme_minimal()
      }
      
      ggplotly(p,  tootltip = "text")
    })
    
    
    output$OSOverTime <- renderPlotly({
      datOSOverTime <- datLines %>% select(c("OS", "Year"))
      
      datOSOverTime <- drop_na(datOSOverTime)
      
      datOSOverTime$OS <- word(datOSOverTime$OS, 1)
      
      OSCount <- datOSOverTime %>% group_by(Year) %>% count(OS)
      
      otherVal <- OSCount %>% filter(n < 13)
      otherValSumGrouped <- otherVal %>% group_by(Year) %>% summarise(n = sum(n), OS = "Other")
      OSCount <- rbind(OSCount, otherValSumGrouped)
      
      OSCount <- OSCount %>% filter(n >= 3)
      
      
      p <- ggplot(OSCount, aes(x=Year, y=n, fill=OS )) +
        geom_bar(position="stack", stat="identity") +
        scale_fill_brewer(palette = "Paired") +
        ylab("Amount") + 
        ggtitle("OS over year") +
        theme_minimal()
      
      
      ggplotly(p,  tootltip = "text")
    })
    
    output$downloadData  <- downloadHandler(
      filename = "smartphone_evolution.csv",
      content = function (file){
        write.csv(dat, file)
      }
    )
})
