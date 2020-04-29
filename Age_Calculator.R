library(lubridate)

make_date_age <- function(year, month, day){
  make_date(year, month, day)
}

age_calculator <- function(x, y, z){
  a = make_date_age(x, y, z)
  actual = today() - a
  print(as.duration(actual))
}

#example
age_calculator(1879, 06, 18)
#> [1] "4445280000s (~140.86 years)"  
      