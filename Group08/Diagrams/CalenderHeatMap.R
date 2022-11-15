library(tidyverse)
library(ggplot2)
library(gganimate)
library(zoo)
library(sqldf)
library(quantmod)
library(reshape2)
library(plyr)
library(scales)
library(RColorBrewer)

dat <- read_csv("Smartphone_updated_dates.csv")
dat_dates <- read_csv("formatted_dates_full.csv")
dat[4] <- dat_dates[1]

dat <- dat %>% select(c("Brand", "Release_Date"))
dat <- drop_na(dat)

dat <- dat %>% count("Release_Date")

dat$year<-as.numeric(as.POSIXlt(dat$Release_Date)$year+1900)
dat$month<-as.numeric(as.POSIXlt(dat$Release_Date)$mon+1)

dat$monthf<-factor(dat$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)

dat$weekday = as.POSIXlt(dat$Release_Date)$wday

dat$weekdayf<-factor(dat$weekday,levels=rev(0:6),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE)

dat$yearmonth<-as.yearmon(dat$Release_Date)

dat$yearmonthf<-factor(dat$yearmonth)

dat$week <- as.numeric(format(dat$Release_Date,"%W"))

dat$date <- as.numeric(format(dat$Release_Date,"%d"))


dat<-ddply(dat,.(yearmonthf),transform,monthweek=1+week-min(week))

query = sqldf("SELECT * FROM dat WHERE year BETWEEN 2004 and 2022")

ggplot(query, aes(monthf, date, fill = freq)) + 
  geom_tile(colour = "white") + 
  #facet_grid(year~monthf) + 
  scale_fill_gradient(low="gray", high="black") +
  ggtitle("Phone Release Dates") +  xlab("\n\Month") + ylab("Dates")
