# library
library(treemap)
library(tidyverse)

# Loading dataset
data <- read.csv("Smartphone_updated_dates.csv")   

# Stripping processor names
data$Processor <- word(data$Processor, 1)

# Selecting columns
datBrand <- data %>% select(c("Brand", "Processor"))

# Dropping NA values
datBrand <- drop_na(datBrand)

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

