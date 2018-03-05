library("dplyr")
library("ggplot2")
library("shiny")

ped.flu.death.data <- read.csv("./data/PedFluDeath_MapData.csv")

my.ui <- fluidPage(
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
      plotOutput("plot")
    )
  )
)

my.server <- function(input, output) {
  
  ped.flu.data <- reactive({
    data <- ped.flu.death.data %>% filter(REGION %in% as.numeric(gsub("([0-9]+).*$", "\\1", input$region.select)))
    return(data)
  })
  output$plot <- renderPlot({
    if (input$target.select == "Rate") {
      ggplot(ped.flu.data(), aes(x=SEASON, y=RATE, group=REGION)) + 
      geom_line(aes(color=as.factor(REGION))) + 
      labs(title = "Pediatric Deaths by Region",
           x = "Season",
           y = "Pediatric Death Rate",
           color = "Region")
    } else {
      ggplot(ped.flu.data(), aes(x=SEASON, y=COUNT, group=REGION)) +
      geom_line(aes(color=as.factor(REGION))) +
      labs(title = "Pediatric Deaths by Region",
           x = "Season",
           y = "Pediatric Death Count",
           color = "Region")
    }
  }) 
}

shinyApp(ui = my.ui, server = my.server)
