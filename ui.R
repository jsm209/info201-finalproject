library(shiny)
library(leaflet)

shinyUI(navbarPage(
  "Airbnb's in Seattle",
  tabPanel(
    "Visual Representation #1", # label for the tab in the navbar
    titlePanel("Airbnb Heatmap of Locations in Seattle"), # show with a displayed title
    # This content uses a sidebar layout
    sidebarLayout(
      sidebarPanel(
        h3("Seattle"),
        selectInput(
          inputId = "location",
          label = "Filter by:",
          choices = c("Ballard", "Beacon Hill", "Capitol Hill",
                      "Cascade","Central Area","Delridge",
                      "Downtown","Interbay","Lake City",
                      "Magnolia","Northgate","Other neighbourhoods",
                      "Queen Anne","Rainier Valley","Seward Park",
                      "University District","West Seattle")
        )
      ),
      mainPanel(
        p("This is an interactive heatmap showing the locations 
          that are the most populated with Airbnb's in the Seattle Area.
          You can choose to zoom into specific neighbourhood group to see
          location "),
        leafletOutput("interactive_map")
      )
    )
  )
))