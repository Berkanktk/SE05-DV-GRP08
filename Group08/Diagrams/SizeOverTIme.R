library(tidyverse)
library(ggplot2)
library(dplyr)
library(plotly)
library(RColorBrewer)

##DISPLAY SIZE line chart

dat <- read_csv("Smartphone_updated_dates.csv")
dat$Year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
datSizeOverTime <- dat %>% select(c("Display_Size", "Year"))

datSizeOverTime <- drop_na(datSizeOverTime)

group <- datSizeOverTime %>% group_by(Year) %>% summarise(Display_Size = mean(Display_Size))

p <- ggplot(group, aes(x=Year, y=Display_Size, )) +
  geom_line()
  
ggplotly(p,  tootltip = "text")

##Battery line chart


dat <- read_csv("Smartphone_updated_dates.csv")
dat$Year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
datBatteryOverTime <- dat %>% select(c("Battery", "Year"))

datBatteryOverTime <- drop_na(datBatteryOverTime)

group <- datBatteryOverTime %>% group_by(Year) %>% summarise(Battery = mean(Battery))

p <- ggplot(group, aes(x=Year, y=Battery, )) +
  geom_line() +
  ylab("Battery(maH)")

ggplotly(p,  tootltip = "text")

### OS stacked bar chart

dat <- read_csv("Smartphone_updated_dates.csv")
dat$Year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
datOSOverTime <- dat %>% select(c("OS", "Year"))

datOSOverTime <- drop_na(datOSOverTime)

datOSOverTime$OS <- word(datOSOverTime$OS, 1)

OSCount <- datOSOverTime %>% group_by(Year) %>% count(OS)

otherVal <- OSCount %>% filter(n < 13)
otherValSumGrouped <- otherVal %>% group_by(Year) %>% summarise(n = sum(n), OS = "Other")
OSCount <- rbind(OSCount, otherValSumGrouped)

OSCount <- OSCount %>% filter(n >= 4)


p <- ggplot(OSCount, aes(x=Year, y=n, fill=OS )) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_brewer(palette = "Paired") +
  ylab("Amount")
  

ggplotly(p,  tootltip = "text")


##Primary Camera line chart

dat <- read_csv("Smartphone_updated_dates.csv")
dat$Year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
datCameraOverTime <- dat %>% select(c("Primary_Camera", "Year"))

datCameraOverTime <- drop_na(datCameraOverTime)

group <- datCameraOverTime %>% group_by(Year) %>% summarise(Primary_Camera = mean(Primary_Camera))

p <- ggplot(group, aes(x=Year, y=Primary_Camera, )) +
  geom_line()+
  ylab("Camera (megapixels)")

ggplotly(p,  tootltip = "text")



##Front Camera line chart

dat <- read_csv("Smartphone_updated_dates.csv")
dat$Year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
datFCameraOverTime <- dat %>% select(c("Front_Camera", "Year"))

datFCameraOverTime <- drop_na(datFCameraOverTime)
datFCameraOverTime <- datFCameraOverTime[!is.na(as.numeric(as.character(datFCameraOverTime$Front_Camera))),]

datFCameraOverTime$Front_Camera <- word(datFCameraOverTime$Front_Camera, 1)

group <- datFCameraOverTime %>% group_by(Year) %>% summarise(Front_Camera = mean(as.double(Front_Camera)))

p <- ggplot(group, aes(x=Year, y=Front_Camera, )) +
  geom_line()+
  ylab("Camera (megapixels)")

ggplotly(p,  tootltip = "text")
