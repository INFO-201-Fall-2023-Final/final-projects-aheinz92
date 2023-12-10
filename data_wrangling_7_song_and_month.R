library(dplyr)
library(stringr)

spotify_df <- read.csv("spotify_us_charts_months_is_korean.csv")

# Create a data set groups on songs and months, to see how many times
# a particular song charted in a single month on Spotify.
# This is used to create the points on the line chart of Song Impact.

# Filter to just the songs by Korean artists
spotify_korean_df <- filter(spotify_df, is_korean == TRUE)

# Group by song title and month
spotify_korean_grouped_df <- group_by(spotify_korean_df, title, artist, date_month)
spotify_korean_song_month_df <- summarize(spotify_korean_grouped_df, count = n())

# Save as a CSV for backup and other use
write.csv(spotify_korean_song_month_df, "spotify_korean_song_month.csv")

spotify_korean_song_month_unique_df <- spotify_korean_song_month_df %>%
  group_by(date_month) %>%
  filter(count == max(count)) %>%
  slice(1)  # In case of two songs with a shared maximum count, limit to 1

# Save as a CSV for backup and other use
write.csv(spotify_korean_song_month_unique_df, "spotify_korean_song_month_unique.csv")

# I then manually edited this CSV to add a new column 'korean_artist' which
# separates out the featured or collaborative artists, when present

# I also added custom color codes to each row for their display in a visualization

# I also added youtube links for the songs in order to test embedding