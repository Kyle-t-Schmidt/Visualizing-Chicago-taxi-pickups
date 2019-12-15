# Import Packages for app
library(dplyr)
library(tidyr)
library(shiny)
library(leaflet)
library(viridis)

# Import data
Taxi <- read.csv('Taxi.csv')

# The Day variable needs to be changed to something that will look nicer and be
# more readable in the app

# Make lists of values that will replace the old values. This will also be used
# as the list of choices for the check box selector
dates <- c("Sun 3/11/18", "Mon 3/12/18", "Tues 3/13/18", "Wed 3/14/18",
           "Thurs 3/15/18", "Fri 3/16/18", "Sat 3/17/18")

# Make lists of values to be replaced
nums <- c(11:17)

# Replace old values with new values in the Day column
for (i in 1:7){
    Taxi$Day <- gsub(nums[i], dates[i], Taxi$Day)
}

# The hour options for the slider input
hours <- c(0:23)

# Initiate the user interface
ui <- fluidPage(
    
    # Title at the top of the page. Use h3 option to choose text size and center
    # over the map
    titlePanel(
        h3("Chicago Taxi Rides by Pickup Location", align="center")),
    
    # Create the side panel with the days clickbox selector and hours slider
    #selector
    sidebarPanel(
        width=3,
        
        # Check box selector input for days of the week in side panel
        checkboxGroupInput(inputId='days', label="Day of the week",
                           choices=dates, selected=dates[1]),
        
        # Slider selector input for hours of the day in side panel
        sliderInput(inputId='hours', label="Hour of the day", min=0, max=23,
                    value=c(0,0)),
            ),
    
    # Create main panel to hold the map
    mainPanel(
        width=9,
        
        # The map input
        leafletOutput("mymap"),
        
        # Raw text going under the map describing the purpose.
        "St. Patricks days is a big deal in Chicago! The week of 3/11/18 - 
        3/17/18 was the busiest week of 2018 for Chicago taxis based on
        number of pickups. Select days and a time frame using the selectors
        on the left to see where taxis were making their pickups. "
        )
    )

#Initiate the server function
server <- function(input, output){
    
    # Create map output
    output$mymap <- renderLeaflet({
        
        # Filter taxi data by input parameters
        filtered <- Taxi[(Taxi$Hour %in% seq(input$hours[1], input$hours[2])) &
                             (Taxi$Day %in% input$days),]
        
        # Group filtered data by location
        grouped <- aggregate(filtered$Count,
                             by=list(Category=filtered$pickup_location),
                             FUN=sum)
        
        # I need to break the pickup location into separate Lat and Lng columns
        # to create the map markers for each location.
        #Remove extra characters from copy_pickup_location
        grouped$Category <- gsub('POINT \\(', '', grouped$Category)
        grouped$Category <- gsub('\\)', '', grouped$Category)
        
        # Split pickup_location into latitude and longitude
        grouped <- grouped %>% separate(Category, c('Long', 'Lat'), sep = ' ')
        
        # Change lat and long from characters to numeric data type
        options(digits = 12) # Set length so coords aren't truncated
        grouped$Lat <- as.double(grouped$Lat)
        grouped$Long <- as.double(grouped$Long)
        
        # Create color palette for marker coloring
        pal <- colorNumeric('viridis', grouped$x)
        
        # Insert the map and select visual options 
        leaflet() %>% addProviderTiles(providers$Stamen.Terrain,
                                       options=providerTileOptions(noWrap = TRUE)
                                       ) %>%
            
        # Add markers for each lat/lng set. Color by number of pickups   
        addCircleMarkers(lng=grouped$Long, lat=grouped$Lat, 
                       radius=5, opacity=0.5, fillOpacity=0.5,
                       fillColor=pal(grouped$x), color=pal(grouped$x),
                       label=paste('Number of pickups: ', grouped$x)
                       ) %>%
         
        # Add legend for the marker color
        addLegend("topright", pal=pal, values=grouped$x,
                  title="Number of pickups")
        })
    }

# Launch app.
shinyApp(ui, server)



