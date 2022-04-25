# install.packages("gdata")
library(gdata)
library(reshape2)
library(ggplot2)

############# Read in the word frequency tables #########
oneStar = read.csv("oneStar.csv")
twoStar = read.csv("twoStar.csv")
threeStar = read.csv("threeStar.csv")
fourStar = read.csv("fourStar.csv")
fiveStar = read.csv("fiveStar.csv")

############## Read in the training data set #############
df_train = read.csv("./#Guides/train_yelp.csv")
df_test = read.csv("./#Guides/test_yelp.csv")

########### Read in the counts ##################
df_counts = df_train %>%
  group_by(star) %>%
  count()

####### Combine all the word frequency plots and rename the labels####
df = combine(oneStar, twoStar, threeStar, fourStar, fiveStar)
levels(df$source) = c(1, 2, 3, 4, 5)

################ List of unique words##################
uniqueWords = unique(df$Word)

########### Create a list of word frequencies for each word ##########
wordsRelFreq = list()
for (i in 1:length(uniqueWords)){
  cat("Processing", i, "\n")
  temp <- df %>%
    filter(Word == uniqueWords[i]) %>%
    mutate(Frequency = Count/df_counts$n[source])
  add <- c(1:5)[!1:5 %in% temp$source]
  df_add <- data.frame(Word = rep(temp$Word[1], length(add)),
                       Count = rep(0, length(add)),
                       source = add,
                       Frequency = rep(0, length(add)))
  temp <- rbind(temp, df_add)
  temp = temp[order(temp$source),]
  wordsRelFreq[[i]] = temp
}

############ Filter out only strictly increasing or decreasing####
unsorted = vector()
for (i in 1:length(uniqueWords)){
  cat("Processing", i, "\n")
  if (is.unsorted(wordsRelFreq[[i]]$Frequency)){
    if (is.unsorted(-wordsRelFreq[[i]]$Frequency)){
      unsorted = c(unsorted, i)
    }
  }
}
sorted = wordsRelFreq[-unsorted]
# There are 11414 ascending, descending words
################### Filter out words in all five ratings##########
toosmall = vector()
for (i in 1:length(sorted)){
  cat("Processing", i, "\n")
  if (all(sorted[[i]]$Count < 30)){
    toosmall = c(toosmall, i)
  }
}
atleast = sorted[-toosmall]
# 220 words
#################### Order all five by level of difference#########
magnitude = vector()
for (i in 1:length(atleast)){
  magnitude = c(magnitude, abs(atleast[[i]]$Frequency[5]-atleast[[i]]$Frequency[1]))
}

ordered = atleast[order(magnitude, decreasing = T)]

# Create word list
atleast30 = vector()
for (i in 1:length(ordered)){
  atleast30 = c(atleast30, ordered[[i]]$Word[1])
}

##################### Plots of 220 words #########################
plots = list()
for (i in 1:length(ordered)){
  p <- ordered[[i]]%>%
    ggplot(aes(x = source, y = Frequency, fill = source))+
    geom_bar(stat = "identity")+
    ggtitle(ordered[[i]]$Word[1])+
    scale_fill_manual(values = c("red", "orange", "yellow", "lightgreen", "green"))
  plots[[i]] = p
}

for (i in 1:length(ordered)){
  png(paste("Words_220/", i, ".", ordered[[i]]$Word[1], ".png", sep = ""))
  print(plots[[i]])
  dev.off()
}

##################### What words never appear in 5 stars #######################
neverInFive = vector()
for (i in 1:length(sorted)){
  cat("Processing", i, "\n")
  if (sorted[[i]]$Count[sorted[[i]]$source==5]==0){
    neverInFive = c(neverInFive, i)
  }
}
neverInFiveList = sorted[neverInFive]

magnitude = vector()
for (i in 1:length(neverInFiveList)){
  magnitude = c(magnitude, neverInFiveList[[i]]$Count[1])
}

orderedbyMag = neverInFiveList[order(magnitude, decreasing = T)]

plots = list()
for (i in 1:length(orderedbyMag)){
  p <- orderedbyMag[[i]]%>%
    ggplot(aes(x = source, y = Frequency, fill = source))+
    geom_bar(stat = "identity")+
    ggtitle(orderedbyMag[[i]]$Word[1])+
    scale_fill_manual(values = c("red", "orange", "yellow", "lightgreen", "green"))
  plots[[i]] = p
}

for (i in 1:length(orderedbyMag)){
  png(paste("NeverInFive/", i, ".", orderedbyMag[[i]]$Word[1], ".png", sep = ""))
  print(plots[[i]])
  dev.off()
}

# Create word list
neverInFiveWords = vector()
for (i in 1:length(orderedbyMag)){
  neverInFiveWords = c(neverInFiveWords, orderedbyMag[[i]]$Word[1])
}

##################### What words never appear in 1 stars #######################
#####################            Not Useful              #######################
neverInOne = vector()
for (i in 1:length(sorted)){
  cat("Processing", i, "\n")
  if (sorted[[i]]$Count[sorted[[i]]$source==1]==0){
    if (sorted[[i]]$Count[sorted[[i]]$source == 5] >=10){
      neverInOne = c(neverInOne, i)
    }
  }
}
neverInOneList = sorted[neverInOne]

magnitude = vector()
for (i in 1:length(neverInOneList)){
  magnitude = c(magnitude, neverInOneList[[i]]$Count[5])
}

orderedbyMag = neverInOneList[order(magnitude, decreasing = T)]

plots = list()
for (i in 1:length(orderedbyMag)){
  p <- orderedbyMag[[i]]%>%
    ggplot(aes(x = source, y = Frequency, fill = source))+
    geom_bar(stat = "identity")+
    ggtitle(orderedbyMag[[i]]$Word[1])+
    scale_fill_manual(values = c("red", "orange", "yellow", "lightgreen", "green"))
  plots[[i]] = p
}

for (i in 1:length(orderedbyMag)){
  png(paste("NeverInOne/", i, ".", orderedbyMag[[i]]$Word[1], ".png", sep = ""))
  print(plots[[i]])
  dev.off()
}


#### Use the ordered to filter out most likely predictors
#### Use Lasso Multinomial