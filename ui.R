source("ageFactor.R")
source("iliFactor.R")
source("pediatricDeathRate.R")

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
    ),
    tabPanel("Pediatric Death in Rural VS Urban Areas",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("region.select", "Select Region", 
                             c("1 - Connecticut, Maine, Massachusetts, New Hampshire, Rhode Island, and Vermont",
                               "2 - New Jersey, New York, Puerto Rico, and the U.S. Virgin Islands",
                               "3 - Delaware, District of Columbia, Maryland, Pennsylvania, Virginia, and West Virginia",
                               "4 - Alabama, Florida, Georgia, Kentucky, Mississippi, North Carolina, South Carolina, and Tennessee",
                               "5 - Illinois, Indiana, Michigan, Minnesota, Ohio, and Wisconsin", 
                               "6 - Arkansas, Louisiana, New Mexico, Oklahoma, and Texas",
                               "7 - Iowa, Kansas, Missouri, and Nebraska",
                               "8 - Colorado, Montana, North Dakota, South Dakota, Utah, and Wyoming",
                               "9 - Arizona, California, Hawaii, and Nevada",
                               "10 - Alaska, Idaho, Oregon, and Washington"), 
                             selected = c("10 - Alaska, Idaho, Oregon, and Washington")),
          selectInput("target.select", "Select target", c("Rate" ,"Count"), selected = "Rate")
        ),
        mainPanel(
          titlePanel("Pediatric Death Rate In Different Region"),
          plotlyOutput("pediatricPlot")
        )
      )
    )
  )
)

shinyUI(ui)