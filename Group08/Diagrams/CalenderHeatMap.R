library(tidyverse)
library(ggplot2)
library(zoo)
library(reshape2)
library(scales)
library(RColorBrewer)
library(plotly)

dat <- read_csv("Smartphone_updated_dates.csv")
dat_dates <- read_csv("formatted_dates_full.csv")
dat[4] <- dat_dates[1]

dat <- dat %>% select(c("Brand", "Release_Date"))
dat <- drop_na(dat)

dat <- dat %>% filter(Brand == "Apple") %>% count(Release_Date)

dat$year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
dat$month<-as.numeric(as.POSIXlt(dat$Release_Date)$mon+1)

dat$monthf<-factor(dat$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)

dat$date <- as.numeric(format(dat$Release_Date,"%d"))

query <- dat %>% filter(year >= 2003) %>% filter(year <= 2022)  %>% select(c(year, monthf, n))
grouped <- query %>% group_by(monthf, year) %>% summarise(n=sum(n))

p <- ggplot(grouped, aes(year, monthf, fill = n)) + 
  geom_tile(colour = "white") + 
  scale_fill_gradient2(low="blue", high="red") +
  ggtitle("Phone Release Dates") +  xlab("\nMonth") + ylab("Dates")
  
ggplotly(p)
