library(shiny)
library(shinyWidgets)
library(shinythemes)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(scales)
library(splines)
library(splines2)


# Load data
songs_df <- read.csv("spotify_korean_song_totals.csv")
summary_df <- read.csv("final_korean_media_data.csv")
songs_and_months_df <- read.csv("spotify_korean_song_month_unique.csv")

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
        
        p(textOutput("overallTrendText")), 
        fluidRow(
          column(3,
            wellPanel(
              style = "padding:20px; border-radius:10px",
              
              checkboxInput("showRawTotal", "Raw Total", value = TRUE),
              checkboxInput("showRollingAvg3", "3-Month Rolling Average", value = TRUE),
              checkboxInput("showRollingAvg6", "6-Month Rolling Average", value = TRUE),
              checkboxInput("showLinearTrend", "Linear Trend Line", value = TRUE)
            )
          ),
          column(4,
            wellPanel(
              style = "padding:20px; border-radius:10px",
              
              textOutput("lineChartText") # Placeholder for additional text for the chart etc, reactive
            )
          )
        ),
        
        plotOutput("stackedLineChart") # Stacked line chart output
      ),
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      tabItem(tabName = "songImpact",
              
        h2("Song Impact"),
        
        p(textOutput("songImpactText")), # Placeholder for additional text related to the bar chart

        fluidRow(
          wellPanel(
            style = "padding:20px; border-radius: 8px",
            htmlOutput("youtubeEmbed"),
            sliderInput("songRange", "Minimum Spotify Song Appearances", min = 10, max = 50, value = 40, step = 5),
            textOutput("songInfo") # Placeholder for song information, reactive
          )
        ),
        
        plotlyOutput("lineGraph") # Stacked line chart output
      ),

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      tabItem(tabName = "artistPopularity",
              
        h2("Artist Popularity"),
        
        p(textOutput("barChartText1")), # Placeholder for additional text related to the bar chart
        
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
              checkboxInput("showBTS", "Show BTS?", value = FALSE), # Check box to hide/show the bar for BTS
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

server <- function(input, output, session) {
  
  # For some of these placeholder values we have used car parts/themes as an example, so you SHOULD just be able to replace those and have it work
  # but if that doesn't work for any reason feel free to troubleshoot with me if you want, it was a bit hard to do this part without our datasets
  
  # I can also do better themeing when you are done if you want me to do that!
  
  # Rendering text:
  output$lineChartText <- renderText({
    # Can update this to be another static piece of text or change from user input... whatever
    "1. raw data peaks a lot from things like specific songs hitting, so we explore rolling avgs to see the trend more interpretably. 
     2. gradual build despite peaks and valleys"
  })
  
  output$barChartText1 <- renderText({
    # Info about the bar chart
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  })
  
  output$barChartText2 <- renderText({
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
  
  output$overallTrendText <- renderText({
    "Lorem ipsum blah blah blah"
  })
  
  output$songImpactText <- renderText({
    "note that JENNIE and LISA are members of BLACKPINK, and V is a member of
    BTS, so technically every song is BTS or BLACKPINK that meets this criteria
    except for V and ZICO's single hits"
  })
  

  
  
  
  output$stackedLineChart <- renderPlot({
    summary_df$date_month <- as.Date(summary_df$date_month)
    
    p <- ggplot() +
      theme_minimal() +
      labs(x = "Month",
           y = "Spotify and Netflix Presence")
    
    # Add lines conditionally
    if (input$showRawTotal) {
      p <- p + geom_line(data = summary_df, 
                         aes(x = date_month, y = total_spotify_and_netflix, color = "Raw Total"), size = 1)
    }
    
    if (input$showRollingAvg3) {
      # Fit spline model and predict values
      spline_model <- lm(rolling_avg_3_month ~ bs(date_month, df = 17), data = summary_df)  # I experimented with df values for smoothing
      new_rolling_avg_3_month <- predict(spline_model, newdata = list(date_month = summary_df$date_month))
      p <- p + geom_line(data = summary_df, 
                         aes(x = date_month, y = new_rolling_avg_3_month, color = "3-Month Avg"), size = 1)
    }
    
    if (input$showRollingAvg6) {
      # Fit spline model and predict values
      spline_model <- lm(rolling_avg_6_month ~ bs(date_month, df = 12), data = summary_df)  # I experimented with df values for smoothing
      new_rolling_avg_6_month <- predict(spline_model, newdata = list(date_month = summary_df$date_month))
      p <- p + geom_line(data = summary_df, 
                         aes(x = date_month, y = new_rolling_avg_6_month, color = "6-Month Avg"), size = 1)
    }
    
    if (input$showLinearTrend) {
      # Linear trend line to show growth
      p <- p + geom_smooth(data = summary_df, 
                           aes(x = date_month, y = total_spotify_and_netflix, color = "Linear Trend",), method = "lm", se = FALSE)
    }
    
    # Additional plot formatting
    p <- p + 
      scale_color_manual(values = c("Raw Total" = "#b0c7f5", "3-Month Avg" = "#7debbb", "6-Month Avg" = "#e4eb7d", "Linear Trend" = "grey")) +
      scale_x_date(date_breaks = "6 months", date_labels = "%Y-%m")
    
    p
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  song_points <- reactiveValues(data = NULL, html_embed = c(""))  
  
  observe({
    if (!is.null(input$songRange)) { 
      song_points$data <- songs_and_months_df[songs_and_months_df$count >= input$songRange, ]
    }
  })
  
  output$lineGraph <- renderPlotly({
    req(song_points$data)
    song_points$data$date_month <- as.Date(paste0(song_points$data$date_month, "-01"), format="%Y-%m-%d")
    song_points$data <- song_points$data[song_points$data$date_month <= max(summary_df$date_month),]
    song_points$data <- merge(song_points$data, summary_df, by = "date_month", all.x = TRUE, suffixes = c(".song_points", ".summary_df"))
    
    song_points$data$date_month_numeric.song_points <- as.numeric(song_points$data$date_month)
    song_points$data$new_count_spotify_korean.song_points <- approx(summary_df$date_month_numeric, 
                                                                    summary_df$new_count_spotify_korean, 
                                                                    xout = song_points$data$date_month_numeric.song_points)$y
    song_points$data$color <- song_points$data$chart_color
    
    p <- plot_ly() %>%
      add_trace(data = summary_df, 
                x = ~date_month, 
                y = ~new_count_spotify_korean, 
                type = "scatter", 
                mode = "lines", 
                hoverinfo = "none",
                showlegend = FALSE)
    
    p <- p %>%
      add_trace(data = song_points$data, 
                x = ~date_month, 
                y = ~new_count_spotify_korean.song_points, 
                type = "scatter", 
                mode = "markers", 
                hoverinfo = "text",
                text = ~paste(title, "by", artist, "charted", count, "times in", format(date_month, "%B %Y")),
                customdata = ~youtube_url,
                marker = list(size = ~count/2, color = ~color, line = list(width = 0))) %>%
      layout(xaxis = list(title = "Month"), 
             yaxis = list(title = "No. of times on Spotify charts"))
    
    p <- event_register(p, "plotly_click") 
    p
  })
  
  observe({
    song_info <- event_data("plotly_click", source = "lineGraph")
    if (!is.null(song_info)) {
      url <- song_info$customdata
      song_points$html_embed[1] <<- paste0('<iframe width="360" height="180" src="', url, '" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>')
    }
  })
  
  output$youtubeEmbed <- renderUI({
    HTML(song_points$html_embed[1])
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
      xlab("Artist") +
      ylab("Chart Appearances") +
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
  
}

shinyApp(ui = ui, server = server)