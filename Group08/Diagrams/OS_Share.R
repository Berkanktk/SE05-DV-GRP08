# library
library(treemap)
library(tidyverse)
library(RColorBrewer)
library(ggplot2)

myPalette <- brewer.pal(8, "Set1") # Yellow color is a problem, easy fix tho

# Loading dataset
data <- read.csv("Smartphone_updated_dates.csv")   

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
OSCount <- OSCount %>% filter(n >= 14)

############################### CHARTS ###############################

# Pie Chart (Trash)
pie(OSCount$n , 
    labels = OSCount$OS, 
    col = myPalette, 
    border = "white", 
    edges = 1000, 
    radius = 1, 
    main = "OS Distributions",
    cex=0.7
)

# Basic piechart (ggplot)
ggplot(data=OSCount, aes(x="", y=n, fill=OS)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  theme_void()  # remove background, grid, numeric labels

# Bar Chart
barplot(sort(OSCount$n, decreasing = TRUE), 
        main="OS Distribution for models", 
        names.arg = OSCount$OS, 
        xlab = "OS", 
        ylab = "Total Models", 
        col = myPalette,
        border = "white",
        legend.text=OSCount$OS, 
        args.legend=list(bty="n", horiz=FALSE))

# Bar Chart (GGplot)
ggplot(data=OSCount, aes(x=reorder(OS, -n), y=n, fill=OS)) + 
  geom_bar(stat="identity", color="white") +
  ggtitle("OS Distribution for models") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab("OS") + 
  ylab("Total Models") + 
  ylim(0, 4000) +
  geom_text(aes(label=n), vjust=-0.3, size=3.5) + 
  theme_minimal()
  # theme_void() 
  


