source("scripts/build_map.R")
source("scripts/build_treemap.R")
source("scripts/build_plot.R")

# Imports the listings of Airbnbs
listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

# Imports the names of the neighborhoods.
neighbourhoods <- read.csv("data/neighbourhoods.csv",
                           stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  output$interactive_map <- renderLeaflet({
    build_map(listings, input$location)
  })

  output$interactive_treemap <- renderD3tree2({
    build_treemap(listings, neighbourhoods, input$tree_map_variable)
  })

  output$interactive_plot <- renderPlotly({
    build_plot(listings, input$x_axis)
  })
})