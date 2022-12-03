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
                    titlePanel("Are more phones being released each year?"),
                    # Sidebar with a slider input selecting year
                    sidebarLayout(
                      sidebarPanel(
                        sliderInput("year",
                                    "Year:",
                                    min = 2003,
                                    max = 2022,
                                    value = 2022,
                                    sep = ""),
                        selectInput("brand", "Select Brand to highlight", choices = c("All", "ZTE", "Xiaomi", "Sony", "Samsung", "OPPO", "OnePlus", "Nokia", "Motorola", "Micromax", "LG", "Lenovo", "LAVA", "Huawei", "HTC", "Honor", "BLU", "BlackBerry", "Asus", "Apple", "Alcatel")),
                        checkboxInput("cumulativeCheckbox", "Cumulative", FALSE)
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
           tabPanel("Correlations",
                    fluidRow(
                      column(6,
                             titlePanel("How does screen size relate to battery size?"),
                             mainPanel(
                               img(src="ScreenAndBattery.gif", align="left")
                             )),
                      column(6,
                             titlePanel("How has primary and front camera followed eachother?"),
                             mainPanel(
                               img(src="Camera_evolution.gif", align="left")
                             ))
                    ),

            ),
           tabPanel("Distribution",
                    fluidPage(
                      fluidRow(
                        titlePanel("Which processor brand is the most popular?"),
                        plotOutput("ProcessorTreemap")
                      ),
                      fluidRow(
                        titlePanel("Which OS is the most popular?"),
                        column(6, plotOutput("OSPieChart")),
                        column(6, plotOutput("OSBarChart"))
                      )
                    )
            ),
           tabPanel("Evolution",
                    fluidPage(
                      titlePanel("How have smartphones evolved over time?"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                            "chart", 
                            "Select evolution to display", 
                            choices=c(
                              "Display size", 
                              "Battery capacity", 
                              "Primary camera resolution", 
                              "Front camera resolution"
                              )
                            )
                        ),
                        mainPanel(
                          plotlyOutput("EvolutionChart")
                        )
                      ),
                      fluidRow(
                        plotlyOutput("OSOverTime")
                      )
                    )
          ),
          tabPanel("About",
                   titlePanel("Download dataset"),
                   fluidPage(
                     fluidRow(
                       HTML("<p>The original dataset was found on kaggle, it can be found <a href='https://www.kaggle.com/datasets/pranav941/evolution-of-smartphones'>here</a>.</p><br /> <p>The data has been cleaned a little bit, so the dataset that has been used for this report can downloaded by pressing the download button below.</p>"),
                       downloadButton("downloadData", "Download")
                     )
                   )

         )
)
