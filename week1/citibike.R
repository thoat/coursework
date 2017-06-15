library(tidyverse)
library(lubridate)
library(scales)

theme_set(theme_bw())

options(repr.plot.width=4, repr.plot.height=3)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
# trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# count the number of trips (= rows in the data frame)
# or: nrow(trips)
summarize(trips, count = n())

# find the earliest and latest birth years (see help for max and min to deal with NAs)
trips <- mutate(trips, birth_year = as.numeric(birth_year))
min(trips$birth_year, na.rm = TRUE)
max(trips$birth_year, na.rm = TRUE)

# use filter and grepl to find all trips that either start or end on broadway
filter(trips, grepl('broadway', start_station_name, ignore.case = T) | grepl('broadway', end_station_name, ignore.case = T))

# do the same, but find all trips that both start and end on broadway
filter(trips, grepl('broadway', start_station_name, ignore.case = T) & grepl('broadway', end_station_name, ignore.case = T))

# find all unique station names
# or: trips %>% count(start_station_name)
# or: trips %>% distinct(start_station_name)
# or: unique(combine(trips[,"start_station_name"], trips[,"end_station_name"]))
unique(trips$start_station_name)

# count the number of trips by gender
# or: trips %>% group_by(gender) %>% count()
trips %>%
  group_by(gender) %>%
  summarize(num_of_trips = n())

# compute the average trip time by gender
trips %>%
  group_by(gender) %>%
  summarise(avg_mis = mean(tripduration)/60)

# comment on whether there's a (statistically) significant difference
trips %>%
  group_by(gender) %>%
  summarize(avg_trip_time = mean(tripduration), sd_triptime = sd(tripduration))

# find the 10 most frequent station-to-station trips
trips %>%
  group_by(start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  group_by(start_station_name) %>%
  arrange(desc(count)) %>%
  head(10)

# find the top 3 end stations for trips starting from each start station
trips %>%
  group_by(start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  arrange(start_station_name, -count) %>%
  top_n(3)

# find the top 3 most common station-to-station trips by gender
trips %>%
  group_by(gender, start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  arrange(gender, desc(count)) %>%
  group_by(gender) %>%
  top_n(3)

# find the day with the most trips
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)
trips %>%
  mutate(startdate = as.Date(starttime)) %>%
  group_by(startdate) %>%
  summarize(num_trips = n()) %>%
  arrange(-num_trips) %>%
  head(1)

# compute the average number of trips taken during each of the 24 hours of the day across the entire month
hours <- Vectorize(hour)
(trips_per_hour <- 
  trips %>%
  group_by(starthour=hours(starttime), startdate=as.Date(starttime)) %>%
  summarize(num_trips=n()) %>%
  group_by(starthour) %>%
  summarize(avg_trips=mean(num_trips))) 
ggplot(trips_per_hour, aes(x = starthour, y=avg_trips)) + geom_bar(stat = "identity")

# what time(s) of day tend to be peak hour(s)?
filter(trips_per_hour, avg_trips==max(avg_trips))
