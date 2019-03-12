# Note: This file uses packages not found on the CRAN, namely the "d3treeR"
# package. The source code can be found at the following link:
#
# https://github.com/d3treeR/d3treeR
#
# The installation instructions can be found here under
# "Quick Installation" via the following link:
#
# http://www.buildingwidgets.com/blog/2015/7/22/week-29-d3treer-v2

library(dplyr)
library(treemap)
library(htmlwidgets)
library(data.tree)
library(d3treeR)

# "build_treemap" takes in a dataframe, which is assumed to be the InsideAirbnb
# "listings" dataset, and a variable to plot, which can be the following: 
# price, availability_365, number_of_reviews_ minimum_nights.
# Will construct an interactive treemap.
build_treemap <- function(listings, neighourhoods, variable) {

  # Get relevant columns
  filtered <- select(listings, neighbourhood, price, minimum_nights,
                     number_of_reviews, availability_365)

  # Imports the names of the neighborhoods.
  neighbourhoods <- read.csv("data/neighbourhoods.csv",
                             stringsAsFactors = FALSE)

  # Get averages and associate neighbourhood with its neighbourhood group
  averages <- group_by(filtered, neighbourhood) %>%
    summarise_all(funs(mean)) %>%
    left_join(neighbourhoods)

  # Assigns appropriate unit for description depending on question variable
  unit <- ""
  if (variable == "price") unit <- " dollars per night"
  if (variable == "minimum_nights") unit <- " minimum nights to stay"
  if (variable == "number_of_reviews") unit <- " reviews"
  if (variable == "availability_365") unit <- " days of the year available"

  # Gives every entry the appropriate label
  averages$label <- paste0(averages$neighbourhood, " (",
                           round(averages[[variable]]), " ", unit, ")")

  # Builds a regular treemap using the "treemap" library.
  tm <- treemap(averages,
          index = c("neighbourhood_group", "label"),
          vSize = variable,
          vColor = "neighbourhood_group",
          type = "categorical",
          palette = "Set2",
          title = paste0("Average ", variable, " of airbnbs in Seattle."),
          fontsize.title = 14,
          algorithm = "squarified"
  )

  # Uses the previous treemap to build an interactive treemap.
  # Uses the "d3treeR" library, not found in CRAN.
  # Source of resources required for this function
  # is found at the top of the file.
  d3tree2(tm, rootname = paste0("Average ", variable,
                               " of airbnbs for different areas in Seattle."))
}
