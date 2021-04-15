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
  
  token <- reactive({ token <- Sys.getenv('SPOTIFY_TOKEN')})
  
  values <- reactiveValues(df_data = NULL) 
  
  #----Tab 3 Get Artist Data-----
  artist_info <- reactive({
    req(input$ser_art_2 != '')
    search_spotify(input$ser_art_2, 'artist', authorization = token()) %>% 
      filter(!duplicated(name))
  })
  
  observeEvent(input$act_btn2, {
    choices <- artist_info()$name
    names(choices) <- choices
     output$select_artist_ui<- renderUI({selectInput('select_artist',
                                                     label = "Choose an artist from these matches on Spotify", 
                                                     choices = choices)})
     output$b2 <- renderUI({actionButton("b3","Get Audio Feature")})
  })
  
  observeEvent(input$b3, {
    df <- get_artist_audio_features(input$select_artist, authorization = token()) %>% 
      mutate(album_img = map_chr(1:nrow(.), function(row) {
        .$album_images[[row]]$url[1]
      }))
    if (nrow(df) == 0) {
      stop("Sorry, couldn't find any tracks for that artist's albums on Spotify.")
    }
    
    output$find_audio <- DT::renderDataTable({df[,-c(1,2,3,4,5,6,7,8,20,21,22,23,24,25,27,28,29,31,32,33,34,35,36,37,38,39)]})
    #audio_features<- reactive({df})
  })
  
  
  
  
  
  #--------#
  
  observeEvent(input$search,{
    if(input$search!=""){
     
      print(token)
      search_result <- search_spotify(q = input$ser_art,
                                      type = input$sel_type, 
                                      authorization = token())
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


