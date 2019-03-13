library(shiny)
library(leaflet)
library(plotly)

shinyUI(navbarPage(
  "Airbnb's in Seattle",
  tabPanel(
    "Visual Representation #1", # label for the tab in the navbar
    titlePanel("Airbnb Heatmap of Locations in Seattle"), # show with a title
    # This content uses a sidebar layout
    sidebarLayout(
      sidebarPanel(
        h3("Seattle"),
        checkboxGroupInput(
          inputId = "location",
          label = "Filter by:",
          choices = c("Ballard", "Beacon Hill", "Capitol Hill",
                      "Cascade", "Central Area", "Delridge",
                      "Downtown", "Interbay", "Lake City",
                      "Magnolia", "Northgate", "Other neighbourhoods",
                      "Queen Anne", "Rainier Valley", "Seward Park",
                      "University District", "West Seattle"),
          selected = c("Ballard", "Beacon Hill", "Capitol Hill",
                       "Cascade", "Central Area", "Delridge",
                       "Downtown", "Interbay", "Lake City",
                       "Magnolia", "Northgate", "Other neighbourhoods",
                       "Queen Anne", "Rainier Valley", "Seward Park",
                       "University District", "West Seattle")
        )
      ),
      mainPanel(
        p("This is an interactive heatmap showing the locations
          that are the most populated with Airbnb's in the Seattle Area.
          You can choose to zoom into specific neighbourhood(s) group to see
          that particular area's Airbnb."),
        leafletOutput("interactive_map")
      )
    )
  ),
  tabPanel(
    "Interactive Tree Map", # label for the tab in the navbar
    titlePanel("Tree Map of Airbnbs in Seattle"), # show with a displayed title
    # This content uses a sidebar layout
    sidebarLayout(
      sidebarPanel(
        h3("Seattle"),
        selectInput(
          inputId = "tree_map_variable",
          label = "Organize Size By...",
          choices = c("Price" = "price",
                      "Days Available" = "availability_365",
                      "Number of Reviews" = "number_of_reviews",
                      "Minimum Nights to Stay" = "minimum_nights"),
          selected = "price"
        )
      ),
      mainPanel(
        p("This is an interactive tree that groups the smaller neighborhoods of
          Seattle by their general region, then dictates their size depending
          on the variable selected. Clicking on the boxes will allow you to 
          explore different neighborhoods of Seattle to see their relationship 
          relative to other neighborhoods."),
        d3treeOutput("interactive_treemap")
      )
    )
  ),
  tabPanel(
    "Scatter Plot", # label for the tab in the navbar
    titlePanel("Scatter Plot of the Number of Reviews v.s. Other Variables"),
    # This content uses a sidebar layout
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "x_axis",
          label = "Compare To:",
          choices = list(
            "Price" = "price",
            "Year-round Availability" = "availability_365",
            "Reviews per Months" = "reviews_per_month"
          )
        )
      ),
      mainPanel(
        p("This plot compares the number of reviews by the chosen variable
          according to neighbourhood groups in Seattle"),
        plotlyOutput("interactive_plot")
      )
    )
  )
))