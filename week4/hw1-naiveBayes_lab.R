setwd("~/GitHub/ds3-2017/coursework/week4")
library(e1071)

########

train <- data.frame(buy=c("yes", "no", "no", "yes"),
                    income=c("high", "high", "medium", "low"),
                    gender=c("male", "female", "female", "male")) 
train
## By default, the factors are sorted alphabetically.

classifer <- naiveBayes(buy ~ income + gender, train)
classifer

test <- data.frame(income=c("high"),
                   gender=c("male"))
# Here, there's only one "H" and one "M", so "high" is mapped to 1 (still correct w/ the Train data), 
# but "male" is mapped to 1 (which is incorrect bcz in Train data it is female=1 and male=2). 
# To fix that:
test$gender <- factor(test$gender, levels=c("female", "male")) #imagine there's a "F" which occupies 1, leaving 2 to "M"

# And just to be safe: test$income <- factor(test$income, levels=c("high", "low", "medium"))
 

prediction <- predict(classifer, test, type="raw")
prediction 

########
# Naive Bayes is less good in theory, but better in practice (bcz you can't do computations over large amt of data)
# "meet" and "viagra" could be related i.e. when you use one you are more likely to use the other,
# but Naive Bayes treat them as independent. 
