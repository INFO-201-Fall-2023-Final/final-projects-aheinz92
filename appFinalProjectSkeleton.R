library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(shinyWidgets)
library(shinythemes)
library(scales)

# Load data
songs_df <- read.csv("spotify_korean_song_totals.csv")
summary_df <- read.csv("final_korean_media_data.csv")

ui <- fluidPage(
  tags$style(HTML("body {background-color: $F0F0F0; color: #333333")),
  navbarPage("Korean Media Analysis",
             # Tab 1: Intro
             tabPanel("Introduction",
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
             
             # Tab 2: Stacked Line Chart and interactive element
             tabPanel("Stacked Line Chart",
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
             
             # Tab 3: Line Graph with Interactive Elements/YouTube Player
             # Note: if you want the youtube to always be center of the panel no matter window size, lmk, I will work on that will just take a bit,
             # seems like it needs to be in CSS, but for purposes of this project it's probably fine
             tabPanel("Line Graph",
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
             
             # Tab 4: Stacked Bar Chart
             tabPanel("Stacked Bar Chart",
                      fluidRow(
                        column(4,
                               wellPanel(
                                 style = "padding:20px; border-radius: 8px",
                                 sliderInput("barSlider", 
                                             "Adjust Parameter:", 
                                             min = 1, 
                                             max = 100,
                                             value = c(20, 100)),
                                 checkboxInput("showBTS", "Show BTS", value = FALSE), # Check box to hide/show the bar for BTS
                                 textOutput("barChartText") # Placeholder for additional text related to the bar chart
                               )
                        ),
                        column(8,
                               wellPanel(
                                 style = "padding:20px; border-radius: 8px",
                                 plotlyOutput("stackedBarChart") # Stacked bar chart output as plotly
                  )
                )
              )
             ),
             
             # Tab 5: Predictions and Final Takeaways
             tabPanel("Predictions and Summary",
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


server <- function(input, output) {
  
  # For some of these placeholder values we have used car parts/themes as an example, so you SHOULD just be able to replace those and have it work
  # but if that doesn't work for any reason feel free to troubleshoot with me if you want, it was a bit hard to do this part without our datasets
  
  # I can also do better themeing when you are done if you want me to do that!

  # Rendering text:
  output$lineChartText <- renderText({
    # Can update this to be another static piece of text or change from user input... whatever
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  })
  
  output$songInfo <- renderText({
    # Information about a song selected if we want to keep this
    paste("Information for the song:", input$iframeSelector)
  })
  
  output$barChartText <- renderText({
    # Info about the bar chart
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  })
  
  output$finalTakeaways <- renderText({
    # Can summarize the final takeaways here
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  })
  
  output$finalTakeaways2 <- renderText({
    # Can summarize the final takeaways here
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  })
  
  # Rendering plots:
  output$stackedLineChart <- renderPlot({
    summary_df$date_month <- as.Date(summary_df$date_month)
    # Start the ggplot
    p <- ggplot() +
      theme_minimal() +
      labs(title = "Korean Media Popularity Over Time",
           x = "Month",
           y = "Value")
    # Add lines conditionally
    if (input$showRawTotal) {
      p <- p + geom_line(data = summary_df, aes(x = date_month, y = total_spotify_and_netflix, color = "Raw Total"), size = 1)
    }
    if (input$showRollingAvg3) {
      p <- p + geom_line(data = summary_df, aes(x = date_month, y = rolling_avg_3_month, color = "3-Month Avg"), size = 1)
    }
    if (input$showRollingAvg6) {
      p <- p + geom_line(data = summary_df, aes(x = date_month, y = rolling_avg_6_month, color = "6-Month Avg"), size = 1)
    }
    # Additional plot formatting
    p <- p + scale_color_manual(values = c("Raw Total" = "blue", "3-Month Avg" = "green", "6-Month Avg" = "red")) +
      scale_x_date(date_breaks = "6 months", date_labels = "%Y-%m")
    
    p
  })
  
  # Line Graph with Points
  output$lineGraph <- renderPlot({
    # Replace with the data/chart code
    # Use input$pointSlider to filter or modify the data based on slider input, (again, should work but lmk if not)...
    ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_line() + geom_point()
  })
  
  # YouTube Embed
  output$youtubeEmbed <- renderUI({
    HTML(input$iframeSelector)
  })
  
  # Song Info
  output$songInfo <- renderText({
    # Update this with logic to display song information based on selected song 
    # once we have list finalized, and if we wont more info at all (don't need)
    paste("Information for the song:", input$songSelector)
  })
  output$stackedBarChart <- renderPlotly({
    # Get the values from the range slider
    slider_min <- input$barSlider[1]
    slider_max <- input$barSlider[2]
    # Calculate total times on chart for each artist and arrange in descending order
    artist_totals <- songs_df %>%
      group_by(artist) %>%
      summarize(total_times_on_chart = sum(times_on_chart), .groups = 'drop') %>%
      filter((total_times_on_chart >= slider_min & total_times_on_chart <= slider_max) |
               (artist == "BTS" & input$showBTS)) %>%
      arrange(desc(total_times_on_chart))
    # Join with original data to get song details
    filtered_data <- songs_df %>%
      inner_join(artist_totals, by = "artist")
    # Filter based on whether BTS should be shown or not
    if (!input$showBTS) {
      filtered_data <- filtered_data %>% filter(artist != "BTS")
    }
    # Reorder artist factor based on total times on chart
    filtered_data$artist <- factor(filtered_data$artist, levels = artist_totals$artist)
    
    # Create the stacked bar chart
    p <- ggplot(filtered_data, aes(x = artist, y = times_on_chart, fill = title, 
                                   text = paste0(title, ": ", times_on_chart, " appearances"))) +
      geom_bar(stat = "identity", position = "stack") +
      xlab("Musical Artist or Group") +
      ylab("Number of Song Appearances on US Spotify Charts (2017-2021)") +
      scale_y_continuous(breaks = pretty_breaks(n = 5)) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1),
            axis.text = element_text(size = 10), 
            axis.ticks = element_line(linewidth = 1), 
            legend.position = "none")
    # Convert to a plotly object
    ggplotly(p, tooltip = "text") %>%
      config(displayModeBar = FALSE)
  })
  
  # Example: Multi-Line Chart
  output$multiLineChart <- renderPlot({
    # Replace with the data/chart code
    # Use input$lineSelector to filter or modify the lines based on checkbox input.
    ggplot(data = mpg, aes(x = displ, y = hwy, color = class)) + geom_line()
  })
  
  # For sure missing till we have data implemented:
  # Reactive expressions to update text, images, or charts based on user input/selection
  
}
shinyApp(ui = ui, server = server)
