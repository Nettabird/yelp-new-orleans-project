library(tidyverse)
source("R/config.R")

# Searches the review text for picky-eater phrases and caches the matches.
# Needs data/LA/reviews.rds (the version with text), created by R/import.R .

overwrite <- FALSE   # set TRUE after changing the phrases, then set back to FALSE

if (!file.exists(review_out)) {
  stop(review_out, " not found. Run R/import.R first.")
}

apos <- "['’]?"   # optional straight or curly apostrophe

# One regex per phrase; a review can match several phrases.
# "picky" alone overlaps the first two on purpose, to check how precise it is.
phrases <- c(    # Set overwrite to TRUE after changing phrases, then set back to FALSE
  picky_eater    = "picky eaters?",
  picky_kid      = "picky (kids?|child|children|son|daughter|toddlers?|teens?)",
  picky          = "picky",
  kids_menu      = paste0("(kids?", apos, "s?", apos, "|children", apos, "s) menu"),
  kid_friendly   = "(kid|family)[- ]friendly",
  for_families   = "great for families",
  for_everyone   = "something for everyone",
  accommodate    = "accommodat(e|ed|ing)",
  customize      = "customiz(e|able|ible|ations?)",
  tenders        = "chicken (tenders?|fingers?|strips?|nuggets?)",
  grilled_cheese = "grilled cheese",
  mac_cheese     = "mac (and|&|n|n'|'n') cheese|macaroni and cheese"
)

if (overwrite || !file.exists(picky_out)) {
  reviews <- readRDS(review_out)

  matches <- imap(phrases, \(pattern, name) {
    rx   <- regex(paste0("\\b(", pattern, ")\\b"), ignore_case = TRUE)
    hits <- reviews |> filter(str_detect(text, rx))
    pos  <- str_locate(hits$text, rx)   # first match in each review

    hits |>
      mutate(
        phrase  = name,
        snippet = str_sub(text, pmax(1, pos[, "start"] - 100), pos[, "end"] + 100)
      ) |>
      select(business_id, user_id, date, stars, phrase, snippet)
  }) |>
    list_rbind()

  saveRDS(matches, picky_out)
}

# Sample for the precision check. Label the "relevant" column by hand (y/n).
# Not overwritten on rerun, so labels are safe; delete the file to resample.
picky_sample <- file.path(out_dir, "picky_sample.csv")

if (!file.exists(picky_sample)) {
  set.seed(1)
  readRDS(picky_out) |>
    group_by(phrase) |>
    slice_sample(n = 50) |>
    ungroup() |>
    mutate(relevant = NA) |>
    write_csv(picky_sample)
}

# Quick check: matches and restaurants per phrase
readRDS(picky_out) |>
  group_by(phrase) |>
  summarise(reviews = n(), restaurants = n_distinct(business_id)) |>
  arrange(desc(reviews))
