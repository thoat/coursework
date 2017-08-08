setwd("~/GitHub/ds3-2017/coursework/week4")
library(tm)
library(Matrix)
library(glmnet)
library(ROCR)
library(ggplot2)
library(readr)
library(dplyr)

# read business and world articles into one data frame
df <- read_tsv("get_articles_nyt.tsv")
################################################################
# create a Corpus from the article snippets
dfCorpus = Corpus(VectorSource(df$snippet)) 
inspect(dfCorpus)

# create a DocumentTermMatrix from the snippet Corpus
# remove punctuation and numbers
dtm <- DocumentTermMatrix(dfCorpus,
                          control = list(removePunctuation = TRUE,
                                         removeNumbers = TRUE,
                                         ))

# convert the DocumentTermMatrix to a sparseMatrix, required by cv.glmnet
# helper function
dtm_to_sparse <- function(dtm) {
 sparseMatrix(i=dtm$i, j=dtm$j, x=dtm$v, dims=c(dtm$nrow, dtm$ncol), dimnames=dtm$dimnames)
}
sparse <- dtm_to_sparse(dtm)   #spareMatrix is a much more efficient way to store data, i.e. only store [matrix, word, index where that word happens]
###############################################################
# create a train / test split
spliter <- floor(0.8 * nrow(df))

index <- 1:nrow(df)
set.seed(1) 
trainindex <- sample(index, spliter)

train_set <- df[trainindex,]
test_set <- df[-trainindex ,]
##############################################################
# cross-validate logistic regression with cv.glmnet, measuring auc
logit_model <- cv.glmnet( ~ )
logit_model[auc]

# evaluate performance for the best-fit model

# plot ROC curve and output accuracy and AUC
plot(logit_model)

# extract coefficients for words with non-zero weight
# helper function
get_informative_words <- function(crossval) {
  coefs <- coef(crossval, s="lambda.min")
  coefs <- as.data.frame(as.matrix(coefs))
  names(coefs) <- "weight"
  coefs$word <- row.names(coefs)
  row.names(coefs) <- NULL
  subset(coefs, weight != 0)
}

# show weights on words with top 10 weights for business

# show weights on words with top 10 weights for world





## row 15 has e^-0.54354 chance of being Business section
## prediction() : tries different threshold to achieve the best predict results.

# arrange(weights) %>% filter(rank(weight) <= 10 OR rank(weight) >= n() - 1)

#base::row would not work because it returns A MATRIX of row-th numbers and it accepts (as argument) a
