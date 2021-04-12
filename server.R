shinyServer(function(input,output,session){
  
  
  
   observeEvent(input$authenticate,{
    id <- input$client
    secret <- input$secret
    Sys.setenv(SPOTIFY_CLIENT_ID = id)
    Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)
    token <- get_spotify_access_token(id, secret)
    Sys.setenv(SPOTIFY_TOKEN = token)
    #access_token <- get_spotify_authorization_code(scope= c('user-top-read','playlist-read-private','user-read-recently-played'))
    sendSweetAlert(
      session = session,
      title = "Success !!",
      text = "Authorized",
      type = "success"
    )
    beatles <- get_artist_audio_features('the beatles')
    # output$table <- render_html(beatles %>% 
    #                               count(key_mode, sort = TRUE) %>% 
    #                               head(5) %>% 
    #                               kable())
    print(beatles %>% 
            count(key_mode, sort = TRUE) %>% 
            head(5))
    }
   )
  
  values <- reactiveValues(df_data = NULL) 
  
  observeEvent(input$search,{
    if(input$search!=""){
      token <- Sys.getenv('SPOTIFY_TOKEN')
      print(token)
      search_result <- search_spotify(q = input$ser_art,type = input$sel_type, authorization = token)
      #t <- paste0(input$sel_type,'s')
      #print(names(search_result))
      #search_result_df <- search_result[[t]]['items']
      #print(colnames(search_result_df))
     search_result_df <- get_data(search_result,input$sel_type)
     values$df_data <- search_result_df
     print(dim(values$df_data))
     output$ser_data <- DT::renderDataTable(search_result_df)
     
      # output$sel_artist <- renderUI({
      #         selectInput("get_art",
      #                 label = "Select Artist",
      #                 choices = art_choices)})
    }
    
  })
  
  output$download <- downloadHandler(
    filename = function() {
      paste(input$sel_type,"_df", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(values$df_data, file, row.names = FALSE)
    }
  )
  
  

}
)


