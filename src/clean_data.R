#! /usr/bin/env Rscript
# clean_data.R

# Gabriel Bogo
# Nov 20 2018

# Purpose: basic data wrangling and cleaning for subsequent modeling.

# Example usage:
# Rscript src/clean_data.R data/amsterdam_listings.csv data/amsterdam_clean_listings.csv


suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(here))

#Capture command line arguments and convert into path strings
args <- commandArgs(trailingOnly = TRUE)
input_path <- args[1]
output_path <- args[2]

#Read file
listings=read_csv(input_path, col_types="icicccddciiiDdii")

#DATA CLEANING
#There is no missing values coded as NA, but there are a few prices set to zero. Let's eliminate those.
listings <- listings %>%
  filter(price > quantile(price, 0.025),
         price < quantile(price, 0.975))

#All neighborhood groups are null. Let's drop this column.
listings <- listings %>%
  select(-neighbourhood_group)

#Drop non-sense large minimum nights
listings <-listings %>% filter(minimum_nights<999)

#Now let's create a categorical value based on the price.
xs <- quantile(listings$price,c(0,1/3,2/3,1))
listings <- listings %>%
  mutate(price_level=cut(price,breaks=xs,labels=c("low","median","high"))) %>%
  filter(!is.na(price_level))

#Next, create a categorical value based on the room type
listings <- listings %>%
  mutate(room_type_num = case_when(
    room_type == "Shared room" ~ 0,
    room_type == "Private room" ~ 1,
    room_type == "Entire home/apt" ~ 2)
    )

#Finally, let's save the dataset to a file
listings %>% write_csv(output_path)
