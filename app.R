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
                       h1("App Summary"),
                       p("This dataset was collected for Vandenberg Air Force Base (VAFB) by Point Blue Conservation Science, a nonprofit based in central California, as part of ongoing beach ecosystem and snowy plover conservation projects. Our app will explore seasonal and annual fluctuations in shorebird, gull, and raptor abundance, and changes in beach habitat characteristics at VAFB."),
                       h1("Data"),
                       p("Since March 2012, weekly transect surveys were conducted at VAFB beaches. Each beach sector was divided into “transect blocks” approximately 100-300 meters in length along the coastal strand. Within each transect block, counts were taken of the number of snowy plovers, age, sex, flock size, presence of paired individuals, and presence of broods. Additionally, the number and species of shorebirds, seabird, or raptors utilizing the habitat was recorded, and the amount of wrack present on each block was scored (Robinette et al. 2017)"),
                       p("Thousands of data points from bird count transects have been collected by field biologists since 2012. The data are not in tidy format. Data have not been recorded for each bird observed-- bird counts are aggregated and reported at the end of each transect and/or field survey. We will be able to convert the data to tidy format if necessary."),
                       p("We will use the following variables in our app, which include data from weekly and semi-weekly field surveys:  
                        *Date of survey
                        *Location of survey site
                        *Bird type: Category (shorebird, gull, or raptor), Species
                        *Species/Category abundance: # of observed snowy plovers (based on age & sex), shorebirds, gulls, or raptors 
                        *Wrack Index: category assigned to abundance of fresh wrack (surf-cast kelp) on the beach (e.g. a rating of 1 would be the least amount of wrack, and 5 is the highest amount of wrack)")), #figure out how to insert bullet points
              
              
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

