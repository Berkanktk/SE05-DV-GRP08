library(tidyverse)

# import dataset
dat <- read_csv("Smartphone_Evolution.csv")

# Scatterplot for battery size and display size
plot(dat$Battery, dat$Display_Size)


# Select only release dates and remove phones with no data about release
dat <- dat %>% select(c("Release_Date"))
dat <- drop_na(dat)

