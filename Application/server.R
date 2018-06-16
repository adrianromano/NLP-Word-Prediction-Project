library(shiny)
library(stringr)
library(tm)

bigram <- readRDS("data/bigram.RData")
trigram <- readRDS("data/trigram.RData")
fourgram <- readRDS("data/fourgram.RData")
fivegram <- readRDS("data/fivegram.RData")


bigram$Word <- as.character(bigram$Word)
bistrsplit <- strsplit(bigram$Word, split = " ")
bigram <- transform(bigram, word1 = sapply(bistrsplit, "[[", 1),
                    word2 = sapply(bistrsplit, "[[", 2))
bigram <- bigram[bigram$Freq > 1, ]

bigram <- data.frame(w1 = bigram$word1, w2 = bigram$word2,
                     freq = bigram$Freq, stringsAsFactors = FALSE)

trigram$Word <- as.character(trigram$Word)
tristrsplit <- strsplit(trigram$Word, split = " ")
trigram <- transform(trigram, word1 = sapply(tristrsplit, "[[", 1),
                     word2 = sapply(tristrsplit, "[[", 2),
                     word3 = sapply(tristrsplit, "[[", 3))

trigram <- trigram[trigram$Freq > 1, ]

trigram <- data.frame(w1 = trigram$word1, w2 = trigram$word2, w3 = trigram$word3,
                      freq = trigram$Freq, stringsAsFactors = FALSE)

fourgram$Word <- as.character(fourgram$Word)
fourstrsplit <- strsplit(fourgram$Word, split = " ")
fourgram <- transform(fourgram, word1 = sapply(fourstrsplit, "[[", 1),
                      word2 = sapply(fourstrsplit, "[[", 2),
                      word3 = sapply(fourstrsplit, "[[", 3),
                      word4 = sapply(fourstrsplit, "[[", 4))

fourgram <- fourgram[fourgram$Freq > 1, ]

fourgram <- data.frame(w1 = fourgram$word1, w2 = fourgram$word2, w3 = fourgram$word3, w4 = fourgram$word4,
                       freq = fourgram$Freq, stringsAsFactors = FALSE)

fivegram$Word <- as.character(fivegram$Word)
fivestrsplit <- strsplit(fivegram$Word, split = " ")
fivegram <- transform(fivegram, word1 = sapply(fivestrsplit, "[[", 1),
                      word2 = sapply(fivestrsplit, "[[", 2),
                      word3 = sapply(fivestrsplit, "[[", 3),
                      word4 = sapply(fivestrsplit, "[[", 4),
                      word5 = sapply(fivestrsplit, "[[", 5))

fivegram <- fivegram[fivegram$Freq > 1, ]

fivegram <- data.frame(w1 = fivegram$word1, w2 = fivegram$word2, w3 = fivegram$word3, w4 = fivegram$word4, w5 = fivegram$word5,
                       freq = fivegram$Freq, stringsAsFactors = FALSE)

predictFunc<- function(word) {
    wordInput <- stripWhitespace(removeNumbers(removePunctuation(tolower(word), preserve_intra_word_dashes = TRUE)))
    word <- strsplit(wordInput, " ")[[1]]
    length <- length(word)
    
    if(length == 1) {word <- as.character(tail(word, 1)); bigramFunc(word)}
    
    else if (length == 2) {word <- as.character(tail(word, 2)); trigramFunc(word)}
    
    else if (length == 3) {word <- as.character(tail(word, 3)); fourgramFunc(word)}
    
    else if (length >= 4) {word <- as.character(tail(word, 4)); fivegramFunc(word)}
}

bigramFunc <- function(word) {
    if(identical(character(0), as.character(head(bigram[bigram$w1 == word[1], 2], 1)))) {
        as.character(head("and", 1))
    }
    else{
        as.character(head(bigram[bigram$w1 == word[1], 2], 1))
    }
}

trigramFunc <- function(word) {
    if(identical(character(0), as.character(head(trigram[trigram$w1 == word[1] & trigram$w2 == word[2], 3], 1)))){
        as.character(predictFunc(word[2]))
    }
    else{
        as.character(head(trigram[trigram$w1 == word[1] & trigram$w2 == word[2], 3], 1))
    }
}

fourgramFunc <- function(word) {
    if (identical(character(0),as.character(head(fourgram[fourgram$w1 == word[1]
                                                          & fourgram$w2 == word[2]
                                                          & fourgram$w3 == word[3], 4], 1)))) {
        as.character(predictFunc(paste(word[2], word[3], sep=" ")))
    }
    else {
        as.character(head(fourgram[fourgram$w1 == word[1] 
                                   & fourgram$w2 == word[2]
                                   & fourgram$w3 == word[3], 4], 1))
    }       
}

fivegramFunc <- function(word) {
    if (identical(character(0),as.character(head(fivegram[fivegram$w1 == word[1]
                                                          & fivegram$w2 == word[2]
                                                          & fivegram$w3 == word[3]
                                                          & fivegram$w4 == word[4], 5], 1)))) {
        as.character(predictFunc(paste(word[2], word[3], word[4], sep=" ")))
    }
    else {
        as.character(head(fourgram[fivegram$w1 == word[1] 
                                   & fivegram$w2 == word[2]
                                   & fivegram$w3 == word[3]
                                   & fivegram$w4 == word[4], 5], 1))
    }       
}

shinyServer(function(input, output) {
    output$prediction <- renderPrint({
        result <- predictFunc(input$inputText)
        result
    })
}
)