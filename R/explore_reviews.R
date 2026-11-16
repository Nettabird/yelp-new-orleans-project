source("R/config.R")
library(tidyverse)

reviews_text <- readRDS(review_out) |>
  mutate(date = ymd_hms(date))

qualified_text <- reviews_text |>
  inner_join(select(qualified, business_id, area_id, name), by = "business_id") |>
  left_join(select(adjusted, business_id, user_id, date, norm_mean),
            by = c("business_id", "user_id", "date")) |>
  select(area_id, name, stars, norm_mean, date, text) |>
  arrange(area_id, desc(norm_mean), name)

rm(reviews_text)