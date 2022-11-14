#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

navbarPage("Evolution of Smartphones",
           tabPanel("Yearly releases",
                    # Sidebar with a slider input selecting year
                    sidebarLayout(
                      sidebarPanel(
                        sliderInput("year",
                                    "Year:",
                                    min = 2003,
                                    max = 2022,
                                    value = 2022)
                      ),
                      
                      # Show a bar chart with releases for the year
                      mainPanel(
                        plotOutput("brandRelease")
                      )
                    )),
           tabPanel("Battery and Display",
                    mainPanel(
                      plotOutput("batteryDisplayPlot")
                    ))
)
