# Importing csv file
dat <- read.csv("Smartphone_updated_dates.csv")   

# Filtering data
dat <- dat %>% select(c("Battery", "Display_Size"))

# Dropping NA values
dat <- drop_na(datBattery)

# Creating variables
datBattery <- dat$Battery
datSize <- dat$Display_Size

# Plotting them in a graph
plot(datSize, datBattery)

