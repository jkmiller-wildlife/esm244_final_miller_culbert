library(tidyverse)
library(shiny)
library(shinythemes)

############################################
# Data 

birds_by_region <- read_csv("birds_by_region.csv")

birds_by_sector <- read_csv("birds_by_sector.csv")

#birds_by_region$survey_week <- mdy(birds_by_region$survey_week)

wrack_avian_tab3 <- read_csv("wrack_avian_fix.csv")

#wrack_avian_tab3$survey_week <- mdy(wrack_avian_tab3$survey_week)

wrack_mean <- read_csv("wrack_mean.csv") 

#wrack_mean$survey_week <- mdy(wrack_mean$survey_week) # always gets warning emssage: All formats failed to parse. No formats found.

#############################################

#### User Interface: Define UI for application 

ui <- fluidPage(theme = shinytheme("superhero"), #Valid themes: cerulean, cosmo, cyborg, darkly, flatly, journal, lumen, paper, readable, sandstone, simplex, slate, spacelab, superhero, united, yeti. # JKM likes superhero and darkly.

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
                                      h1("How to Use"), 
                                      p("Our data is assessed at two spatial scales. VAFB is split into three beach regions: North, Purisima, and South Beaches. These regions are further split into beach sections, split in the field by rivers or access trails. The map on the second tab shows the location of the beach sections and their three letter code. North Beaches labels are in blue, Purisima Beaches in yellow, and South Beaches in green"),
                                      p("The first tab summarizes abundance of four bird families (Shorebirds, Gulls, Terns, and Raptors) over time at the three beach regions of VAFB. A date range can be selected to assess population at different time scales. The second tab assesses the population of Western snowy plovers, sanderlings, and all gulls relative to brown algal wrack abundance at the beach section scale. The third tab summarizes species diversity for each beach section at a selected time scale. The four-letter species codes in the species diversity tab are from the American Ornithological Union Bird Species List, link below."),
                                      tags$a(href = "http://www.wec.ufl.edu/birds/SurveyDocs/species_list.pdf", "American Ornithological Union Bird Species List."),
                                      h1("Authors"), 
                                      p("This app was created in Shiny by Jamie Miller and Kristan Culbert for ESM 244 (Advanced Data Analysis) - Winter 2019. Photo by Ross Griswold. Map is from Robinette et al. 2017"))),
                           
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
                                    h1("Species Abundance Over Time"),
                                    sidebarLayout(
                                      sidebarPanel(
                                       
                         img(src='VAFB_small.jpg', align = "left")
                                        
                                      ),
                                      
                                      
                                      # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot
                                      mainPanel(
                                        plotOutput("beach_species_plot"),
                                        
                                        hr(),
                                        
                                        fluidRow(
                                          
                                          column(4,
                                             
                                                 dateRangeInput("survey_week_1", 
                                                       label = "Choose Date Range:",
                                                       start = "2011-03-01", 
                                                       end = "2019-03-01",
                                                       min = "2011-03-01", 
                                                       max ="2019-03-01")
                                                 ),
                                          
                                          column(4,
                                                 
                                                 selectInput("species_type_1", 
                                                             label = "Select Avian Family:",
                                                             choices = list("Shorebird" = "Shorebird", 
                                                                            "Gull" = "Gull", 
                                                                            "Tern" = "Tern",
                                                                            "Raptor" = "Raptor"))
                                                 ),
                                          
                                          column(4, 
                                                 
                                                 radioButtons("beach_1", 
                                                              label = "Select Beach Region:", 
                                                              choices = list("North Beaches" = "NORTH",
                                                                             "Purisima Beaches" = "PURISIMA",
                                                                             "South Beaches" = "SOUTH")) 
                                                 )
                                        )
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

tabPanel("Habitat and Species Change Over Time", 
         h1("Habitat and Species Change Over Time"),
         
         # Sidebar with a slider input for number of bins 
         sidebarLayout(
           sidebarPanel(
             
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
                                        "Surf South (SSO)" = "SSO"))

             ),
           
           
           # Output: use radio buttons for site location, radio buttons for bird species to create a line plot
           mainPanel(
             plotOutput("wrack_plot"),
             plotOutput("wrack_avian_plot")
             
         ))),


# Species Diversity

tabPanel("Species Diversity",
         h1("Species Diversity"),
         
         mainPanel(
           
           fluidRow(
               
               column(4,

             dateRangeInput("survey_week_5", 
                            label = "Choose Date Range:",
                            start = "2011-03-01", 
                            end = "2019-03-01",
                            min = "2011-03-01", 
                            max ="2019-03-01")
             ),

                          column(4,
                    
                    selectInput("species_type_5", 
                                label = "Select Avian Family:",
                                choices = list("Shorebird" = "Shorebird", 
                                               "Gull" = "Gull", 
                                               "Tern" = "Tern",
                                               "Raptor" = "Raptor"))
             ),
             
             column(4,

             selectInput("beach_5", 
                         label = "Select Beach Section:", 
                         choices = list("Minuteman (MIN)" = "MIN",
                                        "Shuman North (SHN)" = "SHN",
                                        "Shuman South (SHS)" = "SHS",
                                        "San Antonio (SAN)" = "SAN",
                                        "Purisima North (PNO)" = "PNO",
                                        "Wall Beach (WAL)" = "WAL",
                                        "Surf North (SNO)" = "SNO",
                                        "Surf South (SSO)" = "SSO"))
           )),
          
           # Output: use year input, radio buttons for site location, radio buttons for bird species to create a line plot

             plotOutput("avian_diversity_plot")
           )
         )))



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
        geom_smooth() +
 #       geom_line(aes(color = mean_wrack)) +
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
    }, height = 350, width = 1000)
  
  
    output$wrack_avian_plot <- renderPlot({
      
      ggplot(wrack_avian(), 
             aes(x = survey_week, y = total)) +
        geom_col(aes(fill = species_2), show.legend = FALSE) +
        scale_fill_manual(limits = c("SNPL", "SAND", "Gull"), 
                          values = c("deepskyblue4","darkolivegreen4","darkgoldenrod2")) +
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
        theme_classic()
    }, height = 350, width = 1000)

 #######################################   
    # Species diversity
    
#    display_date = reactive({input$survey_week_4})
#    renderPrint(display_date())
    
    avian_diversity <- reactive(
      {
        birds_by_sector %>%
          filter(survey_week >= input$survey_week_5[1], survey_week <= input$survey_week_5[2]) %>% 
          filter(beach_section_initials == input$beach_5[1]
                 | beach_section_initials == input$beach_5[2]
                 | beach_section_initials == input$beach_5[3]
                 | beach_section_initials == input$beach_5[4]
                 | beach_section_initials == input$beach_5[5]
                 | beach_section_initials == input$beach_5[6]
                 | beach_section_initials == input$beach_5[7]
                 | beach_section_initials == input$beach_5[8]) %>%
          filter(species_type == input$species_type_5[1] | 
                   species_type == input$species_type_5[2] | 
                   species_type == input$species_type_5[3] |
                   species_type == input$species_type_5[4])
      }
    )
    
    output$avian_diversity_plot <- renderPlot({
      
      ggplot(avian_diversity(), 
             aes(x = survey_week, y = total, fill = species)) +
        geom_bar(stat = "identity", position = "fill") + 
#        scale_color_brewer(palette = "Spectral") + # Not working
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
        labs(x = "Date", y = "Proportion of Species") +
#        theme(legend.position="bottom") + # Not working
        theme_classic()
    }, height = 500, width = 1500)
}

# Run the application 
shinyApp(ui = ui, server = server)
