library(shiny)
library(plyr)
library(dplyr)
library(ggplot2)
source("get_data.R")

ui = fluidPage(
  tags$head(
    tags$style("html, body { height: 100%; width: 100%}"),
    #tags$style("#panel2 {overflow: auto; }"),
    tags$style("#panel1 {height: 100%;background: #ADD8E6}")
    
  ),
  #inputs
  titlePanel("Vaccine Confidence Project Shiny App"),
  sidebarLayout(
    sidebarPanel(width = 2,id = "panel1",
                 p("Data source: ",
                   a("Figueiredo et al. 2020", 
                     href = "https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(20)31558-0/fulltext"), "Mapping global trends in vaccine confidence and investigating barriers to vaccine uptake: a large-scale retrospective temporal modelling study. ", em("The Lancet")),
                 sliderInput(inputId="year_range", label="Year range", value=c(2015, 2020), min=2015, max=2020, step=0.5),
                 selectInput(inputId="regions", label="Region", choices = all_regions, selected="EUR")
    ),
    #outputs
    mainPanel(width = 10,id = "panel2",
              
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
      #geom_point(aes( colour= response), shape = 21)+
      #geom_label(data = dd %>% filter(time %in% c(min(dd$time),max(dd$time))), 
      #          aes( fill= response, label = round(mean)), size = 3, show.legend = FALSE)+
      geom_ribbon(aes(ymin=X95.HPDlow, ymax=X95.HPDhigh, fill = response), alpha=0.1)+
      facet_wrap(~country.or.territory)+
      ggtitle("Are vaccines safe?")+
      coord_cartesian(clip = 'off', expand = TRUE)+
      theme_classic()+
      theme(legend.position = "top")
      #theme(legend.position = "top", 
            #axis.title.y=element_blank(),
            #axis.text.y=element_blank(),
            #axis.ticks.y=element_blank(), 
            #panel.spacing = unit(1, "lines"))
  }, width = "auto",
  height = 650)
  
  output$year_range_plot_imp<- renderPlot({
    
    dd = d_imp %>% 
      filter(who_region %in% input$regions) %>% 
      filter(time >= input$year_range[1] & time <= input$year_range[2])
    
    ggplot(data = dd , 
           aes(x= time, y=mean, group=response)) + 
      geom_line(aes(colour= response))+
      geom_ribbon(aes(ymin=X95.HPDlow, ymax=X95.HPDhigh, fill = response), alpha=0.1)+
      facet_wrap(~country.or.territory)+
      ggtitle("Are vaccines important?")+
      theme_classic()+
      theme(legend.position = "top")
  }, width = "auto",
  height = 650)
  
  output$year_range_plot_eff <- renderPlot({
    
    dd = d_eff %>% 
      filter(who_region %in% input$regions) %>% 
      filter(time >= input$year_range[1] & time <= input$year_range[2])
    
    ggplot(data = dd , 
           aes(x= time, y=mean, group=response)) + 
      geom_line(aes( colour= response))+
      geom_ribbon(aes(ymin=X95.HPDlow, ymax=X95.HPDhigh, fill = response), alpha=0.1)+
      facet_wrap(~country.or.territory)+
      ggtitle("Are vaccines efficient?")+
      theme_classic()+
      theme(legend.position = "top")
  }, width = "auto",
  height = 650)
  
}

shinyApp(ui, server)