# Project settings shared by R/import.R, R/picky_search.R and the .qmd.
# To use another area, change the values below.

# Area
area_city  <- "New Orleans"   # unused for New Orleans, kept for other areas in future
area_state <- "LA"
out_dir    <- "data/LA"

# Cached files
business_out         <- file.path(out_dir, "business.rds")
review_out           <- file.path(out_dir, "reviews.rds")           # with text, not committed
no_text_out          <- file.path(out_dir, "reviews_no_text.rds")
user_out             <- file.path(out_dir, "users.rds")
reviewer_reviews_out <- file.path(out_dir, "reviewer_all_reviews.rds")
picky_out            <- file.path(out_dir, "picky_mentions.rds")

# Study area: center point (Jackson Square) and radius
center_lon <- -90.0629
center_lat <-  29.9574
radius_m   <- 10000   # about 6.2 miles

# Boundaries
zcta_prefixes <- c("700", "701")                       # ZCTAs to download
parishes      <- c("Orleans", "Jefferson", "St. Bernard")  # for roads and water
nsa_file      <- file.path(out_dir, "neighborhoods.geojson")
nsa_url       <- "https://maps.nola.gov/server/rest/services/Reference/Reference_Layers/MapServer/0/query?where=1%3D1&outFields=*&f=geojson"

# Reviewers
min_user_reviews   <- 5
min_biz_reviews    <- 30
min_active_reviews <- 5