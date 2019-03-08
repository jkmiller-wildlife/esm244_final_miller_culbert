

library(shiny)
library(shinythemes)



# Define UI for application that draws a histogram
ui <- fluidPage(theme=shinytheme("united"),
   
   # Application title
   titlePanel("Taking Flight: A Look into the Birds of Vandenberg Air Force Base"),
   
   navbarPage("Click the tabs below to learn more about birds at Vandenberg Air Force Base in Lompoc, California.",
            
              
              # First Tab Panel = Introduction/Summary
              tabPanel("Summary",
                       
                       
                       
                       h1("App Summary"),
                       p("This dataset was collected for Vandenberg Air Force Base (VAFB) by Point Blue Conservation Science, a nonprofit based in central California, as part of ongoing beach ecosystem and snowy plover conservation projects. Our app will explore seasonal and annual fluctuations in shorebird, gull, and raptor abundance, and changes in beach habitat characteristics at VAFB."),
                       h1("Data"),
                       p("Since March 2012, weekly transect surveys were conducted at VAFB beaches. Each beach sector was divided into “transect blocks” approximately 100-300 meters in length along the coastal strand. Within each transect block, counts were taken of the number of snowy plovers, age, sex, flock size, presence of paired individuals, and presence of broods. Additionally, the number and species of shorebirds, seabird, or raptors utilizing the habitat was recorded, and the amount of wrack present on each block was scored (Robinette et al. 2017)"),
                       p("Thousands of data points from bird count transects have been collected by field biologists since 2012. Bird counts have been aggregated and reported at the end of each transect and/or field survey. We will be able to convert the data to tidy format if necessary."),
                       p("We will use the following variables in our app, which include data from weekly and semi-weekly field surveys: survey date and location, bird type (shorebird, gull, raptor), bird species, species/category abundance (recorded as number of observed birds, and wrack index (defined as the abundance of fresh surf-cast kelp on the beach, where a rating of 1 would be the least amount of wrack, and 5 is the highest amount of wrack).")),
              
            
              # Second Tab Panel = Time and Species Count Data    
              tabPanel("Time and Species Count Data",
                       h1("Time and Species Count Data"),
                    # Sidebar with a slider input for number of bins 
                    sidebarLayout(
                      sidebarPanel(
                        dateRangeInput("point_size", 
                                    label = "Choose year range:"),
                        
                        radioButtons("radio", 
                                     label = "Choose observation site:",
                                     choices = list("California", "Oregon", "Washington")),
                       
                         radioButtons("color", 
                                     label = "Choose bird species:", 
                                     choices = list("blue","purple","orange"))
                        
                      ),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                              plotOutput("distPlot")
                            )
                          )),
              
              # Third Tab Panel = Species Abundance and Study Map    
              tabPanel("Species Abundance and Study Map",
                       h1("Species Abundance and Study Map"),
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
              tabPanel("Time and Wrack Data", # JKM removed a close-parenthesis from between ".
                       h1("Time and Wrack Data"),
                       
                       #Input: Location of Observation Site with date input, radio buttons, and select bird species checkbox
                       sidebarLayout(
                         sidebarPanel(
                           dateRangeInput("point_size", 
                                          label = "Choose year range:"),
                           
                           radioButtons("radio", 
                                        label = "Choose observation site:",
                                        choices = list("North Beach", "South Beach", "Middle Beach")),
                           
                           checkboxGroupInput("checkgroup", 
                                        label = h3("Choose shorebird species:"), 
                                        choices = list("Sanpiper", "Snowy Plover", "Gull"))
                           
                         ),
                         
                         # Show a plot of the generated distribution
                         mainPanel(
                           plotOutput("distPlot")
                         )
                       )))) # JKM added a close-parenthesis here. fingers-crossed. deleted a comma.
              
              
              
              
              

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

