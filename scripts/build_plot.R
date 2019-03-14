library(tidyverse)
library(plotly)

build_plot <- function(df, x_axis, y_axis) {
  # Subset data to use for plot
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

  # Building scatter plot
  p <- plot_ly(
    data = plot_data, type = "scatter", mode = "markers",
    x = x1, y = y1, text = ~ paste0(neighbourhood_group_cleansed),
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

build_amenplot <- function(data, y_var) {
  # subset data to amenities
  amenities <- data %>%
    separate_rows(amenities, sep = ",")
  amenities$amenities <- gsub("[{\"}]", "", amenities$amenities)
  amenities <- amenities %>%
    group_by(id) %>%
    summarise(count = n())
  df <- full_join(amenities, data)

  if (y_var == "price") {
    y_text <- "Price"
  }
  if (y_var == "review_scores_rating") {
    y_text <- "Overall Review Rating"
  }
  if (y_var == "host_is_superhost") {
    y_text <- "Superhost"
  }

  df %>%
    ggplot(aes(x = count, y = df[[y_var]])) +
    geom_point() +
    geom_smooth() +
    labs(
      title = paste0("Relationship between Amenities and ", y_text),
      x = "Number of Amenities",
      y = y_text
    ) %>%
    return()
}
