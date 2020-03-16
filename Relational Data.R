# RELATIONAL DATA WITH DPLYR
library(tidyverse)
library(nycflights13)

#tibbles to be used
airlines
airports
planes
weather
# Keys
# explicit keys
planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

# non explicit keys
flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)

as_tibble(Lahman::Batting)
Lahman::Batting %>% 
  count(playerID, yearID, stint, teamID, lgID) %>% 
  filter(n > 1)

ggplot2::diamonds %>% 
  count(carat, cut, color, clarity, depth, table, price) %>% 
  filter(n > 1)

# Mutating Joins: Combine variables from two tables

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

# add the full airline name to flights2
flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")
# the above code does the same as 
flights2 %>% 
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# Understanding Joins
x <- tribble(
  ~key, ~val_x,
     1, "x1",
     2, "x2",
     3, "x3"
)

y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2",
     4, "y3"
)

# Inner Join
x %>% 
  inner_join(y, by = "key")

# Duplicate Keys
# for one table with a duplicate key
x <- tribble(
  ~key, ~val_x,
     1, "x1",
     2, "x2",
     2, "x3",
     1, "x4"
)

y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2"
)

left_join(x, y, by = "key")

# for both tables having duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)

y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2",
     2, "y3",
     3, "y4"
)

left_join(x, y, by = "key")

# Defining the key columns

# by = NULL
View(flights2 %>% 
  left_join(weather)
)

# by = "x"
View(flights2 %>% 
  left_join(planes, by = "tailnum")
)

# a named character vector: by = c("a" = "b")
flights2 %>% 
  left_join(airports, by = c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))

airports %>% 
  semi_join(flights, c("faa" = "dest")) %>% 
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# FIltering Joins
# semi-joins: matching a filtered table back to the original rows

#find the top-10 most popular destinations
top_dest <- flights %>% 
  count(dest, sort = TRUE) %>% 
  head(10)
top_dest
arrange(top_dest, dest)

# find each flight that went to one of those destinations
flights %>% 
  filter(dest %in% top_dest$dest)

flights %>%
  semi_join(top_dest)

anti_join(flights, airports, by = c("dest" = "faa"))

# Set operations
df1 <- tribble(
  ~x, ~y,
   1, 1,
   2, 1
)

df2 <- tribble(
  ~x, ~y,
   1, 1,
   1, 2
)
# the four possibilities are
intersect(df1, df2) # Return only observations in both x and y
union(df1, df2) # Return unique observations in x and y
setdiff(df1, df2) # Return observations in x, but not in y
setdiff(df2, df1) # Return observations in y, but not in x


