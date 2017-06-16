<<<<<<< HEAD
########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)
library(lubridate)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides
ggplot(trips, aes(x = tripduration/60)) +
  geom_histogram(binwidth=1) +
  xlim(c(0, 60)) +
  xlab("Trip duration (in mins)") +
  ylab("Number of trips") + 
  scale_y_continuous(label = comma)

ggplot(trips, aes(x = tripduration/60)) +
  geom_density() +
  xlim(c(0, 60)) +
  xlab('Trip duration (in mins)') +
  ylab('Number of trips')

ggplot(trips, aes(x = tripduration/60)) +
  geom_density() +
  xlab('Trip duration (in mins)') +
  ylab('Number of trips') +
  scale_x_log10()
  
# plot the distribution of trip times by rider type
ggplot(trips, aes(x = tripduration/60, color = usertype, fill = usertype)) +
  geom_density(alpha = 0.25) +
  xlim(c(0, 60)) +
  xlab('Trip duration (in mins)') +
  ylab('Number of trips') +
  labs(usertype = "Rider types")

ggplot(trips, aes(x = tripduration/60, color = usertype, fill = usertype)) +
  geom_histogram(alpha = 0.25) +
  xlim(c(0, 60)) +
  xlab('Trip duration (in mins)') +
  ylab('Number of trips') +
  labs(usertype = "Rider types")  #THIS IS A STACKED HISTOGRAM. BETTER TO USE THE BELOW:

ggplot(trips, aes(x = tripduration/60, color = usertype, fill = usertype)) +
  geom_histogram(alpha = 0.25, position="identity") +
  xlim(c(0, 60)) +
  xlab('Trip duration (in mins)') +
  ylab('Number of trips') +
  labs(usertype = "Rider types")

# plot the number of trips over each day
trips %>%
  group_by(ymd) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = ymd, y = count)) +
  geom_line() +
  xlab("Dates") +
  ylab("Number of trips") +
  scale_y_continuous(label = comma)

# plot the number of trips by gender and age
trips %>%
  mutate(age = 2017 - birth_year) %>%
  #group_by (age) %>%
  #summarize(count = n()) %>%
  ggplot(aes(x = age)) +
  geom_histogram() +
  xlab("Age") +
  ylab("Number of trips") +
  labs(gender = "Gender") +
  scale_y_continuous(label = comma) +
  facet_wrap(~ gender, scales = "free_y")

trips %>%
  mutate(age = 2017 - birth_year) %>%
  filter(gender != "Unknown") %>%
  group_by (gender, age) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = age)) +
  geom_point(aes(x = age, y = count, color = gender)) +
  xlab("Age") +
  ylab("Number of trips") +
  labs(gender = "Gender") +
  scale_y_continuous(label = comma)

# plot the ratio of male to female trips by age
# hint: use the spread() function to reshape things to make it easier to compute this ratio
trips %>%
  mutate(age = 2017 - birth_year) %>%
  filter(gender != "Unknown") %>%
  group_by (gender, age) %>%
  summarize(num_trips = n()) %>%
  spread(gender, num_trips) %>%
  mutate(ratio = Male/Female) %>%
  ggplot(aes(x = age, y = ratio, color = sqrt(Male+Female))) +
  geom_point() +
  xlim(c(0, 70)) +
  ylim(c(0, 7.5)) +
  scale_color_continuous(label = comma)

########################################
# plot weather data
########################################
# plot the minimum temperature over each day
weather %>%
  ggplot(aes(x = ymd, y = tmin)) +
  labs(x = "Day", y = "Min temp") +
  geom_point(color = "dark blue")

# plot the minimum temperature and maximum temperature over each day
# hint: try using the gather() function for this to reshape things before plotting
weather %>%
  ggplot(aes(x = ymd)) +
  geom_point(aes(y = tmin), color = "turquoise") +
  geom_smooth(aes(y = tmin), color = "dark blue", se = F) +
  geom_point(aes(y = tmax), color = "orange") +
  geom_smooth(aes(y = tmax), color = "red", se = F)
  labs(x = "Day", y = "Temp")

weather %>%
  ggplot(aes(x=ymd)) +
  geom_ribbon(aes(ymin=tmin, ymax=tmax), alpha=0.2, color="black") +
  geom_point(aes(y=tmax), color="red") +
  geom_point(aes(y=tmin), color="dark blue")

weather %>%
  select(ymd, tmin, tmax) %>%
  gather("type", "temp", tmin, tmax) %>%
  ggplot(mapping = aes(x=ymd, y=temp, color = type)) +
  geom_point(alpha = 0.25, show.legend = FALSE) + 
  geom_smooth(se=F, show.legend = FALSE) +
  labs(x = "Day", y = "Temp") 
  
########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather %>%
  group_by(tmin, ymd) %>%
  summarize(num_trips = n()) %>%
  ggplot(aes(x = tmin, y = num_trips)) + 
  geom_point() +
  geom_smooth() +
  labs(x="Min temp", y="Number of trips per day")

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
# add a smoothed fit on top of the previous plot, using geom_smooth
quantile(trips_with_weather$prcp, seq(0, 1, 0.1))   #sequential vector from 0 to 1, step=0.1

trips_with_weather %>%
  mutate(substantial_prcp = prcp >= quantile(prcp, 0.8)) %>%  #0.9 quantile works too!
  group_by(tmin, ymd, substantial_prcp) %>%
  summarize(num_trips = n()) %>%
  ggplot(aes(x = tmin, y = num_trips, color = substantial_prcp)) +
  geom_point(alpha = 0.25) +
  geom_smooth() +
  labs(x="Min temp", y="Number of trips per day")

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
# plot the above
(trips_by_hour <- 
  trips %>%
  mutate(starthour = hour(starttime)) %>%
  group_by(starthour, ymd) %>%
  summarize(num_trips = n()) %>%
  group_by(starthour) %>%
  summarize(avg_trips = mean(num_trips), sd_trips = sd(num_trips)))
trips_by_hour %>%
  ggplot(aes(x=starthour, y=avg_trips)) +
  geom_pointrange(aes(ymin= avg_trips - sd_trips, ymax = avg_trips + sd_trips))


# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
(trips_by_hour <- 
    trips %>%
    mutate(starthour = hour(starttime), weekend = wday(starttime) %in% c(1,7)) %>%
    group_by(starthour, ymd, weekend) %>%
    select(starthour, ymd, weekend) %>%
    summarize(num_trips = n()) %>%
    group_by(starthour, weekend) %>%
    summarize(avg_trips = mean(num_trips), sd_trips = sd(num_trips)))
trips_by_hour %>%
  ggplot(aes(x=starthour, y=avg_trips, color = weekend, fill = weekend)) +
  geom_point() +
  geom_ribbon(alpha = 0.2, aes(ymin= avg_trips - sd_trips, ymax = avg_trips + sd_trips))
=======
########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides

# plot the distribution of trip times by rider type

# plot the total number of trips over each day

# plot the total number of trips (on the y axis) by age (on the x axis) and age (indicated with color)

# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread() function to reshape things to make it easier to compute this ratio

########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting

########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this

# add a smoothed fit on top of the previous plot, using geom_smooth

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package

# plot the above

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
>>>>>>> 36a79647769ab70346f44b7064b71fdfd34cfca9
