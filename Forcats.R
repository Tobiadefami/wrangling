# Factors with forcats
library(tidyverse)

# Creating Factors

x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")

# create a list of the valid levels
month_levels <- c(
   "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  )
# now create the factor
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
# any values not in the set will be converted to NA
y2 <- factor(x2, levels = month_levels)
y2
# if you wanna print an error
y2 <- parse_factor(x2, levels = month_levels)

factor(x1)
# matchng the order of the levels with the order of the first appearance in the data
f1 <- factor(x1, levels = unique(x1)) 
f1
f2 <- x1 %>% 
  factor() %>% 
  fct_inorder()
f2
levels(f2) # accessing the set of valid levels directly

# General Social Survey
forcats::gss_cat
glimpse(gss_cat)

# view the levels of the factors with count() or a bar chart
gss_cat %>% 
  count(race)
gss_cat %>% 
  count(rincome)

ggplot(gss_cat, aes(race)) +
  geom_bar()
ggplot(gss_cat, aes(rincome)) +
  geom_bar()
# to show levels that do not have any values
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = F)
# EXPLORE 
gss_cat %>% 
  count(relig)
ggplot(gss_cat, aes(relig)) +
  geom_bar()

gss_cat %>% 
  count(partyid)

gss_cat %>% 
  ggplot(aes(partyid)) +
  geom_bar()

# Modifying Factor Order

# exploring the average number of hours spent watching TV per day across religions
relig <- gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T),
    n = n()
)
relig

ggplot(relig, aes(tvhours, relig)) +
  geom_point()
# using fct_reorder to add a pattern to the above plot
ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

#it's recommended to move the transformations out of aes() and into a separate mutate() step
# the above plot can be re-written as
relig %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(tvhours, relig)) +
  geom_point()

# creating a similar plot looking at how average age varies accross reported income level
rincome <- gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome, aes(age, fct_reorder(rincome, age))) +
  geom_point()
# or
rincome %>% 
  ggplot(aes(age, rincome)) +
  geom_point()

# to pull "Not applicable" to the front with the other special levels
ggplot(
  rincome,
  aes(age, fct_relevel(rincome, "Not applicable"))
) +
  geom_point()
# or
rincome %>% 
  mutate(rincome = fct_relevel(rincome, "Not applicable")) %>% 
  ggplot(aes(age, rincome)) +
  geom_point()

# Reodering with fct_reorder()
by_age <- gss_cat %>% 
  filter(!is.na(age)) %>% 
  group_by(age, marital) %>% 
  count() %>% 
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, color = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(color = "marital")
# for bar plots
gss_cat %>% 
  mutate(marital = marital %>% 
           fct_infreq() %>% 
           fct_rev()) %>% 
  ggplot(aes(marital)) +
  geom_bar()

# modifying Factor levels
gss_cat %>% 
  count(partyid)

# tweaking the levels to be longer and use a parallel construction
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"                       
    )) %>% 
  count(partyid)

# To combine levels
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>%
  count(partyid)

# to collapse a lot of levels

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
    other = c("No answer", "Don't know", "Other party"),
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Independent", "Ind,near dem"),
    dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

# To lump together all the small groups to make a plot or table simpler
gss_cat %>% 
  mutate(relig = fct_lump(relig)) %>% 
  count(relig)

gss_cat %>% 
  mutate(relig = fct_lump(relig, n = 10)) %>% 
  count(relig, sort = TRUE) %>%
  print(n = Inf)
          