library(scales)
library(readr)
library(tidyverse)

# set plot theme
theme_set(theme_bw())

# read ratings from csv file
ratings <- read_csv('ratings.csv')

# for reference: same thing, using base R functions and explicitly setting column information
  ratings <- read.delim('ratings.csv',
                        sep=',',
                        header=F,
                        col.names=c('user_id','movie_id','rating','timestamp'),
                        colClasses=c('integer','integer','numeric','integer'))

print(object.size(ratings), units="Mb")

####################
# brief look at data
####################

head(ratings)
nrow(ratings)
str(ratings)
summary(ratings)

####################
# aggregate stats
####################

# plot distribution of rating values (slide 21)
ratings %>%
  ggplot(aes(x = rating)) +
  geom_histogram(stat="count") +
  labs(x = "Rating", y = "Number of ratings") +
  scale_y_continuous(label = comma) 
  
####################
# per-movie stats
####################

# aggregate ratings by movie, computing mean and number of ratings
# hint: use the n() function for easy counting within a group
ratings %>%
  group_by(movie_id) %>%
  summarize(count = n(), avg_rating = ) %>%
  ggplot(aes(x = movie_id)) +
  geom_histogram() 

# plot distribution of movie popularity (= number of ratings the movie received)
# hint: try scale_x_log10() for a logarithmic x axis
(ratings_by_movie <- 
  ratings %>%
  group_by(movie_id) %>%
  summarize(num_ratings = n()))
ratings_by_movie %>%
  arrange(num_ratings) 
ratings_by_movie %>%
  ggplot(aes(x = num_ratings)) +
  geom_histogram() +
  scale_x_log10()

# plot distribution of mean ratings by movie (slide 23)
# hint: try geom_histogram and geom_density
mean_star <- 
  ratings %>%
  group_by(movie_id) %>%
  summarize(mean_star = mean(rating))
mean_star %>%
  ggplot(aes(x = mean_star)) +
  geom_density(fill = "black") +
  labs(x = "Mean Rating by Movie", y = "Density")

# rank movies by popularity and compute the cdf, or fraction of movies (ACTUALLY: NUM_RATINGS, not popularity or movies) covered by the top-k moves (slide 25)
# hint: use dplyr's rank and arrange functions, and the base R sum and cumsum functions
(cdf_popularity <-
ratings_by_movie %>%
  mutate(
    popularity = rank(desc(num_ratings), ties.method="first")
  ) %>%
  arrange(popularity) %>%
  mutate(
    cdf = cumsum(num_ratings)/sum(num_ratings)*100
  )
)

# plot the CDF of movie popularity
cdf_popularity %>%
  ggplot(aes(x = popularity, y=cdf)) +
  geom_line() +
  scale_x_continuous(labels = comma, name = "Movie Rank") +
  scale_y_continuous(name = "CDF")

####################
# per-user stats
####################

# aggregate ratings by user, computing mean and number of ratings
(ratings_by_user <-
  ratings %>%
  group_by(user_id) %>%
  summarize(num_ratings = n(), mean_ratings = mean(rating)))

# plot distribution of user activity (= number of ratings the user made)
# hint: try a log scale here
ratings_by_user %>%
  #group_by(num_ratings) %>%
  #summarize(count_users = n()) %>%
  ggplot(aes(x = num_ratings)) +
  geom_density() +
  scale_x_log10(name = "User activity (i.e. num of ratings)") +
  ylab("Distribution of users")

####################
# anatomy of the long tail
####################

# generate the equivalent of figure 2 of this paper:
# https://5harad.com/papers/long_tail.pdf

# Specifically, for the subset of users who rated at least 10 movies,
# produce a plot that shows the fraction of users satisfied (vertical
# axis) as a function of inventory size (horizontal axis). We will
# define "satisfied" as follows: an individual user is satisfied p% of
# the time at inventory of size k if at least p% of the movies they
# rated are contained in the top k most popular movies. As in the
# paper, produce one curve for the 100% user satisfaction level and
# another for 90%---do not, however, bother implementing the null
# model (shown in the dashed lines).

# Join users and movie-ranks dataframes:
users_and_their_movies <-
  inner_join(ratings, cdf_popularity, by = c('movie_id' = 'movie_id')) %>%
  select(user_id, movie_id, popularity) %>%
  arrange(user_id, popularity) %>%
  group_by(user_id) %>%
  mutate(rank_per_user = seq(1, n()))

# Calculate users satisfied as a function of inventory size:
# 100% user satisfaction:
inventory_100_users <-
  users_and_their_movies %>%
  mutate(satisfy = (rank_per_user == max(rank_per_user)))
inventory_100_users <-
  inventory_100_users %>%
  group_by(popularity) %>%
  summarize(count_users_covered = sum(satisfy))
inventory_100_users <- 
  inventory_100_users %>%
  ungroup() %>%
  mutate(cdf_users = cumsum(count_users_covered)/sum(count_users_covered))

# 90% user satisfaction
inventory_90_users <-
  users_and_their_movies %>%  
  filter(rank_per_user < 0.9*n() + 1)
inventory_90_users <-
  inventory_90_users %>%
  mutate(satisfy = (rank_per_user == max(rank_per_user)))
inventory_90_users <-
  inventory_90_users %>%
  group_by(popularity) %>%
  summarize(count_users_covered = sum(satisfy))
inventory_90_users <- 
  inventory_90_users %>%
  ungroup() %>%
  mutate(cdf_users = cumsum(count_users_covered)/sum(count_users_covered))

# combine 100 and 90 into one dataframe
inventory_and_users <-
  bind_rows("100%" = inventory_100_users, "90%" = inventory_90_users, .id='percent_satisfied') %>%
  arrange(popularity)

# plot
inventory_and_users %>%
  ggplot(aes(x = popularity, y = cdf_users, group = percent_satisfied)) +
  geom_line() + 
  scale_x_continuous(labels = comma, name = "Inventory Size") +
  scale_y_continuous(labels = percent, name = "Percent of Users Satisfied")
