library(dplyr)
library(stringr)

netflix_df <- read.csv("netflix_titles.csv")
netflix_kr_df <- filter(netflix_df, str_detect(country, "South Korea"))  # Filter data to Korean shows
netflix_kr_df$date_added_asdate <- as.Date(trimws(netflix_kr_df$date_added), format="%B %d, %Y")  # Make a better date format value
netflix_kr_df$date_month <- format(netflix_kr_df$date_added_asdate, "%Y-%m")  # Add a new column that labels the date by month only

spotify_df <- read.csv("spotify_us_charts.csv")
spotify_df$date_asdate <- as.Date(spotify_df$date)
spotify_df$date_month <- format(spotify_df$date_asdate, "%Y-%m")



korean_artists_df <- read.csv("spotify_list_of_korean_artists_in_dataset.csv")

korean_artist_check <- function(artist_string, korean_artists) {
  artists_in_string <- unlist(strsplit(artist_string, ", "))
  any(korean_artists$artist %in% artists_in_string)
}

spotify_df$is_korean <- FALSE  # Initializing the new column before running the function loop

for (i in 1:nrow(spotify_df)) {
  spotify_df$is_korean[i] <- korean_artist_check(spotify_df$artist[i], korean_artists_df)
}



netflix_kr_grouped_df <- group_by(netflix_kr_df, date_month)
netflix_kr_monthly_df <- summarize(netflix_kr_grouped_df, count_netflix_korean = n())

spotify_grouped_df <- group_by(spotify_df, date_month)
spotify_monthly_df <- summarize(spotify_grouped_df, count_spotify_korean = sum(is_korean, na.rm = TRUE))

joined_df_outer <- merge(x = spotify_monthly_df, y = netflix_kr_monthly_df, all = TRUE)  # This adds NA for some quarters not shared
joined_df_inner <- merge(x = spotify_monthly_df, y = netflix_kr_monthly_df)  # This only keeps the shared months
write.csv(joined_df_inner, "spotify_and_netflix_korean_monthly.csv")  # Backing up to a CSV