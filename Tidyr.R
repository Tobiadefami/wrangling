# Tidy Data with tidyr
library(tidyverse)
library(nycflights13)
# Tidy Data
table1 # this is the omly tidy data
table2
table3
table4a
table4b

# Working with table1:
# compute rate per 10,000
table1 %>%
  mutate(rate = cases / population * 10000)
# compute cases per year
table1 %>%
  count(year, wt = cases)
# visualize changes over time
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country))

cases <- table2 %>%
  count(type == "cases")


# Spreading and Gathering

# Gathering
table4a
filter(table1, year == 1999 | year == 2000)
arrange(select(filter(table1, year == 1999), year:cases))
arrange(filter(table1, year == 1999 | year == 2000)) # foolingz around

table4a # an example where some of the column names are not names of variables, but values of variables

# using gather to tidy table4a
table4a %>%
  gather('1999', '2000', key = "year", value = "cases")
# using gather to tidy table4b
table4b %>%
  gather('1999', '2000', key = "year", value = "population")

# to combine the tidied versions of table4a and table4b use dplyr::left_join()

tidy4a <- table4a %>% 
  gather('1999', '2000', key = "year", value = "class")
tidy4b <- table4b %>% 
  gather('1999', '2000', key = "year", value = "population")
left_join(tidy4a, tidy4b)

# Spreading
# this is used when an operation is scattered across multiple rows
table2

# using spread() on table2
table2 %>% 
  spread(key = "type", value = "count")

stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(   1,   2,   1,   2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", '2015':'2016')

table4a %>% 
  gather('1999', '2000', key = "year", value = "cases")

preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes", NA, 10,
  "no",  20, 12
)
preg %>% 
  gather(male, female, key = "sex", value = "pregnant")


# Seperating and Pull
# for table3
table3

table3 %>% 
  separate(rate, into = c("cases", "population"))

# if you wish to use a specific character to separate a column use the sep argument
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

# to convert affected columns to ideal data types use convert = TRUE
table3 %>% 
  separate(
    rate,
    into = c("cases", "population"),
    sep = "/",
    convert = TRUE
  )
# yoou can also pass a vector of integers to sep
table3 %>% 
  separate(
    year, 
    into = c("century", "year"),
    sep = 2
  )

# Unite
# this is used to combine multiple columns into a column
table5 %>% 
  unite(new, century, year)

# using the sep argument to remove any separator
table5 %>% 
  unite(new, century, year, sep = "")

# exercise
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"),
           extra = "drop")

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"),
           remove = TRUE)

# MISSING VALUES
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(1, 2, 3, 4, 2, 3, 4),
  return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)
# to make the implicit missing values explicit in the stocks dataset
stocks %>% 
  spread(year, return)
# to turn explicit missing values implicit
stocks %>% 
  spread(year, return) %>% 
  gather(year, return, '2015':'2016', na.rm = TRUE)
# another important tool for making missing values explicit is complete()
stocks %>% 
  complete(year, qtr)

treatment <- tribble(
  ~ person,          ~treatment, ~response,
  "Derric Whitmore", 1,           7,
  NA,                2,           10,
  NA,                3,           9,
  "Katherine Burke", 1,           4
)

treatment %>% 
  complete(person)

# Case study
who
View(who)

# first step to tidy the who data is to gather the columns that aint variables
who1 <- who %>% 
  gather(
    new_sp_m014:newrel_f65,
    key = "key",
    value = "cases",
    na.rm = TRUE
  )
who1
View(who1)

# get some hint of the structure of the values in the new key column by counting them
who1 %>% 
  count(key)

# fix the format of the column names
who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2
View(who2)

# separate the values in each code with two passes of sseparate
who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3

# drop the new, iso2, and iso3 columns
who3 %>% 
  count(new)

who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
who4
# separate sexage into sex and age by splitting after the first character
who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

# alternativelyy you can build up a complex pipe
who %>% 
  gather(unknown, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(unknown = stringr::str_replace(unknown, "newrel", "new_rel")) %>% 
  separate(unknown, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

#exercise
who6 <- who %>% 
  gather(unknown, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(unknown = stringr::str_replace(unknown, "newrel", "new_rel")) %>% 
  separate(unknown, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

View(who6)

Afghan <- who6 %>% 
  filter(country == "Afghanistan") %>%
  group_by(country, year, sex) %>% 
  summarise(cases = sum(value))
    
ggplot(Afghan, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country)) 

