library(dplyr)
library(stringr)

# Trimming a 26 million row data set down to 455 thousand rows for just the US region's listening charts
spotify_df <- read.csv("spotify_charts.csv")
spotify_us_df <- filter(spotify_df, region == "United States")
write.csv(spotify_us_df, "spotify_us_charts.csv", row.names = FALSE)  # Saved to a CSV to use, since this process was very slow to repeat

# Adding a monthly date field to the Spotify data
spotify_df <- read.csv("spotify_us_charts.csv")
spotify_df$date_asdate <- as.Date(spotify_df$date)
spotify_df$date_month <- format(spotify_df$date_asdate, "%Y-%m")
write.csv(spotify_df, "spotify_us_charts_months.csv", row.names = FALSE)

# Trimming Netflix data to South Korean shows and adding a monthly date field
netflix_df <- read.csv("netflix_titles.csv")
netflix_kr_df <- filter(netflix_df, str_detect(country, "South Korea"))  # Filter data to Korean shows
netflix_kr_df$date_added_asdate <- as.Date(trimws(netflix_kr_df$date_added), format="%B %d, %Y")  # Make a better date format value
netflix_kr_df$date_month <- format(netflix_kr_df$date_added_asdate, "%Y-%m")  # Add a new column that labels the date by month only
write.csv(netflix_kr_df, "netflix_titles_months.csv", row.names = FALSE)