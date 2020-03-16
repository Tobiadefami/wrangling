# STRINGS WITH Stringr
library(tidyverse)
library(stringr)

# string basics
string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

# To see the raw contents of a string
x <- c("\"", "\\")
writeLines(x)
# multiple srtings are often stred with a character vector
c("one", "two", "three")

# String Length
str_length(c("a", "R for data science", NA))

# Combining Strings with str_C()
str_c("x", "y")
str_c("x", "y", "z")
# use the sep argument to control how they are separated
str_c("x", "y", sep = ", ")
#if you want missing values to print as NA, use str_replace_na()
x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")
# str_c() is vectorised
str_c("prefix-", c("a", "b", "c"), "-suffix")
# Objects of length 0 are silently dropped
name <- "Chief"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if(birthday) " and HAPPY BIRTHHDAY",
  "."
)

name <- "Chief"
time_of_day <- "morning"
birthday <- TRUE

str_c(
  "Good ", time_of_day, " ", name,
  if(birthday) " and HAPPY BIRTHHDAY",
  "."
)

# to collapse a vector of strings into a single string, use collapse
str_c(c("x", "y", "z"), collapse = " " )

# Subsetting Strings
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)
# str_sub willact the same even if the vector is too short
str_sub("a", 1, 5)
# the assignment form of str_sub can also be used to modify strings
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

# Locales

# Turkish has two i's: with and without a dot, and it
# has a different rule for capitalizing them:
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

#sorting
x <- c("apple", "eggplant", "banana")

str_sort(x, locale = "em") # English

str_sort(x, locale = "haw") # Hawaiian

      