import requests
from bs4 import BeautifulSoup
import re
import nltk
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import csv

"""
Read in Training Data
"""
df_train = pd.read_csv(
    "/Users/bumjunpark/Desktop/2022 Spring/STAT 333/Projects/Project 2/#Guides/train_yelp.csv"
)
df_train = pd.DataFrame(df_train)

"""
Divide the texts by star review
"""
textsOne = df_train[df_train["star"] == 1]["text"]
textsTwo = df_train[df_train["star"] == 2]["text"]
textsThree = df_train[df_train["star"] == 3]["text"]
textsFour = df_train[df_train["star"] == 4]["text"]
textsFive = df_train[df_train["star"] == 5]["text"]

"""
Extract tokenized words out of each text file
"""
tokensOne = []
tokensTwo = []
tokensThree = []
tokensFour = []
tokensFive = []
for text in textsOne:
    tokensOne.append(re.findall("\w+", text))
for text in textsTwo:
    tokensTwo.append(re.findall("\w+", text))
for text in textsThree:
    tokensThree.append(re.findall("\w+", text))
for text in textsFour:
    tokensFour.append(re.findall("\w+", text))
for text in textsFive:
    tokensFive.append(re.findall("\w+", text))

"""
Change all words to lower case
"""
df_wordsOne = []
df_wordsTwo = []
df_wordsThree = []
df_wordsFour = []
df_wordsFive = []

for token in tokensOne:
    words = []
    for word in token:
        words.append(word.lower())
    df_wordsOne.append(words)
for token in tokensTwo:
    words = []
    for word in token:
        words.append(word.lower())
    df_wordsTwo.append(words)
for token in tokensThree:
    words = []
    for word in token:
        words.append(word.lower())
    df_wordsThree.append(words)
for token in tokensFour:
    words = []
    for word in token:
        words.append(word.lower())
    df_wordsFour.append(words)
for token in tokensFive:
    words = []
    for word in token:
        words.append(word.lower())
    df_wordsFive.append(words)


"""
Remove stopwords
"""
# nltk.download("stopwords")
sw = nltk.corpus.stopwords.words("english")
# print(sw[:10])

df_words_swOne = []
df_words_swTwo = []
df_words_swThree = []
df_words_swFour = []
df_words_swFive = []

for words in df_wordsOne:
    words_sw = []
    for word in words:
        if word not in sw:
            words_sw.append(word)
    df_words_swOne.append(words_sw)
for words in df_wordsTwo:
    words_sw = []
    for word in words:
        if word not in sw:
            words_sw.append(word)
    df_words_swTwo.append(words_sw)
for words in df_wordsThree:
    words_sw = []
    for word in words:
        if word not in sw:
            words_sw.append(word)
    df_words_swThree.append(words_sw)
for words in df_wordsFour:
    words_sw = []
    for word in words:
        if word not in sw:
            words_sw.append(word)
    df_words_swFour.append(words_sw)
for words in df_wordsFive:
    words_sw = []
    for word in words:
        if word not in sw:
            words_sw.append(word)
    df_words_swFive.append(words_sw)

"""
Merge entire Data Frame into one String
"""
oneStar = df_words_swOne[0]
for i in range(1, len(df_words_swOne)):
    oneStar += df_words_swOne[i]

twoStar = df_words_swTwo[0]
for i in range(1, len(df_words_swTwo)):
    twoStar += df_words_swTwo[i]

threeStar = df_words_swThree[0]
for i in range(1, len(df_words_swThree)):
    threeStar += df_words_swThree[i]

fourStar = df_words_swOne[0]
for i in range(1, len(df_words_swFour)):
    fourStar += df_words_swFour[i]

fiveStar = df_words_swFive[0]
for i in range(1, len(df_words_swFive)):
    fiveStar += df_words_swFive[i]

"""
Create Frequency Plot for One Star
"""
# sns.set_style("darkgrid")
# nlp_words = nltk.FreqDist(oneStar)
# nlp_words.plot(20)

# with open(
#     "/Users/bumjunpark/Desktop/2022 Spring/STAT 333/Projects/Project 2/oneStar.csv",
#     "w",
# ) as fp:
#     writer = csv.writer(fp, quoting=csv.QUOTE_ALL)
#     writer.writerow(["Word", "Count"])
#     writer.writerows(nlp_words.items())

"""
Create Frequency Plot for Two Stars
"""

# sns.set_style("darkgrid")
# nlp_words = nltk.FreqDist(twoStar)
# # nlp_words.plot(20)

# with open(
#     "/Users/bumjunpark/Desktop/2022 Spring/STAT 333/Projects/Project 2/twoStar.csv",
#     "w",
# ) as fp:
#     writer = csv.writer(fp, quoting=csv.QUOTE_ALL)
#     writer.writerow(["Word", "Count"])
#     writer.writerows(nlp_words.items())


"""
Create Frequency Plot for Three Stars
"""
# sns.set_style("darkgrid")
# nlp_words = nltk.FreqDist(threeStar)
# # nlp_words.plot(20)

# with open(
#     "/Users/bumjunpark/Desktop/2022 Spring/STAT 333/Projects/Project 2/threeStar.csv",
#     "w",
# ) as fp:
#     writer = csv.writer(fp, quoting=csv.QUOTE_ALL)
#     writer.writerow(["Word", "Count"])
#     writer.writerows(nlp_words.items())

"""
Create Frequency Plot for Four Stars
"""

# sns.set_style("darkgrid")
# nlp_words = nltk.FreqDist(fourStar)
# # nlp_words.plot(20)

# with open(
#     "/Users/bumjunpark/Desktop/2022 Spring/STAT 333/Projects/Project 2/fourStar.csv",
#     "w",
# ) as fp:
#     writer = csv.writer(fp, quoting=csv.QUOTE_ALL)
#     writer.writerow(["Word", "Count"])
#     writer.writerows(nlp_words.items())

"""
Create Frequency Plot for Five Stars
"""

sns.set_style("darkgrid")
nlp_words = nltk.FreqDist(fiveStar)
# nlp_words.plot(20)

with open(
    "/Users/bumjunpark/Desktop/2022 Spring/STAT 333/Projects/Project 2/fiveStar.csv",
    "w",
) as fp:
    writer = csv.writer(fp, quoting=csv.QUOTE_ALL)
    writer.writerow(["Word", "Count"])
    writer.writerows(nlp_words.items())
