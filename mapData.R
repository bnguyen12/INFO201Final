source("setup.R")

map.data <- read.csv("./data/Flu_Map_Coverage.csv") %>%
  select("region" = STATENAME, "activity" = ACTIVITYESTIMATE)

# Capitalize first letter of anything
capFirst <- function(word) {
  paste0(toupper(substring(word, 1, 1)), substring(word, 2))
}

locations <- map_data("state")
locations$region <- capFirst(locations$region)
locations <- full_join(locations, map.data)