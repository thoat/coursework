#!/bin/bash
#
# add your solution after each of the 10 comments below
#

# count the number of unique stations
awk -F, 'NR > 1 {count[$9]++} END {for (k in count) print count[k]"\t" k}' 201402-citibike-tripdata.csv | wc -l
# or: cut -d, -f8 201402-citibike-tripdata.csv | sort | uniq -c | head -n-1 | wc -l


# count the number of unique bikes
awk -F, 'NR > 1 {count[$12]++} END {for (k in count) print count[k]"\t" k}' 201402-citibike-tripdata.csv | wc -l
# or: cut -d, -f12 201402-citibike-tripdata.csv | sort | uniq -c | head -n-1 | wc -l


# count the number of trips per day
cut -d, -f2 201402-citibike-tripdata.csv | cut -c 2-11 | awk 'NR > 1 {count[$1]++} END {for (k in count) print count[k]"\t" k}' | sort -k2
# or: cut -d, -f2 201402-citibike-tripdata.csv | cut -c 2-11 | sort | uniq -c | head -n-1 


# find the day with the most rides
cut -d, -f2 201402-citibike-tripdata.csv | cut -c 2-11 | sort | uniq -c | sort -rnk1 | head -n1


# find the day with the fewest rides
cut -d, -f2 201402-citibike-tripdata.csv | cut -c 2-11 | sort | uniq -c | sort -rnk1 | tail -n2 | head -n1


# find the id of the bike with the most rides
cut -d, -f12 201402-citibike-tripdata.csv | sort | uniq -c | sort -rnk1 | head -n1


# count the number of rides by gender and birth year
# if you don't need sorting
cut -d, -f15,14 201402-citibike-tripdata.csv | sort | uniq -c
# if you want the list to be sorted
cut -d, -f15,14 201402-citibike-tripdata.csv | sort -k1.2 | sort -k1.9 | uniq -c


# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
# or cut -d, -f5 201402-citibike-tripdata.csv | grep '[0-9].*[^&].*[0-9]' | wc -l
awk -F, '$5 ~ /Broadway/ && $9 ~ /Broadway/' 201402-citibike-tripdata.csv | wc -l



# compute the average trip duration
# jake's answer: tr -d '"' < filename.cvs | awk -F, '{total+= $1} END {print total/(NR-1)}' 
# or: ....................................| awk -F, 'NR > 1 {total+= $1} END {print total/NR}'
cut -d, -f1 201402-citibike-tripdata.csv | tr -d '"' | awk -F, '{sum += $1; n++} END { if (n>0) print sum / n}'