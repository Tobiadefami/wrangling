# Tibble with tibble
library(tidyverse)
library(nycflights13)

# coerce a data frame to a tibble with
as_tibble(iris)

# creating a tibble from individual vectors
tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
 )

tb <- tibble(
  ':)' = "smile",
  ' ' = "space",
  '2000' = "number"
)

tb

# using tribble() to create a tibble
tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5
)

# Tibbles Versus data.frame

# printing: they print the first 10 variables just to fit the screen
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# when more output is needed than the default display:
nycflights13::flights %>%
  print(n = 10, width = Inf)

# OR use R studio's built-in data viewer
nycflights13::flights %>%
  View()

#SUBSETTING
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
# Extract by name
df$x

# to use these in a pipe, use the special placeholder .
df %>% .$x
df %>% .[["x"]]

# interacting with older code
# use as.data.frame() to turn a tibble back to a data.frame
class(as.data.frame(tb))

class(mtcars)
class(mpg)

df <- data.frame(abc = 1, xyz = "a")

df <- tibble(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]


# Data Import with readr
diamondsX <- read_csv("diamonds.csv")
# supplying an inline csv
read_csv("a,b,c
         1,2,3
         4,5,6")

# to skip the lines of metadata at the top of a file
read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)

read_csv("# A comment I want to skip
         x,y,z
         1,2,3", comment = "#")
# for a data that doesnt have column names
read_csv("1,2,3\n4,5,6", col_names = FALSE)

# allternatively col_names can be passed as a character vector
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

# missing values
read_csv("a,b,c\n1,2,.", na = ".")

# Parsing a vector: these functions take a character vector & return a more specialised vector

str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-04")))

parse_integer(c("1", "231", ".", "456"), na = ".")

# parsing with problems
x <- parse_integer(c("123", "345", "abc", "123.45"))
x
problems(x)

# parsing example
my.name <- readline(prompt="Enter name: ")
my.age <- readline(prompt="Enter age: ")
# convert character into integer
my.age <- parse_integer(my.age)
print(paste("Hi,", my.name, "next year you will be", my.age + 1, "years old."))


# Numbers
# 1
parse_double("1.23") # specifies parsing options that differ from place to place 
parse_double("1,23", locale = locale(decimal_mark = ","))
# 2
parse_number("$100") # ignores non-numeric characters before and after the number
parse_number("20%")
parse_number("It costs $123.45")
#3
# used in America
parse_number("$123,456,789")
# used in many parts of Europe
parse_number("$123.456.789", 
             locale = locale(grouping_mark = ".")) #combintng parse_number and locale
# Used in Switzerland
parse_number("$123'456'789", locale = locale(grouping_mark = "'"))

# Strings
# how coomputers represent strings in R
charToRaw("Chief")
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
# to fix the above codes
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "shift-JIS"))

# if you dont know the encoding to use
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

# Factors: Represent categorical variables that have a known set of possible values
fruit <- c("apple", "banana")
# give parse_factor() a vector of known levels
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

# Dates, Date-Times, and Times
# parse_datetime() ecpects an ISO8601 date-time
parse_datetime("2010-10-01T2010")

# if time is omitted, it will be set to midnight
parse_datetime("20101010")

parse_date("2010-10-01")

# parse_time()
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

# Parsing a file
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("T", "F"))
guess_parser(c("1", "2", "3"))
guess_parser(c("12,352,561"))

str(parse_guess("2010-10-10"))
# problems
challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
#column specification
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_integer(),
    y = col_character()
  )
)
# tweaking the type of the x column
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)
# change the dates from character stings to dates
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)


# Other strategies for parsing files
challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max = 1001
)

# sometimes reading all the columns as character vectors makes it easier to diagnose problems
challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character())
)

# This is particularly useful in conjunction with type_convert()
df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df
# note the column names
type_convert(df)

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

#using feathers
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")