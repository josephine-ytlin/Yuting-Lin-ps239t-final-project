setwd("/Users/yutinglin/desktop/239t/final")
#load csv data
meaningful_tweets_clean <- read.csv("meaningful_tweets_clean.csv")
mindfulness_pure_tweets_clean <- read.csv("mindfulness_pure_tweets_clean.csv")

library(magrittr)
# plot the top 15 words 
meaningful_tweets_clean %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "pink1", color = "pink1") +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in meaningful_life tweets")+
  theme_classic()+
  theme(text = element_text(size=16),
        plot.caption = element_text(colour="black",size=10),
        axis.text.y = element_text(colour="black",size=16),
        axis.text.x = element_text(colour="black",size=16),
        legend.text = element_text(colour="black",size=16))

mindfulness_pure_tweets_clean %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "deeppink", color = "deeppink") +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in mindfulness_pure tweets")+
  theme_classic()+
  theme(text = element_text(size=16),
        plot.caption = element_text(colour="black",size=10),
        axis.text.y = element_text(colour="black",size=16),
        axis.text.x = element_text(colour="black",size=16),
        legend.text = element_text(colour="black",size=16))
#found that there are lots of useless words needed to be removed by applying stop words
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)

nrow(meaningful_tweets_clean)
nrow(mindfulness_pure_tweets_clean)
# remove stop words from your list of words
cleaned_tweet_words <- meaningful_tweets_clean %>%
  anti_join(stop_words)
cleaned_tweet_words_mindfulness_pure <- mindfulness_pure_tweets_clean %>%
  anti_join(stop_words)
# there should be fewer words now
nrow(cleaned_tweet_words)
nrow(cleaned_tweet_words_mindfulness_pure)
# plot the top 15 words again after remove the stop words
cleaned_tweet_words %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "pink1", color = "pink1") +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Count of unique meaningful_life words found in tweets",
       subtitle = "Stop words removed from the list")+
  theme_classic()+
  theme(text = element_text(size=16),
        plot.caption = element_text(colour="black",size=10),
        axis.text.y = element_text(colour="black",size=16),
        axis.text.x = element_text(colour="black",size=16),
        legend.text = element_text(colour="black",size=16))


cleaned_tweet_words_mindfulness_pure %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "deeppink", color = "deeppink") +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Count of unique mindfulness_pure words found in tweets",
       subtitle = "Stop words removed from the list")+
  theme_classic()+
  theme(text = element_text(size=16),
        plot.caption = element_text(colour="black",size=10),
        axis.text.y = element_text(colour="black",size=16),
        axis.text.x = element_text(colour="black",size=16),
        legend.text = element_text(colour="black",size=16))


library(devtools)
#install_github("dgrtwo/widyr")
library(widyr)

# remove punctuation, convert to lowercase, add id for each tweet!
meaningful_tweets_paired_words <- meaningful_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n = 2)

meaningful_tweets_paired_words %>%
  count(paired_words, sort = TRUE)

library(tidyr)
meaningful_tweets_separated_words <- meaningful_tweets_paired_words %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

meaningful_tweets_filtered <- meaningful_tweets_separated_words %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

mindfulness_pure_tweets_paired_words <- mindfulness_pure_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n = 2)

mindfulness_pure_tweets_paired_words %>%
  count(paired_words, sort = TRUE)

library(tidyr)
mindfulness_pure_tweets_separated_words <- mindfulness_pure_tweets_paired_words %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

mindfulness_pure_tweets_filtered <- mindfulness_pure_tweets_separated_words %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
meaningful_words_counts <- meaningful_tweets_filtered %>%
  count(word1, word2, sort = TRUE)

head(meaningful_words_counts)

mindfulness_pure_words_counts <- mindfulness_pure_tweets_filtered %>%
  count(word1, word2, sort = TRUE)

head(mindfulness_pure_words_counts)

library(igraph)
library(ggraph)
library(ggthemes)
# plot word network #Fruchterman-Reingold layout(algorithms)
meaningful_words_counts %>%
  filter(n >= 24) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "pink1", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 5) +
  labs(title = "Word Network: Tweets includes meaningful life",
       subtitle = "Text mining twitter data ",
       x = "", y = "")+
  theme_classic()


mindfulness_pure_words_counts %>%
  filter(n >= 24) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "deeppink", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 5) +
  labs(title = "Word Network: Tweets includes mindfulness",
       subtitle = "Text mining twitter data ",
       x = "", y = "")+
  theme_classic()

############sentiment analysis############

# join sentiment classification to the tweet words
bing_word_counts <- meaningful_tweets_clean %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts_mindfulness_pure <- mindfulness_pure_tweets_clean %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

## Joining, by = "word"

bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(title = "Sentiment about meaningful life in tweets",
       y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()

bing_word_counts_mindfulness_pure %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(title = "Sentiment about mindfulness in tweets",
       y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()
## Selecting by n