library(tidyverse) #many libraries for tidy
library(tidytext) #for tidy

setwd("/Users/yutinglin/desktop/239t/final")
#load csv data
meaningful_tweets$text <- read.csv("meaningful_tweets.csv")
mindfulness_pure_tweets$text <- read.csv("mindfulness_pure_tweets.csv")
#look at the text first
head(meaningful_tweets$text)
head(mindfulness_pure_tweets$text)

#start to clean the data
meaningful_tweets$stripped_text <- gsub("http.*","", meaningful_tweets$text)
meaningful_tweets$stripped_text <- gsub("https.*","", meaningful_tweets$stripped_text)

mindfulness_pure_tweets$stripped_text <- gsub("http.*","", mindfulness_pure_tweets$text)
mindfulness_pure_tweets$stripped_text <- gsub("https.*","", mindfulness_pure_tweets$stripped_text)

# remove punctuation, convert to lowercase, add id for each tweet!
#store the token words from each tweet
meaningful_tweets_clean <- meaningful_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)

mindfulness_pure_tweets_clean <- mindfulness_pure_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)

#save the data into csv file
library("readr")
setwd("/Users/yutinglin/desktop/239t/final")
write.table(meaningful_tweets_clean, file = "meaningful_tweets_clean.csv", sep = ",")
write.table(mindfulness_pure_tweets_clean, file = "mindfulness_pure_tweets_clean.csv", sep = ",")
