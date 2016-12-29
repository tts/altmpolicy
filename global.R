library(dplyr)
library(shiny)
library(shinydashboard)
library(DT)
library(ggiraph)
library(ggplot2)

data <- read.table(file = "metrics.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)

names(data) <- c("Altmetric_URL", "Journal", "Title", "Altmetric", "Mendeley", "CiteULike", 
                          "Readers", "GPlus", "Facebook", "Posts", "Twitter",
                          "Accounts", "Feeds", "YouTube", "Reddit", 
                          "ResearchForums", "NewsOutlets", "Policy", "Year", "Cites", "School")

# Bad data
data$Title <- data$Title <- gsub("'","", data$Title)
data$Title[data$Title == "Long-term sea-level rise implied by 1.5[thinsp][deg]C and 2[thinsp][deg]C warming levels"] <- "Long-term sea-level rise implied by 1.5C and 2C warming levels"
data$Title[data$Title == "Early Prediction of Movie Box Office Success based on Wikipedia Activity\n  Big Data"] <- "Early Prediction of Movie Box Office Success based on Wikipedia Activity Big Data"

data <- data %>% 
  mutate(Link = paste0("<a href='", Altmetric_URL, "' target='_blank'>", substr(Altmetric_URL, 47, nchar(Altmetric_URL)), '</a>'))

# Reorder columns
data <- data[ ,c(ncol(data),1:ncol(data)-1)]

metrics_select <- sort(c("Altmetric", "Mendeley", "Twitter", "Facebook", "GPlus", "CiteULike", "Readers", "Posts", "Accounts", "Cites", "Feeds",
             "YouTube", "Reddit", "NewsOutlets", "ResearchForums", "Policy"))

# No data for ARTS and ELEC
schools <- c("BIZ", "CHEM", "ENG", "SCI")

tooltip_css <- "background-color:WhiteSmoke;width:300px;border-style:dotted;font-style:italic;padding:3px;"

