#!/bin/bash
#
# add your solution after each of the 10 comments below
#

# count the number of unique stations
cut -d, -f4,8 201402-citibike-tripdata.csv | tr , "\n" | sort | uniq -c | tail -n +3 | wc -l
# (1) actually, all unique stations are represented in the startStation and endStation columns --> I can rely in either of them, don't need both.
# (2) tail -n+3 === head -n-2 (skip first 2 rows)
# (3) tail or head MUST be after sort | uniq -c; else, the header row(s) are not removed
# awk answer: NR > 1 === skip row no. 1
# awk -F, 'NR > 1 {counts[$8]++} END {for (k in counts) print counts[k]" " k}' 201402-citibike-tripdata.csv | wc -l
#######################################################################

# count the number of unique bikes
cut -d, -f12 201402-citibike-tripdata.csv | sort | uniq -c | head -n-1 | wc -l
# awk answer: awk -F, 'NR > 1 {count[$12]++} END {for (k in count) print count[k]" " k}' 201402-citibike-tripdata.csv | wc -l

# count the number of trips per day

# find the day with the most rides

# find the day with the fewest rides

# find the id of the bike with the most rides

# count the number of rides by gender and birth year

# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)

# compute the average trip duration

- Number of rows (incl. headers): 224,737
- Number of unique bikeid's (incl. header): 5700
- `tatoo.txt` stores: num_of_instances | bikeid | usertype. This file is sorted by num_of_instances. ONE INTERESTING THING to discover is: when is the "cut-off" - the minimum num_of_instances where there's no longer any Customer type. i.e. everything from this num and above is of Subscriber type. Because by first look, Customer occupies the top of the file aka small num_of_instances.
