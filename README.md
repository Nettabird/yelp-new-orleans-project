# Yelp New Orleans Restaurant Project

Analysis of New Orleans restaurant reviews from the [Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/), done in R.

> **Status:** work in progress. The data import, filtering, and cleaning are complete. Category analysis, spatial joins, reviewer-normalized scores, the top-ten list, and the final report are in progress.

## Research question

What restaurants in New Orleans are best for dinner for a tourist family that includes picky eaters?

## Executive summary

*TODO: two or three sentences stating the answer (the top 10 restaurants) and the main finding. Fill in after the analysis.*

## Files and folders

```         
yelp-new-orleans-project/
├── README.md
├── yelp_new_orleans_project.qmd        # main report (renders to HTML)
├── RestaurantReviews.Rproj             # RStudio project file
├── docs/
│   └── yelp_new_orleans_project.html   # rendered report
├── data/
│   ├── raw/                            # original Yelp JSON files (not committed)
│   └── LA/
│       ├── business.rds                # filtered Louisiana businesses
│       ├── reviews_no_text.rds         # filtered reviews without the text column
│       ├── users.rds                   # filtered reviewer data
│       └── neighborhoods.geojson       # New Orleans neighborhood boundaries
├── R/
│   └── import.R                        # imports the large JSON files, filters, caches
├── renv/                               # renv setup files (activate.R, settings.json)
├── renv.lock                           # package versions
├── .Rprofile                           # activates renv
└── .gitignore
```

## Getting the data

1.  Download the Yelp Open Dataset (JSON version) from <https://business.yelp.com/data/resources/open-dataset/>. You will need to accept Yelp's terms.
2.  Extract the archive and place these two files in `data/raw/`:
    - `yelp_academic_dataset_business.json`
    - `yelp_academic_dataset_review.json`
3.  Open the project in RStudio, restore packages with `renv::restore()`, and run `R/import.R`.

The review file is about 5 GB, and parsing it takes roughly 8 to 10 minutes. `import.R` streams it in chunks, keeps only Louisiana businesses, and saves the result to `data/LA/`. After that, every later step reads the small cached files.

To run the project for another city, change `area_city`, `area_state`, and `out_dir` at the top of `R/import.R`, and make the necessary changes to the geographic area in the .qmd file.

## Why the raw data is not on GitHub

The raw JSON files are several gigabytes, which is far above GitHub's 100 MB file limit. The filtered New Orleans files in `data/LA/` are small enough to commit, and the steps above recreate everything else. The repo includes `business.rds`, `reviews_no_text.rds`, `users.rds`, and `neighborhoods.geojson`; the full reviews with text are recreated by running `R/import.R`.

## Report

*TODO: Publish a GitHub Page and link to it here.* [Rendered report](docs/yelp_new_orleans_project.html)

## Key findings

*TODO: two or three findings written for a nontechnical reader, with embedded tables, graphs, and maps.*

## Tools

R, RStudio, Quarto. Packages: tidyverse, jsonlite, lubridate, sf, tigris, scales, viridis, renv.

## AI assistance

*TODO: update this*

I used Claude (Anthropic) as a coding and troubleshooting assistant. Claude also drafted the structure of this README and the report. The research question, category selection, analysis decisions, and conclusions are my own. I review and test all code before using it.
