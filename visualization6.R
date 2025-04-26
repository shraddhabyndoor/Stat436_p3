library(ggplot2)
library(dplyr)
library(wordcloud)
library(RColorBrewer)
library(viridis)


# Load dataset
high_popularity_data <- read.csv("https://raw.githubusercontent.com/shraddhabyndoor/project2_stat436/refs/heads/main/high_popularity_spotify_data.csv")

# Aggregate artist popularity
artist_popularity <- high_popularity_data %>% 
  group_by(track_artist) %>% 
  summarise(total_popularity = sum(track_popularity, na.rm = TRUE)) %>% 
  arrange(desc(total_popularity))


# Generate the word cloud
set.seed(1234)
wordcloud(words = artist_popularity$track_artist, 
          freq = artist_popularity$total_popularity, 
          min.freq = 1, 
          max.words = 100, 
          #colors = brewer.pal(8, "Dark2"), 
          colors = viridis(10),
          scale = c(2.5, 0.3),  # Reduce size
          random.order = FALSE, 
          rot.per = 0.1)  # Reduce rotation
