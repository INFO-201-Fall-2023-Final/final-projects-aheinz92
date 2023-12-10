library(shiny)
library(shinyWidgets)
library(shinythemes)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(scales)


# Load data
songs_df <- read.csv("spotify_korean_song_totals.csv")
summary_df <- read.csv("final_korean_media_data.csv")

ui <- dashboardPage(
  
  skin = "purple",
  dashboardHeader(title = "Korean Media Analysis"),
  
  dashboardSidebar(
    width = 150,
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("info-circle")),
      menuItem("Overall Trend", tabName = "overallTrend", icon = icon("line-chart")),
      menuItem("Song Impact", tabName = "songImpact", icon = icon("music")),
      menuItem("Artist Popularity", tabName = "artistPopularity", icon = icon("star")),
      menuItem("Conclusions", tabName = "conclusions", icon = icon("check-circle"))
    )
  ),
  
  dashboardBody(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    tabItems(
      tabItem(tabName = "introduction",
              h2("Introduction"),
              fluidRow(
                column(4,
                       wellPanel(
                         style = "padding:20px; border-radius: 8px",
                         # Placeholder for various interactive elements or whatever you want
                         p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                       )
                ),
                column(8,
                       wellPanel(
                         style = "padding:20px; border-radius: 8px",
                         p("This Shinyapp was created for our INFO 201 final group project, which aims to show how Korean media has spread to the US over time."),
                         p("Our final dataset has 55 months, totals of Netflix and Spotify Korean media appearances, a sum of both, 3-month and 6-month rolling averages, a rate of change, and a categorical value for the trend."),
                         p("Leading us to be able to make good predictions about the future, and analyze the past.")
                       ),
                       wellPanel(
                         style = "text-align:center; padding: 20px",
                         img(src = "IMAGE PATH", height = "200px", style = "max-width: 100%; height: auto;") # for all the images I just put IMAGE PATH, and we can fit some that work or add more/less
                       )
                )
              )
      ),
      tabItem(tabName = "overallTrend",
              h2("Overall Trend"),
              fluidRow(
                column(4,
                       wellPanel(
                         style = "padding:20px; border-radius: 8px",
                         checkboxInput("showRawTotal", "Raw Total", value = TRUE),
                         checkboxInput("showRollingAvg3", "3-Month Rolling Average", value = TRUE),
                         checkboxInput("showRollingAvg6", "6-Month Rolling Average", value = TRUE),
                         textOutput("lineChartText") # Placeholder for additional text for the chart etc, reactive
                       )
                ),
                column(8,
                       wellPanel(
                         style = "padding:20px; border-radius: 8px",
                         plotOutput("stackedLineChart") # Stacked line chart output
                       )
                )
              )
      ),
      tabItem(tabName = "songImpact",
              h2("Song Impact"),
              fluidRow(
                column(4,
                       wellPanel(
                         style = "padding:20px; border-radius: 8px",
                         selectInput("iframeSelector", "Choose a Video:", choices = list(
                           "{EXAMPLE} FREEDOM DIVE YURIMENTAL" = '<iframe width="360" height="180" src="https://www.youtube.com/embed/rpj4Sr_0Epw?si=9P0OGhObIKbwwL25" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>',
                           "More videos here" = " " # We can add other videos here, also change dims of player above at width and height=.
                         )),
                         uiOutput("youtubeEmbed"),
                         sliderInput("pointSlider", "Chart Threshold:", min = 1, max = 100, value = 50),
                         textOutput("songInfo") # Placeholder for song information, reactive
                       )
                ),
                column(8,
                       wellPanel(
                         style = "padding:20px; border-radius: 8px",
                         plotOutput("lineGraph") # Line graph with points output
                       )
                )
              )
      ),
      
      tabItem(tabName = "artistPopularity",
              
              h2("Artist Popularity"),
              
              textOutput("barChartText2"), # Placeholder for additional text related to the bar chart
              
              wellPanel(
                style = "padding:20px; border-radius:10px",
                
                fluidRow(
                  column(8,
                         sliderInput("barSlider", # Slider to select a range
                                     "Adjust Parameter:", 
                                     min = 1, 
                                     max = 100,
                                     value = c(20, 100)
                         ),
                  ),
                  column(4,
                         checkboxInput("showBTS", "Show BTS", value = FALSE), # Check box to hide/show the bar for BTS
                  )
                ),
                
                textOutput("barChartText2") # Placeholder for additional text related to the bar chart
              ),
              
              plotlyOutput("stackedBarChart") # Stacked bar chart output as plotly
      ),
      
      tabItem(tabName = "conclusions",
              h2("Conclusions"),
              fluidRow(
                column(4,
                       wellPanel(
                         style = "padding:20px; border-radius: 10px; margin-bottom: 20px", # Margin for proper spacing
                         img(src = "IMG PATH", height = "300px"), # Prediction image placeholder
                         textOutput("finalTakeaways") # Placeholder text for final takeaways, reactive
                       ),
                       wellPanel(
                         style = "padding:20px; border-radius: 10px",
                         textOutput("finalTakeaways2") # Additional placeholder text for final takeaways, reactive
                       )
                ),
                column(8,
                       wellPanel(
                         style = "padding:20px; border-radius: 10px",
                         plotOutput("multiLineChart"), # Multi-line chart output
                         checkboxGroupInput("lineSelector", "Choose Lines:", choices = c("Line 1", "Line 2", "Line 3"))
                       )
                )
              )
      )
    )
  )
)

server <- function(input, output) {
  

  
}

shinyApp(ui = ui, server = server)