get_artists <- function(artist_name, token) {
  
  # Search Spotify API for artist name
  res <- GET('https://api.spotify.com/v1/search', query = list(q = artist_name, type = 'artist', access_token = token)) %>%
    content %>% .$artists %>% .$items
  
  # Clean response and combine all returned artists into a dataframe
  artists <- map_df(seq_len(length(res)), function(x) {
    list(
      artist_name = res[[x]]$name,
      artist_uri = str_replace(res[[x]]$uri, 'spotify:artist:', ''), # remove meta info from the uri string
      artist_img = ifelse(length(res[[x]]$images) > 0, res[[x]]$images[[1]]$url, NA)
    )
  })

  
  if(nrow(artists)>0)
    return(artists)
  
  return(NULL)
}

# get_url <- function(x){
#   paste0(
#     "<a href='",
#    x,
#     "' target='_blank'>",
#     "'",
#     x,
#     "'</a>"
#   )
# }

get_data <- function(df,type){
  if(type=="album"){
  #  df$external_urls.spotify <- get_url(df$external_urls.spotify)
    return(df[,c('album_type','name','release_date','total_tracks','external_urls.spotify')])
  }else if(type=="artist"){
    return(df[,c("name","popularity","type","external_urls.spotify","followers.total")])
  }else if (type=="playlist"){
    return(df[,c("name","description","external_urls.spotify","owner.display_name","owner.href","tracks.total")])
  }else{
    return(df[,c("name","duration_ms","popularity","track_number","album.name","album.release_date","album.total_tracks","album.external_urls.spotify")])
  }
}


library(httr)
library(shiny)
library(shinyjs)
library(shinyBS)
library(tidyverse)
library(shinymaterial)
library(tibble)
library(highcharter)
library(RColorBrewer)
library(shinycssloaders)
library(htmltools)
library(lubridate)
library(lazyeval)
library(spotifyr)

rm(list = ls())

source('helpers.R')

jscode <-
  '$(document).on("shiny:connected", function(e) {
  var jsWidth = screen.width;
  Shiny.onInputChange("GetScreenWidth",jsWidth);
});
'
base_url <- 'https://api.spotify.com/v1/'

neon_colors <- c(
  '#84DE02'
  , '#FF4466'
  , '#4BC7CF'
  , '#FF85CF'
  , '#FFDF46'
  , '#391285'
  , '#E88E5A'
  , '#DDE26A'
  , '#C53151'
  , '#B05C52'
  , '#FD5240'
  , '#FF4681'
  , '#FF6D3A'
  , '#FF404C'
  , '#A0E6FF'
)

pca_vars <- c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms')

