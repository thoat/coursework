setwd("~/GitHub/ds3-2017/coursework/week4")
library(dplyr)
library(stargazer)
library(caret)



loan <- read.csv("https://www.dropbox.com/s/89g1yyhwpcqwjn9/lending_club_cleaned.csv?raw=1")
#loan <- read.csv("C:/Users/dvorakt/Google Drive/business analytics/labs/lab9/lending_club_cleaned.csv")
summary(loan)

### IN-CLASS EXERCISE 1: What is the effect of debt to income ratio (dti) on the odds of a loan being good?

## Interpreting probabilities: calculate how A CHANGE in fico AFFECTS the PROBABILITY of a good loan
## This is more difficult. Non-linear, therefore, have to specify the range of change.
## e.g. the effect of fico going form 700 to 750 on the probability on loan being good

### IN-CLASS EXERCISE 2: What is the effect of fico going from 750 to 800?

## Once you include more than one independent variable, the interpretation of the coefficient on an independent variable
## is the effect of that independent variable HOLDING ALL OTHER INDEPENDENT VARIABLES CONSTANT.

## Logit OMITS observations/rows with MISSING VALUES for any of the inde. variables.
## e.g. the model is estimated on half of the observations in the data set.

data <- read.csv("https://www.dropbox.com/s/eg6kack8wmlqmhg/titanic_train.csv?raw=1")
summary(data)
###########################
# 1. The odds of surviving the shipwreck? NOT WORKING YET
data %>%
  group_by(Survived) %>%
  summarize(count=n()) %>%
  select(data[2,"count"] %/% data[1,"count"])

#############################
# 2. Odds of survival for men relative to women:
logit1 <- glm(data = data,
              formula = Survived ~ Sex,
              family = "binomial")
summary(logit1)
exp(coef(logit1))
## Being male, the odds of surival went down by 8%.

###########################
# 3. Controlling for gender, does age have a statistically significant effect on the odds of survival?
logit2 <- glm(data = data,
              formula = Survived ~ Sex + Age,
              family = "binomial")
summary(logit2) ##No, the p-value for Age shows that Age does not have a significant effect on the odds of survival.
exp(coef(logit2))

############################
# 4. Controlling for gender, does passenger class 
logit3 <- glm(data = data,
               formula = Survived ~ Sex + Pclass,
               family = "binomial")
summary(logit3) ##Yes, passenger class has a significant effect on the odds of survival.
exp(coef(logit3))
## Passenger class goes up by 1, the odds of survival goes down by 38%.

##########################
# 5. Controlling for gender, estimate the effect of being in 2nd class relative to the 1st,
# and being in the 3rd relative to the 1st.
logit4 <- glm(data = data,
              formula = Survived ~ Sex + as.factor(Pclass),
              family = "binomial")
exp(coef(logit4))
## Controlling for gender, being 2nd class --> survive = 43% of 1st class, i.e. decreases by 57%.
## Controlling for gender, being 3rd class --> survive = 15% of 1st class, i.e. decreases by 85%.

################################
# 6. Add fare to the regression.
logit5 <- glm(data = data,
              formula = Survived ~ Sex + as.factor(Pclass) + Fare,
              family = "binomial")
summary(logit5) ##No, Fare is not significant when controlling for Gender and Pass.Class.
## I think if we regress survival on just gender and fare, fare would be significant. Because here, 
## Fare and Pass.class might have effect on one another.

###############################
# 7. Survival PROBABILITY of Jack (3rd class, paid 5 pounds),
# and Rose (1st class, paid 500 pounds)
test <- 
  data.frame(Pclass =c(3,1),
             Fare = c(5,500),
             Sex =c("male","female"))
test$pred <- predict(logit5, test, type="response")
test

################################
# 8. Create your own logistic model & make predictions 
# for passengers in the Titanic test dataset. 
testdata <- read.csv("https://storage.googleapis.com/kaggle-competitions-data/kaggle/3136/test.csv?GoogleAccessId=competitions-data@kaggle-161607.iam.gserviceaccount.com&Expires=1499543847&Signature=Tm0TDXhyr1PUAp2wrt82mvuRcgT4W0BqBThe6J5m2UPn7omfIYXV963ls9QLHnob5wKBXj%2FNBT%2FXuBlLVKAZNaNMbC6I%2B9m%2FxUiL5kLhWdf6VgBJ3RRG9CrqBAbIDoXxkwwa87bIjNE7O2hOyYp%2BPn1s6k3C7FeKU1mPbnoUQ0cJQCIUZq%2BkEXCB92I5Wemjq6X3jxNn7pCs2z0bRj9mVMVXM%2FcARqZyIJqBxej7kSBMKjBS0u8tNiz5cOhm3DPcdMp8KSLxUEcHEASlS49CWGYyyT0fJyjzGyEQSO%2BPEiBmbg0C%2F7Dg6dPa7uI8vvVsOt8JraqfFo%2BVo8%2BqNa7Puw%3D%3D")
logitMy <- glm(data = data, 
               formula = Survived ~ Sex + Pclass + Fare + SibSp + Parch,
               family = "binomial")
testdata$pred <- predict(logitMy, testdata, type="response")

testdata$good_pred <- ifelse(testdata$pred > 0.50, "good", "bad")
confusionMatrix(testdata$good_pred, testdata$good)



submission <- 
  testdata %>%
  mutate(Survived = ifelse(pred > 0.50, 1, 0)) %>%
  select(PassengerId, Survived) %>%
  mutate(Survived = ifelse(is.na(Survived), 0, Survived))

write.csv(submission, file="lab9submission.csv", quote=F, row.names=F)
