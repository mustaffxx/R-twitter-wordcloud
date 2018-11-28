library(wordcloud2)
library(rtweet)
library(httpuv)
library(tidytext)
library(tidyverse)

create_token(
  app = "my_twitter_research_app",
  consumer_key = "your_consume_key",
  consumer_secret = "your_secret_key")

user = "twitter_user"

#get 500 tweets from the timeline and transforms into date frame
myuser <- get_timeline(user, n = 500, home = FALSE)
#head(myuser$text)

df <- data.frame(text = matrix(unlist(myuser[5]), byrow = TRUE), stringsAsFactors = FALSE)
#View(df)

#remove links, numbers and other regular expressions
subs <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&alt;|&gt;|RT|https|@"

df_tokens <- df %>% mutate(text = str_replace_all(text, subs, "")) %>% 
  unnest_tokens(words, text)
#View(df_tokens)


#https://github.com/stopwords-iso/stopwords-pt/blob/master/stopwords-pt.txt save as csv
stopwords_pt <- read_csv("stopwords.csv", col_names = "words")
#View(stopwords_pt)

df_tokens <- anti_join(df_tokens, stopwords_pt)

#removes words with less than 3 characters
#in my language many regular expressions have this number of characters
words <- subset(df_tokens$words, nchar(df_tokens$words) >= 3 ) %>% data.frame(words = .,
                                                                                       stringsAsFactors = F)
words <- count(words, words, sort = T)
#View(words)

words <- words[1:350, ]

wordcloud2(words, size = 1.6)
