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
ui <- fluidPage(
   
   # Application title
   titlePanel("Birds, birds, birds or some other good title..."),
   
   navbarPage("VAFB Birds!",
              # First Tab Panel = Introduction/Summary
              tabPanel("Summary",
                       h1("A header!"),
                       h2("A secondary header..."),
                       p("Then some paragraph text. ."),
                       p("Followed by another paragraph of text..."),
                       h1("Then another header"),
                       p("You get the idea...)")
              ), 
              
              # Second Tab Panel = Time and Species Count Data    
              tabPanel("Time and Species Count Data",
                          
                          # Sidebar with a slider input for number of bins 
                          sidebarLayout(
                            sidebarPanel(
                              sliderInput("bins",
                                          "Number of bins:",
                                          min = 1,
                                          max = 50,
                                          value = 30),
                              
                              selectInput("color", 
                                          "Select histogram color:",
                                          choices = c("purple","blue","orange"))
                            ),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                              plotOutput("distPlot")
                            )
                          )),
              
              # Third Tab Panel = Species Abundance and Study Map    
              tabPanel("Species Abundance and Study Map",
                       
                       # Sidebar with a slider input for number of bins 
                       sidebarLayout(
                         sidebarPanel(
                           sliderInput("bins",
                                       "Number of bins:",
                                       min = 1,
                                       max = 50,
                                       value = 30),
                           
                           selectInput("color", 
                                       "Select histogram color:",
                                       choices = c("purple","blue","orange"))
                         ),
                         
                         # Show a plot of the generated distribution
                         mainPanel(
                           plotOutput("distPlot")
                         )
                       )),
              
              # Fourth Tab Panel = Time and Wrack Data                
              tabPanel("Time and Wrack Data",
                       
                       # Sidebar with a slider input for number of bins 
                       sidebarLayout(
                         sidebarPanel(
                           
                           radioButtons("scattercolor", 
                                        "Select scatterplot color:",
                                        choices = c("red","blue","gray50"))
                         ),
                         
                         # Show a plot of the generated distribution
                         mainPanel(
                           plotOutput("scatter")
                         )
                       ))
              
   )
   
)
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )


# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

