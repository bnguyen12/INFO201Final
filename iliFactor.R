source("setup.R")

ili.data.2015.2016 <- read.csv("./data/Washington_FluView_BySeason_2015-2016.csv", stringsAsFactors = FALSE)
ili.data.2017.2018 <- read.csv("./data/Washington_FluView_BySeason_2017-2018.csv", stringsAsFactors = FALSE)
flu.mortality.2015.2018 <- read.csv("./data/PedFluDeath_WeeklyData_2015-2018.csv", stringsAsFactors = FALSE)

ili.data <- full_join(ili.data.2015.2016, ili.data.2017.2018)


ili.data <- ili.data %>% select(YEAR, WEEK, ILITOTAL, TOTAL.PATIENTS, 
                                X.UNWEIGHTED.ILI, NUM..OF.PROVIDERS) %>% 
                         rename(PERCENT_UNWEIGHTED_ILI = X.UNWEIGHTED.ILI, 
                                NUMBER_OF_PROVIDERS = NUM..OF.PROVIDERS)

#Contains flu mortality as well as ili reported cases
flu.mortality.ili.data <- na.omit(full_join(flu.mortality.2015.2018, ili.data)) 

flu.mortality.ili.data.2016 <- flu.mortality.ili.data %>% filter(YEAR == "2017") %>% 
                                                          mutate(DEATH_RATE = (PREVIOUS.WEEKS.DEATHS / 
                                                                               YEAR.TOTAL.DEATHS) * 100)

map1 <- ggplot(data = flu.mortality.ili.data.2016, aes(x = WEEK, y = Percentage, group = YEAR)) +
           geom_line(aes(y = PERCENT_UNWEIGHTED_ILI, color = "ili cases")) +
           geom_line(aes(y = DEATH_RATE, color = "Deaths"))


