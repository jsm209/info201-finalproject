source("scripts/build_map.R")

listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  output$interactive_map <- renderLeaflet({
    return(build_map(listings))
  })
})