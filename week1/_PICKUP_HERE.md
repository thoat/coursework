# Things to pick up

## Practice syntax EVERYDAY:

### R:

https://practice.datacamp.com/p/2

** If sth is unclear, consult:

- [Basic types](http://www.r-tutor.com/r-introduction/basic-data-types): (numeric, character, logical, factor)
- Vectors, lists, dataframes: a [one page reference](http://www.statmethods.net/input/datatypes.html) and [more details](https://en.wikibooks.org/wiki/R_Programming/Data_types)
- Rstudio's [data wrangling cheatsheet](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

### Memorize stuff:

- 15-30 mins/day drilling all cards. Drill "failed" cards till bored. Retry all cards.
- 5 mins before bed: drill "failed" cards.

## Revisit this next Sun (12/16/2018):

- Click on "Start Project" [here](https://www.datacamp.com/home)

## Work left from Sun, 12/9/2018

### Intro to R:

- Fill in solutions to `./citibike.R`

- Maybe the day after:
   - Read ch2 & 3 in R for Data Science, and think about how to generate Fig1 and 2 in The Anatomy of the Long Tail.

---
NEXT

- Do `plot_trips.R` to review basic R viz

- WORTH CARE: [RStudo's ggplot2 cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf)

- Spend 1-2 days trying out the materials under ["References"](https://github.com/msr-ds3/coursework/tree/master/week1#plotting), e.g.
  - RStudio's ggplot2 cheatsheet
  - Sean Anderson's slides
  - R Graphics Cookbook
  - Videos on visualizing data with ggplot2
  - _Optional: Official ggplot2 docs (not that long)_

## Work left from 12/10/2018 (Mon)

### Commandline tutorials:

- Continue [here: _Learn more (optional)_](https://github.com/msr-ds3/coursework/tree/master/week1#learn-more-optional-1)

- Exercise `citibike.sh`: continue 2-4 more questions

---
MAYBE:

- ["R Packages" book](http://r-pkgs.had.co.nz/)

MAYBE, MAYBE NOT: (cuz not help me w/ core stats & research design)

- https://www.kaggle.com/learn/overview
- https://www.kaggle.com/c/titanic#tutorials (mostly good for doing Kaggle competitions)

## Work left from 12/13/2018 (Thu)

### Commandline:

- On Codecademy: [Learn Bash scripting](https://www.codecademy.com/courses/learn-the-command-line/lessons/learn-bash-scripting/exercises/introduction)
- Pick up [CL crashcourse on "Learn Python the Hard Way"](https://learnpythonthehardway.org/book/appendix-a-cli/ex14.html)

### R programming:

- [Cyclismo's](http://www.cyclismo.org/tutorial/R/index.html) more extensive tutorial (e.g. Distributions, Intermediate Plotting) -- SHORT ENOUGH, CAN BE DONE IN 1-2 DAYS - PRIORITIZE THIS OVER Hadley's Advanced R, because this is more for DS while Hadley's is more for programming
- Pick up [Hadley's Advanced R](http://adv-r.had.co.nz/Data-structures.html) - might do like a 30mins/day?

- Next: week 2 - day 1: these stats topics are a bit tough & need more + spaced repettion practice!
- After that, resume: data viz, data combine & reshape (incl. CLEANING DATA TUTS on DataCamp), Makefile & reproducibility

## Work left from 12/15/2018 (Sat)

### R syntax:

- [Lists and double square brackets](http://www.r-tutor.com/r-introduction/list). Example:

```{r}
> lst <- list(
   x = c(-5, 2),
   y = c(TRUE, TRUE),
   z = c("M", "N")
)
> str(lst)
List of 3
  $ x: num [1:2] -5 2
  $ y: logi [1:2] TRUE TRUE
  $ z: chr [1:2] "M" "N"
> lst[2]
$y
[1] TRUE TRUE
> lst[[2]]
[1] TRUE TRUE
```

- [Factor levels](https://campus.datacamp.com/courses/free-introduction-to-r/chapter-4-factors-4?ex=4): 
  - "When you first get a data set, you will often notice that it contains factors with specific factor levels. However, sometimes you will want to change the names of these levels for clarity or other reasons. R allows you to do this with the function `levels()`":

```{r}
data_vector <- c("data1", "data1", "data2", "data1", ...)
factor_vector <- factor(data_vector)
levels(factor_vector) <- c("newname1", "newname2", ...)
```