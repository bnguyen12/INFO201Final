source("setup.R")

ili.data <- read.csv("./data/ILI_Washington.csv", stringsAsFactors = FALSE) %>%
  filter(YEAR != 2017) %>%
  filter(YEAR == 2013 | YEAR == 2014 | YEAR == 2015 | YEAR == 2016) %>%
  select(REGION, YEAR, WEEK, "ILI.Rate" = X.UNWEIGHTED.ILI)
colnames(ili.data)[1] <- "state"

death.data <- read.csv("./data/Flu_Death_Washington.csv", stringsAsFactors = FALSE) %>%
  select(state, "YEAR" = Year, "WEEK" = Week, "Mortality.Rate" = Percent.of.Deaths.Due.to.Pneumonia.and.Influenza)

full.data <- merge(death.data, ili.data)