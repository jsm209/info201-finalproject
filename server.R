source("scripts/build_map.R")
source("scripts/build_treemap.R")
source("scripts/build_plot.R")

# Imports the listings of Airbnbs
listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)
listings_exp <- read.csv("data/listings.csv.gz", stringsAsFactors = FALSE)

# Imports the names of the neighborhoods.
neighbourhoods <- read.csv("data/neighbourhoods.csv",
                           stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  output$dataset <- renderTable(get(input$rand_var)(get(input$dataset_var),
                                                    input$row_var),
                                       bordered = T,
                                       hover = T,
                                       spacing = 'xs')
                           
  output$interactive_map <- renderLeaflet({
    listings <- listings %>%
      filter(room_type %in% input$roomtype) %>%
      filter(price >= input$price_choice[1], price <= input$price_choice[2])
    build_map(listings, input$location)
  })

  output$interactive_treemap <- renderD3tree2({
    build_treemap(listings, neighbourhoods, input$tree_map_variable)
  })

  output$interactive_plot <- renderPlotly({
    build_plot(listings_exp, input$x_axis)
  })
})
