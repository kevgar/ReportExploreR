library(stringr)
library(tm)
library(syuzhet)
library(edgar)
library(shinycssloaders)
library(DT)
library(shinythemes)
library(data.table)
# library(devtools)
# devtools::install_github('hadley/ggplot2')
library(ggplot2)
library(plotly)

# Suppress "Warning in origRenderFunc().."
options(warn =-1)

# Load custom functions
source('helper_functions.R')
# stockPrice <- read.csv('JPM_stock_data.csv', colClasses = c(rep('numeric',5),'Date'))
# stockPrice <- read.csv('SP1_stock_data.csv', colClasses = c(rep('numeric',5),'Date'))

wordFrq <- readRDS('wordFrequency.RDS')
senti <- readRDS('NormalizedSentiment.RDS')

df <- readRDS('df.RDS')
rownames(df) <- 1:nrow(df)

neg.words <- readRDS('neg.words.RDS')
pos.words <- readRDS('pos.words.RDS')

files_df <- getCleanFilingInfo()

# # Create vector of documents
# filesVec <- files_df$files # vector of file paths
# corpus_vec <- vapply(X=1:length(filesVec), FUN=function(i){
#     # Load file as a character string
#     readChar(filesVec[i], file.info(filesVec[i])$size)
#     }, FUN.VALUE = character(1))
# 
# # Create corpus from vector source
# corp <- VCorpus(VectorSource(corpus_vec))
# 
# # Apply basic text cleaning trasformations
# corp <- tm_map(corp, removePunctuation)
# corp <- tm_map(corp, removeNumbers)
# corp <- tm_map(corp, stripWhitespace)
# corp <- tm_map(corp, tolower)
# corp <- tm_map(corp, PlainTextDocument)
# 
# # Convert corpus back to character vector
# corpus_vec <- unlist(sapply(corp, "[", "content"))
# # class(corpus_vec) # [1] "character"
# 
# 
# poa_word_v <- get_tokens(corpus_vec, pattern = "\\W")
# # class(poa_word_v) # [1] "character"
# # length(poa_word_v) # [1] 3075936
# 
# 
# Get sentiment vocab from the edgar package
# neg.words <- scan(system.file("data/negwords.txt.gz",
#                               package="edgar"), what=character())
# saveRDS(neg.words,'neg.words.RDS')
# 
# pos.words <- scan(system.file("data/poswords.txt.gz",
#                               package="edgar"), what=character())
# saveRDS(pos.words,'pos.words.RDS')
# 
# 
# # ?get_sentiment
# # poa_v_sentiment <- get_sentiment(neg.words)
# 
# isNotEmpty <- !grepl('na na na na', corpus_vec, fixed = TRUE)
# 
# 
# # ?edgar::getWordfrquency
# wordFrq <- lapply(files_df$files[isNotEmpty], edgar::getWordfrquency)
# # str(wordFrq)
# 
# # ?edgar::getSentimentCount
# # edgar::getSentimentCount(wordFrq[[1]], pos.words)
# posMinusNeg <- vapply(1:length(wordFrq), function(i) {
#     cat(paste0(i, '\n'))
#     pos <- edgar::getSentimentCount(wordFrq[[i]], pos.words)$FREQUENCY
#     neg <- edgar::getSentimentCount(wordFrq[[i]], neg.words)$FREQUENCY
#     sum(pos)-sum(neg)
#     }, FUN.VALUE = integer(1))
# 
# summary(posMinusNeg)
# boxplot(posMinusNeg)
