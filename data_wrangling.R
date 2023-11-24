library(dplyr)
library(stringr)

#   This previously executed code trimmed a 26 million row data set down to 455 thousand rows,
#   by limiting the top chart data to just the United States region.
#spotify_df <- read.csv("spotify_charts.csv")
#spotify_us_df <- filter(spotify_df, region == "United States")
#write.csv(spotify_us_df, "spotify_us_charts.csv", row.names = FALSE)

#   Read in the Netflix data set, to try to summarize it successfully in a useful way
netflix_df <- read.csv("netflix_titles.csv")
#   CAVEAT: Netflix "country" data is apparently "Country where the movie / show was produced"
#   and it isn't sure if this exactly matches out purposes in using the data for conclusions.

#   Function that returns a quarter of the year when given a month
get_quarter <- function(month) {
  if (month %in% 1:3) {
    return("Q1")
  } else if (month %in% 4:6) {
    return("Q2")
  } else if (month %in% 7:9) {
    return("Q3")
  } else {
    return("Q4")
  }
}


#   Add a new column that labels the date by quarter, ran previously.
#   This took a while on 455k rows, so we wrote a new CSV with the added column to re-use.
#spotify_df <- read.csv("spotify_us_charts.csv")
#
#spotify_df$date_quarter <- sapply(as.Date(spotify_df$date), function(date) {
#  if (!is.na(date)) {
#    year <- format(date, "%Y")
#    month <- as.numeric(format(date, "%m"))
#    quarter <- get_quarter(month)
#    return(paste(year, quarter))
#  } else {
#    return(NA)
#  }
#})
#
#write.csv(spotify_df, "spotify_us_charts_quarterly.csv", row.names = FALSE)





# This prepared a list of artists to work with in spotify_artist_wrangling.R
#spotify_df <- read.csv("spotify_us_charts_quarterly.csv")
#spotify_grouped_df <- group_by(spotify_df, artist)  # Group by artist
#spotify_artists_df <- summarize(spotify_grouped_df, count = n())  # Summarize by artist with the total count of rows
#write.csv(spotify_artists_df, "spotify_artists.csv", row.names = FALSE)  # Write to a CSV in order to explore the artist data externally

# Next, work was done in spotify_artist_wrangling.R to find which artists are Korean.
# Now we will apply a CSV that contains a column saying if each artist name is Korean or not.

#   Read in the smaller new CSV of just United States data from Spotify (1.7% of the original row count)
#   with an added column for the quarter of the year.
#spotify_df <- read.csv("spotify_us_charts_quarterly.csv")
#korean_df <- read.csv("spotify_artists_is_korean.csv")

# Initialize new column is_korean (default value is false)
#spotify_df$is_korean <- FALSE

# Function to check if the artists are korean, using our other data frame
# 'artist_string' is the whole 'artist' field from spotify_df, which could have comma-separated collaborators
# 'korean_artists' is the entire list of artists and their is_korean boolean value
#korean_artist_check <- function(artist_string, korean_artists) {
#  artists_in_string <- unlist(strsplit(artist_string, ", "))  # Split the collaborator string by the commas
#  any(korean_artists$artist %in% artists_in_string & korean_artists$is_korean)  # Check for any Korean artists
#}

# Use the korean_artist_check function across all the rows of artists
#for (i in 1:nrow(spotify_df)) {
#  spotify_df$is_korean[i] <- korean_artist_check(spotify_df$artist[i], korean_df)
#}

# Save this new dataframe again as a backup
#write.csv(spotify_df, "spotify_us_charts_quarterly_with_korean.csv")



# Import that CSV again after trimming off some unnecessary columns and fixing a few false positives in is_korean.
# Some simple names had false positives, so the smaller list of artists was checked over manually to fix some,
# like Aurora, Jax, Kyla, Kai, Kyle, Q, Kato, and more artists with those sorts of names.
spotify_df <- read.csv("spotify_us_charts_quarterly_with_korean.csv")

# Summarize with the number of top Korean tracks per quarter
spotify_grouped_df <- group_by(spotify_df, date_quarter)
spotify_quarterly_df <- summarize(spotify_grouped_df, count_spotify_korean = sum(is_korean, na.rm = TRUE))




#   Netflix$country is a LIST of any production countries, so we will simply find "Korea" in that list.
netflix_kr_df <- filter(netflix_df, str_detect(country, "South Korea"))  # Filter data to Korean shows

#   Attempting to create a date column using quarters of the year
netflix_kr_df$date_added_asdate <- as.Date(trimws(netflix_kr_df$date_added), format="%B %d, %Y")  # Make a better date format value

#   Add a new column that labels the date by quarter
netflix_kr_df$date_quarter <- sapply(netflix_kr_df$date_added_asdate, function(date) {
  if (!is.na(date)) {
    year <- format(date, "%Y")
    month <- as.numeric(format(date, "%m"))
    quarter <- get_quarter(month)
    return(paste(year, quarter))
  } else {
    return(NA)
  }
})

netflix_kr_grouped_df <- group_by(netflix_kr_df, date_quarter)  # Group by quarter
netflix_kr_quarterly_df <- summarize(netflix_kr_grouped_df, count_netflix_korean = n())  # Summarize with the total count of shows each quarter




# JOINING the two cleaned per-quarter tables
#joined_df_outer <- merge(x = spotify_quarterly_df, y = netflix_kr_quarterly_df, all = TRUE)  # This adds NA for some quarters not shared
joined_df_inner <- merge(x = spotify_quarterly_df, y = netflix_kr_quarterly_df)  # This removes 4 quarters not shared by both data sets
write.csv(joined_df_inner, "spotify_and_netflix_korean_quarterly.csv")  # Backing up to a CSV

# The inner join seems better, so we have data from each set for each quarter to visualize.







