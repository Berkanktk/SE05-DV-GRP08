# library
library(treemap)
library(tidyverse)
library(RColorBrewer)
library(ggplot2)

myPalette <- brewer.pal(8, "Paired") # Yellow color is a problem, easy fix tho
customPallette <- c("#A4C639", "#66C2A5", "#FC8D62", "#8DA0CB", "#00A4EF", "#FFD92F", "#E5C494", "#B3B3B3")

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
OSCount <- OSCount %>% filter(n >= 21)

############################### CHARTS ###############################

myPaletteCustom <- c("#A6CEE3","#1F78B4","#B2DF8A","#FB9A99","#E31A1C","#33A02C")

# Pie Chart (Trash)
pie(OSCount$n , 
    labels = OSCount$OS, 
    col = myPaletteCustom, 
    border = "white", 
    edges = 1000, 
    radius = 1, 
    main = "OS Distributions",
    cex=0.7
)

# Basic piechart (ggplot)
ggplot(data=OSCount, aes(x="", y=n, fill=OS)) +
  geom_bar(stat="identity", width=1) +
  scale_fill_brewer(palette = "Paired") +
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
  scale_fill_brewer(palette = "Paired") +
  geom_bar(stat="identity", color="white") +
  ggtitle("OS Distribution for models") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab("OS") + 
  ylab("Total Models") + 
  ylim(0, 4000) +
  geom_text(aes(label=n), vjust=-0.3, size=3.5) + 
  theme_minimal()
  # theme_void() 
  
# --------- Note til Victor! ---------
# Pie chart = pie version
# Bar chart = ggplot version

