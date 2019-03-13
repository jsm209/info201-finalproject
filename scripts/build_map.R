library(dplyr)
library(ggplot2)
library(leaflet)
library(leaflet.extras)

# "build_map" will take in a dataframe
#  which is the InsideAirbnb "listings" dataset
#  It will return an interactive heatmap 
#  of the locations that are most populated with Airbnb's

build_map <- function(df, user_nb){
  df_neighbourhood <- df %>%
    select(neighbourhood_group, longitude, latitude) %>%
    filter(neighbourhood_group %in% user_nb)
  interactive_map <- leaflet(df_neighbourhood) %>%
    addProviderTiles(providers$Stamen.Toner) %>%
    addHeatmap(lng = ~df_neighbourhood$longitude,
               lat = ~df_neighbourhood$latitude,
               blur = 24,
               max = 0.05,
               radius = 15) %>%
    return()
}
