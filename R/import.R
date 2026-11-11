library(tidyverse)
library(jsonlite)

# To use another area, change these values and point out_dir to a new folder.
area_city  <- "New Orleans"       # unused for New Orleans, kept for other areas in future
area_state <- "LA"
out_dir    <- "data/LA"

overwrite <- FALSE   # set TRUE to rebuild the cached files, then set back to FALSE

business_file <- "data/raw/yelp_academic_dataset_business.json"
review_file <- "data/raw/yelp_academic_dataset_review.json"
business_out <- file.path(out_dir, "business.rds")
review_out <- file.path(out_dir, "reviews.rds")
user_file <- "data/raw/yelp_academic_dataset_user.json"
user_out  <- file.path(out_dir, "users.rds")

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Businesses: small file, parse directly, keep the area only
if (overwrite || !file.exists(business_out)) {
  business <- jsonlite::stream_in(file(business_file), verbose = FALSE) |>
    select( # on changing select, set overwrite to TRUE
      business_id, name, address, city, state, postal_code,
      latitude, longitude, stars, review_count, categories
    ) |>
    # on changing filters, set overwrite to TRUE
    filter(state %in% area_state, str_detect(categories, "Restaurants"))
  
  saveRDS(business, business_out)
}

# Reviews: stream in chunks, keep only the area's businesses
if (overwrite || !file.exists(review_out)) {
  area_ids <- readRDS(business_out)$business_id
  chunks <- list()
  
  print(system.time(
    jsonlite::stream_in(
      file(review_file),
      pagesize = 100000,
      verbose = FALSE,
      handler = function(df) {
        chunks[[length(chunks) + 1]] <<- df |>
          filter(business_id %in% area_ids) |>
          # on changing select, set overwrite to TRUE
          select(business_id, user_id, stars, date, text, useful, funny, cool)
      })))
  
  saveRDS(bind_rows(chunks), review_out)
}

no_text_out <- file.path(out_dir, "reviews_no_text.rds")
if (overwrite || !file.exists(no_text_out)) {
  saveRDS(select(readRDS(review_out), -text), no_text_out)
}

# Reviewers
if (!file.exists(user_out)) {
  reviewer_ids <- unique(reviews$user_id)
  chunks <- list()
  
  print(system.time(
    jsonlite::stream_in(
      file(user_file),
      pagesize = 100000,
      verbose = FALSE,
      handler = function(df) {
        chunks[[length(chunks) + 1]] <<- df |>
          filter(user_id %in% reviewer_ids) |>
          # on changing select, set overwrite to TRUE
          select(user_id, review_count, average_stars, yelping_since, useful, funny, cool, fans)
      }
    )
  ))
  
  saveRDS(bind_rows(chunks), user_out)
}