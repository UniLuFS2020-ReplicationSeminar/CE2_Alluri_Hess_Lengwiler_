
#Load library
library(httr)

# Define base URL and parameters 
base_url <- "https://content.guardianapis.com/search"
topic <- "COVID-19"
api_key <- Sys.getenv("Guardian_API_KEY")# Create Renviron text file in your project directory 
                                         # and type the following line:
                                         # Guardian_API_KEY="enter-your-registered-api-key-here"
                                         # We have "git-ignored" this file 
   
#GET request 
api_response1 <- GET(url = base_url, 
                     query = list(q = topic,`api-key` = api_key))
#Do not mind the error

# Check the response status and output results
# Article Titles and URL's
if (status_code(api_response1) == 200) {
  content_data <- content(api_response1, "parsed") 
  print(content_data)
} else {
  print(paste("Failed with status:", status_code(api_response1)))
}
