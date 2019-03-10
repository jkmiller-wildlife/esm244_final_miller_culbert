library(tidyverse)
library(shiny)
library(shinythemes)
library(lubridate)


############################################
# Load app data 

#Load dataset for tab 2 (time and species count data)
birds_by_region <- read_csv("birds_by_region.csv")

birds_by_region$survey_week <- mdy(birds_by_region$survey_week)


#Load dataset for tab 3 (species abundance and study map)



#Load dataset for tab 4

wrack_avian <- read_csv("wrack_avian_tab3.csv")
wrack_avian$survey_week <- mdy(wrack_avian$survey_week)



#############################################

#### User Interface: Define UI for application 

ui <- fluidPage(theme=shinytheme("superhero"), 
                
                # Title Panel
                titlePanel("Taking Flight: A Look into the Birds of Vandenberg Air Force Base"), #main app title
                
                navbarPage("Learn more about coastal bird population dynamics at VAFB in Central California.", #navigation bar title
                           
                           
                           # First Tab Panel = Introduction/Summary
                           
                           tabPanel("About", #title of tab
                                    
                                    # Photo of banded snowy plover in side bar panel. If this photo can't be resized small enough and look good let's use the drawing. It's very nice.
                                    # The photo size is formatted so it looks good on my browser/screen. It might be best to use my laptop for the presentation so there are no formatting surprises because the monitor makes a difference.
                                    sidebarPanel(img(src='SNPL_small.jpg', align = "left")),
                                    
                                    # Main panel with info. I want this shown to the right of the photo in the sidebarPanel.
                                    mainPanel(              
                                      h1("App Summary"), #subtitle
                                      p("This dataset was collected for Vandenberg Air Force Base (VAFB) by Point Blue Conservation Science, a nonprofit based in central California, as part of ongoing beach ecosystem and snowy plover conservation projects. Our app will explore seasonal and annual fluctuations in shorebird and gull abundance, and changes in beach habitat at VAFB."),
                                      h1("Data"), #subtitle
                                      p("Since March 2011, weekly transect surveys were conducted at VAFB beaches. North and South VAFB beaches were separated by distinct beach sectors. Each beach sector was divided into transect blocks approximately 100-300 meters in length along the coastal strand. Within each transect block, counts were taken of the number of snowy plovers, age, sex, flock size, presence of paired individuals, and presence of broods. Additionally, the number and species of shorebirds, seabird, or raptors utilizing the habitat was recorded, and the amount of wrack present on each block was scored (Robinette et al. 2017)"),
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
                                        
                                        selectInput("species_type_1", 
                                                    label = "Select species type:",
                                                    choices = list("Shorebird" = "Shorebird", "Gull" = "Gull", "Tern" = "Tern")),
                                        
                                        radioButtons("beach_1", 
                                                     label = "Select beach region:", 
                                                     choices = list("North" = "NORTH","Purisima" = "PURISIMA","South" = "SOUTH"))
                                        
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
                           
                           tabPanel("Species Abundance by Location",
                                    h1("Species Abundance and Study Map"),
                                    
                                    # Sidebar with a slider input for number of bins 
                                    sidebarLayout(
                                      sidebarPanel(
                                        dateRangeInput("survey_week", 
                                                       label = "Choose year range:", 
                                                       start = "2012-03-12", end = "2019-02-28",
                                                       min = "2011-03-01", max ="2019-02-28"),
                                        
                                        radioButtons("species_type", 
                                                     label = "Select species type:",
                                                     choices = list("Shorebird", "Gull", "All")),
                                        
                                        radioButtons("beach", 
                                                     label = "Select beach region:", 
                                                     choices = list("North","Purisima","South"))
                                        
                                      ),
                                      
                                      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel(
                                        plotOutput("mapPlot") #create df for plot
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
                           
                           tabPanel("Habitat Change Over Time", 
                                    h1("Shorebird, Gull, and Relative Wrack Abundance - Time Series"),
                                    
                                    # Sidebar with a slider input for number of bins 
                                    sidebarLayout(
                                      sidebarPanel(
                                        dateRangeInput("point_size", 
                                                       label = "Choose date range:"),
                                        
                                        radioButtons("species_type", 
                                                     label = "Select species:",
                                                     choices = list("Snowy Plover", "Sanderling", "Gulls")),
                                        
                                        radioButtons("beach", 
                                                     label = "Select beach region:", 
                                                     choices = list("North","Purisima","South"))
                                        
                                      ),
                                      
                                      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel(
                                        plotOutput("distPlot") #insert name for plot 1 here -- JKM needs to create df for plot
                                      )
                                      
                                    ))
                           
                ))





####Server: Define server logic required to draw plots for each tab

server <- function(input, output) {
  
  
  ##Generate Tab 2 Outputs: Generate a line graph using year range input data, species, count data to create a line graph. 
  
  # specifies date range for survey_date
  
  date_range <- reactive(
    {
      birds_by_region %>% 
        filter(survey_week >= input$survey_week_1[1], survey_week <= input$survey_week_1[2]) %>% 
        filter(beach == input$beach_1[1] | beach == input$beach_1[2] | beach == input$beach_1[3]) %>%
        filter(species_type == input$species_type_1[1] | species_type == input$species_type_1[2] | species_type == input$species_type_1[3]) #%>%
      #      mutate(survey_week = mdy(survey_week)) %>% 
      #      mutate(total = as.numeric(total))
      #      mutate(beach = as.factor(beach)) %>%
      #     mutate(species_type = as.factor(species_type))
    }
  )
  
  output$beach_species_plot <- renderPlot({
    
    ggplot(date_range(), 
           aes(x = survey_week, y = total)) +
      geom_col(aes(fill = species_type)) +
      scale_y_continuous(expand = c(0,0)) +
      #         scale_x_date(breaks = as.Date(c("2011-03-01","2011-05-01","2011-07-01","2011-09-01","2011-11-01","2012-01-01",
      #                                  "2012-03-01","2012-05-01","2012-07-01","2012-09-01","2012-11-01","2013-01-01",
      #                                 "2013-03-01","2013-05-01","2013-07-01","2013-09-01","2013-11-01","2014-01-01",
      #                                "2014-03-01","2014-05-01","2014-07-01","2014-09-01","2014-11-01","2015-01-01",
      #                               "2015-03-01","2015-05-01","2015-07-01","2015-09-01","2015-11-01","2016-01-01",
      #                              "2016-03-01","2016-05-01","2016-07-01","2016-09-01","2016-11-01","2017-01-01",
      #                             "2017-03-01","2017-05-01","2017-07-01","2017-09-01","2017-11-01","2018-01-01",
      #                            "2018-03-01","2018-05-01","2018-07-01","2018-09-01","2018-11-01","2019-01-01",
      #                           "2019-02-01"))) +
      scale_x_date(breaks = as.Date(c("2011-03-01",
                                      "2012-03-01",
                                      "2013-03-01",
                                      "2014-03-01",
                                      "2015-03-01",
                                      "2016-03-01",
                                      "2017-03-01",
                                      "2018-03-01",
                                      "2019-03-01"))) +
      labs(x = "Date", y = "Number Birds Observed") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme_classic()
  })
  
  ##Generate Tab 3 Outputs: Species Abundance and Study Map 
  
  
  
  
  output$map <- renderPlot({
    
   
    # draw map using inputs 
    map <- ggplot(sb_crop2) +
      geom_sf(aes(fill = STATE),
              fill = "darkgreen",
              color = "NA",
              show.legend = FALSE) +
      geom_point(data = block_gps2,
                 aes(x = x_proj, y = y_proj),
                 color = "black") +
      theme(panel.background = element_rect(fill = 'blue', colour = 'NA')) + # can change these to better colors
      coord_sf(datum = NA) +
      labs(x = "", 
           y = "")
  })
  
  ##Generate Tab 4 Outputs: Time and Wrack Data, SNPL/SAND/gull graphs
 
   # specifies date range for survey_date
  
  date_range <- reactive(
    {
      birds_by_region %>% 
        filter(survey_week >= input$survey_week_1[1], survey_week <= input$survey_week_1[2]) %>% 
        filter(beach == input$beach_1[1] | beach == input$beach_1[2] | beach == input$beach_1[3]) %>%
        filter(species_type == input$species_type_1[1] | species_type == input$species_type_1[2] | species_type == input$species_type_1[3]) #%>%
      #      mutate(survey_week = mdy(survey_week)) %>% 
      #      mutate(total = as.numeric(total))
      #      mutate(beach = as.factor(beach)) %>%
      #     mutate(species_type = as.factor(species_type))
    }
  )
  
  output$beach_species_plot <- renderPlot({
    
    ggplot(date_range(), 
           aes(x = survey_week, y = total)) +
      geom_col(aes(fill = species_type)) +
      scale_y_continuous(expand = c(0,0)) +
      #         scale_x_date(breaks = as.Date(c("2011-03-01","2011-05-01","2011-07-01","2011-09-01","2011-11-01","2012-01-01",
      #                                  "2012-03-01","2012-05-01","2012-07-01","2012-09-01","2012-11-01","2013-01-01",
      #                                 "2013-03-01","2013-05-01","2013-07-01","2013-09-01","2013-11-01","2014-01-01",
      #                                "2014-03-01","2014-05-01","2014-07-01","2014-09-01","2014-11-01","2015-01-01",
      #                               "2015-03-01","2015-05-01","2015-07-01","2015-09-01","2015-11-01","2016-01-01",
      #                              "2016-03-01","2016-05-01","2016-07-01","2016-09-01","2016-11-01","2017-01-01",
      #                             "2017-03-01","2017-05-01","2017-07-01","2017-09-01","2017-11-01","2018-01-01",
      #                            "2018-03-01","2018-05-01","2018-07-01","2018-09-01","2018-11-01","2019-01-01",
      #                           "2019-02-01"))) +
      scale_x_date(breaks = as.Date(c("2011-03-01",
                                      "2012-03-01",
                                      "2013-03-01",
                                      "2014-03-01",
                                      "2015-03-01",
                                      "2016-03-01",
                                      "2017-03-01",
                                      "2018-03-01",
                                      "2019-03-01"))) +
      labs(x = "Date", y = "Number Birds Observed") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme_classic()
  })
  
  
}




# Run the application 
shinyApp(ui = ui, server = server)

