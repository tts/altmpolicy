sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Plot", tabName = "altmetric", icon = icon("dashboard")),
    menuSubItem("Data", tabName = "data", icon = icon("angle-double-right"), selected = NULL),
    selectInput(inputId = "school", 
                label = "School", 
                choices = c("All", schools),
                multiple = FALSE,
                selected = "All"),
    selectInput("xc", "Horizontal axis", as.list(metrics_select), selected = "Policy"),
    selectInput("yc", "Vertical axis", as.list(metrics_select), selected = "Cites"),
    HTML("<div class='form-group shiny-input-container'><p><a href='http://www.altmetric.com'>Altmetric</a> data and WoS cites 2016-12-12. Altmetric API search based on DOI</p></div>"),
    HTML("<div class='form-group shiny-input-container'><p>R source code of <a href='https://github.com/tts/altmpolicy'>building this app</a></p></div>")
  ), width = 150
)


body <- dashboardBody(
  
   tabItems(
    
    tabItem("altmetric",
            fluidRow(
              column(
                width = 8,
                box(title = "Scatterplot by School",
                    status = "success",
                    solidHeader = TRUE,
                    width = "100%",
                    height = "800px",
                    ggiraphOutput("plot", width = "100%"))
              ),
              column(
                width = 4,
                valueBoxOutput("nrofitemswithmetrics", width = "100%"),
                valueBoxOutput("maxaltmetrics", width = "100%"),
                valueBoxOutput("maxvideo", width = "100%"),
                valueBoxOutput("maxtwitter", width = "100%"),
                valueBoxOutput("maxcites", width = "100%"))
            ),
            fluidRow(
              column(
                width = 8,
                box(title = "Selected item(s)",
                    status = "warning",
                    solidHeader = TRUE,
                    width = "100%",
                    tableOutput("sel"))),
              column(
                width = 2,
                box(width = NULL,
                    height = "50px",
                    actionButton("reset", label = "Reset selection", 
                                 icon = icon("refresh"), width = "100%")))
            )
              
    ),
    
    tabItem("data",
            fluidRow(
              box(title = "Table",
                  status = "info",
                  solidHeader = TRUE,
                  width = 12,
                  height = "600px",
                  DT::dataTableOutput("datatable", 
                                      height = "600px"))
              )
    )
    
  ))


dashboardPage(
  dashboardHeader(title = "Aalto University publications 2007-2015 with altmetrics from policy sources",
                  titleWidth = "700"),
  sidebar,
  body,
  skin = "black"
)

