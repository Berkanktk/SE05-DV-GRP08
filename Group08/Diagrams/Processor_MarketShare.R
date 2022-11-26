# library
library(treemap)
library(tidyverse)
library(ggplot2)
library(treemapify) # install.packages("treemapify")

# Loading dataset
data <- read.csv("Smartphone_updated_dates.csv")   

# Stripping processor names
data$Processor <- word(data$Processor, 1)

# Selecting columns
datBrand <- data %>% select(c("Brand", "Processor"))

# Dropping NA values
datBrand <- drop_na(datBrand)
datBrand$Processor <- replace(datBrand$Processor, datBrand$Processor == "Mediatek", "MediaTek")

# Filtering processors
processCount <- datBrand %>% count(Processor)
processCount <- processCount %>% filter(n >= 35)

# Create data
group <- processCount$Processor
value <- processCount$n
data <- data.frame(group,value)

# Treemap
treemap(data,
        title="Processor Marketshare",
        index="group",
        vSize="value",
        type="index",
        border.col = "white",
        fontfamily.title = "sans",
        fontfamily.labels = "sans",
        fontfamily.legend = "sans",
        vColor = "value",
        fontcolor.labels = "white",
)

ggplot(data=processCount, aes(area = n, fill = Processor, label = paste(Processor, n, sep = "\n"))) +
  geom_treemap() +
  geom_treemap_text(colour = "white",
                  place = "centre",
                  size = 15) +
  ggtitle("Processor Marketshare") +
  theme(plot.title = element_text(hjust = 0.5, size = 20)) +
  scale_fill_brewer(palette = "Paired")
  
  
