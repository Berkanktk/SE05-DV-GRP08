library(tidyverse)

# import datasets
dat <- read_csv("Smartphone_Evolution.csv")

#Formatted dates dataframe
#dat <- read_csv("Smartphone_updated_dates.csv")
#dates <- read_csv("formatted_dates.csv")
#dat[4] <- dates[1]
#write.csv(dat, "./Smartphone_updated_dates.csv", row.names = FALSE)


# Scatterplot for battery size and display size
plot(dat$Battery, dat$Display_Size)


# Select only release dates and remove phones with no data about release
dat <- dat %>% select(c("Release_Date"))
dat <- drop_na(dat)

