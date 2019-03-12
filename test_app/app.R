library(tidyverse)
library(shiny)
library(shinythemes)
library(lubridate)


############################################
# Data 

wrack_avian <- read_csv(wrack_avian_tab3.csv)
birds <- read_csv(birds_by_region.csv)


#############################################

#### User Interface: Define UI for application 

ui <- fluidPage(theme=shinytheme("superhero"), 
                
                # Title Panel
                titlePanel("Taking Flight: A Look into the Birds of Vandenberg Air Force Base"), #main app title
                
                navbarPage("Learn more about coastal bird population dynamics at VAFB in Central California.", #navigation bar title
                           # depending on the monitor, the tabs are either to the side of 'Click the tabs...' or below. any preference? Just delete word 'below'? How about 'Learn more about birds at Vandenberg Air Force Base in Central California'
                           # original 'Click the tabs below to learn more about birds at Vandenberg Air Force Base in Lompoc, California'
                           
                           # First Tab Panel = Introduction/Summary
                           
                           tabPanel("About", 
                                    
                                    sidebarPanel(img(src='SNPL_small.jpg', align = "left")),
                                    
                          # Second Tab Panel: Simple Linear Regresion - Does mean wrack value influence bird populations?
                          
                           sidebarLayout(
                             sidebarPanel(
                               radioButtons("species_type", 
                                            label = "Select species type:",
                                            choices = list("Shorebird", "Gull", "All")),
                               
                               radioButtons("beach", 
                                            label = "Select beach region:", 
                                            choices = list("North","Purisima","South"))
                               
                             ),
                                      
                                      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel(plotOutput("regressionPlot")
                                                )))
))


####Server: Define server logic required to draw plots for each tab

server <- function(input, output) {
  
 
  # Regression output
  output$regressionPlot <- renderPrint({
    
    lm_fit <- lm(wrack_avian[,input$species_type] ~ wrack_avian[,input$beach])
    summary(fit)
    })
  
  # Data output
  output$tbl = DT::renderDataTable({
    DT::datatable(wrack_avian, options = list(lengthChange = FALSE))
  })
  
    
}


# Run the application 
shinyApp(ui = ui, server = server)
