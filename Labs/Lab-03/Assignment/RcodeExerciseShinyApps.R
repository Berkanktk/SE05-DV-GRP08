library(shiny)
library(tidyverse)
library(dplyr)

#####Import Data

# Type in your data path
dat<-read_csv("DataExerciseShinyApps.csv")
dat<- dat %>% select(c("pid7","ideo5")) # Party ID and ideology

# Remove missing values 
dat<-drop_na(dat)

# UI component
ui <- fluidPage(
  
  # Application title
  titlePanel("Party Ideologies"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins",
                  label = "Select Five Point Ideology (1=Very liberal, 5=Very conservative)",
                  min = 1,
                  max = 5,
                  value = 3),
                # hr(),
                # helpText("Data from 1000 respondents.")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Server component
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    filtered_dat <-filter(dat, ideo5 == input$bins)
    
    x <- filtered_dat$pid7

    # Drawing the histogram 
    ggplot(filtered_dat, aes(x=pid7)) + 
      geom_histogram(color="black", 
                     fill="gray", 
                     binwidth = 1) + 
      labs(x = '7 Point party ID, 1=very D, 7=very R', y='Count') +
      scale_x_continuous(breaks = seq(1,7, by=1))
    
  
#    hist(x = x,
#         #breaks = input$bins,
#         #ylim = c(0,100),
#         xlab = '7 Point party ID, 1=very D, 7=very R',
#         ylab = 'Count',
#         main = 'Histogram over ideologies',
#         breaks = 7
#        )
    
    })
}


# Complete app with UI and server configs
shinyApp(ui, server)