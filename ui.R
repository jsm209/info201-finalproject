library(shiny)
library(leaflet)

shinyUI(navbarPage(
  "yo change this to something intelligent",
  tabPanel(
    "Interactive Map",
    titlePanel("will add options later"),
    sidebarLayout(
      sidebarPanel(
        p("This is an interactive map that plots the locations of thousands 
          of Airbnb locations provided in the dataset from 'InsideAirBnb',
          an independent, non-commerical set of tools and data for Airbnb 
          analysis.")
      ),
      mainPanel(
        leafletOutput("interactive_map")
      )
    )
  )
))