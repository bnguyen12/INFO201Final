library("dplyr")
library("ggplot2")
library("shiny")

ped.flu.death.data <- read.csv("./data/PedFluDeath_MapData.csv")
ped.flu.death.data$REGION <- as.character(ped.flu.death.data$REGION)

my.ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("region.select", "Select Region", c("1" ,"2", "3", "4", "5", "6", "7", "8", "9", "10"), selected=c("1" ,"2", "3", "4", "5", "6", "7", "8", "9", "10")),
      selectInput("target.select", "Select target", c("Rate" ,"Count"), selected="Rate")
    ),
    mainPanel(
      titlePanel("Pediatric Death Rate In Different Region"),
      plotOutput("plot")
    )
  )
)

my.server <- function(input, output) {
  output$plot <- renderPlot({
    if (!is.null(input$region.select)) {
        data <- ped.flu.death.data %>% filter(REGION %in% c(input$region.select))
        if (input$target.select == "Rate") {
            ggplot(data, aes(x=SEASON, y=RATE, group=REGION)) + geom_line(aes(color=REGION))  + xlab("Season") + ylab("Pediatric Death Rate")
        } else {
            ggplot(data, aes(x=SEASON, y=COUNT, group=REGION)) + geom_line(aes(color=REGION))  + xlab("Season") + ylab("Pediatric Death Count")
        }
    }
  }) 
}

shinyApp(ui = my.ui, server = my.server)
