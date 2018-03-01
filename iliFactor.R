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

flu.mortality.ili.data <- flu.mortality.ili.data %>% mutate(DEATH_RATE = (PREVIOUS.WEEKS.DEATHS / 
                                                                          YEAR.TOTAL.DEATHS) * 100)






my.ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      selectInput("trend.select", "Select a Trend", choices = c("2015 Trend" ,"2016 Trend", "2017 Trend", 
                              "Current Year"), selected = "")
      
      
    ),
    mainPanel(
      titlePanel("Influenza like illnesses compared to Death Rates"),
      plotOutput("ili.map")
      
    )
    
  )

  
)

my.server <- function(input, output) {
 
  output$ili.map <- renderPlot({
    
    plot.builder <- function(data.frame){
      ili.plot <- ggplot(data = flu.mortality.ili.data.year, aes(x = WEEK, y = Percentage, group = YEAR)) +
        geom_line(aes(y = PERCENT_UNWEIGHTED_ILI, color = "ili cases")) +
        geom_line(aes(y = DEATH_RATE, color = "Deaths"))
      return(ili.plot)
    }
    
  if(input$trend.select == "2015 Trend"){
    flu.mortality.ili.data.year <- flu.mortality.ili.data %>% filter(YEAR == "2015", (WEEK >= 48 & WEEK <= 52)) 
    
    plot.builder(flu.mortality.ili.data.2015)
  }
  #2-10 weeks for 2016 data trend
  else if(input$trend.select == "2016 Trend"){
    flu.mortality.ili.data.year <- flu.mortality.ili.data %>% filter(YEAR == "2016", (WEEK >= 2 & WEEK <= 10)) 
    
    plot.builder(flu.mortality.ili.data.year)
    
  }
   else if(input$trend.select == "2017 Trend"){
      flu.mortality.ili.data.year <- flu.mortality.ili.data %>% filter(YEAR == "2017", (WEEK >= 49 & WEEK <= 52)) 
      
      plot.builder(flu.mortality.ili.data.year)
      
    }
    else {
      flu.mortality.ili.data.year <- flu.mortality.ili.data %>% filter(YEAR == "2018", (WEEK >= 2 & WEEK <= 7)) 
      
      plot.builder(flu.mortality.ili.data.year)
      
    }
  
  }) 
  
  
}






shinyApp(ui = my.ui, server = my.server)
