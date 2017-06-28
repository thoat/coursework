library(tidyverse)
library(tidyr)
library(plyr)
library(dplyr)
library(modelr)
library(ggplot2)

# set plot theme
theme_set(theme_bw())

# read ratings from csv file
teens_gaming <- read_csv('Teens_Gaming_2008_csv.csv')

# for reference: same thing, using base R functions and explicitly setting column information
ratings <- read.delim('ratings.csv',
                      sep=',',
                      header=F,
                      col.names=c('user_id','movie_id','rating','timestamp'),
                      colClasses=c('integer','integer','numeric','integer'))

####################
# brief look at data
####################

head(ratings)
nrow(ratings)
str(ratings)
summary(ratings)


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
