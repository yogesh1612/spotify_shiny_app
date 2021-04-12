install.packages('rlang')
devtools::install_github('charlie86/spotifyr')
library('spotifyr')

get_my_top_artists_or_tracks(type = 'artists', time_range = 'medium_term', limit = 5,authorization = access_token) %>% 
  select(name, genres) %>% 
  rowwise %>% 
  mutate(genres = paste(genres, collapse = ', ')) %>% 
  ungroup