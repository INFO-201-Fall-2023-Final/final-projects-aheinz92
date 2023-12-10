library(dplyr)
library(stringr)
library(ggplot2)
library(tidyr)

# ----- Creating new columns for a total sum and two different rolling averages -----

joined_df <- read.csv("spotify_and_netflix_korean_monthly.csv")

# Create a new column for the sum of Netflix plus Spotify monthly presence
# IMPORTANT: Netflix added shows were a much lower count, usually, than Spotify song chartings.
# Therefore, it was decided to weight Netflix shows higher. This is very arbitary, and could be
# most usefully weighted anywhere from 2 to 10 times. We settled on 5 times.
joined_df$total_spotify_and_netflix <- joined_df$count_spotify_korean + (joined_df$count_netflix_korean * 5)

# Create a new column for a 3-month rolling average
joined_df$rolling_avg_3_month <- sapply(1:nrow(joined_df), function(i) {
  start_index <- max(1, i-2)
  round(mean(joined_df$total_spotify_and_netflix[start_index:i], na.rm = TRUE), 1)
})

# Create a new column for a 6-month rolling average
joined_df$rolling_avg_6_month <- sapply(1:nrow(joined_df), function(i) {
  start_index <- max(1, i-5)
  round(mean(joined_df$total_spotify_and_netflix[start_index:i], na.rm = TRUE), 1)
})



# ----- Testing out a plot of rolling averages to see the differences -----

# Convert the date_month column in the original dataframe
joined_df$date_month <- as.Date(paste0(joined_df$date_month, "-01"), format = "%Y-%m-%d")

# Reshape the data frame to long format for ggplot2
long_data <- pivot_longer(joined_df, 
                          cols = c("total_spotify_and_netflix", "rolling_avg_3_month", "rolling_avg_6_month"), 
                          names_to = "average_type", 
                          values_to = "average_value")

# Create a line chart using the reshaped data
joined_plot <- ggplot(long_data, aes(x = date_month, y = average_value, color = average_type, group = average_type)) +
  geom_line() +
  theme_minimal() + 
  labs(title = "3-Month vs 6-Month Rolling Averages",
       x = "Month",
       y = "Value", 
       color = "") + 
  scale_x_date(date_breaks = "4 months", date_labels = "%m/%y") +  # Corrected format here
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(joined_plot)



# ----- Using the 6-month rolling average to create a percent change value -----
joined_df$percent_change_6_month <- round((joined_df$rolling_avg_6_month - lag(joined_df$rolling_avg_6_month)) / lag(joined_df$rolling_avg_6_month) * 100, 2)
joined_df$percent_change_6_month[1] <- 0  # Setting the initial rate of change also to 0



# ----- Using the 6-month percent change to make a categorical trend value -----
joined_df$trend_6_month <- NA

for (i in 1:nrow(joined_df)) {
  percent_change <- joined_df$percent_change_6_month[i]
  
  if (percent_change > 50) {
    joined_df$trend_6_month[i] <- "Sharp Rise"
  } else if (percent_change >= 20) {
    joined_df$trend_6_month[i] <- "Rise"
  } else if (percent_change >= -20) {
    joined_df$trend_6_month[i] <- "Steady"
  } else if (percent_change >= -50) {
    joined_df$trend_6_month[i] <- "Decline"
  } else {
    joined_df$trend_6_month[i] <- "Sharp Decline"
  }
}

# Save a final CSV as a backup
write.csv(joined_df, "final_korean_media_data.csv")  # Backing up inner join to a CSV