source("setup.R")

ili.data.2015.2016 <- read.csv("./data/Washington_FluView_BySeason_2015-2016.csv", stringsAsFactors = FALSE)
ili.data.2017.2018 <- read.csv("./data/Washington_FluView_BySeason_2017-2018.csv", stringsAsFactors = FALSE)
flu.mortality.2015.2018 <- read.csv("./data/State_Washington_2015-18_Data.csv", stringsAsFactors = FALSE)

ili.data <- full_join(ili.data.2015.2016, ili.data.2017.2018)


ili.data <- ili.data %>% select(YEAR, WEEK, ILITOTAL, TOTAL.PATIENTS, 
                                X.UNWEIGHTED.ILI, NUM..OF.PROVIDERS) %>% 
                         rename(PERCENT_UNWEIGHTED_ILI = X.UNWEIGHTED.ILI, 
                                NUMBER_OF_PROVIDERS = NUM..OF.PROVIDERS)

#Contains flu mortality as well as ili reported cases
flu.mortality.ili.data <- na.omit(full_join(flu.mortality.2015.2018, ili.data)) 








my.ui <- fluidPage(
  
  sidebarLayout(
  
    sidebarPanel(
     
      selectInput("year.select", "Select a Year", choices = c("2015" ,"2016", "2017", 
                              "Current Year"), selected = "Current Year"),
     
      sliderInput("week.slider", "Display weeks of choice", 
                  min = 1, max = 52, value = c("", ""), sep = 1)
      
      
    ),
    mainPanel(
      
      
      titlePanel("Influenza like illnesses compared to death rates"),
      p("This plot displays a visual of ili cases (influenza like illnesses) alongside a plot of the desired
        year's deaths. Severity of any illness is best represented by the number of deaths it has caused, as
        the death count with any illness is what shocks the media most. When this media coverage happens, it 
        is statistically prevalent that more people are checking into hospitals for ili cases out of concern 
        for having the actual flu. Therefor, the higher the death count, the greater the number of ili cases 
        in any given year."),
      
      plotOutput("ili.map")
      
    )
    
  )

  
)

my.server <- function(input, output, session) {
  
  
  
  output$ili.map <- renderPlot({
    #Takes in a data frame, a string for a desired year, and two integers to specify a week range
    #that is then used to make a plot graph for ili/death rate data for the selected year.
    
    plot.builder <- function(mortality.ili.data, year.select, user.week, week.begin, week.end){
      
      suppressWarnings(flu.mortality.ili.data.year <- mortality.ili.data %>% filter(YEAR == year.select,
                                                                  WEEK >= user.week & WEEK <= week.end))
      
      
      updateSliderInput(session, "week.slider", value = c(user.week, user.week), 
                                         min = week.begin, max = week.end)
      
      ili.plot <- ggplot(data = flu.mortality.ili.data.year, aes(x = WEEK, y = Percentage, group = YEAR)) +
                  geom_line(aes(y = PERCENT_UNWEIGHTED_ILI, color = "ili cases")) +
                  geom_line(aes(y = PERCENT.P.I, color = "Deaths"))
      return(ili.plot)
    }
    
  if(input$year.select == "2015"){
    week.begin <- 40
    week.end <- 52
    user.week <- input$week.slider
    plot.builder(flu.mortality.ili.data, "2015", user.week, week.begin, week.end)
    
  }
  
  else if(input$year.select == "2016"){
    week.begin <- 1
    week.end <- 52
    user.week <- input$week.slider
    plot.builder(flu.mortality.ili.data, "2016", user.week, week.begin, week.end)
    
  }
  else if(input$year.select == "2017"){
    week.begin <- 40
    week.end <- 52
    user.week <- input$week.slider
    plot.builder(flu.mortality.ili.data, "2017", user.week, week.begin, week.end)
    
  }
  else {
      week.begin <- 1
      week.end <- 5
      user.week <- input$week.slider
      plot.builder(flu.mortality.ili.data, "2018",user.week, week.begin, week.end)
      
    }
  
  }) 
  

  
  
}






shinyApp(ui = my.ui, server = my.server)
