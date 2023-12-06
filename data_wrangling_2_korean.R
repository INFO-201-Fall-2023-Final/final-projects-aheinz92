library(dplyr)
library(stringr)

# ----- Combine lists of Korean artist names into one data structure -----

# Read in K-pop data sets to get a full list of names, including any variations
idols_df <- read.csv("kpop_idols.csv")  # We want "Stage.Name", "Full.Name", "Korean.Name", and "K..Stage.Name"
boy_groups_df <- read.csv("kpop_idols_boy_groups.csv")  # We want "Name", "Short", and Korean.Name"
girl_groups_df <- read.csv("kpop_idols_girl_groups.csv")  # We want "Name", "Short", and Korean.Name"

# Extract all the name columns
idol_names <- c(idols_df$Stage.Name, idols_df$Full.Name, idols_df$Korean.Name, idols_df$K..Stage.Name)
boy_group_names <- c(boy_groups_df$Name, boy_groups_df$Short, boy_groups_df$Korean.Name)
girl_group_names <- c(girl_groups_df$Name, girl_groups_df$Short, girl_groups_df$Korean.Name)

# Combine into one list and remove duplicates
all_kpop_names <- unique(c(idol_names, boy_group_names, girl_group_names))

# Make a data frame
all_kpop_names_df <- data.frame(name = all_kpop_names)

# Write to a file to backup the list of Korean artist names
write.csv(all_kpop_names_df, "all_kpop_names.csv", row.names = FALSE)



# ----- Make a list of all unique artist names from the Spotify charts data -----

# Prepare a list of unique artists from the spotify charts
spotify_df <- read.csv("spotify_us_charts_months.csv")
spotify_grouped_df <- group_by(spotify_df, artist)  # Group by artist
spotify_artists_df <- summarize(spotify_grouped_df, count = n())  # Summarize by artist with the total count of rows
write.csv(spotify_artists_df, "spotify_artists.csv", row.names = FALSE)  # Write to a CSV in order to explore the artist data externally

artists_df <- read.csv("spotify_artists.csv")

# Split the artists and repeat the count values
artist_count_list <- mapply(function(artist, count) {
  artists_split <- strsplit(artist, ", ")[[1]]
  data.frame(artist = artists_split, count = rep(count, length(artists_split)))
}, artists_df$artist, artists_df$count, SIMPLIFY = FALSE)

# Flatten
all_artist_counts <- do.call(rbind, artist_count_list)

# Aggregate counts by artist
grouped_artists <- group_by(all_artist_counts, artist)
artists_unique_df <- summarize(grouped_artists, total_count = sum(count))

# Add the is_korean boolean column
artists_unique_df$is_korean <- FALSE

# Check the resulting data frame
head(artists_unique_df)

# Sort by count
artists_unique_df <- artists_unique_df[order(-artists_unique_df$total_count), ]

# Save this work in a CSV, just in case
write.csv(artists_unique_df, "spotify_unique_artists_plus_counts.csv", row.names = FALSE)



# ----- Check the unique artists list for matches with the Korean artists list  -----

# Check if an artist name is in the Korean artist list
check_korean <- function(artist_name, korean_names) {
  any(grepl(paste0("\\b", artist_name, "\\b"), korean_names, ignore.case = TRUE))
}

# Apply this function to each artist in artists_unique_df
artists_unique_df$is_korean <- sapply(artists_unique_df$artist, check_korean, all_kpop_names_df$name)

# Save this as a CSV to use in the main data wrangling R file
write.csv(artists_unique_df, "spotify_artists_is_korean.csv", row.names = FALSE)



# ----- Here spotify_artists_is_korean.csv was edited into CSV with a ----- 
# ----- single unique list of names of the Korean artists, -----
# ----- named spotify_list_of_korean_artists_in_dataset.csv -----



# ----- Finally, adding the is_korean field to the original Spotify data -----

# Load in a CSV that was reformatted a bit from the one we just created, to simply include a list 
# of artist names from the Spotify data set that are confirmed to be Korean
korean_artists_df <- read.csv("spotify_list_of_korean_artists_in_dataset.csv")

# A function to check that list against the artists in our big Spotify data frame
korean_artist_check <- function(artist_string, korean_artists) {
  artists_in_string <- unlist(strsplit(artist_string, ", "))
  any(korean_artists$artist %in% artists_in_string)
}

# Initializing the new column before running the function loop
spotify_df$is_korean <- FALSE

# Applying the function to the whole table, adding a boolean column is_korean
for (i in 1:nrow(spotify_df)) {
  spotify_df$is_korean[i] <- korean_artist_check(spotify_df$artist[i], korean_artists_df)
}

# Save into a CSV for later use
write.csv(spotify_df, "spotify_us_charts_months_is_korean.csv", row.names = FALSE)