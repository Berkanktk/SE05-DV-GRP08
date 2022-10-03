


#Practice

ggplot(economics) +
  geom_line(mapping = aes(x = date, y = unemploy))

#Practice asia
library(readxl)

asia<-read_excel("asia.xlsx")
asia


ggplot(asia) +
geom_line(mapping = aes(x = year, y = gdpPercap))

ggplot(asia) +
  geom_point(mapping = aes(x = year, y = gdpPercap))

ggplot(asia) +
  geom_line(mapping = aes(x = year, y = gdpPercap, group=country))

ggplot(asia) +
  geom_line(mapping = aes(x = year, y = gdpPercap, color = country))

ggplot(asia) +
  geom_line(mapping = aes(x = year, y = lifeExp, color = country, 
                          linetype = country))

########Density Plots & Boxplots
# plot the distribution of salaries 
# by rank using kernel density plots
Salaries<-read_excel("Salaries.xlsx")

ggplot(Salaries, 
       aes(x = salary, 
           fill = rank)) +
  geom_density(alpha = 0.4) +
  labs(title = "Salary distribution by rank")


# plot the distribution of salaries by rank using boxplots

ggplot(Salaries, 
       aes(x = rank, 
           y = salary)) +
  geom_boxplot() +
  labs(title = "Salary distribution by rank")


# plot the distribution using violin and boxplots
ggplot(Salaries, 
       aes(x = rank, 
           y = salary)) +
  geom_violin(fill = "cornflowerblue") +
  geom_boxplot(width = .2, 
               fill = "orange",
               outlier.color = "orange",
               outlier.size = 2) + 
  labs(title = "Salary distribution by rank")


# create ridgeline graph
library(ggplot2)
library(ggridges)

ggplot(mpg, 
       aes(x = cty, 
           y = class, 
           fill = class)) +
  geom_density_ridges() + 
  theme_ridges() +
  labs("Highway mileage by auto class") +
  theme(legend.position = "none")


# calculate means, standard deviations,
# standard errors, and 95% confidence 
# intervals by rank
library(dplyr)

plotdata <- Salaries %>%
  group_by(rank, sex) %>%
  summarize(n = n(),
            mean = mean(salary),
            sd = sd(salary),
            se = sd/sqrt(n))


ggplot(plotdata, aes(x = rank,
                     y = mean, 
                     group=sex, 
                     color=sex)) +
  geom_point(size = 3) +
  geom_line(size = 1) +
  geom_errorbar(aes(ymin  =mean - se, 
                    ymax = mean+se), 
                width = .1)


# plot the distribution of salaries 
# by rank using jittering
library(scales)
ggplot(Salaries, 
       aes(x = factor(rank,
                      labels = c("Assistant\nProfessor",
                                 "Associate\nProfessor",
                                 "Full\nProfessor")), 
           y = salary, 
           color = rank)) +
  geom_boxplot(size=1,
               outlier.shape = 1,
               outlier.color = "black",
               outlier.size  = 3) +
  geom_jitter(alpha = 0.5, 
              width=.2) + 
  scale_y_continuous(label = dollar) +
  labs(title = "Academic Salary by Rank", 
       subtitle = "9-month salary for 2008-2009",
       x = "",
       y = "") +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()


##Multivariate: Grouping/ Faceting
# plot experience vs. salary 
# (color represents rank and size represents service)
ggplot(Salaries, 
       aes(x = yrs.since.phd, 
           y = salary, 
           color = rank, 
           size = yrs.service)) +
  geom_point(alpha = .6) +
  labs(title = "Academic salary by rank, years of service, and years since degree")



# plot salary histograms by rank
ggplot(Salaries, aes(x = salary)) +
  geom_histogram(fill = "cornflowerblue",
                 color = "white") +
  facet_wrap(~rank, ncol = 1) +
  labs(title = "Salary histograms by rank")


#Maps
fl <- map_data("state", region = "florida")
ggplot(fl) +
  geom_polygon(mapping = aes(x = long, y = lat))


#####Overplotting
#Due to rounding
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), alpha= 0.25)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

##Large data
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price))

ggplot(data = diamonds) +
  geom_smooth(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = carat, y = price, group = cut_width(carat, width = 0.2)))


##3d Histogram

ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price), bins = c(40, 50))

ggplot(data = diamonds) +
  geom_hex(mapping = aes(x = carat, y = price))

#density2d
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(alpha = 0.1) +
  geom_density2d()
