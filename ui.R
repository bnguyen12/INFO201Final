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
                    "Seasons 1997-2004" = "97-04")),
          br(),
          p("The plots shown on the right show the amount of people infected
            with the flu. The plots differ in the type of flu that people were
            infected with, which was predominantly of", strong("type A, type B"),
            "and", strong("type H3N2v."), "The most common strain of the flu
            goes from top to bottom of these plots: type A, type B, and type H3N2v.
            The x-axis contains the age groups, the y-axis contains the number
            of people found positive for that flu type, and the legend shows
            the flu season color-coded by the year."),
          br(),
          p("This section is meant to show a strong correlation between age
            and catching the flu. Our assumption before looking at any data was
            that the oldest and youngest ends of the spectrum were most likely
            to catch the flu, because that when our immune systems are the weakest.
            However, when looking at the graphs, we see trends for recent years
            (2012-2017) that ages 5-24 is where the peaks are for flu-positive
            specimens. Looking at older data (2005-2011), it's shown that from
            all three flu types, ages 5-24 was still the age group that caught
            the flu more than others. Thus, we can conclude that age does affect
            how likely we catch the flu, although our assumption that the youngest
            and oldest age groups were in danger was false.")
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
          plotlyOutput("ili.map"),
          br(),
          p("This plot displays a visual of", strong("ILI cases (influenza like illnesses)"),
            "alongside a plot of the desired year's deaths from Washington state. 
            The x-axis shows the weeks of that year, whereas the y-axis shows
            the percentage of", strong("mortality"), "and", strong("ILI cases."),
            "To go more in-depth, the ILI rate was the percentage of people that
            came into clinics noting they had flu-like symptoms, such as fevers,
            coughts, etc. and concluding themselves that they thought they had the flu."),
          br(),
          p("Severity of any illness is best represented by the number of 
            deaths it has caused, as the death count with any illness is what
            shocks the media most. When this media coverage happens, it is 
            statistically prevalent that more people are checking into hospitals
            for ILI cases out of concern for having the actual flu. The question
            we were trying to answer was if the severity of the flu in media
            had a psychological effect on people to think they had the flu
            when they actually didn't. Using our dataset, it was seen that
            the trendline for ILI cases nearly matched the shape of the amount
            of deaths by the flu. Using the amount of deaths as an indicator
            for severity, we concluded that the severity of which the media
            portrays the flu makes more people think they have flu out of
            concern. Thus, the higher the death count, the greater the number
            of ILI cases in any given year.")
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
          plotlyOutput("pediatricPlot"),
          br(),
          p("This plot shows the", strong("rate"), "and", strong("count"),
            "of", strong("pediatric"), "deaths due to the flu. There are
            regions that contain certain states as listed left of the graph,
            with seasons shown on the x-axis and rate/count on the y-axis."),
          br(),
          p("The question we were trying to answer was if an urban environment
            led to less deaths by the flu because urban areas like New York 
            City and Seattle have more resources at their disposal to quickly 
            respond to emergencies. The data used for this divides areas by 
            regions, rather than at the state level. Now, after
            viewing the trends show in the graph, it's shown region six, which
            included primarily rural areas like Oklahoma and Arkansas, had the
            highest rate of pediatric death for the flu. In addition, regions
            9 and 10, which had an overall flatter trendline than the other regions,
            were comprised of highly urban states such as Washington and California.
            Using this data, we indeed saw that urban areas overall had a lower
            rate and count of pediatric death than rural areas, which supports
            our assumption that an urban environment combats the flu better than
            rural areas.")
        )
      )
    ),
    tabPanel("Heat Map for Flu Cases",
      sidebarLayout(
        sidebarPanel(
          p("Placeholder text")
        ),
        mainPanel(
          titlePanel("Flu Cases in the USA"),
          plotlyOutput("heatMap")
        )
      )
    )
  )
)

shinyUI(ui)