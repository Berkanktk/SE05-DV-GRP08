library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("CensusVis"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          helpText("Create demographic maps with informationfrom the 2010 US Census"),
          
          
          selectInput("select", ("Choose a variable to display"), 
                      choices = list("Percent white" = 1, 
                                     "Percent black" = 2,
                                     "Percent hispanic" = 3), selected = 1),
          
          sliderInput("slider2", "Range of interest:",
                      min = 0, max = 100, value = c(0, 100))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
