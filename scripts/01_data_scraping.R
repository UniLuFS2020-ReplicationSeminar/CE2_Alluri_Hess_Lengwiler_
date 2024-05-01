
#Load library
library(httr)
library(tidyverse)

# Define base URL and parameters 
base_url <- "https://content.guardianapis.com/search"
topic <- "covid"
api_key <- Sys.getenv("Guardian_API_KEY")# Create Renviron text file in your project directory 
                                         # and type the following line:
                                         # Guardian_API_KEY="enter-your-registered-api-key-here"
                                         # We have "git-ignored" this file 
   
#GET request 
 for (i in 1:50) {
    api_response1 <- GET(url = base_url, 
                         query = list(q = topic,
                                      `api-key` = api_key,
                                      page = i,
                                      `page-size` = 50)
                         )
    #Do not mind the error
    
    # Check the response status and output results
    # Article Titles and URL's 
    if (status_code(api_response1) == 200) {
      content_data <- content(api_response1, "parsed") 
      print(content_data)
    } else {
      print(paste("Failed with status:", status_code(api_response1)))
    }
 }
 

#Creating a data frame by extracting necessary info
# View the list heirarchy by clicking on content_data-> response -> results
dat <- tibble(
  id = map_chr(content_data$response$results, 1),   #Extract id element      
  section_name = map_chr(content_data$response$results, 4),   #Extract sectionNname element
  publish_date = map_chr(content_data$response$results, 5),   #webPublicationDate
  title = map_chr(content_data$response$results, 6),          #webTitle
  web_url = map_chr(content_data$response$results, 7)         #webURL
)

