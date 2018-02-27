library("dplyr")

age.data <- read.csv('./data/AgeViewBySeason.csv', stringsAsFactors = FALSE)
season.12.thru.17 <- age.data[1:24, ]
season.05.thru.11 <- age.data[25:52, ]
season.04.thru.97 <- age.data[53:84, ]

getInfected <- function(season, age.group) {
  infected <- filter(season, Age.Group == age.group)
  infected <- mutate(infected, "Type_A" = sum(infected[, 3:7] / nrow(infected)),
                     "Type_B" = sum(infected[, 8:10]) / nrow(infected),
                     "Type_H3N2v" = sum(infected[, 11]) / nrow(infected))
  infected <- select(infected, Type_A, Type_B, Type_H3N2v)
  return(infected[1, ])
}

average.infected.test <- getInfected(season.05.thru.11, "0-4 yr")
