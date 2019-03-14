library(tidyverse)
library(shiny)
library(leaflet)
library(plotly)
library(d3treeR) # nolint
library(DT)

# Imports the listings of Airbnbs
listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

listings_exp <- read.csv("data/listings_exp.csv")
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
    "Exploration By Neighborhood",
    titlePanel("Exploration of Airbnbs by neighborhood in Seattle"),
    sidebarLayout(
      sidebarPanel(
        HTML("
          This is an interactive treemap that groups the smaller neighborhoods
          of Seattle by their general region, then <b>dictates their size 
          depending on the variable selected.</b> 
          <br />
          <br />
          Additionally, a table with neighbourhoods and the selected variable
          is also provided for a more specific comparison between desired 
          neighborhoods.
          <br />
          <br />
          <i>Clicking on the boxes will allow you to
          explore different neighborhoods of Seattle to see their relationship
          relative to other neighborhoods.</i>
          <br/>
          <i>The table of values can be searched using the search bar at the
          top right of the table, or be sorted by clicking the respective 
          column name</i>
          <br />
          <br />
          By comparing the sizes of the boxes against the entire city of 
          Seattle by their relative scale, one can at a glance quickly see 
          for example:
          <ul>
            <li>The neighbourhoods of Seattle that on average, cost 
                the most.</li>
            <ul>
              <li>
                The most expensive neighborhood on average is 
                <b>Pike Market</b>, however the most expensive neighborhood
                group is <b>other neighborhoods</b>. 
              </li>
            </ul>
            <li>The neighbourhoods that on average, have the most availability
                during the year.</li>
            <ul>
              <li>
                The most available neighborhood on average is <b>International 
                District</b>. 
              </li>
            </ul>
            <li>The neighbourhoods that on average, get the least amount of 
                reviews.</li>
            <ul>
              <li>
                The neighbourhood with the least amount of reviews is 
                <b>South Lake Union.</b>
              </li>
            </ul>
          </ul>
          "),
        h3("Seattle"),
        selectInput(
          inputId = "tree_map_variable",
          label = "Organize Treemap Size By...",
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
        d3treeOutput("interactive_treemap"),
        DT::dataTableOutput("treemap_dataset")
      )
    )
  ),
  tabPanel(
    "Scatter Plot", # label for the tab in the navbar
    titlePanel("Scatter Plot of the Number of Reviews v.s. Other Variables"),
    # This content uses a sidebar layout
    sidebarLayout(
      sidebarPanel(
        HTML("
          Surprisingly, <i>there isn't much of a correlation between the average
          price per neighbourhood and the overall score.</i> The scores tend to 
          be high generally regardless of what the price is with the only 
          outlier being <b>University District</b> which is cheaper than most 
          neighbourhoods but also has a lower overall score.
          <br />
          <br />
          There is some correlation between the location and the price since
          <i>some of the neighborhoods with lower location scores are also cheaper
          on average.</i>
          <br />
          <br />
          The number of people accommodated on average sees a positive
          correlation midway between the plot which goes to show which
          neighbourhoods have bigger houses listed as Airbnbs and how the
          price increases with the number of people that can be accommodated
          which is expected.
          <br />
          <br />
          <i>We also see a positive correlation between the number of total 
          reviews and number of reviews per month</i> which tells us which
          neighbourhoods have consistently more visitors from Airbnb on
          average.
          <br />
          <br />
          There is a mild negative correlation between the number of total
          reviews and the year round availability which is to be expected since
          more availability would mean more visitors and hence, more reviews.
             "),
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