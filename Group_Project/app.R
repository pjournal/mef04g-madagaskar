library(readxl)
library(tidyverse)
library(lubridate)
library(openxlsx)
library(rio)
library(reshape)
library(kableExtra)


mapdata <- rio::import("https://github.com/pjournal/mef04g-madagaskar/blob/gh-pages/Data/shinydata.xlsx?raw=True")

library(shiny)
library(leaflet)
library(shinythemes)
server <- function(input, output, session) {
    rval_mapdata <- reactive({
        # MODIFY CODE BELOW: Filter mass_shootings on nb_fatalities and
        # selected date_range.
        mapdata %>%
            filter(
              percentage >= input$percentage
            )
    })
    output$map <- leaflet::renderLeaflet({
        rval_mapdata() %>%
            leaflet() %>%
            addTiles() %>%
            setView( 35.00, 39.00, zoom = 6) %>%
            addTiles() %>%
            addCircleMarkers(
                lng= ~Lon, lat= ~Lan,
                radius = ~ percentage,
                fillColor = 'red', color = 'red', weight = 3
            )
    })
}
ui <- bootstrapPage(
    theme = shinythemes::shinytheme('simplex'),
    leaflet::leafletOutput('map', height = '100%', width = '100%'),
    absolutePanel(top = 10, right = 10, id = 'controls',
                  sliderInput('percentage', 'Select Preference Rate of Services', 0, 100, c(0,10))
    ),
    tags$style(type = "text/css", "
    html, body {width:100%;height:100%}
    #controls{background-color:white;padding:20px;}
  ")
)
shinyApp(ui = ui, server = server)