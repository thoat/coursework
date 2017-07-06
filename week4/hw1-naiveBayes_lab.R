setwd("~/GitHub/ds3-2017/coursework/week4")
library(e1071)

########

train <- data.frame(buy=c("yes", "no", "no", "yes"),
                    income=c("high", "high", "medium", "low"),
                    gender=c("male", "female", "female", "male"))
train

classifer <- naiveBayes(buy ~ income + gender, train)
classifer

test <- data.frame(income=c("high"),
                   gender=c("male"))
test$income <- factor(test$income, levels=c("high", "medium", "low"))
test$gender <- factor(test$gender, levels=c("male", "female"))

prediction <- predict(classifer, test, type="raw")
prediction 

########

