#  AirBnb's in Seattle

## Project Description

Our group will be working with the **AirBnb data collected on Seattle** as provided by **InsideAirBnb**. **InsideAirBnb** is *“an independent, non-commercial set of tools and data that allows you to explore how Airbnb is really being used in cities around the world”* to know more [click here](http://insideairbnb.com/about.html). The data used in this project can be found [here](http://insideairbnb.com/get-the-data.html).

Our **target audience** are *tourists* and *visitors* in Seattle who use **Airbnb** to plan their stay. Because a wide variety of people are likely to visit Seattle, we are focusing on the demographic of people who prefer to select the most cost effective choice, such as younger adults.

The **target audience** would most *benefit* from learning about **cost effective options** for their optimizing the quality of their stay. Because **location** is one of the *most important factors* in selecting an **Airbnb**, our *questions* focus on exploring the **effects of location on price, availability, amenities and housing options**. By choosing **location** as an *independent variable*, our target audience can learn more about their options in Seattle based on where they want to stay.

### Specific Questions
* Which neighborhoods in Seattle have more available Airbnb options based on the time of year?
* Does the location of the Airbnb affect the amount of bedrooms and bathrooms?
* Neighborhoods are most expensive for renting Airbnbs?
* Are there neighborhoods in Seattle where it costs more for an Airbnb to have more bathrooms? (bathroom to price ratio based on location)
* Are there neighborhoods in Seattle where it costs more for an Airbnb to have more bedrooms? (bedroom to price ratio based on location)
* How does the amount of bedrooms affect the price of an Airbnb listing?
* How does the amount of bathrooms affect the price of an Airbnb listing?
* What is the most common combination of amenities for an Airbnb listing? Does this change or depend on the neighborhood?
* Which locations in Seattle do Airbnb listings get more reviews per month?
* Which neighborhoods have the most futons and which neighborhoods have the most real beds?
* To what extent does the availability of wifi affect the availability of an airbnb?

## Technical Description

We are using datasets provided by [InsideAirBnb](http://insideairbnb.com/get-the-data.html). Because the data is in a `.csv file`, we can use built in `R functions` to `read in the file` to a `dataframe` to analyze.

There are many columns about an **Airbnb** that we will most likely not consider, such as columns like “cancelation”, which is a characteristic describing their cancellation policies, or “notes” which is a literal note left by the landlord. Therefore, `filtering` columns with `dplyr`, and parsing other string based column data (like the offered amenities for a listing) are steps that need to be taken to clean our data.

* `library(“tidyverse”)` - includes `dplyr` and `ggplot2` among others
* `library(“leaflet”)` - interactive mapping

One major **challenge** we anticipate is understanding the syntax and functions necessary to use shiny and our interactive mapping together in a cohesive graphical user interface. A second major **challenge** we anticipate is distributing tasks and working as a team remotely over github, because there can be issues with communication, even workloads for everyone, and working towards a common goal.
