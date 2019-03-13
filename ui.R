library(tidyverse)
library(shiny)
library(leaflet)
library(plotly)
library(d3treeR) # nolint

# Imports the listings of Airbnbs
listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

listings_exp <- read_csv("data/listings.csv.gz")
# extract amenities info
amenities <- listings_exp %>%
  separate_rows(amenities, sep = ",") %>%
  select(id, amenities)
amenities$amenities <- gsub("[{\"}]", "", amenities$amenities)

ratings <- listings_exp %>%
  select(id, review_scores_rating, neighbourhood_group_cleansed, price, room_type, amenities)


# Imports the names of the neighborhoods.
neighbourhoods <- read.csv("data/neighbourhoods.csv",
                           stringsAsFactors = FALSE)

# Price range
price_range <- range(listings$price)

shinyUI(navbarPage(
  "Airbnb in Seattle",
  tabPanel(
    "Overview", # label for the tab in the navbar
    titlePanel("Project Overview"), # show with a title
    HTML("<h4>Introduction</h4>
        This report focuses on Airbnb trends in Seattle, using the
        datasets provided by <a href=insideairbnb.com>InsideAirbnb</a>.
        <b>InsideAirbnb</b> is <i>'an independent, non-commercial set of tools
        and data that allows you to explore how Airbnb is really being used in
        cities around the world.'</i> Specifically, we are focusing on Seattle
        and working with the listings and neighborhoods datasets.
        <h4>Main Goals</h4>
        These are the major questions we are exploring in this report:
        <ul><li>What kind of Airbnbs are concentrated in what Seattle
        neighborhoods?</li>
        <li>How does the location/neighborhood of a listing affect the
        pricing of Airbnb options?</li>
        <li>What time of year is most popular?</li>
        <li>Availability? Amenities? Ratings? </li></ul>
        <h4>Visualizations</h4>
        To answer the above questions, we have analyzed the data and
        processed them into three main visualizations: heatmap,
        interactive tree map, and a scatterplot. Explore these visualizations
        in their corresponding tabs above!
        <h4>Preview of Datasets</h4>
        The two main datasets we are using are listings and neighborhoods,
        the csv files of which are publicly available on InsideAirbnb.
        Use the widget below to preview the two datasets by customizable
        sorting settings."),
    headerPanel(""), #add extra space
    sidebarLayout(
      sidebarPanel(
        h3("Preview Settings"),
        selectInput(
          inputId = "dataset_var",
          label = "Choose Dataset:",
          choices = c(
            "Listings" = "listings",
            "Neighborhoods" = "neighbourhoods"
          )
        ),
        selectInput(
          inputId = "rand_var",
          label = "Arrange:",
          choices = c(
            "Default" = "head",
            "Random" = "sample_n"
          )
        ),
        numericInput(
          inputId = "row_var",
          label = "Number of Rows",
          value = 6
        ),
        width = 3
      ),
      mainPanel(
        div(
          style = "height: 350px; overflow: scroll",
          tableOutput("dataset")
        )
      )),
    HTML("        <h4>Summary of Results</h4>
        These are the main trends that we are seeing in the data:
         <ul><li></li><li></li><li></li></ul>")
  ),
  tabPanel(
    "Heatmap", # label for the tab in the navbar
    titlePanel("Airbnb Heatmap of Locations in Seattle"), # show with a title
    # This content uses a sidebar layout
    sidebarLayout(
      sidebarPanel(
        h3("Heatmap Settings"),
        checkboxGroupInput(
          inputId = "roomtype",
          label = "Room Type:",
          choices = c("Entire home/apt", "Private room", "Shared room"),
          selected = c("Entire home/apt", "Private room", "Shared room")
        ),
        sliderInput(
          inputId = "price_choice",
          label = "Price Range",
          min = price_range[1], max = price_range[2], value = price_range),
        checkboxGroupInput(
          inputId = "location",
          label = "Neighborhood:",
          choices = c(
            "Ballard", "Beacon Hill", "Capitol Hill",
            "Cascade", "Central Area", "Delridge",
            "Downtown", "Interbay", "Lake City",
            "Magnolia", "Northgate", "Queen Anne", "Rainier Valley",
            "Seward Park", "University District", "West Seattle",
            "Other neighbourhoods"
          ),
          selected = c(
            "Ballard", "Beacon Hill", "Capitol Hill",
            "Cascade", "Central Area", "Delridge",
            "Downtown", "Interbay", "Lake City",
            "Magnolia", "Northgate", "Queen Anne", "Rainier Valley",
            "Seward Park", "University District", "West Seattle",
            "Other neighbourhoods"
          )
        )
      ),
      mainPanel(
        p("This is an interactive heatmap showing the locations
          that are the most populated with Airbnb's in the Seattle Area.
          You can choose to zoom into specific neighbourhood(s) group to see
          that particular area's Airbnb."),
        leafletOutput("interactive_map")
      )
  )),
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
          choices = c(
            "Price" = "price",
            "Days Available" = "availability_365",
            "Number of Reviews" = "number_of_reviews",
            "Minimum Nights to Stay" = "minimum_nights"
          ),
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
  ),
  footer = HTML("<footer>Published by: Group BC5 (<a href=https://github.com/jasnelmoon>Nel Jee Ae Na</a>,
       <a href=https://github.com/jsm209>Joshua Maza</a>,
       <a href=https://github.com/rajoshich>Rajoshi Chakravarty</a>,
       <a href=https://github.com/TasnimHasan>Tasnim Hasan</a>)")))