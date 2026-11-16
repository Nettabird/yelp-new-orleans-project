# Yelp New Orleans Restaurant Project

Analysis of New Orleans restaurant reviews from the [Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/), done in R.

## Research question

What restaurants in New Orleans are best for a tourist family that includes picky eaters?

## Executive summary

This project uses the Yelp Open Dataset to find restaurants in and around New Orleans that suit a tourist family with picky eaters. I identified likely candidates by searching reviews for mentions of picky kids and by selecting related restaurant categories, grouped them by ZIP code, and ranked them with a score that adjusts for how generously each reviewer rates. The report lists the top 10 restaurants in each of 16 ZIP codes; adjusting for reviewer habits mostly confirms Yelp’s average ratings, and families have plenty of good options across the city.

## Files and folders

```         
yelp-new-orleans-project/
├── README.md
├── yelp_new_orleans_project.qmd        # main report (renders to HTML)
├── RestaurantReviews.Rproj             # RStudio project file
├── docs/
│   ├── yelp_new_orleans_project.html   # rendered report (GitHub Pages)
│   └── figures/                        # copy of the report figures, made by Quarto
├── figures/
│   └── top10_map.png                   # map of the top 10 restaurants
├── data/
│   ├── raw/                            # original Yelp JSON files (not committed)
│   └── LA/
│       ├── business.rds                # filtered Louisiana restaurants
│       ├── reviews_no_text.rds         # their reviews, without the text column
│       ├── reviews.rds                 # their reviews with text (not committed; made by import.R)
│       ├── users.rds                   # reviewer data (not used in the report)
│       ├── reviewer_all_reviews.rds    # all dataset reviews by those reviewers (not used in the report)
│       ├── picky_mentions.rds          # reviews matching picky-eater phrases
│       ├── picky_sample.csv            # hand-labeled sample of phrase matches
│       ├── top10.rds                   # saved top 10 results for the report summary
│       └── neighborhoods.geojson       # New Orleans neighborhood boundaries
├── R/
│   ├── config.R                        # shared settings: area, file paths, study area, boundaries
│   ├── import.R                        # imports the large JSON files, filters, caches
│   ├── picky_search.R                  # searches review text for picky-eater phrases, caches matches
│   └── explore_reviews.R               # optional: review text for restaurants in the final ZIP codes
├── renv/                               # renv setup files (activate.R, settings.json)
├── renv.lock                           # package versions
├── .Rprofile                           # activates renv
└── .gitignore
```

## Getting the data

1.  Download the Yelp Open Dataset (JSON version) from <https://business.yelp.com/data/resources/open-dataset/>. You will need to accept Yelp's terms.
2.  Extract the archive and place these files in `data/raw/`:
    - `yelp_academic_dataset_business.json`
    - `yelp_academic_dataset_review.json`
    - `yelp_academic_dataset_user.json`
3.  Open the project in RStudio, restore packages with `renv::restore()`, and run `R/import.R`.

The review file is about 5 GB, and parsing it took about 355 seconds. `import.R` streams it in chunks, keeps only Louisiana restaurants, and saves the result to `data/LA/`. The user file is about 3 GB; parsing it took about 185 seconds. `import.R` streams it in chunks and saves the result to `data/LA/`. After import, every later step reads the small cached files.

To run the project for another city, change `area_state` and `out_dir` in the config file, and make the necessary changes to the geographic area and the discussion in the .qmd file.

## Why the raw data is not on GitHub

The raw JSON files are several gigabytes, far above GitHub’s 100 MB file limit. The filtered files in data/LA/ are small enough to commit: `business.rds`, `reviews_no_text.rds`, `users.rds`, `neighborhoods.geojson`, `picky_mentions.rds`, `picky_sample.csv`, and `top10.rds`. The full reviews with text are recreated by running `R/import.R`, and the phrase matches by running `R/picky_search.R`. `picky_sample.csv` contains hand-labeled data and cannot be regenerated.

## Report

[Rendered report](https://nettabird.github.io/yelp-new-orleans-project/yelp_new_orleans_project.html)

## Key findings

- Useful (and useless) phrases for picky eaters looking for a place to eat:
  - "Picky kid" is the only one I found useful.
  - "Picky eater" also shows up a lot in the data, but it's too often inside phrases like "I'm not a picky eater, but the food here is terrible!"
  - Other phrases were not correlated closely enough with positive reviews related to picky eaters to be any use.
- 16 ZIP codes, covering a large portion of New Orleans and the nearby area, contained 10 or more likely candidates. This suggests a tourist family has plenty of options even if some or all of them are picky eaters.
- Adjusting for reviewer activity doesn't change rankings much...for the most part. Looking only at the Yelp average rating is still a pretty good measure of what people actually thought about it, regardless of how many stars they tend to be willing to give on average.

## Tools

R, RStudio, Quarto. Packages: tidyverse, jsonlite, lubridate, sf, tigris, scales, viridis, renv, ggspatial, prettymapr, leaflet, knitr, shadowtext, ggrepel.

## AI assistance

I used Claude (Anthropic) as a coding and troubleshooting assistant. Claude also drafted the initial structure of the report and this README, as well as the executive summary for the README. The research question; category selection, conclusions, and other analysis decisions; and discussion are my own. I review and test all code before using it.
