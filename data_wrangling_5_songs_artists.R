library(dplyr)
library(stringr)

spotify_df <- read.csv("spotify_us_charts_months_is_korean.csv")

# Filter the data down to only the charting songs by Korean artists
spotify_korean_only_df <- filter(spotify_df, is_korean == TRUE)

# Correct the artists listed with features and collaborations to just focus on the Korean artists involved
replace_values_bts <- c("BTS, Charli XCX", "BTS, Juice WRLD", "BTS, Nicki Minaj", "BTS, Steve Aoki", 
                        "BTS, Zara Larsson", "Halsey, SUGA, BTS", "Coldplay, BTS")
spotify_korean_only_df$artist[spotify_korean_only_df$artist %in% replace_values_bts] <- "BTS"
spotify_korean_only_df$artist[spotify_korean_only_df$artist == "Dua Lipa, BLACKPINK"] <- "BLACKPINK"
spotify_korean_only_df$artist[spotify_korean_only_df$artist == "j-hope, Supreme Boi"] <- "j-hope"

# Summarize the total times on charts by each Korean artist

spotify_korean_only_grouped_artist_df <- group_by(spotify_korean_only_df, artist)
spotify_korean_artist_totals_df <- summarize(spotify_korean_only_grouped_artist_df, times_on_chart = n())  
write.csv(spotify_korean_artist_totals_df, "spotify_korean_artist_totals.csv", row.names = FALSE)

# Summarize the total times on charts by each song by a Korean artist
spotify_korean_only_grouped_song_df <- group_by(spotify_korean_only_df, title, artist)
spotify_korean_song_totals_df <- summarize(spotify_korean_only_grouped_song_df, times_on_chart = n())
write.csv(spotify_korean_song_totals_df, "spotify_korean_song_totals.csv", row.names = FALSE)