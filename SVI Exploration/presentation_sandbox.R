# Run all chunks before get-shapefile-and-export ----


# Run load-shapefile-join-data-and-explore ----


# Create choropleth map for all counties ----

# Note the change to a vertical lengend to fit better on the slide with the...bold template.

overall_mh_svi_map <- us_counties_data_shifted %>%
  ggplot() +
  geom_sf(aes(fill = RPL_THEMES,
              shape = "No data are available."),
          size = 0.1) +
  scale_fill_gradient(name = "Overall Minority Health Social Vulnerability Ranking\n",
                      low = "#e5eaf9", 
                      high = "#192c64", 
                      labels = scales::percent_format(),
                      na.value = "gray87") +
  scale_shape(guide = "legend") +                                   # use to ensure override.aes() accepted
  guides(shape = guide_legend(title = NULL,                         # reinforce that there should be no legend title
                              override.aes = list(fill = "gray87",  # add NA value to legend
                                                  title = NULL,
                                                  label = FALSE,
                                                  order = 2,
                                                  color = "transparent")), # change stroke color in legend
         fill = guide_colorbar(title.position = "top",                     # see https://r-graphics.org/recipe-legend-reverse
                               title.hjust = 0.5,
                               title.theme = element_text(size = 9,
                                                          color = "gray27"),
                               reverse = TRUE,
                               order = 1) 
  ) +
  theme_void() +
  theme(legend.text = element_text(size = 9,                   # ensure that no-data message is gray font
                                   color = "gray27"),
        legend.position = "right",
        legend.margin = margin(10, 10, 10, 10),                # remember clockwise ordeR: top, right, bottom, left
        plot.background = element_rect(fill = "transparent",   
                                       color = NA)
  )


## Save choropleth map ----

ggsave(filename = "overall_mh_svi_map_presentation.svg")                       


# Create map for all high svi counties (one color) ----

high_svi_map_presentation <- high_sv_counties_shifted %>%
  ggplot() +
  geom_sf( aes(fill = RPL_THEMES),
           size = 0.1) +
  scale_fill_gradient( low = "#192c64", 
                       high = "#192c64",
                       labels = scales::percent_format(),
                       na.value = "gray97") +                   
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "transparent",     
                                       color = NA)
  )

## Save high SVI map ----

ggsave(filename = "high_svi_map_presentation.svg",
       width = 5, units = "in" )        


# Try treemap ---

# df <- data.frame(Category = c("All U.S. Counties", "High-Vulnerability Counties"),
#                  Value = c(3124,325))
# 
# ggplot2::ggplot(df,aes(area=Value,fill=Value)) +
#   treemapify::geom_treemap() +
#   theme_void()


# Retrieve CA outline to layer on targeted map ----

ca_outline <- high_sv_counties_shifted %>%
  filter(STATEFP == "06") %>%
  sf::st_union()
  
## Export CA outline shapefile ----

sf::st_write(ca_outline, "ca_outline.shp")


# Create vectors for subsetting data ----

aanhpi_pop <- h_asian_nhpi_df %>%
  select(FIPS) %>%
  pull()

all_lep_pop <-  h_lep_chin_viet_kor_df %>%
  select(FIPS) %>%
  pull()

all_pops <-  all_overlaps %>%
  select(FIPS) %>%
  pull()

## Add flag to shapefile ----

high_sv_counties_shifted <- high_sv_counties_shifted %>%
  mutate( aanhpi_flag = ifelse(GEOID %in% aanhpi_pop, 1, 0),
          all_lep_flag = ifelse(GEOID %in% all_lep_pop, 1, 0),
          overlaps_flag = ifelse(GEOID %in% all_pops, 1, 0)
        )


# See targetedMap function in use-color-palette-from-actual-tool chunk ----


# Define function to create targeted maps for presentation ----

indivMap <- function(var_name, low_color, high_color, ...){
  
  ggplot() +
    geom_sf(data = high_sv_counties_shifted,
            aes(fill = ifelse(.data[[var_name]] == 0, NA, .data[[var_name]])),
            size = 0.1) +
    scale_fill_gradient(low = {{low_color}},                     # specify the same HEX code for gradient
                        high = {{high_color}},
                        na.value = "gray97") +
    theme_void() +
    theme(legend.position = "none",
          plot.background = element_rect(fill = "transparent",   # ensure transparent bg upon saving
                                         color = NA)
    )
  
}

## Create map for AANHPI flag ----

aanhpi_map <- indivMap(var_name = "aanhpi_flag", low_color = "#213a83", high_color = "#213a83")

ggsave(filename = "aanhpi_pop_map_presentation.svg")


## Create map for LEP flag ----

all_lep_map <- indivMap(var_name = "all_lep_flag", low_color = "#2948a3", high_color = "#2948a3")

ggsave(filename = "lep_pop_map_presentation.svg")


# Create final map with CA outline ----

overlaps_map_presentation <- ggplot() +
  geom_sf(data = high_sv_counties_shifted,
          aes(fill = ifelse(overlaps_flag == 0, NA, overlaps_flag)),
          size = 0.1) +
  scale_fill_gradient(low = "#3155c2",                     
                      high = "#3155c2",
                      na.value = "gray97") +
  geom_sf(data = ca_outline,
          size = 1,
          alpha = 0) +                                         # make top layer zero opacity
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "transparent",   # ensure transparent bg upon saving
                                       color = NA)
  )

ggsave(filename = "overlaps_flag_map_presentation.svg")
