dat <- read.csv("Smartphone_updated_dates.csv")   

# Filtering data
dat <- dat %>% select(c("Front_Camera", "Primary_Camera"))

# Dropping NA values
dat <- drop_na(dat)

# Creating variables
datPrimary <- dat$Primary_Camera
datFront <- dat$Front_Camera

# Plotting them in a graph
plot(datFront, datPrimary, 
     xlab = "Front Camera", 
     ylab = "Primary Camera", 
     main = "Front Camera and Primary Cammera")

# Performing regression
datlm = lm(dat$Display_Size ~ dat$Battery)
datlm
summary(datlm)

abline(lm(dat$Primary_Camera ~ dat$Front_Camera))
