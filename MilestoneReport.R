## Download and read the data
if (!file.exists("Courseradata")) {
    dir.create("Courseradata")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(fileUrl, destfile = "/Users/adrianromano/Downloads/Courseradata/Coursera-SwiftKey.zip", method = "curl")
if (!file.exists("/Users/adrianromano/Downloads/Courseradata/Coursera-SwiftKey")) {
    unzip(zipfile = "/Users/adrianromano/Downloads/Courseradata/Coursera-SwiftKey.zip", 
          exdir = "/Users/adrianromano/Downloads/Courseradata")
}

blogs <- readLines("/Users/adrianromano/Downloads/Courseradata//final/en_US/en_US.blogs.txt")
news <- readLines("/Users/adrianromano/Downloads/Courseradata//final/en_US/en_US.news.txt")
twitter <- readLines("/Users/adrianromano/Downloads/Courseradata//final/en_US/en_US.twitter.txt")

## Check Number of Lines
blogsLength <- length(blogs)
newsLength <- length(news)
twitterLength <- length(twitter)

## Check Number of Words
library(stringi)
blogsWords <- sum(stri_count_words(blogs))
newsWords <- sum(stri_count_words(news))
twitterWords <- sum(stri_count_words(twitter))

## Check Memory Sizes
blogsSize <- file.info("/Users/adrianromano/Downloads/Courseradata//final/en_US/en_US.blogs.txt")$size/1024^2
newsSize <- file.info("/Users/adrianromano/Downloads/Courseradata//final/en_US/en_US.news.txt")$size/1024^2
twitterSize <- file.info("/Users/adrianromano/Downloads/Courseradata//final/en_US/en_US.twitter.txt")$size/1024^2

## Summary of the data
summaryData <- data.frame(Dataset = c("blogs", "news", "twitter"),
                          Lines = c(blogsLength, newsLength, twitterLength),
                          Words = c(blogsWords, newsWords, twitterWords),
                          FileSize.MB = c(blogsSize, newsSize, twitterSize))
summaryData

## Sample 1% of each raw dataset
set.seed(1995)
blogsSample <- sample(blogs, blogsLength * 0.01)
newsSample <- sample(news, newsLength * 0.01)
twitterSample <- sample(twitter, twitterLength * 0.01)

## Check the first line of each dataset
head(blogsSample, 1)
head(newsSample, 1)
head(twitterSample, 1)

## Combine all dataset into one and check the number of lines and words
totalSample <- c(blogsSample, newsSample, twitterSample)
length(totalSample)
sum(stri_count_words(totalSample))

## Set working directory and Download profanity dataset
setwd("/Users/adrianromano/Downloads")
badwords <- readLines("full-list-of-bad-words-text-file_2018_03_26.txt")

## Clean up the data by creating corpus to set all characters to lower case and remove numbers, punctuation, white space and profanity. 
library(tm)
corpus <- VCorpus(VectorSource(totalSample))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, badwords)

## Remove unusable dataset to free memory space
rm(blogs, news, twitter, blogsSample, newsSample, twitterSample, totalSample)

## Unigram 
library(RWeka)
library(ggplot2)
library(wordcloud2)
Tokenizer1 <- function (x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
unigram <- TermDocumentMatrix(corpus, control = list(tokenize = Tokenizer1))
unigram <- removeSparseTerms(unigram, 0.9999)

uniFreq <- sort(rowSums(as.matrix(unigram)), decreasing = TRUE)
uniFreq.df <- data.frame(Word = names(uniFreq), Freq = uniFreq)

saveRDS(uniFreq.df, file = "/Users/adrianromano/Downloads/unigram.RDS")

ggplot(uniFreq.df[1:10, ], aes(x = reorder(Word, Freq), y = Freq, fill = Freq, alpha = 0.1)) +
    geom_bar(stat = "identity", color = "black") +
    xlab("Unigram") +
    ylab("Frequency") +
    ggtitle("Top 10 unigrams by Frequency") +
    coord_flip() +
    guides(fill = FALSE, alpha = FALSE) 

set.seed(1995)
wordcloud2(uniFreq.df, size = 3, fontWeight = "bold", fontFamily = "Comic Sans MS", color = "random-light", backgroundColor = "black")

## Bigram 
Tokenizer2 <- function (x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
bigram <- TermDocumentMatrix(corpus, control = list(tokenize = Tokenizer2))
bigram <- removeSparseTerms(bigram, 0.9999)

biFreq <- sort(rowSums(as.matrix(bigram)), decreasing = TRUE)
biFreq.df <- data.frame(Word = names(biFreq), Freq = biFreq)

saveRDS(biFreq.df, file = "/Users/adrianromano/Downloads/bigram.RData")

ggplot(biFreq.df[1:10, ], aes(x = reorder(Word, Freq), y = Freq, fill = Freq, alpha = 0.1)) +
    geom_bar(stat = "identity", color = "black") +
    xlab("Bigram") +
    ylab("Frequency") +
    ggtitle("Top 10 bigrams by Frequency") +
    coord_flip() +
    guides(fill = FALSE, alpha = FALSE) 

set.seed(1995)
wordcloud2(biFreq.df, fontWeight = "normal", color = "random-light", fontFamily = "Comic Sans MS", backgroundColor = "black")

## Trigram 
Tokenizer3 <- function (x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
trigram <- TermDocumentMatrix(corpus, control = list(tokenize = Tokenizer3))
trigram <- removeSparseTerms(trigram, 0.9999)

triFreq <- sort(rowSums(as.matrix(trigram)), decreasing = TRUE)
triFreq.df <- data.frame(Word = names(triFreq), Freq = triFreq)

saveRDS(triFreq.df, file = "/Users/adrianromano/Downloads/trigram.RData")

ggplot(triFreq.df[1:10, ], aes(x = reorder(Word, Freq), y = Freq, fill = Freq, alpha = 0.1)) +
    geom_bar(stat = "identity", color = "black") +
    xlab("Trigram") +
    ylab("Frequency") +
    ggtitle("Top 10 trigrams by Frequency") +
    coord_flip() +
    guides(fill = FALSE, alpha = FALSE) 

set.seed(1995)
wordcloud2(triFreq.df, fontWeight = "bold", color = "random-light", fontFamily = "Comic Sans MS", backgroundColor = "black")

## Fourgram 
Tokenizer4 <- function (x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
fourgram <- TermDocumentMatrix(corpus, control = list(tokenize = Tokenizer4))
fourgram <- removeSparseTerms(fourgram, 0.9999)

fourFreq <- sort(rowSums(as.matrix(fourgram)), decreasing = TRUE)
fourFreq.df <- data.frame(Word = names(fourFreq), Freq = fourFreq)

saveRDS(fourFreq.df, file = "/Users/adrianromano/Downloads/fourgram.RData")

ggplot(fourFreq.df[1:10, ], aes(x = reorder(Word, Freq), y = Freq, fill = Freq, alpha = 0.1)) +
    geom_bar(stat = "identity", color = "black") +
    xlab("Fourgram") +
    ylab("Frequency") +
    ggtitle("Top 10 fourgrams by Frequency") +
    coord_flip() +
    guides(fill = FALSE, alpha = FALSE) 

set.seed(1995)
wordcloud2(fourFreq.df, size = 0.5, fontWeight = "bold", color = "random-light", fontFamily = "Comic Sans MS", backgroundColor = "black")

## Fivegram
Tokenizer5 <- function (x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
fivegram <- TermDocumentMatrix(corpus, control = list(tokenize = Tokenizer5))
fivegram <- removeSparseTerms(fivegram, 0.9999)

fiveFreq <- sort(rowSums(as.matrix(fivegram)), decreasing = TRUE)
fiveFreq.df <- data.frame(Word = names(fiveFreq), Freq = fiveFreq)

saveRDS(fiveFreq.df, file = "/Users/adrianromano/Downloads/fivegram.RData")

ggplot(fiveFreq.df[1:10, ], aes(x = reorder(Word, Freq), y = Freq, fill = Freq, alpha = 0.1)) +
    geom_bar(stat = "identity", color = "black") +
    xlab("Fivegram") +
    ylab("Frequency") +
    ggtitle("Top 10 fivegrams by Frequency") +
    coord_flip() +
    guides(fill = FALSE, alpha = FALSE) 

set.seed(1995)
wordcloud2(fiveFreq.df, size = 0.4, fontWeight = "bold", color = "random-light", fontFamily = "Comic Sans MS", backgroundColor = "black")
