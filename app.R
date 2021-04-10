library(shiny)
library(plyr)
library(dplyr)
library(ggplot2)
source("get_data.R")

ui = fluidPage(
  #inputs
  titlePanel("Vaccine Confidence Project Shiny App"),
  sidebarLayout(
    sidebarPanel(width = 2,
                 p("Data source: ",
                   a("Figueiredo et al. 2020", 
                     href = "https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(20)31558-0/fulltext"), "Mapping global trends in vaccine confidence and investigating barriers to vaccine uptake: a large-scale retrospective temporal modelling study. ", em("The Lancet")),
                 sliderInput(inputId="year_range", label="Year range", value=c(2015, 2020), min=2015, max=2020, step=0.5),
                 selectInput(inputId="regions", label="Region", choices = all_regions, selected="EUR")
    ),
    #outputs
    mainPanel(width = 10,
              
              tabsetPanel(type = "tabs",
                          tabPanel("Safe", plotOutput(outputId="year_range_plot_safe")),
                          tabPanel("Efficient", plotOutput(outputId="year_range_plot_eff")),
                          tabPanel("Important", plotOutput(outputId="year_range_plot_imp"))
              )
    )
    
    
  )
)
server = function(input, output){
  
  output$year_range_plot_safe <- renderPlot({
    
    dd = d_safe %>% 
      filter(who_region %in% input$regions) %>% 
      filter(time >= input$year_range[1] & time <= input$year_range[2])
    
    ggplot(data = dd , 
           aes(x= time, y=mean, group=response)) + 
      geom_line(aes( colour= response))+
      geom_ribbon(aes(ymin=X95.HPDlow, ymax=X95.HPDhigh), linetype=2, alpha=0.1)+
      facet_wrap(~country.or.territory, ncol=10)+
      ggtitle("Are vaccines safe?")+
      theme_bw()+
      theme(legend.position = "top")
  }, width = "auto",
  height = 600)
  
  output$year_range_plot_imp<- renderPlot({
    
    dd = d_imp %>% 
      filter(who_region %in% input$regions) %>% 
      filter(time >= input$year_range[1] & time <= input$year_range[2])
    
    ggplot(data = dd , 
           aes(x= time, y=mean, group=response)) + 
      geom_line(aes( colour= response))+
      geom_ribbon(aes(ymin=X95.HPDlow, ymax=X95.HPDhigh), linetype=2, alpha=0.1)+
      facet_wrap(~country.or.territory, ncol=10)+
      ggtitle("Are vaccines important?")+
      theme_bw()+
      theme(legend.position = "top")
  }, width = "auto",
  height = 600)
  
  output$year_range_plot_eff <- renderPlot({
    
    dd = d_eff %>% 
      filter(who_region %in% input$regions) %>% 
      filter(time >= input$year_range[1] & time <= input$year_range[2])
    
    ggplot(data = dd , 
           aes(x= time, y=mean, group=response)) + 
      geom_line(aes( colour= response))+
      geom_ribbon(aes(ymin=X95.HPDlow, ymax=X95.HPDhigh), linetype=2, alpha=0.1)+
      facet_wrap(~country.or.territory, ncol=10)+
      ggtitle("Are vaccines efficient?")+
      theme_bw()+
      theme(legend.position = "top")
  }, width = "auto",
  height = 600)
  
}

shinyApp(ui, server)