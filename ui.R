library(tidyverse)
library(shiny)
library(leaflet)
library(plotly)
library(d3treeR) # nolint
library(DT)
library(shinythemes)

# Imports the listings of Airbnbs
listings <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

listings_exp <- read.csv("data/listings_exp.csv", stringsAsFactors = FALSE)
listings_exp$price <- as.numeric(gsub("[$, ]", "", listings_exp$price))

ratings <- listings_exp %>%
  select(
    id, review_scores_rating, neighbourhood_group_cleansed, price,
    room_type, amenities
  )


# Imports the names of the neighborhoods.
neighbourhoods <- read.csv("data/neighbourhoods.csv",
  stringsAsFactors = FALSE
)

# Price range
price_range <- range(listings$price)

shinyUI(fluidPage(theme = shinytheme("yeti"),
  navbarPage(
  "Airbnb in Seattle",
  tabPanel(
    "Overview", # label for the tab in the navbar
    titlePanel("Project Overview"), # show with a title
    HTML("<h4>Introduction and Purpose</h4>
        The purpose of this report is to focus on Airbnb trends in Seattle,
        using datasets provided by <a href=www.insideairbnb.com>
        InsideAirbnb</a>. <b>InsideAirbnb</b> is <i>'an independent,
        non-commercial set of tools and data that allows you to explore how
        Airbnb is really being used in cities around the world'.</i>
        Specifically, we are focusing on Seattle and working with the listings
        and neighborhoods datasets.
        <h4>Preview of Datasets</h4>
        The two main datasets we are using are listings and neighborhoods,
        the csv files of which are publicly available on InsideAirbnb.
        There are two different datasets available for listings information,
        one being a summary of 16 variables and the other being an extensively
        detailed dataset of 106 variables. The neighborhoods dataset provides a
        list of neighborhood categorizations used by InsideAirbnb."),
    headerPanel(""),
    sidebarLayout(
      sidebarPanel(
        h4("Preview Settings"),
        HTML("Use this widget to preview the datasets by customizable sorting
             options.<br/><br/>"),
        selectInput(
          inputId = "dataset_var",
          label = "Choose Dataset:",
          choices = c(
            "Summary Listings" = "listings",
            "Detailed Listings" = "listings_exp",
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
          style = "height: 400px; overflow: scroll",
          tableOutput("dataset")
        )
      )
    ),
    HTML("<h4>Main Goals</h4>
        These are the major questions we are exploring in this report:
         <ul><li>What kind of Airbnbs are concentrated in what Seattle
         neighborhoods?</li>
         <li>How does the location/neighborhood of a listing differ on its
        characteristics?</li>
         <li>How are Seattle Airbnb listings rated?</li>
        <li>What kind of amenities are available at Seattle Airbnbs?</li></ul>
         <h4>Visualizations</h4>
         To answer the above questions, we have analyzed the data and
         processed them into visualizations in the form of a heatmap,
         interactive tree map, scatterplots, and bar graphs. Explore the data
        with the two different kinds of maps or by different variables in their
       corresponding tabs above!
        <h4>Summary of Results</h4>
        These are the main trends that we have observed in the data:
         <ul><li>Most Airbnb listings are categorized as 'Other neighborhoods',
        followed by Downtown and Capitol Hill.</li>
         <li>Downtown has the highest proportion of Entire home/apt type
        listings.</li>
        <li>The most amount of shared room types are concentrated in Capitol
Hill.</li>
        <li>The average most expensive neighborhood is Pike Market.</li>
        <li>International District listings have the most availability.</li>
        <li>There is no correlation between rating score and price.</li>
        <li>The most commonly offered amenity is Wifi.</li>
        <li>There is no correlation between amenities and price.</li>
        <li>There is no correlation between amenities and review ratings
         scores.</li></ul>")
  ),
  tabPanel(
    "Heatmap", # label for the tab in the navbar
    titlePanel("Heatmap of Seattle Airbnb Locations"), # show with a title
    # This content uses a sidebar layout
    HTML("This is an interactive heatmap showing the concentrations of Seattle
        Airbnb listings. In the widget provided below, you can adjust settings
        to filter by room types, a price range, and neighborhoods. We are using
        17 neighborhood groupings. You can also zoom into an area of the map
        and it will adjust accordingly. <br/><br/>
        We have observed the most Airbnb listings concentrated around
        Seattle neighborhoods that have popular tourist or scenic attributes,
        such as <b>Downtown, Capitol Hill,</b> and near lakes/waterfront views.
        On average, <i>Downtown listings also tend to be more expensive</i>.
        When observing room types, we saw that Downtown had the most proportion
        of Entire home/apt types. The least available room type was shared
        rooms, which were the most concentrated in <b>Capitol Hill.</b>
        "),
    headerPanel(""),
    sidebarLayout(
      sidebarPanel(div(
        style = "height: 400px; overflow-y: scroll",
        h4("Heatmap Settings"),
        checkboxGroupInput(
          inputId = "roomtype",
          label = "Room Type:",
          choices = c("Entire home/apt", "Private room", "Shared room"),
          selected = c("Entire home/apt", "Private room", "Shared room")
        ),
        sliderInput(
          inputId = "price_choice",
          label = "Price Range",
          min = price_range[1], max = price_range[2], value = price_range
        ),
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
      )),
      mainPanel(
        leafletOutput("interactive_map")
      )
    )
  ),
  tabPanel(
    "Tree Map",
    titlePanel("Exploration of Seattle Airbnbs by Neighborhood"),
    HTML("This is an interactive treemap that groups the smaller neighborhoods
         of Seattle by their general region, then <b>dictates their size
         depending on the variable selected.</b>
         <br />
         <br />
         Additionally, a table with neighbourhoods and the selected variable
         is also provided for a more specific comparison between desired
         neighborhoods.
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
    sidebarLayout(
      sidebarPanel(
        h4("Map Settings"),
        HTML("<i>Clicking on the boxes will allow you to
         explore different neighborhoods of Seattle to see their relationship
             relative to other neighborhoods.</i>
             <br/>
             <br />
             <i>The table of values can be searched using the search bar at the
             top right of the table, or be sorted by clicking the respective
             column name.</i><br/>"),
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
    "Reviews", # label for the tab in the navbar
    titlePanel("Exploring Reviews and Other Variables"),
    # This content uses a sidebar layout
    HTML("The scatterplot provided below compares the number of reviews by the
        chosen variable according to neighbourhood groups in Seattle.
        Surprisingly, <i>there isn't much of a correlation between the average
          price per neighbourhood and the overall score.</i> The scores tend to
         be high generally regardless of what the price is with the only
         outlier being <b>University District</b> which is cheaper than most
         neighbourhoods but also has a lower overall score.
         <br />
         <br />
         There is some correlation between the location and the price since
         <i>some of the neighborhoods with lower location scores are also
        cheaper on average.</i>
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
         more availability would mean more visitors and hence, more reviews."),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "y_axis",
          label = "Chosen variable:",
          choices = list(
            "Price" = "price",
            "Number of Total Reviews" = "number_of_reviews"
          )
        ),
        selectInput(
          inputId = "x_axis",
          label = "Compare to:",
          choices = list(
            "Overall Review Scores (out of 100)" = "review_scores_rating",
            "Location Score (out of 10)" = "review_scores_location",
            "Reviews per Months" = "reviews_per_month",
            "Year-round Availability" = "availability_365",
            "No. of people Accomodated (on average)" = "accommodates"
          )
        )
      ),
      mainPanel(
        plotlyOutput("interactive_plot")
      )
    )
  ),
  tabPanel(
    "Amenities", # label for the tab in the navbar
    titlePanel("Amenities Offered at an Airbnb"),
    # This content uses a sidebar layout
    HTML("<h4>Most Common Amenities</h4>
        This bar chart shows the most common amenities offered at Seattle
        Airbnb listings. The most commonly offered amenity is <b>Wifi</b> at
        <i>97.9%</i> of all Seattle Airbnb listings. Adjust the settings
        below to see what percentage of listings offer what type of
        amenities.<br/><br/>"),
    sidebarLayout(
      sidebarPanel(
        numericInput(
          inputId = "topn_var",
          label = "Number of Amenities",
          value = 6,
          min = 1,
          max = 186
        ),
        width = 3
      ),
      mainPanel(
        plotlyOutput("amenitiesbar")
      )
    ),
    HTML("<h4>Relationship between Amenities and Other Variables</h4>
        This scatterplot shows how other variables may be correlated with the
        number of amenities offered at an Airbnb listing.
        The available variables to choose from are price, overall review
        ratings, and whether or not the host is a superhost. These
        variables are then plotted against the number of amenities."),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "y_var",
          label = "Choose Other Variable:",
          choices = c(
            "Price" = "price",
            "Overall Review Rating" = "review_scores_rating",
            "Superhost" = "host_is_superhost"
          )
        ),
        width = 3
      ),
      mainPanel(
        plotOutput("amenitiesplot")
      )
    ),
    HTML("<ul><li><b>Price: </b>We can observe that when plotted against price,
        the number of amenities widely vary, with the exception of several
        outliers. They seem to be concentrated on the lower left of the ranges,
        near the average number of amenities. There seems to be no correlation
        between the price and the number of amenities.</li>
        <li><b>Reviews: </b>When plotted against the overall review ratings
        (max 100), we see a concentration of observations in the upper
        region of the graph. This may be partly due to majority of Airbnb
        reviewers leaving highly positive reviews. There does not seem to be a
        very strong correlation between number of amenities and review ratings.
        However, when looking at observations closer to outliers, we can see
        that listings with high number of amenities have positive reviews and
        listings with negative reviews offer less amenities.</li>
        <li><b>Superhost: </b>Airbnb provides specific criteria for hosts to
        earn a Superhost status. They are generally seen as superior to other
        hosts and their listings. Plotted t for true and f for false, we see
        that the range of amenities only slightly differ based on superhost
        status. Only about 10 superhost listings offer more amenities than
        non-superhost listings.</li></ul>")
  ),
  footer = HTML("<footer>Published by: Group BC5
      (<a href=https://github.com/jasnelmoon>Nel Jee Ae Na</a>,
       <a href=https://github.com/jsm209>Joshua Maza</a>,
       <a href=https://github.com/rajoshich>Rajoshi Chakravarty</a>,
       <a href=https://github.com/TasnimHasan>Tasnim Hasan</a>)")
)))
