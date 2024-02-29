install.packages(c("tidyverse", "sp", "raster", "sf", "lwgeom", "terra", "stars", "exactextractr"))
install.packages("rinat")
install.packages("rosm")
install.packages("ggspatial")
install.packages("ggplot2")
install.packages("ggplot2map")
install.packages("prettymapr")
install.packages("leaflet")
install.packages("htmltools")
install.packages("leafpop")
install.packages("mapview")


library(rinat)
library(tidyverse)
library(sf)
library(sp)
library(raster)
library(lwgeom)
library(terra)
library(stars)
library(rosm)
library(ggspatial)
library(ggplot2)
library(prettymapr)
library(leaflet)
library(htmltools)
library(leafpop)
library(mapview)
library(dplyr)

#Call the data directly from iNat
hp <- get_inat_obs(taxon_name = "Hyperolius pickersgilli",
                   maxresults = 1000)

hp <- hp %>% filter(!is.na(latitude) &
                      captive_cultivated == "false" &
                      quality_grade == "research")
class(hp)


hp <- st_as_sf(hp, coords = c("longitude", "latitude"), crs = 4326)

ggplot() + geom_sf(data=hp)

ggplot() + 
  annotation_map_tile(type = "osm", progress = "none") + 
  geom_sf(data=hp)

leaflet() %>%
  # Add default OpenStreetMap map tiles
  addTiles(group = "Default") %>%  
  # Add our points
  addCircleMarkers(data = hp,
                   group = "Hyperolius pickersgilli",
                   radius = 3, 
                   color = "green") 
mapview(hp, 
        popup = 
          popupTable(hp,
                     zcol = c("user_login", "captive_cultivated", "url")))


lhp <- hp %>%
  mutate(click_url = paste("<b><a href='", url, "'>Link to iNat observation</a></b>"))

mapview(hp, 
        popup = 
          popupTable(lhp,
                     zcol = c("user_login", "captive_cultivated", "click_url")))

indices_to_exclude <- c(2, 30, 38)
filtered_hp <- hp %>%
  filter(!row_number() %in% indices_to_exclude)

# Create the popup content with the modified dataset
lhp <- filtered_hp %>%
  mutate(click_url = paste("<b><a href='", url, "'>Link to iNat observation</a></b>"))

# Plot the filtered points using mapview
mapview(filtered_hp, 
        popup = 
          popupTable(lhp,
                     zcol = c("user_login", "captive_cultivated", "click_url")))
