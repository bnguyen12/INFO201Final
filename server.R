source("ageFactor.R")
source("iliFactor.R")
source("pediatricDeathRate.R")

server <- function(input, output, session) {
  
  # Return dataset for infected people by age
  infected.data <- reactive({
    season.data <- ""
    if (input$season == "12-17") {
      season.data <- age.data[1:24, ]
    } else if (input$season == "05-11") {
      season.data <- age.data[25:52, ]
    } else {
      season.data <- age.data[53:84, ]
    }
    season.data <- mutate(season.data, "Type_A" = rowSums(season.data[, 3:7]),
                          "Type_B" = rowSums(season.data[, 8:10]),
                          "Type_H3N2v" = H3N2v) %>%
      select(Season, Age.Group, Type_A, Type_B, Type_H3N2v)
    return(season.data)
  })
  
  # Returns dataset for mortality and ILI rate
  death.current.data <- reactive({
    data <- filter(full.data, YEAR == input$year.death) %>%
      filter(WEEK >= input$week.slider[1] & WEEK <= input$week.slider[2])
    return(data)
  })
  
  # Returns data set for pediatric deaths by region
  ped.flu.data <- reactive({
    data <- ped.flu.death.data %>% filter(REGION %in% as.numeric(gsub("([0-9]+).*$", "\\1", input$region.select)))
    return(data)
  })
  
  # Renders plot of mortality vs ILI rate
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
  
  # Create a line graph for those infected with type A influenza
  output$age.plot.type.A <- renderPlotly({
    plot = ggplot() +
      geom_line(data = infected.data(), mapping = aes(x = Age.Group, y = Type_A, 
                                                  group = Season, 
                                                  color = Season,
                                                  text = paste("infected:", Type_A))) +
      labs(title = "Infected With Type A Influenza",
           x = "Age Group (years)",
           y = "# Found Positive (people)",
           color = "Flu Season by Year") +
      scale_x_discrete(limits=c("0-4 yr","5-24 yr","25-64 yr", "65+ yr"))
    final.plot <- ggplotly(plot, tooltip = c("text"))
    final.plot %>% layout(margin = list(l = 75, b = 75)) #shift axes text to the left to not overlap axis ticks
  })
  
  # Create a line graph for those infected with type A influenza
  output$age.plot.type.B <- renderPlotly({
    plot = ggplot() +
      geom_line(data = infected.data(), mapping = aes(x = Age.Group, y = Type_B, 
                                                      group = Season, 
                                                      color = Season,
                                                      text = paste("infected", Type_B))) +
      labs(title = "Infected With Type B Influenza",
           x = "Age Group (years)",
           y = "# Found Positive (people)",
           color = "Flu Season by Year") +
      scale_x_discrete(limits=c("0-4 yr","5-24 yr","25-64 yr", "65+ yr"))
    final.plot <- ggplotly(plot, tooltip = c("text"))
    final.plot %>% layout(margin = list(l = 75, b = 75))
  })
  
  # Create line graph for those infected with "other" (H3N2v)
  output$age.plot.type.H <- renderPlotly({
    plot = ggplot() +
      geom_line(data = infected.data(), mapping = aes(x = Age.Group, y = Type_H3N2v, 
                                                      group = Season, 
                                                      color = Season,
                                                      text = paste("infected", Type_H3N2v))) +
      labs(title = "Infected With Type H3N2v Influenza",
           x = "Age Group (years)",
           y = "# Found Positive (people)",
           color = "Flu Season by Year") +
      scale_x_discrete(limits=c("0-4 yr","5-24 yr","25-64 yr", "65+ yr"))
    final.plot <- ggplotly(plot, tooltip = c("text"))
    final.plot %>% layout(margin = list(l = 75, b = 75))
  })
  
  # Plot data for pediatric deaths in different regions
  output$pediatricPlot <- renderPlotly({
    if (input$target.select == "Rate") {
      plot = ggplot(ped.flu.data(), aes(x=SEASON, y=RATE, group=REGION)) + 
        geom_line(aes(color=as.factor(REGION))) + 
        labs(title = "Pediatric Deaths by Region",
             x = "Season",
             y = "Pediatric Death Rate",
             color = "Region")
      ggplotly(plot, tooltip = c("y"))
    } else {
      plot = ggplot(ped.flu.data(), aes(x=SEASON, y=COUNT, group=REGION)) +
        geom_line(aes(color=as.factor(REGION))) +
        labs(title = "Pediatric Deaths by Region",
             x = "Season",
             y = "Pediatric Death Count",
             color = "Region")
      ggplotly(plot, tooltip = c("y"))
    }
  }) 
}

shinyServer(server)