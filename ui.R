library('shiny')
library("shinyWidgets")
library('httr')
library('DT')
library("markdown")
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
                id = "conditionedPanels"  
                )
                
     )
)
  )
