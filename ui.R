source("ageFactor.R")
source("iliFactor.R")

ui <- fluidPage(
  titlePanel("Flu Data"),
  tabsetPanel(type = "tabs",
    tabPanel("Age Data",
      sidebarLayout(
        sidebarPanel(
          br(),
          radioButtons("season", label = "Which Seasons",
                  c("Seasons 2012-2017" = "12-17",
                    "Seasons 2005-2011" = "05-11",
                    "Seasons 1997-2004" = "97-04"))
        ),
        mainPanel(
          plotlyOutput("age.plot.type.A"),
          br(),
          plotlyOutput("age.plot.type.B"),
          br(),
          plotlyOutput("age.plot.type.H")
        )
      )
    ),
    tabPanel("Death Data",
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
  )
)

shinyUI(ui)