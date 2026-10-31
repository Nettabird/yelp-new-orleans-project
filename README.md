# Yelp New Orleans Restaurant Project

Analysis of New Orleans restaurant reviews from the [Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/), done in R.

> **Status:** work in progress. The data import and filtering are complete. Cleaning, category analysis, spatial joins, and the final report are in progress.

## Research question

*TODO: state one clear research question here.*

## Executive summary

*TODO: two or three sentences stating the answer (the top 10 restaurants) and the main finding. Fill in after the analysis.*

## Files and folders

```         
yelp-new-orleans-project/
├── README.md
├── yelp_new_orleans_project.qmd   # main report (renders to HTML)
├── RestaurantReviews.Rproj        # RStudio project file
├── data/
│   ├── raw/                       # original Yelp JSON files (not committed)
│   └── new_orleans/
│       ├── business.rds           # filtered New Orleans businesses
│       └── reviews_no_text.rds    # filtered reviews without the text column
├── R/
│   └── import.R                   # imports the large JSON files, filters, caches
├── renv/                          # renv setup files
├── renv.lock                      # package versions
├── .Rprofile                      # activates renv
└── .gitignore
```

## Getting the data

1.  Download the Yelp Open Dataset (JSON version) from <https://business.yelp.com/data/resources/open-dataset/>. You will need to accept Yelp's terms.
2.  Extract the archive and place these two files in `data/raw/`:
    - `yelp_academic_dataset_business.json`
    - `yelp_academic_dataset_review.json`
3.  Open the project in RStudio, restore packages with `renv::restore()`, and run `R/import.R`.

The review file is about 5 GB, and parsing it takes roughly 8 to 10 minutes. `import.R` streams it in chunks, keeps only New Orleans businesses, and saves the result to `data/new_orleans/`. After that, every later step reads the small cached files.

To run the project for another city, change `area_city`, `area_state`, and `out_dir` at the top of `R/import.R`.

## Why the raw data is not on GitHub

The raw JSON files are several gigabytes, which is far above GitHub's 100 MB file limit. The filtered New Orleans files in `data/new_orleans/` are small enough to commit, and the steps above recreate everything else. Only business.parquet and reviews_no_text.rds are in the repo; the full reviews with text are recreated by running R/import.R

## Report

*TODO: link to the rendered HTML report once it is published.*

## Key findings

*TODO: two or three findings written for a nontechnical reader, with embedded tables, graphs, and maps.*

## Tools

R, RStudio, Quarto. Packages: tidyverse, jsonlite, lubridate, sf, tigris, scales, viridis, arrow.

## AI assistance

*TODO: update this*

I used Claude (Anthropic) as a coding and troubleshooting assistant. Claude also drafted the structure of this README. The research question, category selection, analysis decisions, and conclusions are my own. I review and test all code before using it.
