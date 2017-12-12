library(stringr)
library(tm)
library(syuzhet)
library(edgar)
library(shinycssloaders)
library(DT)
library(shinythemes)
library(RColorBrewer)
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
# # 
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
# 
# 
# # Plot sentiment over time
# FileSize <- round(files_df$size_MB[isNotEmpty],2)
# Sentiment <- posMinusNeg
# f10k <- files_df$report_type[isNotEmpty]=='10-K'
# date <- files_df$report_date[isNotEmpty]
# 
# plot(date,Sentiment,  type='l')
# plot(FileSize,Sentiment)
# plot(FileSize[f10k],Sentiment[f10k], main='Sentiment of 10-K versus file size')
# plot(FileSize[!f10k],Sentiment[!f10k], main='Sentiment of 10-Q versus file size')
# 
# 
# 
# 
# #################################################
# # Visualization
# #################################################
# 
# 
# # Plot 10K and 10Q sentiments over narrative time
# 
# 
# # Plot moving average sentiment over narative time
# disclosure_sentiment <- get_sentiment(corpus_vec)
# simple_plot(disclosure_sentiment)
# 
# f10k_sentiment <- get_sentiment(corpus_vec[f10k])
# f10q_sentiment <- get_sentiment(corpus_vec[!f10k])
# 
# pwdw <- round(length(f10k_sentiment)*.1)
# f10k_rolled <- zoo::rollmean(f10k_sentiment, k=pwdw)
# bwdw <- round(length(f10q_sentiment)*.1)
# f10q_rolled <- zoo::rollmean(f10q_sentiment, k=bwdw)
# 
# f10k_list <- rescale_x_2(f10k_rolled)
# f10q_list <- rescale_x_2(f10q_rolled)
# plot(f10k_list$x, f10k_list$z, type="l", 
#      col="blue", 
#      xlab="Narrative Time", 
#      ylab="Emotional Valence")
# lines(f10q_list$x, f10q_list$z, col="red")
# legend("bottomright",legend = c("f10k","f10q"),lty=1,col=c("blue","red"))
# 
# 
# # Plot lowess smoothed sentiments over time
# 
# f10k_sentiment <- get_sentiment(corpus_vec[f10k])
# f10q_sentiment <- get_sentiment(corpus_vec[!f10k])
# 
# 
# f10k_x <- 1:length(f10k_sentiment)
# f10k_y <- f10k_sentiment
# 
# raw_f10k <- loess(f10k_y ~ f10k_x, span=.5)
# f10k_line <- rescale(predict(raw_f10k))
# 
# 
# f10q_x <- 1:length(f10q_sentiment)
# f10q_y <- f10q_sentiment
# 
# raw_f10q <- loess(f10q_y ~ f10q_x, span=.5)
# f10q_line <- rescale(predict(raw_f10q))
# 
# f10k_sample <- seq(1, length(f10k_line), by=round(length(f10k_line)/100, 2))
# f10q_sample <- seq(1, length(f10q_line), by=round(length(f10q_line)/100, 2))
# 
# plot(f10k_line[f10k_sample], type="l", col="blue", 
#      main="Loess Smoothed Lines of Sentiments",
#      xlab="Narrative Time (sampled)", 
#      ylab="Emotional Valence")
# lines(f10q_line[f10q_sample], col="red")
# legend("bottomright",legend = c("f10k","f10q"),lty=1,col=c("blue","red"))
