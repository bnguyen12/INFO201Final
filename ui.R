source("ageFactor.R")

ui <- fluidPage(
  titlePanel("Flu Data"),
  tabsetPanel(type = "tabs",
    tabPanel("Age Data",
             br(),
             radioButtons("season", label = "Which Seasons",
                        c("Seasons 2012-2017" = "12-17",
                          "Seasons 2005-2011" = "05-11",
                          "Seasons 1997-2004" = "97-04")),
             plotlyOutput("age.plot.type.A"),
             br(),
             plotlyOutput("age.plot.type.B"),
             br(),
             plotlyOutput("age.plot.type.H")
    )
  )
)

shinyUI(ui)