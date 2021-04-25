library('shiny')
library("shinyWidgets")
library('httr')
library('DT')
library("markdown")
library('spotifyr')
library('dplyr')
library("highcharter")
library("shinycssloaders")

useSweetAlert()

shinyUI(fluidPage(
  
  title = "SpotifyR Shiny App",
  titlePanel(title=div(img(src="logo.png",align='right'),"Spotify ShinyApp")),
  
  sidebarPanel(
    conditionalPanel(condition="input.conditionedPanels == 'Overview'",       
                     passwordInput("client", "SPOTIFY_CLIENT_ID"),
                     passwordInput("secret", "SPOTIFY_CLIENT_SECRET"),
                     actionButton("authenticate", "Authenticate", icon("submit"))
                     ),
    conditionalPanel(condition="input.conditionedPanels == 'Get Data'", 
                     textInput("ser_art","Search Spotify"),
                     selectInput("sel_type","Select Type",choices = c("album", "artist", "playlist", "track")),
                     actionButton("search","Search"),
                     downloadButton("download")
                    ),
    conditionalPanel(condition = "input.conditionedPanels== 'Get Audio Features'",
                     textInput("ser_art_2","Artist Name"),
                     actionButton("act_btn2","Search"),
                     uiOutput('select_artist_ui'),
                     uiOutput('b2'),
                     
                     )
    ),
  
  mainPanel(
    
    tabsetPanel(type="tabs",
                tabPanel("Overview",
                         h3(p("How to use this App")),
                         hr(),
                         includeMarkdown("Read me.md")
                         # verbatimTextOutput("secretID"),
                         # verbatimTextOutput("clientID")
                         #htmlOutput('table')
                         ),
                       # tabPanel("Downloads",)
                tabPanel("Get Data",
                         DT::dataTableOutput("ser_data")
                         
                         ),
                tabPanel("Get Audio Features",
                         hr(),
                         uiOutput('artist_plot'),
                         downloadButton("download_audio_feature"),
                         DT::dataTableOutput('find_audio')),
                id = "conditionedPanels"  
                )
                
     )
)
  )
