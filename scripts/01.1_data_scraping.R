install.packages("textdata")


library(httr)
library(jsonlite)
library(tidytext)
library(textTinyR)
library(textdata)
library(ggplot2)


# Base URL  
base_url <- "https://content.guardianapis.com/search"

# API key
api_key <- Sys.getenv("Guardian_API_KEY")

if (api_key == "") {
  stop("API key is not set. Please ensure your .Renviron file is configured correctly.") #Checks for API key and gives error message if not
}

# Setting the parameters for the request

parameters <- list(
  "q" = "COVID-19 AND restriction",
  "from-date" = "2019-11-01",
  "to-date" = "2024-05-02",
  "api-key" = api_key,
  "show-fields" = "body",
  "page-size" = 200
)

# Get request and parsing the data 

response <- GET(url = base_url, query = parameters)
data <- content(response, "text", encoding = "UTF-8")
parsed_data <- fromJSON(data)

# Extract articles

articles <- parsed_data$response$results


# Save the data to a CSV file
  
write.csv(articles, file = "articles.csv", row.names = FALSE)

##Sentiment analysis
afinn_lexicon <- get_sentiments("afinn")

# Read and prepare the data
articles <- read.csv("articles.csv", stringsAsFactors = FALSE)
articles$date <- as.Date(substr(articles$webPublicationDate, 1, 10))

articles_tokens <- articles %>%
  unnest_tokens(word, fields)

articles_sentiment <- articles_tokens %>%
  inner_join(afinn_lexicon, by = "word")


average_scores <- articles_sentiment%>% #Somethin is wrong here: score is the same for every article.
  group_by(id) %>%
  summarize(avg_score = mean(value))


