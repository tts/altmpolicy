sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Plot", tabName = "altmetric", icon = icon("dashboard")),
    menuSubItem("Data", tabName = "data", icon = icon("angle-double-right"), selected = NULL),
    selectInput(inputId = "school", 
                label = "School", 
                choices = c("All", schools),
                multiple = FALSE,
                selected = "All"),
    selectInput("xc", "x axis", as.list(metrics_select), selected = "Policy"),
    selectInput("yc", "y axis", as.list(metrics_select), selected = "Cites"),
    selectInput(inputId = "scx", 
                label = "x axis scale", 
                choices = c("identity", "log10"),
                multiple = FALSE,
                selected = "identity"),
    selectInput(inputId = "scy", 
                label = "y axis scale", 
                choices = c("identity", "log10"),
                multiple = FALSE,
                selected = "identity"),
    HTML("<div class='form-group shiny-input-container'><p><a href='http://www.altmetric.com'>Altmetric</a> data and WoS cites 2016-12-12. Altmetric API search based on DOI</p></div>"),
    HTML("<div class='form-group shiny-input-container'><p>The bigger the circle, the more citing policy documents</p></div>"),
    HTML("<div class='form-group shiny-input-container'><p>No data from Schools ARTS and ELEC</p></div>"),
    HTML("<div class='form-group shiny-input-container'><p>R source code of <a href='https://github.com/tts/altmpolicy'>this app</a></p></div>")
  ), width = 150
)


body <- dashboardBody(
  
   tabItems(
    
    tabItem("altmetric",
            fluidRow(
              column(
                width = 8,
                box(title = "Click to select items to table below. You can also zoom in/out",
                    status = "success",
                    solidHeader = TRUE,
                    width = "100%",
                    ggiraphOutput("plot", width = "100%"))),
              column(
                width = 4,
                valueBoxOutput("nrofitemswithmetrics", width = NULL),
                valueBoxOutput("maxaltmetrics", width = NULL),
                valueBoxOutput("maxvideo", width = NULL),
                valueBoxOutput("maxtwitter", width = NULL),
                valueBoxOutput("maxcites", width = NULL))
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
                  DT::dataTableOutput("datatable", 
                                      height = "600px"))
              )
    )
    
  ))


dashboardPage(
  dashboardHeader(title = "Aalto University publications 2007-2015 with altmetrics from policy documents",
                  titleWidth = "700"),
  sidebar,
  body,
  skin = "black"
)

