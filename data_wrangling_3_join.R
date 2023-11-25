library(dplyr)
library(stringr)

netflix_kr_df <- read.csv("netflix_titles_months.csv")
netflix_kr_grouped_df <- group_by(netflix_kr_df, date_month)
netflix_kr_monthly_df <- summarize(netflix_kr_grouped_df, count_netflix_korean = n())

spotify_df <- read.csv("spotify_us_charts_months_is_korean.csv")
spotify_grouped_df <- group_by(spotify_df, date_month)
spotify_monthly_df <- summarize(spotify_grouped_df, count_spotify_korean = sum(is_korean, na.rm = TRUE))

joined_df_outer <- merge(x = spotify_monthly_df, y = netflix_kr_monthly_df, all = TRUE)  # This adds NA for some quarters not shared
joined_df_inner <- merge(x = spotify_monthly_df, y = netflix_kr_monthly_df)  # This only keeps the shared months
write.csv(joined_df_inner, "spotify_and_netflix_korean_monthly.csv")  # Backing up inner join to a CSV