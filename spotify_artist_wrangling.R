library(dplyr)
library(stringr)

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
#write.csv(artists_unique_df, "spotify_unique_artists_plus_counts.csv", row.names = FALSE)





# Read in K-pop data sets to get a full list of names
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
#write.csv(all_kpop_names_df, "all_kpop_names.csv", row.names = FALSE)




# Check if an artist name is in the Korean artist list
check_korean <- function(artist_name, korean_names) {
  any(grepl(paste0("\\b", artist_name, "\\b"), korean_names, ignore.case = TRUE))
}

# Apply this function to each artist in artists_unique_df
artists_unique_df$is_korean <- sapply(artists_unique_df$artist, check_korean, all_kpop_names_df$name)

# Save this as a CSV to use in the main data wrangling R file
#write.csv(artists_unique_df, "spotify_artists_is_korean.csv", row.names = FALSE)




# OLD CODE THAT I USED BEFORE, UNTIL I REALIZED I WANTED "COUNT" STILL REPRESENTED

# Split the artist strings into separate names
#split_artists <- strsplit(artists_df$artist, ", ")

# Unlist and flatten the list of artist vectors into a single vector
#all_artists <- unlist(split_artists)  # 8,061 total non-unique artist mentions

# Get unique artist names
#unique_artists <- unique(all_artists)  # 4,834 unique artists

# How many collaborative tracks are there?
#count <- sum(grepl(", ", artists_df$artist))  # 2,019 total collaborative tracks

# Create a quick data frame to start checking if artists are Korean
#artists_unique_df <- data.frame(artist = unique_artists, is_korean = rep(FALSE, length(unique_artists)))