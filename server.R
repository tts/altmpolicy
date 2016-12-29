function(input, output, session) {
  
  selectedSchoolData <- reactive({
    
    if ( input$school == 'All' ) 
      return(data)

     data %>%
        filter(School %in% input$school) 
  })
  
  
  select_metrics <- reactive({
    
    # Are there columns that are all NA?
    all_na_cols <- apply(selectedSchoolData(), 2, function(x) all(is.na(x)));  
    cols_with_all_na <- names(all_na_cols[all_na_cols>0]);    
    
    # Exclude these from the metrics vector so that they cannot be selected
    new_metrics <- setdiff(metrics_select, cols_with_all_na)
    new_metrics
    
  })
  
  
  # Update the selection of metrics in the UI if necessary
  observe({
    updateSelectInput(session, "xc",
                      choices = as.list(select_metrics()),
                      selected = "Policy")
    updateSelectInput(session, "yc",
                      choices = as.list(select_metrics()),
                      selected = "Cites")
  })
  
  
 output$plot <- renderggiraph({
  
    xc <- as.name(input$xc)
    yc <- as.name(input$yc)
    
    df <- selectedSchoolData()
    
    # max_y <- max(df$xc)
    # max_x <- max(df$yc)
    
    legend_title <- "School"
    
    gg_point <- ggplot(df, 
                       aes_q(x = xc,
                             y = yc,
                             size = df$Policy,
                             colour = df$School,
                             data_id = df$Title,
                             tooltip = df$Title)) + 
      labs(color=legend_title) +
      scale_x_continuous(trans="log10") +
      scale_y_continuous(trans="log10") +
      geom_point_interactive(alpha = 0.5, na.rm = TRUE) +
      scale_size(guide = "none")
    
    ggiraph(code = {print(gg_point)}, 
            selection_type = "multiple", 
            width_svg = 8, height_svg = 8, 
            hover_css = "fill:yellow", 
            tooltip_extra_css = tooltip_css,
            tooltip_offx = 20, tooltip_offy = -10,
            zoom_max = 3)
    
  })
 
 selected_state <- reactive({
   input$plot_selected
 })
 
 
 observeEvent(input$reset, {
   session$sendCustomMessage(type = 'plot_set', message = character(0))
 })
 
 
 
 output$sel <- renderTable({
   
   sel_df <- selectedSchoolData()
   
   out <- sel_df[sel_df$Title %in% selected_state(), 
                 c("Link", "Year", "Title", "School", "Journal", "Altmetric", "Cites")]
   
   if( nrow(out) < 1 ) return(NULL)
   row.names(out) <- NULL
   out
 }, sanitize.text.function = function(x) x)
 
 
  
  output$nrofitemswithmetrics <- renderValueBox({
    valueBox(
      "Items with metrics", 
      nrow(selectedSchoolData()), 
      icon = icon("calculator"),
      color = "yellow"
    )
  })
  
  output$maxaltmetrics <- renderValueBox({
    valueBox(
      "Top Altmetric score", 
      max(selectedSchoolData()$Altmetric), 
      icon = icon("spinner"),
      color = "green",
      href = selectedSchoolData()[selectedSchoolData()$Altmetric == max(selectedSchoolData()$Altmetric), "Altmetric_URL"][1]
    )
  })
  
  output$maxvideo <- renderValueBox({
    valueBox(
      "Top YouTube score", 
      ifelse(is.finite(max(selectedSchoolData()$YouTube, na.rm = TRUE)), max(selectedSchoolData()$YouTube, na.rm = TRUE), "N/A"), 
      icon = icon("youtube"),
      color = "teal",
      href = selectedSchoolData()[selectedSchoolData()$YouTube == max(selectedSchoolData()$YouTube, na.rm = TRUE), "Altmetric_URL"][1]
    )
  })

  output$maxtwitter <- renderValueBox({
    valueBox(
      "Top Twitter score", 
      ifelse(is.finite(max(selectedSchoolData()$Twitter, na.rm = TRUE)), max(selectedSchoolData()$Twitter, na.rm = TRUE), "N/A"), 
      icon = icon("twitter"),
      color = "light-blue",
      href = selectedSchoolData()[selectedSchoolData()$Twitter == max(selectedSchoolData()$Twitter, na.rm = TRUE), "Altmetric_URL"][1]
    )
  })
  
  output$maxcites <- renderValueBox({
    valueBox(
      "Top Cites score", 
      max(selectedSchoolData()$Cites), 
      icon = icon("line-chart"),
      color = "fuchsia",
      href = selectedSchoolData()[selectedSchoolData()$Cites == max(selectedSchoolData()$Cites), "Altmetric_URL"][1]
    )
  })
  
  
    # Datatable
   output$datatable <- DT::renderDataTable({
    
     totable <- selectedSchoolData()
     
     totable <- totable %>% 
       select(-Altmetric_URL)
    
    }, escape = FALSE, options = list(scrollX = T)
)
  
  
}
