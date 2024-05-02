### 02_data_processing

## stuff you always need ####

# Load libraries
library(tidyverse)
library(rvest)

# clear the environment
rm(list = ls())

# check the working directory
getwd()

## Data processing ####

# load the data
dat <- read_csv("../data_original/guardian_covid_travel.csv")

# delete the variable id_endpoint
dat$id_endpoint <- NULL

#create a new variable month published based on publish_date
dat$month_published <- as.Date(dat$publish_date, format = "%Y-%m-%d") %>% format("%Y-%m")

# save the processed data
write_csv(dat, "../data_processed/guardian_covid_travel.csv")

## Data visualization ####

# plot out the variable month_published
dat %>% 
  ggplot(aes(x = month_published)) +
  geom_bar() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# save the plot
ggsave("../output/plot_month_published.png")

# print out how many times a section occurs in the variable section_name
dat %>% 
  count(section_name) %>%
  arrange(desc(n))
