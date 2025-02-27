library(tidyverse)
library(shiny)
library(shinythemes)



############################################
# Data 

birds_by_region <- read_csv("birds_by_region.csv")

#birds_by_region$survey_week <- mdy(birds_by_region$survey_week)

wrack_avian_tab3 <- read_csv("wrack_avian_df.csv")

#wrack_avian_tab3$survey_week <- mdy(wrack_avian_tab3$survey_week)

wrack_mean <- read_csv("wrack_mean.csv") 

#wrack_mean$survey_week <- mdy(wrack_mean$survey_week) # always gets warning emssage: All formats failed to parse. No formats found.

#############################################

#### User Interface: Define UI for application 

ui <- fluidPage(theme=shinytheme("superhero"), #Valid themes: cerulean, cosmo, cyborg, darkly, flatly, journal, lumen, paper, readable, sandstone, simplex, slate, spacelab, superhero, united, yeti. # JKM likes superhero and darkly.
                
                # Title Panel
                titlePanel("Taking Flight: A Look into the Birds of Vandenberg Air Force Base"), #main app title
                
                navbarPage("Learn more about coastal bird population dynamics at VAFB in Central California.", #navigation bar title
                           
                           # First Tab Panel = Introduction/Summary
                           
                           tabPanel("About", #title of tab
                                    
                                    # Photo of banded snowy plover in side bar panel. 
                                    # The photo size is formatted so it looks good on my browser/screen. 
                                    sidebarPanel(img(src='snpl_small_2.jpg', align = "left")),
                                    
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
                                    sidebarLayout(
                                      sidebarPanel(
                                        dateRangeInput("survey_week_1", 
                                                       label = "Choose Date Range:",
                                                       start = "2011-03-01", 
                                                       end = "2019-03-01",
                                                       min = "2011-03-01", 
                                                       max ="2019-03-01"),
                                        
                                        selectInput("species_type_1", 
                                                    label = "Select Avian Family:",
                                                    choices = list("Shorebird" = "Shorebird", 
                                                                   "Gull" = "Gull", 
                                                                   "Tern" = "Tern",
                                                                   "Raptor" = "Raptor")),
                                        
                                        radioButtons("beach_1", 
                                                     label = "Select Beach Region:", 
                                                     choices = list("North Beaches" = "NORTH",
                                                                    "Purisima Beaches" = "PURISIMA",
                                                                    "South Beaches" = "SOUTH")),
                                        img(src='VAFB_small.jpg', align = "left")
                                        
                                      ),
                                      
                                      
                                      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel(
                                        plotOutput("beach_species_plot")
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
                                        #            dateRangeInput("survey_week_3",        
                                        #                          label = "Choose Date Range:",
                                        #                         start = "2011-03-01", 
                                        #                        end = "2019-03-01",
                                        #                       min = "2011-03-01", 
                                        #                      max ="2019-03-01"),
                                        # I don't think we need date as a selector for this one. Already a lot going on with the differnt beach sections.
                                        
                                        radioButtons("species_type_3", 
                                                     label = "Select Species:",
                                                     choices = list("Snowy Plover" = "SNPL", 
                                                                    "Sanderling" = "SAND",
                                                                    "Gulls" = "Gull")),
                                        
                                        selectInput("beach_3", 
                                                    label = "Select Beach Section:", 
                                                    choices = list("Minuteman (MIN)" = "MIN",
                                                                   "Shuman North (SHN)" = "SHN",
                                                                   "Shuman South (SHS)" = "SHS",
                                                                   "San Antonio (SAN)" = "SAN",
                                                                   "Purisima North (PNO)" = "PNO",
                                                                   "Wall Beach (WAL)" = "WAL",
                                                                   "Surf North (SNO)" = "SNO",
                                                                   "Surf South (SSO)" = "SSO")),
                                        img(src='VAFB_small.jpg', align = "left")
                                      ),
                                      
                                      
                                      # Output: use radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel(
                                        plotOutput("wrack_plot"),
                                        plotOutput("wrack_avian_plot")
                                      )
                                    )),
                           
                           
                           # Creating inputs for map
                           
                           tabPanel("Map of Study Sites",
                                    h1("Study Sites for Map"),
                                    sidebarLayout(
                                      sidebarPanel(
                                        
                                        radioButtons("species_type_4", 
                                                     label = "Select Species:",
                                                     choices = list("Snowy Plover" = "SNPL", 
                                                                    "Sanderling" = "SAND",
                                                                    "Gulls" = "Gull")),
                                        
                                        selectInput("beach_4", 
                                                    label = "Select Beach Section:", 
                                                    choices = list("Minuteman (MIN)" = "MIN",
                                                                   "Shuman North (SHN)" = "SHN",
                                                                   "Shuman South (SHS)" = "SHS",
                                                                   "San Antonio (SAN)" = "SAN",
                                                                   "Purisima North (PNO)" = "PNO",
                                                                   "Wall Beach (WAL)" = "WAL",
                                                                   "Surf North (SNO)" = "SNO",
                                                                   "Surf South (SSO)" = "SSO"))
                                      ),
                                      
                                      
                                      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel("Map of Study Area", 
                                                leafletOutput("study_map", height=1000)
                                               )))
                           
                ))




####Server: Define server logic required to draw plots for each tab

server <- function(input, output) {
  
  
  ##Generate Tab 2 Outputs: Generate a line graph using year range input data, species, count data to create a line graph. 
  
  # specifies date range for survey_date
  
  date_range <- reactive(
    {
      birds_by_region %>% 
        filter(survey_week >= input$survey_week_1[1], survey_week <= input$survey_week_1[2]) %>% 
        filter(beach == input$beach_1[1] | 
                 beach == input$beach_1[2] | 
                 beach == input$beach_1[3]) %>%
        filter(species_type == input$species_type_1[1] | 
                 species_type == input$species_type_1[2] | 
                 species_type == input$species_type_1[3] |
                 species_type == input$species_type_1[4]) #%>%
      #      mutate(survey_week = mdy(survey_week)) %>% 
      #      mutate(total = as.numeric(total))
      #      mutate(beach = as.factor(beach)) %>%
      #     mutate(species_type = as.factor(species_type))
    }
  )
  
  output$beach_species_plot <- renderPlot({
    
    ggplot(date_range(), 
           aes(x = survey_week, y = total)) +
      geom_col(aes(fill = species_type), show.legend = FALSE) +
      scale_fill_manual(limits = c("Shorebird","Gull","Tern","Raptor"), 
                        values = c("deepskyblue4","darkolivegreen4","darkgoldenrod2","darkred")) +
      scale_y_continuous(expand = c(0,0)) +
      scale_x_date(breaks = as.Date(c("2011-03-01","2011-09-01",
                                      "2012-03-01","2012-09-01",
                                      "2013-03-01","2013-09-01",
                                      "2014-03-01","2014-09-01",
                                      "2015-03-01","2015-09-01",
                                      "2016-03-01","2016-09-01",
                                      "2017-03-01","2017-09-01",
                                      "2018-03-01","2018-09-01",
                                      "2019-03-01")), 
                   labels = c("03/2011","09/2011",
                              "03/2012","09/2012",
                              "03/2013","09/2013",
                              "03/2014","09/2014",
                              "03/2015","09/2015",
                              "03/2016","09/2016",
                              "03/2017","09/2017",
                              "03/2018","09/2018",
                              "03/2019")) +
      labs(x = "Date", y = "Number Birds Observed") +
      #      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme_classic()
  })
  
  ######################################
  
  ##Generate Tab 4 Outputs: Time and Wrack Data, SNPL/SAND/gull graphs
  
  # specifies date range for survey_date
  
  wrack_mean_2 <- reactive(
    {
      wrack_mean %>% 
        filter(beach_section_initials == input$beach_3[1]
               | beach_section_initials == input$beach_3[2]
               | beach_section_initials == input$beach_3[3]
               | beach_section_initials == input$beach_3[4]
               | beach_section_initials == input$beach_3[5]
               | beach_section_initials == input$beach_3[6]
               | beach_section_initials == input$beach_3[7]
               | beach_section_initials == input$beach_3[8])
    }
  )
  
  wrack_avian <- reactive(
    {
      wrack_avian_tab3 %>% 
        filter(beach_section_initials == input$beach_3[1]
               | beach_section_initials == input$beach_3[2]
               | beach_section_initials == input$beach_3[3]
               | beach_section_initials == input$beach_3[4]
               | beach_section_initials == input$beach_3[5]
               | beach_section_initials == input$beach_3[6]
               | beach_section_initials == input$beach_3[7]
               | beach_section_initials == input$beach_3[8]) %>%
        filter(species_2 == input$species_type_3[1] | 
                 species_2 == input$species_type_3[2] | 
                 species_2 == input$species_type_3[3])
    }
  )
  
  
  
  # need to change the wrack data frame
  output$wrack_plot <- renderPlot({
    
    ggplot(wrack_mean_2(),
           aes(x = survey_week, y = mean)) +
      geom_point() +
      #       geom_line(aes(color = mean_wrack)) +
      #        scale_fill_manual(limits = c("Snowy Plover", "Sanderling", "Gulls"), 
      #                         values = c("deepskyblue4","darkolivegreen4","darkgoldenrod2")) +
      scale_y_continuous(expand = c(0,0)) +
      scale_x_date(breaks = as.Date(c("2012-03-01","2012-09-01",
                                      "2013-03-01","2013-09-01",
                                      "2014-03-01","2014-09-01",
                                      "2015-03-01","2015-09-01",
                                      "2016-03-01","2016-09-01",
                                      "2017-03-01","2017-09-01",
                                      "2018-03-01","2018-09-01",
                                      "2019-03-01")), 
                   labels = c("03/2012","09/2012",
                              "03/2013","09/2013",
                              "03/2014","09/2014",
                              "03/2015","09/2015",
                              "03/2016","09/2016",
                              "03/2017","09/2017",
                              "03/2018","09/2018",
                              "03/2019")) +
      labs(x = " ", y = "Mean Wrack Score") +
      #      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme_classic()
  })
  
  
  output$wrack_avian_plot <- renderPlot({
    
    ggplot(wrack_avian(), 
           aes(x = survey_week, y = total)) +
      geom_col() +
      #       geom_line(aes(color = mean_wrack)) +
      #        scale_fill_manual(limits = c("Snowy Plover", "Sanderling", "Gulls"), 
      #                         values = c("deepskyblue4","darkolivegreen4","darkgoldenrod2")) +
      scale_y_continuous(expand = c(0,0)) +
      scale_x_date(breaks = as.Date(c("2012-03-01","2012-09-01",
                                      "2013-03-01","2013-09-01",
                                      "2014-03-01","2014-09-01",
                                      "2015-03-01","2015-09-01",
                                      "2016-03-01","2016-09-01",
                                      "2017-03-01","2017-09-01",
                                      "2018-03-01","2018-09-01",
                                      "2019-03-01")), 
                   labels = c("03/2012","09/2012",
                              "03/2013","09/2013",
                              "03/2014","09/2014",
                              "03/2015","09/2015",
                              "03/2016","09/2016",
                              "03/2017","09/2017",
                              "03/2018","09/2018",
                              "03/2019")) +
      labs(x = "Date", y = "Number Birds Observed") +
      #      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme_classic()
  })
  
  #######################################   
  # Making the map  
  
  study_map <- reactive({
    x <- map_data
      
    })
  
  
  output$study_map <- renderLeaflet({
    map_data <- data()
    
    m <- leaflet(data = map_data) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitude,
                 lat = ~Latitude,
                 popup = paste("Species", map_data$species, "<br>",
                               "Survey Week", map_data$survey_week, "<br>",
                               "Transect Block", map_data$transect_block, "<br>", 
                               "Count", map_data$count, "<br>")
                 )
    m
    
  })
  
  
}




# Run the application 
shinyApp(ui = ui, server = server)
