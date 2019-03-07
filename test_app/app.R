#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(sidebarLayout(
    sidebarPanel(
      # use regions as option groups
      # Copy the line below to make a date range selector
      dateRangeInput("dates", label = h3("Date range")),
      
      hr(),
      fluidRow(column(4, verbatimTextOutput("value")))
      
    ),
    mainPanel(
      verbatimTextOutput('values')
    )
  ), title = 'Options groups for select(ize) input')

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  # You can access the values of the widget (as a vector of Dates)
  # with input$dates, e.g.
  output$value <- renderPrint({ input$dates })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

