setwd("~/GitHub/ds3-2017/coursework/week4")
library(tidyverse)
library(tm)
library(Matrix)
library(glmnet)
library(ROCR)

# read business and world articles into one data frame
business <- read_tsv('business.tsv')
world <- read_tsv('world.tsv')
articles <- rbind(business, world)

head(articles)

# create a Corpus from the article snippets
corpus <- Corpus(VectorSource(articles$snippet))

# create a DocumentTermMatrix from the snippet Corpus
# remove punctuation and numbers
dtm <- DocumentTermMatrix(corpus, list(weight=weightBin,
                                       stopwords=T,
                                       removePunctuation=T,
                                       removeNumbers=T))
				       
# convert the DocumentTermMatrix to a sparseMatrix
X <- sparseMatrix(i=dtm$i, j=dtm$j, x=dtm$v, dims=c(dtm$nrow, dtm$ncol), dimnames=dtm$dimnames)

### NOTE: there was no fixed random seed, so results will vary due to this ###
# create a train / test split
set.seed(42)
ndx <- sample(nrow(X), floor(nrow(X) * 0.8))

### NOTE: below conflicts with README, so either type.measure='auc' or type.measure='class' are acceptable ###
# cross-validate logistic regression with cv.glmnet (family="binomial"), measuring auc
cv <- cv.glmnet(X[ndx,], articles[ndx, ]$section, family="binomial", type.measure='auc')

# plot the cross-validation curve
plot(cv)

# evaluate performance for the best-fit model
test_set <- data.frame(actual = articles[-ndx, ]$section,
                       predicted = as.character(predict(cv, X[-ndx,], s = "lambda.min", type = "class")),
                       prob = as.numeric(predict(cv, X[-ndx,], s = "lambda.min")))

# accuracy
summarize(test_set, mean(actual == predicted))

# confusion matrix
table(test_set$actual, test_set$predicted)

# ROC curve and AUC
pred <- prediction(test_set$prob, test_set$actual)
perf <- performance(pred, measure='tpr', x.measure='fpr')
plot(perf)
performance(pred, 'auc')

# note: could have used broom here instead
get_informative_words <- function(crossval) {
  coefs <- coef(crossval, s="lambda.min")
  coefs <- as.data.frame(as.matrix(coefs))
  names(coefs) <- "weight"
  coefs$word <- row.names(coefs)
  row.names(coefs) <- NULL
  subset(coefs, weight != 0)
}

coefs <- get_informative_words(cv)
coefs %>% arrange(weight) %>% head(., 10)
coefs %>% arrange(desc(weight)) %>% head(., 10)
