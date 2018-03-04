source("setup.R")

ili.data <- read.csv("./data/ILI_Washington.csv", stringsAsFactors = FALSE) %>%
  filter(YEAR != 2017) %>%
  filter(YEAR == 2013 | YEAR == 2014 | YEAR == 2015 | YEAR == 2016) %>%
  select(REGION, YEAR, WEEK, "ILI.Rate" = X.UNWEIGHTED.ILI)
colnames(ili.data)[1] <- "state"

death.data <- read.csv("./data/Flu_Death_Washington.csv", stringsAsFactors = FALSE) %>%
  select(state, "YEAR" = Year, "WEEK" = Week, "Mortality.Rate" = Percent.of.Deaths.Due.to.Pneumonia.and.Influenza)

full.data <- merge(death.data, ili.data)

my.ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("year.death", "Select a Year", choices = c(2013, 2014, 2015, 2016), selected = 2016),
      sliderInput("week.slider", "Display weeks of choice", 
                  min = 1, max = 37, value = c(1, 37), sep = 1)
    ),
    mainPanel(
      titlePanel("Influenza like illnesses compared to death rates"),
      p("This plot displays a visual of ili cases (influenza like illnesses) alongside a plot of the desired
        year's deaths. Severity of any illness is best represented by the number of deaths it has caused, as
        the death count with any illness is what shocks the media most. When this media coverage happens, it 
        is statistically prevalent that more people are checking into hospitals for ili cases out of concern 
        for having the actual flu. Therefor, the higher the death count, the greater the number of ili cases 
        in any given year."),
      plotlyOutput("ili.map")
    )
  )
)

my.server <- function(input, output, session) {
  death.current.data <- reactive({
    data <- filter(full.data, YEAR == input$year.death) %>%
      filter(WEEK >= input$week.slider[1] & WEEK <= input$week.slider[2])
    return(data)
  })
  
  output$ili.map <- renderPlotly({
    if (input$year.death == 2016) {
      updateSliderInput(session, "week.slider", max = 37)
    } else {
      updateSliderInput(session, "week.slider", max = 52)
    }
    
    plot = ggplot(data = death.current.data()) +
      geom_smooth(mapping = aes(x = WEEK, y = ILI.Rate, color = "ILI Rate")) +
      geom_smooth(mapping = aes(x = WEEK, y = Mortality.Rate, color = "Mortality Rate")) +
      labs(title = "Mortality Rate vs ILI Rate",
           x = "Week",
           y = "Percentage (%)",
           color = "Category"
      )
    ggplotly(plot, tooltip = c("y"))
  })
}

shinyApp(ui = my.ui, server = my.server)
