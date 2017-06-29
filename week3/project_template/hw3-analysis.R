library(plyr)
library(tidyverse)
#library(tidyr)
#library(readr)
#library(dplyr)
library(ggplot2)
library(modelr)
library(lubridate)
library(scales)

# set plot theme
theme_set(theme_bw())

# read loans from csv file
loans <- read_csv('Loan payments data.csv')

####################
# brief look at data
####################
head(loans)
nrow(loans)
str(loans)
summary(loans)

#############
# Clean data
#############
loans <-
  loans %>%
  mutate(effective_date = as.Date(effective_date, "%m/%d/%Y"),
         due_date = as.Date(due_date, "%m/%d/%Y"),
         paid_off_time = as.Date(paid_off_time, "%m/%d/%Y %H:%M"),
         loan_status = as.factor(loan_status),
         education = factor(education, levels = c("High School or Below", "college", "Bechalor", "Master or Above"))
         )

################
# Data analysis
################
loans %>%
  group_by(education, loan_status) %>%
  summarize(count = n()) %>%
  ggplot() +
  geom_bar(aes(x = loan_status, y = count, fill = education), position="dodge", stat="identity")

# Within one level of education, what is the pattern of paying off?
loans %>%
  group_by(education, loan_status) %>%
  summarize(count = n()) %>%
  # arrange(education) %>%
  # group_by(education) %>%
  mutate(percentage = count/sum(count)) %>%
  ggplot() +
  geom_bar(aes(x = loan_status, y = percentage, fill = education), position="dodge", stat="identity") +
  scale_y_continuous(labels= percent)


# Age and Loan Status, per Education Level
loans %>%
  ggplot() +
  geom_histogram(aes(x = age)) +
  facet_wrap(~loan_status)

loans %>%
  ggplot() +
  geom_point(aes(x = age, y=loan_status, color=education))
  
# From Effective Date  
paid <- 
  loans %>%
  filter(loan_status == "PAIDOFF") %>%
  mutate(num_days_used = paid_off_time - effective_date + 1) %>%
  mutate(percent_term_used = num_days_used/as.numeric(due_date - effective_date + 1)) 
max(paid$percent_term_used)
ggplot(paid) +
  geom_boxplot(aes(x = as.factor(Principal), y=percent_term_used))

ggplot(paid) +
  geom_point(aes(x = Loan_ID, y=percent_term_used, shape = as.factor(Principal)))

ggplot(paid) +
  geom_point(aes(x = age, y = percent_term_used))
  
  
  



df = data.frame(id = 1:100)
df$x = df$id/10
df$e = rnorm(100)
df$y = 2*df$x + df$e
ols = lm(y~x, data=df)
pval = summary(ols)$coefficients[2,4]

#Some plots (e.g. ggplot's) can be saved and then shown via print()
#Others like plot(), we'd have to save the output to a graphics file
#(But you should use ggplot anyways!)
plt = ggplot(data=df, aes(x=x, y=y))+geom_point()

save(pval, plt, file="outputs.RData")
