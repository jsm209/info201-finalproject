library(dplyr)
library(ggplot2)
library(leaflet)

# "build_map" takes in a dataframe, which is assumed to be the InsideAirbnb 
# "listings" dataset, creates, and returns an interactive map of points 
# that cluster and present additional information when hovered over or 
# clicked on.
build_map <- function(df) {
  interactive_map <- leaflet() %>%
    addTiles() %>% 
    addMarkers(
      clusterOptions = markerClusterOptions(),
      lng = df$longitude,
      lat = df$latitude,
      label = paste0(
        listings$name,
        " ( Click for more information )"
      ),
      popup = paste(
        "Name:", df$name, "<br>",
        "Neighbourhood:", df$neighbourhood, "<br>",
        "Price: ", df$price, "<br>",
        "Type:", df$room_type, "<br>",
        "Minimum Nights:", df$minimum_nights
      )
    ) %>%
  return()
}
