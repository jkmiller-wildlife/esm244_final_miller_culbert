

library(shiny)
library(shinythemes)



#### User Interface: Define UI for application 

ui <- fluidPage(theme=shinytheme("superhero"), #Valid themes: cerulean, cosmo, cyborg, darkly, flatly, journal, lumen, paper, readable, sandstone, simplex, slate, spacelab, superhero, united, yeti.
                
   
   # Title Panel
   titlePanel("Taking Flight: A Look into the Birds of Vandenberg Air Force Base"), #main app title
   
   navbarPage("Click the tabs below to learn more about birds at Vandenberg Air Force Base in Lompoc, California.", #navigation bar title
            
              # First Tab Panel = Introduction/Summary
              
              tabPanel("Summary", #title of tab
                       
                       h1("App Summary"), #subtitle
                       p("This dataset was collected for Vandenberg Air Force Base (VAFB) by Point Blue Conservation Science, a nonprofit based in central California, as part of ongoing beach ecosystem and snowy plover conservation projects. Our app will explore seasonal and annual fluctuations in shorebird, gull, and raptor abundance, and changes in beach habitat characteristics at VAFB."),
                       h1("Data"), #subtitle
                       p("Since March 2012, weekly transect surveys were conducted at VAFB beaches. Each beach sector was divided into “transect blocks” approximately 100-300 meters in length along the coastal strand. Within each transect block, counts were taken of the number of snowy plovers, age, sex, flock size, presence of paired individuals, and presence of broods. Additionally, the number and species of shorebirds, seabird, or raptors utilizing the habitat was recorded, and the amount of wrack present on each block was scored (Robinette et al. 2017)"),
                       p("Thousands of data points from bird count transects have been collected by field biologists since 2012. Bird counts have been aggregated and reported at the end of each transect and/or field survey. We will be able to convert the data to tidy format if necessary."),
                       p("We will use the following variables in our app, which include data from weekly and semi-weekly field surveys: survey date and location, bird type (shorebird, gull, raptor), bird species, species/category abundance (recorded as number of observed birds, and wrack index (defined as the abundance of fresh surf-cast kelp on the beach, where a rating of 1 would be the least amount of wrack, and 5 is the highest amount of wrack).")),
              
              # Second Tab Panel = Time and Species Count Data
              
              #Widget 1: Input: Time by year (2012 - 2018)
              #Type: Slider, which will allow app users to examine progression of data on a temporal scale. 
              
              #Widget 2
              #Input: Location of observation site
              #Type: Radio button, which will allow app users to switch between observation sites. 
              
              #Widget 3
              #Input: Bird species
              #Type: Checkboxes or multiple select box, which will allow app users to compare multiple species on a single output. 
              
              #App users will be able to use the time slider to scroll through temporal data and species count data, which will generate a line graph. 
              
              
              tabPanel("Time and Species Count Data",
                       h1("Time and Species Count Data"),
                    # Sidebar with a slider input for number of bins 
                    sidebarLayout(
                      sidebarPanel(
                        dateRangeInput("survey_week", 
                                    label = "Choose time range:"),
                        
                        radioButtons("species_type", 
                                     label = "Select species type:",
                                     choices = list("California", "Oregon", "Washington")),
                       
                         radioButtons("beach", 
                                     label = "Select beach sector:", 
                                     choices = list("blue","purple","orange"))
                        
                      ),
                            
                            # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                            mainPanel(
                              plotOutput("beach_species_plot") #placeholder for a plot named "beach_species_plot" - reference this for output
                            )
                          )),
              
              # Third Tab Panel = Species Abundance and Study Map    
              
              #Widget 1
              #Input: Time by year (2012 - 2018)
              #Type: Date Range input, which will allow app users to examine progression of data on a temporal scale. 
              
              #Widget 2
              #Input: Location of observation site
              #Type: Radio button, which will allow app users to switch between observation sites. 
              
              #Widget 3
              #Input: Bird species
              #Type: Checkboxes or multiple select box, which will allow app users to compare multiple species on a single output. 
              
              #App users will be able to view changes in species density over time by selecting one or more species, and projecting species density onto a map of the project area. 
              
              tabPanel("Species Abundance and Study Map",
                       h1("Species Abundance and Study Map"),
                       # Sidebar with a slider input for number of bins 
                       sidebarLayout(
                         sidebarPanel(
                           dateRangeInput("point_size", 
                                          label = "Choose year range:"),
                           
                           radioButtons("radio", 
                                        label = "Select species type:",
                                        choices = list("California", "Oregon", "Washington")),
                           
                           radioButtons("color", 
                                        label = "Select beach sector:", 
                                        choices = list("blue","purple","orange"))
                           
                         ),
                         
                         # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                         mainPanel(
                           plotOutput("distPlot") #create df for plot
                         )
                       )),
              
              # Fourth Tab Panel = Time and Wrack Data, SNPL/SAND/gull graphs
              
              #Widget 1
              #Input: Time by year (2012 - 2018)
              #Type: Choose year range, which will allow app users to examine progression of data on a temporal scale. 
              
              #Widget 2
              #Input: Location of observation site
              #Type: Radio button, which will allow app users to switch between observation sites. 
              
              #Widget 3
              #Input: Shorebird species
              #Type: Checkboxes or multiple select box, which will allow app users to compare multiple species on a single output. 
              
              #App users will be able to use the time slider to scroll through wrack index data and shorebird count data, which will generate a line graph. 
              
              tabPanel("Time and Wrack Data", 
                       h1("Time and Wrack Data"),
                       
                       # Sidebar with a slider input for number of bins 
                       sidebarLayout(
                         sidebarPanel(
                           dateRangeInput("point_size", 
                                          label = "Choose year range:"),
                           
                           radioButtons("radio", 
                                        label = "Select species type:",
                                        choices = list("California", "Oregon", "Washington")),
                           
                           radioButtons("color", 
                                        label = "Select beach sector:", 
                                        choices = list("blue","purple","orange"))
                           
                         ),
                         
                         # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                         mainPanel(
                           plotOutput("distPlot") #insert name for plot 1 here -- JKM needs to create df for plot
                         )
                         
                       ))
              
                       ))
              
              
              
              

####Server: Define server logic required to draw plots for each tab

server <- function(input, output) {
      
  ##Generate outputs for Tab 2: Generate a line graph using year range input data, species, count data to create a line graph. 
  
     output$beach_species_plot <- renderPlot({
      
       # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      beach_species_plot <- beach_species_plot <- ggplot(birds_by_region) +
        geom_point(aes(x = survey_week, y = total)) +
        geom_line(aes(x = survey_week, y = total)) +
        labs(x = "Date", y = "Number Birds Observed", title = "VAFB Birds") +
        facet_wrap(~species_type, scale = "free")
      
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

