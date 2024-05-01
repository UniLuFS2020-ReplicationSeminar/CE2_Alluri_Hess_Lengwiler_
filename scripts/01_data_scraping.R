
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

pages <- list()  

#GET request 
 for (i in 1:50) {
    api_response1 <- GET(url = base_url, 
                         query = list(q = topic,
                                      `api-key` = api_key,
                                      page = i,         #To iterate and get results from page 1 to 50
                                      `page-size` = 50) #50 articles per page
                         )
    #Do not mind the error
    
    # Check the response status and output results
    # Article Titles and URL's 
    if (status_code(api_response1) == 200) {
      content_data <- content(api_response1, "parsed")
      if (!is.null(content_data$response$results)) {   #Ensuring requested data is not null to make  
                                                       #sure that storing and accessing it is not problematic  
        # Iterating and adding each page results to the pages list
        pages <- append(pages, content_data$response$results)
      }
    } else {
      print(paste("Failed with status:", status_code(api_response1)))
    }
 }

#Converting matrix-list/nested structure into a dataframe
pages_flat <- bind_rows(pages)

#Creating a data frame by extracting necessary info
dat <- pages_flat %>% 
  select(id_endpoint = id,
         section_name = sectionName,
         publish_date = webPublicationDate,
         title = webTitle)



