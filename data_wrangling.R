# INFO 201, group of Austin, Ross, and Yashita
# We completed this assignment with only our own group and no external help.
# This data_wrangling.R is a combination of 4 data wrangling .R files
# that were originally separate. The code from each is pasted together here.
# If you want to see the original process, please refer to the other files:
# data_wrangling_1, 2, 3, and 4.
library(dplyr)
library(stringr)
library(ggplot2)

# Trimming a 26 million row data set down to 455 thousand rows for just the US region's listening charts.
# Don't run this part again, 3.5 GB file is too big to put on GitHub so it can't be submitted with loading this csv.
#spotify_df <- read.csv("spotify_charts.csv")
#spotify_us_df <- filter(spotify_df, region == "United States")
#write.csv(spotify_us_df, "spotify_us_charts.csv", row.names = FALSE)  # Saved to a CSV to use, since this process was very slow to repeat

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
# ----- single unique list of names of the Korean artists -----



# ----- Finally applying this is_korean field to the original Spotify data -----

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









netflix_kr_df <- read.csv("netflix_titles_months.csv")
netflix_kr_grouped_df <- group_by(netflix_kr_df, date_month)
netflix_kr_monthly_df <- summarize(netflix_kr_grouped_df, count_netflix_korean = n())

spotify_df <- read.csv("spotify_us_charts_months_is_korean.csv")
spotify_grouped_df <- group_by(spotify_df, date_month)
spotify_monthly_df <- summarize(spotify_grouped_df, count_spotify_korean = sum(is_korean, na.rm = TRUE))

joined_df_outer <- merge(x = spotify_monthly_df, y = netflix_kr_monthly_df, all = TRUE)  # This adds NA for some quarters not shared
joined_df_inner <- merge(x = spotify_monthly_df, y = netflix_kr_monthly_df)  # This only keeps the shared months
write.csv(joined_df_inner, "spotify_and_netflix_korean_monthly.csv")  # Backing up inner join to a CSV











# ----- Creating new columns for a total sum and two different rolling averages -----

joined_df <- read.csv("spotify_and_netflix_korean_monthly.csv")

# Create a new column for the sum of Netflix plus Spotify monthly presence
joined_df$total_spotify_and_netflix <- joined_df$count_spotify_korean + joined_df$count_netflix_korean

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



