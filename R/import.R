library(tidyverse)
library(jsonlite)
library(arrow)

# To use another area, change these two values and point out_dir to a new folder.
area_city  <- "New Orleans"
area_state <- "LA"
out_dir    <- "data/new_orleans"

business_file <- "data/raw/yelp_academic_dataset_business.json"
review_file <- "data/raw/yelp_academic_dataset_review.json"
business_out <- file.path(out_dir, "business.parquet")
review_out <- file.path(out_dir, "reviews.parquet")

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Businesses: small file, parse directly, keep the area only
if (!file.exists(business_out)) {
  business <- jsonlite::stream_in(file(business_file), verbose = FALSE) |>
    select( # on changing select, delete business.parquet and reviews.parquet
      business_id, name, address, city, state, postal_code,
      latitude, longitude, stars, review_count, categories
    ) |>
    # on changing filters, delete business.parquet and reviews.parquet
    filter(city == area_city, state == area_state)
  
  write_parquet(business, business_out)
}

# Reviews: stream in chunks, keep only the area's businesses
if (!file.exists(review_out)) {
  area_ids <- read_parquet(business_out, col_select = "business_id")$business_id
  chunks <- list()
  
  print(system.time(
    jsonlite::stream_in(
      file(review_file),
      pagesize = 100000,
      verbose = FALSE,
      handler = function(df) {
        chunks[[length(chunks) + 1]] <<- df |>
          filter(business_id %in% area_ids) |>
          # on changing select, delete reviews.parquet
          select(business_id, user_id, stars, date, text, useful, funny, cool)
      })))
  
  write_parquet(bind_rows(chunks), review_out)
}

business <- read_parquet(business_out)
reviews  <- read_parquet(review_out)