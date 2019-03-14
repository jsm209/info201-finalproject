source("scripts/build_map.R")
source("scripts/build_treemap.R")
source("scripts/build_plot.R")
source("scripts/build_bar.R")

# Imports the listings of Airbnbs
listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

listings_exp <- read.csv("data/listings_exp.csv", stringsAsFactors = FALSE)
listings_exp$price <- as.numeric(gsub("[$, ]", "", listings_exp$price))

# Imports the names of the neighborhoods.
neighbourhoods <- read.csv("data/neighbourhoods.csv",
  stringsAsFactors = FALSE
)

shinyServer(function(input, output) {
  output$dataset <- renderTable(get(input$rand_var)(get(input$dataset_var),
    input$row_var),
  bordered = T,
  hover = T,
  spacing = "xs"
  )

  output$interactive_map <- renderLeaflet({
    listings <- listings %>%
      filter(room_type %in% input$roomtype) %>%
      filter(price >= input$price_choice[1], price <= input$price_choice[2])
    build_map(listings, input$location)
  })

  output$interactive_treemap <- renderD3tree2({
    build_treemap(listings, neighbourhoods, input$tree_map_variable) # nolint
  })

  output$treemap_dataset <- DT::renderDataTable(build_averages_table(
    listings,
    neighbourhoods, input$tree_map_variable
  ))

  output$interactive_plot <- renderPlotly({
    build_plot(listings_exp, input$x_axis, input$y_axis) # nolint
  })

  output$amenitiesbar <- renderPlotly({
    build_percbar(listings_exp, input$topn_var) # nolint
  })

  output$amenitiesplot <- renderPlot({
    build_amenplot(listings_exp, input$y_var)
  })
})
