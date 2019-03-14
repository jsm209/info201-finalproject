library(dplyr)
library(plotly)

build_plot <- function(df, x_axis, y_axis) {
  # Removing the $ sign to be able to calculate the mean price
  df$price <- as.numeric(gsub("[$, ]", "", df$price))
  
  plot_data <- full_join(aggregate(
    as.formula(paste(
      x_axis,
      "~ neighbourhood_group_cleansed"
    )),
    df, mean
  ),
  aggregate(
    as.formula(paste(
      y_axis,
      "~ neighbourhood_group_cleansed"
    )),
    df, mean
  ),
  by = "neighbourhood_group_cleansed"
  )
  
  x1 <- plot_data[[x_axis]]
  y1 <- plot_data[[y_axis]]
  
  ytext <- "Price"
  if (y_axis == "number_of_reviews") {
    ytext <- "No. of Total Reviews"
  }
    
  xtext <- "Overall Review Scores" 
  if (x_axis == "availability_365") {
    xtext <- "Year-round Availability"
  } else if (x_axis == "reviews_per_month") {
    xtext <- "No. of Reviews per month"
  } else if (x_axis == "accommodates") {
    xtext <- "No. of People Accomodated (on average)"
  } else if (x_axis == "review_scores_location") {
    xtext <- "Location Score"
  }
  
  p <- plot_ly(
    data = plot_data, type = "scatter", mode = "markers",
    x = x1, y = y1, text = ~paste0(neighbourhood_group_cleansed),
    marker = list(
      size = 13,
      color = y1,
      opacity = 0.8
    )
  ) %>%
    layout(
      title = paste("Comparison Between", ytext, "and", xtext),
      yaxis = list(title = ytext, zeroline = FALSE),
      xaxis = list(title = xtext, zeroline = FALSE)
    )
  
  return(p)
}
