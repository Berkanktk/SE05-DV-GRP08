#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)


navbarPage("Evolution of Smartphones",
           tabPanel("Yearly releases",
                    titlePanel("Yearly Releases"),
                    # Sidebar with a slider input selecting year
                    sidebarLayout(
                      sidebarPanel(
                        sliderInput("year",
                                    "Year:",
                                    min = 2003,
                                    max = 2022,
                                    value = 2022),
                        selectInput("brand", "Select Brand to highlight", choices = c("ZTE", "Xiaomi", "Sony", "Samsung", "OPPO", "OnePlus", "Nokia", "Motorola", "Micromax", "LG", "Lenovo", "LAVA", "Huawei", "HTC", "Honor", "BLU", "BlackBerry", "Asus", "Apple", "Alcatel")),
                        checkboxInput("cumulativeCheckbox", "Cumulatative", FALSE)
                      ),
                      
                      # Show a bar chart with releases for the year
                      mainPanel(
                        plotlyOutput("brandRelease")
                      )
                    ),
                    fluidRow(
                      column(6,
                             plotlyOutput("lineReleaseChart")),
                      column(6,
                             plotlyOutput("heatmapRelease"))
                    )
                    ),
           tabPanel("Battery and Display",
                    mainPanel(
                      plotOutput("batteryDisplayPlot")
                    ))
)
