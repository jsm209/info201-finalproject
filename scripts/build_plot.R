library(dplyr)
library(plotly)

build_plot <- function(df, x_axis) {
  plot_data <- full_join(aggregate(
    number_of_reviews ~ neighbourhood_group_cleansed,
    df, mean
  ),
  aggregate(
    as.formula(paste(
      x_axis,
      "~ neighbourhood_group_cleansed"
    )),
    df, mean
  ),
  by = "neighbourhood_group_cleansed"
  )
  
  # Removing the $ sign to be able to calculate the mean price
  if(x_axis == "price") {
    df$price <- str_replace(df$price, "$", "")
  }
  
  
  x1 <- plot_data[[x_axis]]
  y1 <- plot_data[["number_of_reviews"]]

  xtext <- "Price"
  if (x_axis == "availability_365") {
    xtext <- "Year-round Availability"
  } else if (x_axis == "reviews_per_month") {
    xtext <- "Reviews per Month"
  } else if (x_axis == "review_scores_rating") {
    xtext <- "Overall Review Scores"
  }

  p <- plot_ly(
    data = plot_data, type = "scatter", mode = "markers",
    x = x1, y = y1, text = ~ paste0(neighbourhood_group_cleansed),
    marker = list(
      size = 11,
      color = y1
    )
  ) %>%
    layout(
      title = paste("Comparison Between No. of Reviews and", xtext),
      yaxis = list(title = "No. of Reviews", zeroline = FALSE),
      xaxis = list(title = xtext, zeroline = FALSE)
    )

  return(p)
}
