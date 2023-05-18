
# AUXILLARY ANALYSIS ON HAWAII ----


# Load packages ----

## List required packages

packages <- c("tidyverse", "openxlsx", "tigris", "here")

## Load all required packages

invisible( lapply(packages, library, character.only = TRUE) )


# Load 2018 CDC/ATSDR SVI data ----

# These data were downloaded from CDC/ATSDR website: https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html

## Read in HI county-level data (ranking within state only)

hi_county <- read_csv(here("data", "Hawaii_COUNTY.csv")) # see chr: STATE, ST_ABBR, COUNTY, LOCATION

## Read in HI Census tract-level data (ranking within state only)

hi_tracts <- read_csv(here("data", "Hawaii.csv")) # see chr:  STATE, ST_ABBR, COUNTY, LOCATION

## Read in US Census tract-level data; filter to HI (ranking across all US)

us_tracts <- read_csv(here("data", "SVI2018_US.csv")) # see chr: ST, STATE, ST_ABBR, STCNTY, COUNTY, FIPS, LOCATION

## Read in data dictionary 

data_dic <- read.xlsx (here("data", "CDC_SVI_2018_DD.xlsx"), 
                       sheet = 1, startRow = 2)


# Load 2018 Minority Health SVI data ----

hi_mh_svi <- read_csv(here("data", "mh_svi_county_2018.csv"),
                      show_col_types = FALSE) %>%
  filter(ST_ABBR == "HI") %>%
  select(FIPS, COUNTY, RPL_THEMES) %>%
  rename(MH_RPL_THEMES = RPL_THEMES)


# Explore HI data in CDC/ATSDR SVI ----

## See county-level, within-HI rankings

hi_county_ranks <- hi_county %>%
  select(FIPS, LOCATION, RPL_THEMES) 

## See tract-level, within-HI rankings

hi_tract_ranks <- hi_tracts %>%
  select(FIPS, COUNTY, LOCATION, E_TOTPOP, RPL_THEMES) %>%   # note 'FIPS' has tract IDs in tract-only data set
  filter(RPL_THEMES >= 0.90)

## See tract-level, all-US rankings 

hi_us_tract_ranks <- us_tracts %>%
  filter(ST_ABBR == "HI") %>%
  select(FIPS, COUNTY, LOCATION, RPL_THEMES) %>%
  filter(RPL_THEMES >= 0.90)


# Create county-level summary df ---- 

compare_hi_county_ranks <- hi_mh_svi %>%
  left_join(hi_county_ranks,
            by = "FIPS")

## Format summary table

compare_hi_county_ranks_table <- compare_hi_county_ranks %>%
  select(-COUNTY) %>%
  relocate(MH_RPL_THEMES, .after = LOCATION) %>%
  mutate(across(c(MH_RPL_THEMES, RPL_THEMES),
                scales::label_percent(accuracy = 1,   # round to nearest whole number
                                      suffix = "%"))
         ) %>%
  rename(`County FIPS` = FIPS,
         `Minority Health SVI Overall Social Vulnerability Ranking` = MH_RPL_THEMES,
         `CDC/ATSDR SVI Overall Social Vulnerability Ranking` = RPL_THEMES)

# TO DO: Use {officer} to add table to PPTX.


# Make map of HI Census tracts and CDC/ASTDR SVI ---- 

## Retrieve shapefile

shapefile_hi_tracts <- tracts("HI", cb = TRUE, year = 2018)

## Join shapefile and data 

hi_tracts$FIPS <- as.character(hi_tracts$FIPS) # convert data type for merging

shapefile_hi_tracts <- shapefile_hi_tracts %>%
  left_join( hi_tracts, by = c("TRACTCE" = "FIPS") ) # TO DO: This is not working!



ggplot() +
  geom_sf(data = shapefile_hi_tracts,
          aes(fill = ifelse(RPL_THEMES >= 0.90, RPL_THEMES, NA)),
          size = 0.1) +
  scale_fill_gradient(low = "#213a83",                     # specify the same HEX code for gradient
                      high = "#213a83",
                      na.value = "gray97") +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "transparent",   # ensure transparent bg upon saving
                                       color = NA)
  ) +
  coord_sf(xlim = c(-161, -154), 
           ylim = c(18, 23), 
           expand = FALSE)


# Resources ----

# See multiple methods for "zooming in": https://datascience.blog.wzb.eu/2019/04/30/zooming-in-on-maps-with-sf-and-ggplot2/