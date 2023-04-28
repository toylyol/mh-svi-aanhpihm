
# Discarded Functions ----

# Explore clusters (count of counties by state)

## This version of the function does *not* require parameter to be a quoted string [e.g., exploreClusters(EPL_CHIN)]:
#
# exploreClusters1 <- function(varname){
#
#    h_sv_df %>%
#      filter( {{varname}} >= params$var_threshold) %>%
#      group_by(STATE) %>%
#      summarize( `County Count` = n(),
#                 "{{varname}} Average" := mean( {{varname}} )  # note quotes and walrus operator
#               )
#
#  }


## This version of the function takes the parameter as a quoted string to optimize iteration:
#
# exploreClusters2 <- function(varname){
#
#    h_sv_df %>%
#      filter( .data[[varname]] >= params$var_threshold) %>%
#      group_by(STATE) %>%
#      summarize( `County Count` = n(),
#                 "{{varname}} Average" := mean( .data[[varname]] )  # note quotes and walrus operator
#               )
#
# }


# Explore correlations ----

exploreCoor <- function(df, var_name){
  
  df %>%
    ggplot() +
    geom_point(aes(x = {{var_name}}, y = RPL_THEMES)) +
    theme_minimal()
  
}           

# There are no correlations for any of the variables!

cor(x = h_sv_df$EPL_ASIAN, y = h_sv_df$RPL_THEMES, method = c("spearman")) # This confirms that there is no correlation.


# See all about calculating correlation in R here: http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r


# Create all-MH SVI choropleth ----
# The following code does not work due to the {farver} install issues (scale_fill_viridis is the culprit):

# us_counties_data %>%
#   ggplot() +
#   geom_sf(aes(fill = RPL_THEMES,
#               shape = "No MH SVI data is available.")) +
#   scale_fill_viridis(direction = -1,
#                      na.value = "gray47",
#                      name = "Overall MH Social Vulnerability",
#                      labels = scales::label_percent(accuracy = 0.1,
#                                                    suffix = "%")) +
#   guides(shape = guide_legend(override.aes = list(fil = "gray47",   # add NA value to legend
#                                                   title = NULL,
#                                                   order = 2,
#                                                   color = "transparent")),
#          fill = guide_colorbar(order = 1)) +
#   theme_minimal()


# Make choropleth for single variable of interest ----
#
# asian_map <- high_sv_counties_shifted %>%
#   ggplot() +
#   geom_sf( aes(fill = ifelse(EPL_ASIAN < 0.90,   # treat values under 0.89 for EPL_ASIAN as NA
#                              NA, EPL_ASIAN))
#            ) +
#   scale_fill_gradient(low = "#ffffd9",           # specify the same HEX code for low and high value in gradient
#                       high = "#ffffd9",
#                       na.value = "gray97") +
#   theme_void() +
#   theme(legend.position = "none",
#         plot.background = element_rect(fill = "transparent",  # ensure transparent bg upon saving
#                                       color = NA)
#   )
#
# ggsave(filename = "asian_map.svg",
#        height = 5.66, width = 9.05,
#        units = "in")


# Try cropping the map ----
#
# asian_crop_counties <- h_sv_df %>%
#   filter(EPL_ASIAN > params$var_threshold) %>%
#   distinct(ST_ABBR) %>%
#   pull()
#
# asian_counties <- us_counties_data_shifted[us_counties_data_shifted$ST_ABBR %in% asian_crop_counties,]
#
#
# asian_counties %>%
#   ggplot() +
#   geom_sf( aes(fill = ifelse(EPL_ASIAN < params$var_threshold,   # treat values under 0.89 for EPL_ASIAN as NA
#                              NA, EPL_ASIAN))
#            ) +
#   scale_fill_gradient(low = "#ffffd9",
#                     high = "#ffffd9",
#                     na.value = "gray97") +
#   theme_void() +
#   theme(legend.position = "none",
#         plot.background = element_rect(fill = "transparent",  # ensure transparent bg upon saving
#                                       color = NA)
#   )


# Try highlighting the states in which counties are located
#
# test_map <-  ggplot() +
#   geom_sf(data = high_sv_counties_shifted,
#           aes(fill = ifelse(EPL_ASIAN < params$var_threshold,  # treat values under 0.89 for EPL_ASIAN as NA
#                              NA, EPL_ASIAN)),
#           size = 0.1) +
#   scale_fill_gradient(low = "#ffffd9",           # specify the same HEX code for low and high value in gradient
#                       high = "#ffffd9",
#                       na.value = "gray97") +
#   geom_sf(data = filter(high_sv_counties_shifted, EPL_ASIAN > params$var_threshold),
#           size = 0.5,
#           alpha = 0) +                                         # make top layer zero opacity
#   theme_void() +
#   theme(legend.position = "none",
#         plot.background = element_rect(fill = "transparent",   # ensure transparent bg upon saving
#                                       color = NA)
#   )
#
# ggsave(filename = "test_map.svg",
#        height = 5.66, width = 9.05,
#        units = "in")
