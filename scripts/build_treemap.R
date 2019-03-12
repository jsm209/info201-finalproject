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

# "average_by_neighbourhood" takes in a dataframe, which is assumed to be
# the InsideAirbnb "listings" dataset, and the neighbourhoods dataset
# associated with the listings. Then, it will use it to compute averages
# and associate neighbourhood with its neighbourhood group
average_by_neighbourhood <- function(data, neighbourhoods) {
  group_by(data, neighbourhood) %>%
    summarise_all(funs(mean)) %>%
    left_join(neighbourhoods)
}

# "build_treemap" takes in a dataframe, which is assumed to be the InsideAirbnb
# "listings" dataset, the neighbourhoods dataset associated with the listings,
# and a variable to plot, which can be the following:
# price, availability_365, number_of_reviews_ minimum_nights.
# Will construct an interactive treemap.
build_treemap <- function(listings, neighbourhoods, variable = "price") {

  # Get relevant columns
  filtered <- select(
    listings, neighbourhood, price, minimum_nights,
    number_of_reviews, availability_365
  )

  # Get averages and associate neighbourhood with its neighbourhood group
  averages <- average_by_neighbourhood(filtered, neighbourhoods)

  # Assigns appropriate unit for description depending on question variable
  unit <- ""
  if (variable == "price") unit <- " dollars per night"
  if (variable == "minimum_nights") unit <- " minimum nights to stay"
  if (variable == "number_of_reviews") unit <- " reviews"
  if (variable == "availability_365") unit <- " days of the year available"

  # Gives every entry the appropriate label
  averages$label <- paste0(
    averages$neighbourhood, "\n (",
    round(averages[[variable]]), " ", unit, ")"
  )

  # Builds a regular treemap using the "treemap" library.
  tm <- treemap(averages,
    index = c("neighbourhood_group", "label"),
    vSize = variable,
    vColor = "neighbourhood_group",
    type = "categorical",
    palette = "Set2",
    fontsize.title = 14,
    algorithm = "squarified"
  )

  # Builds a d3treemap2
  # Uses the previous treemap to build an interactive treemap.
  # Uses the "d3treeR" library, not found in CRAN.
  # Source of resources required for this function
  # is found at the top of the file.
  tm2 <- d3tree2(tm,
    rootname = paste0(
      "Average ",
      variable,
      " of airbnbs for different areas in Seattle."
    )
  )
  return(tm2)
}
