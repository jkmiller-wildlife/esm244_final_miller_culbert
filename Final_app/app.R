
library(tidyverse)
library(shiny)
library(shinythemes)
library(lubridate)


############################################
# Data 

birds_by_region <- read_csv("birds_by_region.csv")

birds_by_region$survey_week <- mdy(birds_by_region$survey_week)

#############################################

#### User Interface: Define UI for application 

ui <- fluidPage(theme=shinytheme("superhero"), #Valid themes: cerulean, cosmo, cyborg, darkly, flatly, journal, lumen, paper, readable, sandstone, simplex, slate, spacelab, superhero, united, yeti. # JKM likes superhero and darkly.
                
   
   # Title Panel
   titlePanel("Taking Flight: A Look into the Birds of Vandenberg Air Force Base"), #main app title
   
   navbarPage("Learn more about coastal bird population dynamics at VAFB in Central California.", #navigation bar title
              # depending on the monitor, the tabs are either to the side of 'Click the tabs...' or below. any preference? Just delete word 'below'? How about 'Learn more about birds at Vandenberg Air Force Base in Central California'
              # original 'Click the tabs below to learn more about birds at Vandenberg Air Force Base in Lompoc, California'
            
              # First Tab Panel = Introduction/Summary

              tabPanel("About", #title of tab

              # Photo of banded snowy plover in side bar panel. If this photo can't be resized small enough and look good let's use the drawing. It's very nice.
              # The photo size is formatted so it looks good on my browser/screen. It might be best to use my laptop for the presentation so there are no formatting surprises because the monitor makes a difference.
              sidebarPanel(img(src='snpl_small_2.jpg', align = "left")),
              
              # Main panel with info. I want this shown to the right of the photo in the sidebarPanel.
                           mainPanel(              
                       h1("App Summary"), #subtitle
                       p("This dataset was collected for Vandenberg Air Force Base (VAFB) by Point Blue Conservation Science, a nonprofit based in central California, as part of ongoing beach ecosystem and snowy plover conservation projects. Our app will explore seasonal and annual fluctuations in shorebird and gull abundance, and changes in beach habitat at VAFB."),
                       h1("Data"), #subtitle
                       p("Since March 2011, weekly transect surveys were conducted at VAFB beaches. North and South VAFB beaches were separated by distinct beach sectors. Each beach sector was divided into “transect blocks” approximately 100-300 meters in length along the coastal strand. Within each transect block, counts were taken of the number of snowy plovers, age, sex, flock size, presence of paired individuals, and presence of broods. Additionally, the number and species of shorebirds, seabird, or raptors utilizing the habitat was recorded, and the amount of wrack present on each block was scored (Robinette et al. 2017)"),
                       p("Thousands of data points from bird count transects have been collected by field biologists since 2011. Bird counts have been aggregated and reported at the end of each transect and/or field survey. Data from weekly and semi-weekly surveys include: survey date and location, bird type (shorebird or gull), bird species, species/category abundance (recorded as number of observed birds, and wrack index (defined as the abundance of fresh surf-cast kelp on the beach, where a rating of 1 would be the least amount of wrack, and 5 is the highest amount of wrack)."), 
                       h1("Authors"), 
                       p("This app was created in Shiny by Jamie Miler and Kristan Culbert for ESM 244 (Advanced Data Analysis) - Winter 2019. Photo by Ross Griswold."))),
              
              # Second Tab Panel = Time and Species Count Data
              
              #Widget 1: Input: Time by year (2011 - 2018)
              #Type: Slider, which will allow app users to examine progression of data on a temporal scale. 
              
              #Widget 2
              #Input: Location of observation site
              #Type: Radio button, which will allow app users to switch between observation sites. 
              
              #Widget 3
              #Input: Bird species
              #Type: Checkboxes or multiple select box, which will allow app users to compare multiple species on a single output. 
              
              #App users will be able to use the time slider to scroll through temporal data and species count data, which will generate a line graph. 
              
              
              tabPanel("Species Abundance Over Time",
                       h1("Species and Species Type by Beach - Time Series"),
                    # Sidebar with a slider input for number of bins 
                    sidebarLayout(
                      sidebarPanel(
                        dateRangeInput("survey_week_1", 
                                    label = "Choose date range:",
                                    start = "2011-03-01", end = "2019-02-28",
                                    min = "2011-03-01", max ="2019-02-28"),
                        
                        radioButtons("species_type_1", 
                                     label = "Select species type:",
                                     choices = list("Shorebird", "Gull", "Tern")),
                       
                         radioButtons("beach_1", 
                                     label = "Select beach region:", 
                                     choices = list("North","Purisima","South"))
                        
                      ),

                            
      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                            mainPanel(
                              plotOutput("beach_species_plot")
                            )
                          ))))

              

              

####Server: Define server logic required to draw plots for each tab

server <- function(input, output) {
      

  ##Generate Tab 2 Outputs: Generate a line graph using year range input data, species, count data to create a line graph. 

  # specifies date range for survey_date
  
date_range <- reactive(
  {
    birds_by_region %>% 
    filter(survey_week >= input$survey_week_1[1], survey_week <= input$survey_week_1[2]) %>% 
    filter(beach == input$beach_1) %>% 
    filter(species_type == input$species_type_1)
    }
  )
  
     output$beach_species_plot <- renderPlot({

     ggplot(date_range(),
         aes(x = survey_week, 
         y = total, 
         color = species_type, 
         shape = beach)) +
        geom_point() +
        geom_line() +
        labs(x = "Date", y = "Number Birds Observed", title = "VAFB Birds") 
       
     })
  
}


# Run the application 
shinyApp(ui = ui, server = server)

