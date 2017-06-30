# set necessary library
library(tidyverse)
library(varhandle) #not exists??
library(ggplot2)

# set plot theme
theme_set(theme_bw())

# read data from csv file
#minWageData <- read_csv('minWageData.csv')
minWageData <- read.delim('Card & Krueger (1994) - dataset.csv', sep=',', header=T)

minWageData$DIFFEMPFT = minWageData$EMPFT2 - minWageData$EMPFT

fullTimeEMPS_Before_NJ <- 
  minWageData %>%
  filter(STATE == 1, !is.na(EMPFT)) #%>% select(EMPFT)
fullTimeEMPS_After_NJ <- 
  minWageData %>%
  filter(STATE == 1, !is.na(EMPFT2)) #%>% select(EMPFT2)

fullTimeEMPS_Before_PA <- 
  minWageData %>%
  filter(STATE == 0, !is.na(EMPFT)) #%>% select(EMPFT)
fullTimeEMPS_After_PA <- 
  minWageData %>%
  filter(STATE == 0, !is.na(EMPFT2)) #%>% select(EMPFT2)

avgNumEmpsBeforeNJ <- mean(fullTimeEMPSBeforeInNJ$EMPFT)
avgNumEmpsBeforePA <- mean(fullTimeEMPSBeforeInPA$EMPFT)

avgNumEmpsAfterNJ <- mean(fullTimeEMPSAfterInNJ$EMPFT2)
avgNumEmpsAfterPA <- mean(fullTimeEMPSAfterInPA$EMPFT2)

diffNJ = avgNumEmpsAfterNJ - avgNumEmpsBeforeNJ
diffPA = avgNumEmpsAfterPA - avgNumEmpsBeforePA

### So what she did that is different from mine was:
# I took the differences for each obs (i.e. row), then averaged the diffs to get diff_per_metric
# She took the avg_per_metric, then took the difference.

DiDEMPFT = diffNJ - diffPA

## What is the following code section for?
##########################################
DDJN = c()                               #
ft_b_nj <-                               #
  minWageData %>%                        #
  filter(STATE==1, EMPFT)                #
ft_a_nj <-                               #
  minWageData %>%                        #
  filter(STATE==1, EMPFT2)               #
DDJN <- ft_b_nj$EMPFT - ft_a_nj$EMPFT    #
##########################################

## What does this graph show???
##############################################################
minWageData %>%                                              #
  group_by(STATE, CHAIN) %>%                                 #
  ggplot(aes(x = as.factor(CHAIN), y = EMPFT2 - EMPFT)) +    #
  geom_bar(position="dodge", stat="identity")                #
##############################################################

minWageData %>%
  ggplot(aes(y = DIFFEMPFT,
             x = ï..SHEET,
             color = as.factor(STATE))) +
  geom_point() +
  stat_smooth(method = "lm") +
  scale_color_discrete(name = "State", labels = c("PA", "NJ"))
## From this graph, it seems that the majority of stores do not have much change in their
# number of full-time employees. However, there are also a lotttt of variance, which is why
# the band of the smoothline is that wide.


## This does not look like a helpful/informative graph
################################################################
minWageData %>% 
  ggplot(aes(y = DIFFEMPFT, 
             x = as.factor(STATE), 
             color = as.factor(STATE))) +  
  geom_point() + 
  # geom_abline() +  
  geom_smooth()+ #why no line?  
  scale_color_discrete(name = "State", labels = c("PA", "NJ"))
################################################################

# Statistical analysis using OLS
OLS <- lm(data = minWageData,
          formula = DIFFEMPFT ~ STATE)
summary(OLS)
#             Estimate Std. Error t value Pr(>|t|)   
# (Intercept)   -2.743      1.181  -2.323  0.02071 * 
#  STATE          3.443      1.316   2.617  0.00921 **
### The output shows that at the baseline, the DIFFEMPFT is negative i.e. the EMPFT tends to go down (-2.7).
### But if there's treatment (i.e. minwage raise), then the decrease is less steep. 
### And actually, the EMPFT will go up a bit (-2.7 + 3.4 = 0.7).
### However, the correlation is not that strong (see the ****).

#take out those below 5.05
wages = filter(minWageData, WAGE_ST != "NA", WAGE_ST < 5.05)
wages$DiffWage_st = wages$WAGE_ST2 - wages$WAGE_ST

OLSWAGES = lm(DiffWage_st ~ STATE, data = wages)
summary(OLSWAGES)
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -0.0007813  0.0373703  -0.021    0.983    
# STATE        0.5285631  0.0414916  12.739   <2e-16 ***
### This seems to show that at the baseline, the DIFFWAGE is negative i.e. the WAGE_ST tends to go down veeery
### insignificantly. With treatment (i.e. STATE==1 i.e. minwage raise), wAGE_ST raises a litttle bit.