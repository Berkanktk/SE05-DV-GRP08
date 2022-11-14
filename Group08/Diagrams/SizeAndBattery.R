# Importing csv file
dat <- read.csv("Smartphone_updated_dates.csv")   

# Filtering data
dat <- dat %>% select(c("Battery", "Display_Size"))

# Dropping NA values
dat <- drop_na(dat)

# Creating variables
datBattery <- dat$Battery
datSize <- dat$Display_Size

# Plotting them in a graph
plot(datSize, datBattery, 
     xlab = "Screen Size", 
     ylab = "Battery Capacity", 
     main = "Screen size and battery capacity")

# Performing regression
datlm = lm(dat$Display_Size ~ dat$Battery)
datlm
summary(datlm)

abline(lm(dat$Battery ~ dat$Display_Size))
