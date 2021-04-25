hc_theme_rcharlie <- hc_theme_merge(
  hc_theme_monokai(),
  hc_theme(
    chart = list(
      backgroundColor = '#828282'
    ),
    title = list(
      style = list(
        color = '#ffffff'
      )
    ),
    subtitle = list(
      style = list(
        color = '#ffffff'
      )
    ),
    xAxis = list(
      labels = list(style = list(
        color = '#ffffff'
      )),
      title = list(style = list(
        color = '#ffffff'
      ))
      
    ),
    yAxis = list(
      labels = list(style = list(
        color = '#ffffff'
      )),
      title = list(style = list(
        color = '#ffffff'
      ))
    ),
    legend = list(
      itemStyle = list(
        color = '#ffffff'
      )
    )
  )
)

album_feature_chart <- function(df, feature) {
  
  df <- track_info_sub
  
  plot_df <- df %>% 
    mutate_(feature_var = interp(~ x, x = as.name(feature))) %>% 
    rowwise %>% 
    mutate(tooltip = paste0('<a style = "margin-right:', max(nchar(track_name), nchar(album_name)) * 9, 'px">',
                            '<img src=', album_img, ' height="50" style="float:left;margin-right:5px">',
                            '<b>Album:</b> ', album_name,
                            '<br><b>Track:</b> ', track_name)) %>% 
    ungroup
  avg_line <- plot_df %>% 
    group_by(album_rank, album_name, album_img) %>% 
    summarise(avg = mean(feature_var)) %>% 
    ungroup %>% 
    transmute(x = album_rank, y = avg,
              tooltip = paste0('<a style = "margin-right:', nchar(album_name) * 10, 'px">',
                               '<img src=', album_img, ' height="50" style="float:left;margin-right:5px">',
                               '<b>Album:</b> ', album_name,
                               '<br><b>Average Track ', feature,':</b> ', round(avg, 4),
                               '</a>'))
  dep_df <- plot_df %>% 
    mutate(tooltip = paste0(tooltip, '<br><b>', feature, ':</b> ', feature_var, '</a>')) %>% 
    ungroup
  
  cat_str <- paste0('var categoryLinks = {',
                    paste0(map(unique(df$album_name), function(x) {
                      paste0("'", x, "': '", df$album_img[df$album_name == x][1], "'")
                    }), collapse = ','), '};'
  )
  
  album_chart <- hchart(dep_df, x = 'album_rank', y = 'feature_var', group = 'album_name', type = 'scatter') %>% 
    hc_add_series_df(data = avg_line, type = 'line') %>%
    hc_tooltip(formatter = JS(paste0("function() {return this.point.tooltip;}")), useHTML = T) %>% 
    hc_colors(c(rep('#d35400', n_distinct(df$album_name)), 'black')) %>% 
    hc_legend(enabled = F) %>% 
    hc_xAxis(title = list(enabled = F), 
             categories = c('test', unique(dep_df$album_name)),
             labels = list(
               useHTML = T,
               formatter = JS(paste('function() {', cat_str,
                                    'return \'<a style = "align:center;text-align:center"><img src="\' + categoryLinks[this.value] + \'" height = "50px"/><br><b>\' + this.value + \'</b>\';}'))
             )) %>% 
    hc_yAxis(title = list(text = feature)) %>% 
    hc_title(text = paste(artist_name, feature, 'by album')) %>% 
    hc_add_theme(hc_theme_rcharlie)
  album_chart
}

############## both

artist_quadrant_chart <- function(track_df) {
  
  df2 <- data.frame(x = c(0, .9, 0, .9),
                    y = c(1, 1, 0, 0),
                    text = c('Turbulent/Angry',
                             'Happy/Joyful',
                             'Sad/Depressing',
                             'Chill/Peaceful'))
  
  ds2 <- list_parse(df2)
  
  track_df %>% 
    rowwise %>%
    mutate(tooltip = paste0('<a style = \"margin-right:', max(max(nchar(track_name), nchar(album_name)) * 9, 110), 'px\">',
                            '<img src=', album_img, ' height=\"50\" style=\"float:left;margin-right:5px\">',
                            '<b>Track:</b> ', track_name,
                            '<br><b>Album:</b> ', album_name,
                            '<br><b>Valence:</b> ', valence,
                            '<br><b>Energy:</b> ', energy)) %>% 
    ungroup %>% 
    hchart(hcaes(x = 'valence', y = 'energy', group = 'album_name'), type = 'scatter') %>% 
    hc_tooltip(formatter = JS(paste0("function() {return this.point.tooltip;}")), useHTML = T) %>%
    hc_yAxis(max = 1, min = 0, title = list(text = 'Energy')) %>%
    hc_xAxis(max = 1, min = 0, title = list(text = 'Valence')) %>%
    hc_add_theme(hc_theme_rcharlie) %>% 
    hc_colors(neon_colors) %>% 
    hc_yAxis(plotLines = list(list(
      value = .5,
      color = 'black',
      width = 2,
      zIndex = 2))) %>% 
    hc_xAxis(plotLines = list(list(
      value = .5,
      color = 'black',
      width = 2,
      zIndex = 2))) %>% 
    hc_add_series(data = ds2,
                  name = 'annotations',
                  type = 'scatter',
                  color = 'transparent',
                  showInLegend = FALSE,
                  enableMouseTracking = FALSE,
                  zIndex = 0,
                  dataLabels = list(enabled = TRUE, y = 10, format = "{point.text}",
                                    style = list(fontSize = "18px",
                                                 color =  '#fff',
                                                 textOutline = '0px'))
    )
}
