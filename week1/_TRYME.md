# Stuff to put into use right away!!

## Bash

* Redirect output to file / to program

```shell
ls -alh > myfile
cat < myfile
```

------

* Pipe

```shell
# add line numbers to directory listing
ls -talh | cat -n
```

------

* Look at headers in a csv file

```shell
head -n1 tripdata.csv

# more advanced: creat a numbered list of column headers, by
# translating commas to newlines and adding line numbers
head -n1 tripdata.csv | tr , '\n' | cat -n
```

------

* Extract data in a specific column

```shell
# specify ',' as a deliminter; want column 15; limit output to first 10 lines
cut -d, -f15 tripdata.csv | head

# more advanced: before doing `head`, pipe the column into `sort` for comparison purposes

# more advanced: pipe through `grep [0-9]` to limit to rows with a number

# more advanced: pipe through `uniq -c` to count unique instances
```

* Compare `awk` with normal listing

```shell
# count all trips that start & end in Broadway
# similar to: cut -d, -f5,9 tripdata.csv | grep 'Broadway.*Broadway' | wc -l 
awk -F, '$5 ~ /Broadway/ && $9 ~ /Broadway/' tripdata.csv | wc -l

# print trip counts by gender
# similar to: cut -d, -f15 tripdata.csv | sort | uniq -c
awk -F, '{counts[$15]++} END {for (k in counts) print counts[k]" " k}' tripdata.csv
```

## Data review in R

Two ways to easily look at data in transposed view:

* `str(mydata)`: (structure) function
* `dplyr.glimpse(mydata)`: look at data in transposed view. Has a few advantages over `str()` (see `?glimpse`).

## Plotting in R

* Set image to a nice size

```r
# the 'options' function sets global options
options(repr.plot.width = 4, repr.plot.height = 4)
```

------

## Project

For ML/Prediction problems:

1. First step: explore the data. make lots of plots.
2. Choose an algorithm (scikilearn has a chart to help you choose an algorithm)
3. How good is your algo: cross-validation
  - keep track of your cross-validation scores -- use a lab notebook, make a note when you change sth & record the cv score
  - save the script you use for each submission
  - once you have sth working, then invest more time in feature engineering

How to get good at DS:

- Cross-training with different problems
- Have vacation time to spend on (kaggle)
- Others have helped me with DIY ds
- Read people's questions & thought trains in Kaggle forums
- Write up & put in resume/GitHub
- kaggle does have its disadvantages. Don't overtrain yourself in Kaggle and miss out on other DS skills.
  - kaggle tidies the data for you
  - kaggle doesn't reward including error bars or presenting your results nicely
  - lots of DS jobs are primarily stats with little ML. Kaggling does NOT help you learn __stats__ or __experimental design__.