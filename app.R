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
  dashboardHeader(title = "Korean Media"),
  
  dashboardSidebar(
    width = 150,
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("info-circle")),
      menuItem("Big Picture", tabName = "overallTrend", icon = icon("line-chart")),
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
              h2("Introduction: Deep Dive on a Major Cultural Influence"),
              
              br(),
              
              wellPanel(
                style = "padding:15px; border-radius:10px; font-size: 17px; text-align: justify",
                
                p("We aimed to explore how media is exchanged globally across different cultures, 
                  with a focus on music and film. Our project zeroed in on a specific aspect of 
                  this dynamic: the growing influence of international arts in the US. In particular, 
                  we learned most from analyzing Korean media, a major source of cultural exchange 
                  in the US over the past decade."),
                p("By utilizing datasets featuring newly released Korean shows on Netflix and 
                  Spotify chart placements for Korean artists' songs, we tracked, charted, and 
                  analyzed the increasing prominence of these shows and music releases over time. 
                  We explored where and when certain songs became hits, where artists found success, 
                  and, most importantly, identified the overall trend of a significant international 
                  cultural impact on the US."),
                p("Please take a look and explore our interactive visualizations!"),
              ),
              
              br(),
              
              img(src="intro_image_purple_banner.jpg", style="display: block; margin: auto; max-width: 600px; align: center")
      ),
      
      
      
      
      
      
      tabItem(tabName = "overallTrend",
              
              h2("Big Picture: Overall Trends Over Time"),
              
              br(),
              
              fluidRow(
                column(5,
                       wellPanel(
                         style = "padding:15px; border-radius:10px",
                         
                         checkboxInput("showRawTotal", "Raw Total", value = TRUE),
                         checkboxInput("showRollingAvg3", "3-Month Rolling Average", value = TRUE),
                         checkboxInput("showRollingAvg6", "6-Month Rolling Average", value = TRUE),
                         checkboxInput("showLinearTrend", "Linear Trend Line", value = TRUE),
                         
                         p("Use the checkboxes to choose which lines you want to see on the graph.")
                       )
                ),
                column(7,
                       wellPanel(
                         style = "padding:15px; border-radius:10px",
                         
                         p("This primary view provides a comprehensive overview of the presence of 
                           Korean media on both Netflix and Spotify over time. It combines the 
                           number of new Korean releases on Netflix, which are more heavily weighted, 
                           with the frequency of Korean artists' songs appearing on the US Spotify charts."),
                         p("As the raw data contains many spikes, we explored methods to discern the 
                           overall trends. The smoothed results, derived from rolling averages over 
                           both 3-month and 6-month periods, are displayed and accompanied by an overall 
                           trend line depicting the gradual upward growth from early 2017 to late 2021.")
                       )
                )
              ),
              tags$div(
                style = "max-width: 800px; margin: 0 auto;",
                plotOutput("stackedLineChart")
              )
      ),
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      tabItem(tabName = "songImpact",
              h2("Song Impact: Where Individual Songs Peaked"),
              
              br(),

              fluidRow(
                column(5,
                       wellPanel(
                         style = "padding:15px; border-radius:10px",
                         
                         sliderInput("songRange", "Minimum Song Popularity", min = 10, max = 50, value = 35, step = 5),
                         
                         p("Use the slider to select the minimum popularity threshold for which 
                           songs are visible as points on the graph."),
                         p("For example, selecting 25 on the slider will display markers for songs 
                           which appeared 25 or more times on US Spotify charts in a single month.")
                       ),
                ),
                
                column(7,
                       wellPanel(
                         style = "padding:15px; border-radius:10px",
                         
                         p("To gain a clearer understanding of what influenced the growth of Korean 
                           pop music's popularity in the US, this chart displays individual songs 
                           that spiked in popularity, highlighting exactly when these spikes occurred."),
                         p("The blue line represents the cumulative monthly presence of Korean 
                           artists on the US Spotify top charts, as derived from Spotify data. 
                           As you explore the data with the slider, markers will appear to indicate 
                           each song that exceeded a specific threshold of chart appearances within that month."),
                         p("Bigger dots indicate songs with greater popularity, while different 
                           colors denote various bands and artists. You can also hover over the 
                           dots to view detailed information about the song, artist, and its popularity")   
                       )
                )
              ),
              
              br(),
              
              tags$div(
                style = "max-width: 800px; margin: 0 auto;",
                plotlyOutput("lineGraph")
              ),
              
              br(),
              
              HTML("<div style='text-align: center;'>Note: JENNIE and LISA (members of BLACKPINK) and V (member of BTS) are officially
                   <br>categorized as separate artists and have differently colored dots on the chart.</div>"),
      ),  
      
      
      
      
      
      
      
      
      
      tabItem(tabName = "artistPopularity",
              
              h2("Artist Breakdown: Overall Influence Broken Down By Song"),
              
              br(),
              
              
              fluidRow(
                column(5,
                       wellPanel(
                         style = "padding:15px; border-radius:10px; text-align: justify",
                         
                         sliderInput("barSlider",
                                     "Range of Artist Popularity:", 
                                     min = 0, 
                                     max = 100,
                                     step = 10,
                                     value = c(10, 60)
                         ),
                         
                         tags$p("Use the slider to pick a range of popularity for the visible artists on the 
                           bar chart. For example, choosing 30 to 100 will display bars for all artists 
                           who had between 30 and 100 (inclusive) appearances on the US Spotify charts over 
                           the entire data set.", style = "font-size: 12px"),
                         
                         tags$div(style = "text-align: center; font-size: 20px; line-height: 20px; font-weight: bold;",
                                  checkboxInput("showBTS", "Show BTS?", value = FALSE)
                         ),
                         
                         tags$p("BTS has such a massive popularity that it dwarfs all of the other artists, 
                            making the scale for the others harder to see in detail. Use this checkbox 
                            to entirely toggle the bar for BTS on the chart.", style = "font-size: 11px")
                       ),
                ),
                
                column(7,
                       wellPanel(
                         style = "padding:15px; border-radius:10px; font-size: 17px; text-align: justify",
                         p("We can delve deeper into individual artists to uncover which songs contributed 
                           most to their popularity. Here, you'll find a visual representation of each 
                           artist's most successful songs in the US."),
                         p("The bars represent each artist's total chart popularity, with differently 
                           colored segments indicating the contributions of individual songs."),
                         p("Hover over the bars to discover exactly which songs correspond to each segment!")
                       )
                )
              ),
              
              br(),
              
              tags$div(
                style = "max-width: 800px; margin: 0 auto;",
                plotlyOutput("stackedBarChart")
              )
      ),
      
      
      
      
      
      
      tabItem(tabName = "conclusions",
              h2("Conclusion: Trends and Impacts Through Data"),
              
              br(),
              
              wellPanel(
                style = "padding:15px; border-radius:10px; font-size: 17px; text-align: justify",
                
                p("You can see the overall growth trend of Korean media popularity in the US, 
                  in film, television, and particularly in music. Despite occasional peaks and 
                  valleys, there's a discernible upward trend over time. "),
                p("The visualizations clearly demonstrate the immense impact of the musical group BTS 
                  on the entire landscape. Their popularity eclipses that of other Korean artists. 
                  This is similarly true for BLACKPINK, with both groups contributing to the 
                  popularity of solo projects from their members, who are among the most celebrated 
                  Korean artists. Moreover, the success of BTS and BLACKPINK has seemingly 
                  paved the way for numerous other Korean artists to make their mark on the Spotify charts."),
                p("Based on this data, we believe Korean music and shows will increasingly become more 
                  prevalent and popular in America, fostering greater global awareness and appreciation of artists worldwide."),
              ),
              
              br(),
              
              img(src="positive trend.png", style="display: block; margin: auto; max-width: 600px; align: center")
              
              
      )
      
      
      
      
      
      
      
      
      
      
      
    )
  )
)

server <- function(input, output) {
  
  
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
    
    p <- p + 
      scale_color_manual(values = c("Raw Total" = "#b0c7f5", "3-Month Avg" = "#7debbb", "6-Month Avg" = "#e4eb7d", "Linear Trend" = "grey")) +
      scale_x_date(date_breaks = "6 months", date_labels = "%Y-%m")
    
    p
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # Declaring song_points outside of lineGraph so we can use it in other things
  song_points <- reactive({
    req(input$songRange)  
    
    songs_and_months_df[songs_and_months_df$count >= input$songRange,]
  })
  
  
  # Line Graph with Points, for Song Impact page
  output$lineGraph <- renderPlotly({
    # Using the previuosly defined song_points as our data
    data <- song_points()
    
    # Conversion of date/month to Date type
    summary_df$date_month <- as.Date(summary_df$date_month, format="%Y-%m-%d")
    
    # Spotify totals line, with some slight splining
    spline_model <- lm(count_spotify_korean ~ bs(date_month, df = 17), data = summary_df)
    new_count_spotify_korean <- predict(spline_model, newdata = list(date_month = summary_df$date_month))
    summary_df$new_count_spotify_korean <- new_count_spotify_korean
    
    # Filter songs_and_months_df based on the slider
    data <- songs_and_months_df[songs_and_months_df$count >= input$songRange, ]
    data$date_month <- as.Date(paste0(data$date_month, "-01"), format="%Y-%m-%d")
    songs_and_months_df$date_month <- as.Date(paste0(songs_and_months_df$date_month, "-01"), format="%Y-%m-%d")
    summary_df$date_month <- as.Date(paste0(summary_df$date_month, "-01"), format="%Y-%m-%d")
    
    # Remove songs that have dates beyond the scope of the Netflix + Spotify data set summary
    data <- data[data$date_month <= max(summary_df$date_month),]
    
    # Join data and summary_df by date_month
    data <- merge(data, summary_df, by = "date_month", all.x = TRUE)
    
    # Interpolate the y values for data
    data$new_count_spotify_korean <- approx(summary_df$date_month, summary_df$new_count_spotify_korean, xout = data$date_month)$y
    
    p <- plot_ly() %>%
      add_trace(data = summary_df, 
                x = ~date_month, 
                y = ~new_count_spotify_korean, 
                type = "scatter", 
                mode = "lines", 
                hoverinfo = "none",
                showlegend = FALSE)

    p <- p %>%
      add_trace(data = data, 
                x = ~date_month, 
                y = ~new_count_spotify_korean, 
                name = "Song Points", 
                type = "scatter", 
                mode = "markers", 
                hoverinfo = "text",
                text = ~paste(title, "by", artist, "<br>Charted", count, "times in", format(date_month, "%B %Y")), 
                marker = list(size = ~count/2, color = ~chart_color, line = list(width = 0))) %>%
      layout(xaxis = list(title = "Month"), 
             yaxis = list(title = "No. of times on Spotify charts")) %>%
      config(displayModeBar = FALSE)
    
    p
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
}

shinyApp(ui = ui, server = server)