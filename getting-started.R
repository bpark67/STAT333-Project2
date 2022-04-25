### Packages
install.packages("tm") # Text mining
install.packages("SnowballC") # Stemming
install.packages("wordcloud") # Creating wordclouds
install.packages("RColorBrewer")
install.packages("syuzhet") # Sentiment analysis
library(tm)
library(SnowballC)
library(wordcloud)
library(syuzhet)
library(ggplot2)
library(dplyr)

train_data = read.csv("train_yelp.csv",header=TRUE,stringsAsFactors=FALSE)

train_data %>%
  ggplot(aes(x=star))+
  geom_bar()

train_data %>%
  ggplot(aes(x=star, y = die))+
  geom_bar(stat="identity")

### Tokenizing the reviews
toSpace <- content_transformer(function (x, pattern ) gsub(pattern, " ", x))
#### Maybe Differnt Corpuses for Different Ratings
#### For 1 Star Reviews
txtdocs = list()
for (i in 1:5){
  txtdocs[[i]] = Corpus(VectorSource(train_data$text[train_data$star == i]))
  txtdocs[[i]] <- tm_map(txtdocs[[i]], toSpace, "/")
  txtdocs[[i]] <- tm_map(txtdocs[[i]], toSpace, "@")
  txtdocs[[i]] <- tm_map(txtdocs[[i]], toSpace, "\\|")
  txtdocs[[i]] <- tm_map(txtdocs[[i]],
                     content_transformer(tolower))
  txtdocs[[i]] <- tm_map(txtdocs[[i]], removeNumbers)
  txtdocs[[i]] <- tm_map(txtdocs[[i]], removeWords,
                     stopwords("english"))
  txtdocs[[i]] <- tm_map(txtdocs[[i]], removePunctuation)
  txtdocs[[i]] <- tm_map(txtdocs[[i]], stripWhitespace)
  txtdocs[[i]] <- tm_map(txtdocs[[i]], stemDocument)
}

###### Term Document Matrix
dtms = list()
dtvs = list()
dtds = list()
for (i in 1:5){
  dtms[[i]] = TermDocumentMatrix(txtdocs[[i]])
  dtms[[i]] = as.matrix(dtms[[i]])
  dtvs[[i]] = sort(rowSums(dtms[[i]]),decreasing=TRUE)
  dtds[[i]] = data.frame(word = names(dtvs[[i]]),freq=dtvs[[i]])
}

###### Top 5 Frequent Words
barplot(dtm1_d[1:5,]$freq, las = 2, names.arg =
          dtm1_d[1:5,]$word,
        col ="red", main ="Top 5 most
frequent words",
        ylab = "Word frequencies")

barplot(dtm2_d[1:5,]$freq, las = 2, names.arg =
          dtm2_d[1:5,]$word,
        col ="orange", main ="Top 5 most
frequent words",
        ylab = "Word frequencies")

###### Wordcloud
wordcloud(words = dtm2_d$word, freq = dtm2_d$freq,
          min.freq = 5,
          max.words=100, random.order=FALSE,
          rot.per=0.40,
          colors=brewer.pal(8, "Dark2"))


#### Melt all word frequencies into one big data frame
#### Use ggplot to creat 5 barplots. aes x = star
#### See which words differ the most
#### Use relative frequency
