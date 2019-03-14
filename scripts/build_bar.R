library(tidyverse)
library(plotly)

build_percbar <- function(data, topn_var) {
  # subset data to amenities
  amenities <- data %>%
    separate_rows(amenities, sep = ",")
  amenities$amenities <- gsub("[{\"}]", "", amenities$amenities)
  amenities <- amenities %>%
    group_by(amenities) %>%
    summarize(
      count = n(),
      percentage = round(count / nrow(data) * 100, digits = 1)
    ) %>%
    arrange(desc(count))

  # subset amenities data to appropriate number of rows
  topn_amenities <- head(amenities, n = topn_var)

  # plot bar graph
  plot_ly(
    x = topn_amenities$amenities,
    y = topn_amenities$percentage,
    type = "bar",
    text = paste0(topn_amenities$percentage, "%")
  ) %>%
    layout(
      title = paste0("Top ", topn_var, " Most Common Amenities"),
      xaxis = list(
        title = "Types of Amenities",
        categoryorder = "array",
        categoryarray = topn_amenities$amenities
      ),
      yaxis = list(title = "Percentage of Listings")
    ) %>%
    return()
}
