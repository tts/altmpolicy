library(dplyr)
library(shiny)
library(shinydashboard)
library(DT)
library(ggiraph)
library(ggplot2)

# Data for charts and DT datatable
dataForCharts <- read.table(file = "metrics.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)

names(dataForCharts) <- c("Altmetric_URL", "Journal", "Title", "Altmetric", "Mendeley", "CiteULike", 
                          "Readers", "GPlus", "Facebook", "Posts", "Twitter",
                          "Accounts", "Feeds", "YouTube", "Reddit", 
                          "ResearchForums", "NewsOutlets", "Policy", "Year", "Cites", "School")

dataForCharts$Title <- dataForCharts$Title <- gsub("'","", dataForCharts$Title)

dataForCharts <- dataForCharts %>% 
  mutate(Link = paste0("<a href='", Altmetric_URL, "'>", substr(Altmetric_URL, 47, nchar(Altmetric_URL)), '</a>'))

dataForCharts <- dataForCharts[ ,c(ncol(dataForCharts),1:ncol(dataForCharts)-1)]

metrics_select <- sort(c("Altmetric", "Mendeley", "Twitter", "Facebook", "GPlus", "CiteULike", "Readers", "Posts", "Accounts", "Cites", "Feeds",
             "YouTube", "Reddit", "NewsOutlets", "ResearchForums", "Policy"))

# No data for ARTS and ELEC
schools <- c("BIZ", "CHEM", "ENG", "SCI")

tooltip_css <- "background-color:WhiteSmoke;width:300px;border-style:dotted;font-style:italic;padding:3px;"

