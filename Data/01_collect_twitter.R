# load rtweet package
library(rtweet)

#create token and save it as an environment variable
create_token(
  app = "Yuting_twitter_research_app",
  consumer_key = "nt1ztb1gvhlsVIjtwkNdkZqlX",
  consumer_secret = "QAqtZlEUdQM5RCxVbUaokXuDf4v1uphNkWyvS3Tzfd2d1wRmDw")

#search for 5000 tweets includes "meaningful"+"life" and "mindfulness"+"peaceful"+"non-judgment"+"acceptance"+"awareness" 

meaningful_tweets <- search_tweets( "meaningful+life", n = 5000, include_rts = FALSE)
mindfulness_pure_tweets <- search_tweets( "mindfulness", n = 5000, include_rts = FALSE)

#save the data into csv file
library("readr")
setwd("/Users/yutinglin/desktop/239t/final")
write.table(meaningful_tweets$text, file = "meaningful_tweets.csv", sep = ",")
write.table(mindfulness_pure_tweets$text, file = "mindfulness_pure_tweets.csv", sep = ",")
