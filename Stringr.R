# STRINGS WITH Stringr
library(tidyverse)

# string basics
string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

# to include a literal single or double quote
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
Todo <- TRUE

str_c(
  "Good ", time_of_day, " ", name,
  if(Todo) ", get up and WRITE SOME CODES",
  "!!!"
)

# to collapse a vector of strings into a single string, use collapse
str_c(c("x", "y", "z"), collapse = ", " )

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

# Matching Patterns with Regular Expressions

# Basic Matches

# the simplest patterns match exact strings
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

# to create regular expressions, we need \\
dot <- "\\."

# but the expression itself only contains one:
writeLines(dot)

# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)

str_view(x, "\\\\")

# Anchors
x <- c("apple", "banana", "pear")
str_view(x, "^a") # for matching the start of a string

str_view(x, "a$") # for matching the end of a string

# to force a regular expression to only match a complete string,
# anchor it with both ^ and $:

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")

str_view(x, "^apple$")

# CHaracter Classes and Alternatives
str_view(c("grey", "gray"), "gr(e|a)y")

# Repetition
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")

str_view(x, "CC+")

str_view(x, 'C[LX]+')

# number 0f matches can also be specified
str_view(x, "C{2}")

str_view(x, "C{2,}")

str_view(x, "C{2,3}")

# to make these matches "lazy" use ?
str_view(x, 'C{2,3}?')

str_view(x, 'C[LX]+?')

# Grouping and Backreferences
# the following regexp finds all fruits that have a repeated pair of letters
str_view(fruit, "(..)\\1", match =  TRUE)

# Tools
# Detect Matches
x <- c("apple", "banana", "pear")
str_detect(x, "e")
as.double(str_detect(x, "e")) # convert to double

# how many words start with t?
str_detect(words, "^t")
sum(str_detect(words, "^t"))
# What proportion of common words end with a vowel?
str_detect(words, "[aeiou]$")
mean(str_detect(words, "[aeiou]$"))

# find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# find all words consisting of consonants (non- vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

# use str_detect() to select the elements that match a pattern
words[str_detect(words, "x$")]
# or
str_subset(words, "x$")

# using filter instead
df <- tibble(
  word = words,
  i = seq_along(word) # create a column that generates a regular sequence
)

df %>% 
  filter(str_detect(words, "x$")) # filter words that end in x

# A variation of str_detect() is str_count(): tells you how many matches there are in a string
x <- c("apple", "banana", "pear") %>% 
  str_count("a")
x

# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

# it's natural to use str_count() with mutate()
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

# note that matches never overlap
str_count("abababa", "aba")
str_view_all("abababa", "aba")

# Extract Matches

# Using the Havard Sentences
length(sentences)
head(sentences)

# to find all seentences that contain a color
colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse = "|")
color_match

# select the sentences that contain a color, and then extract the color
has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

# Selecting all the sentences that have one than one match
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(more, color_match)

# to get all matches
str_extract_all(more, color_match)
# to return a matrix
str_extract_all(more, color_match, simplify = T)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = T)

# Grouped matches
noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>% 
  str_subset(noun) %>% 
  head(10)
has_noun %>% 
  str_extract(noun)
# this gives each individual coomponent
has_noun %>% 
  str_match(noun)

# if your data is in a tibble use tidyr::extract()
tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = F
  )

# Replacing Matches

# Replacing a pattern with a fixed string
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", ".")
str_replace_all(x, "[aeiou]", ".")

# you can perform multiple replacements by supplying a named vector
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

# instead of replacing with a fixed string, you can use backreferences
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2" ) %>% 
  head(5)
# compare
sentences %>% 
  head(5)

# Splitting
sentences %>% 
  head(5) %>% 
  str_split(" ") # this reurns a list

# if it's a 1-length vector
"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]] # extract the first element of the list

# use simplify = T to turn it into a vector
sentences %>% 
  head(5) %>% 
  str_split(" ", simplify = T)

# a max number of pieces can also be requested
fields <- c("Name: Chief", "Country: NG", "Gender: M")
fields %>% 
  str_split(": ", n = 2, simplify = T)

# Splitting by character, line, sentence, and word boundary()
x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("sentence"))

str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]

# Other Types of Patterns

# the regular call
str_view(fruit, "nana")
# is shortened for
str_view(fruit, regex("nana"))

# ignore_case = TRUE
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

# multiline = TRUE
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = T))

# comments = TRUE
phone <- regex("
  \\(?     # optional opening parens
  (\\d{3}) # area code
  [)- ]?   # optional closing parens, dash, or space
  (\\d{3}) # another three numbers
  [ -]?    # optional space or dash
  (\\d{3}) # three more numbers",
  comments = T )

str_match("514-791-8141", phone)

# Functions useful instead of regex()

# fixed()
library(microbenchmark)
microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)

a1 <- "\u00e1"
a2 <- "a\u0301"
c(a1, a2)
a1 == a2 # they render identically, but they're defined differently

str_detect(a1, fixed(a2))
str_detect(a1, coll(a2)) # this respetcs human character comparison rules

# coll()
i <- c("I", "İ", "i", "ı")
str_subset(i, coll("i", ignore_case = TRUE))
str_subset(
  i, 
  coll("i", ignore_case = TRUE, locale = "tr")
)

# boundary() can also bbe used with other functions
x <- "This is a sentence"
str_view_all(x, boundary("word"))

str_extract_all(x, boundary("word"))

# Other Uses of Regular Expressions

# apropos(): searches all objects available from the global env
apropos("replace") # also useful if you cant quite remember the name of a function

# dir(): lists all files in a directory
head(dir(pattern = "\\.Rmd$")) # an exapmle to find all the R-Md files in the current directory


