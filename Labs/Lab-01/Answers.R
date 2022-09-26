# Practice 1 
((2022-2020)/(2022-2000))*100

# Practice 2
this_year = 2022
uni_start = 2020
born_year = 2000

((this_year-uni_start)/(this_year-born_year))*100

# Practice 3
comp = c(4,5,8,11)
sum(comp)

# Practice 4 and 5
x = rnorm(1000, mean=10, sd=1.4)   
plot(x)

# Practice 6
help(sqrt)

# Practice 7 
source("firstscript.R")

# Practice 8
P = seq(31, 60)

Q = matrix(data=c(P),ncol = 5, nrow = 6)

# Practice 9
source("data_frame.R")

# Practice 10
source("data_frame.R")

# Practice 11
date = strptime( c("24122022","16122022"),format="%d%m%Y")
present = c(2,3)
plot(date, present)


# Practice 12, 13 & 14
salary_csv <- read.csv("Salaries.csv")   
salary_tsv <- read.delim("Salaries.txt")
salary_excel <- read_excel("Salaries.xlsx") # 1) install.packages("readxl") 2) library(readxl)

# Practice 15
# install.packages("tidyverse",dependencies = TRUE)
# library(tidyverse)
data(starwars)

filtered_data <- select(starwars, name, height, gender)

# Practice 16
filtered_data2 <- select(starwars, name, mass:species)

# Practice 17
filtered_data3 <- select(starwars, -birth_year, -gender)

# Practice 18
females <- filter(starwars, sex == "female")

# Practice 19
females_alderaan <- filter(starwars, sex == "female", homeworld == "Alderaan")

# Practice 20
homeworlds <- filter(starwars, homeworld == "Alderaan" | homeworld == "Coruscant" | homeworld == "Endor")

# Practice 21
convert <- mutate(starwars, height_inch = height * 0.394, mass_pounds = mass * 2.205)

# Practice 22
evaluate_height <- mutate(starwars, heightcat = ifelse(height > 180, "tall", "short"))

# Practice 23
evaluate_eyecolor <- mutate(starwars, eye_color = ifelse(eye_color %in% c("black", "blue", "brown"), eye_color, "other"))

# Practice 24
evaluate_heights <- mutate(starwars, height = ifelse(height < 75 | height > 200, NA, height))

# Practice 25
mean_height_mass <- summarize(starwars, 
                              mean_height = mean(height, na.rm=TRUE), 
                              mean_mass = mean(mass, na.rm=TRUE))
# Practice 26
gender <- group_by(starwars, sex)
height_mass_gender <- summarize(gender, 
                                mean_height = mean(height, na.rm=TRUE), 
                                mean_mass = mean(mass, na.rm=TRUE))

# Practice 27
female_species <- group_by(females, species)
mean_height_females <- summarize(female_species, mean_height = mean(height, na.rm = TRUE))


mean_height_females <- starwars %>% # or with this
  filter(sex == "female") %>%
  group_by(species) %>%
  summarize(mean_height = mean(height, na.rm = TRUE))

# Practice 28
# ???

# Practice 29
# ???
