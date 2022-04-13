
#usethis::use_git()
#usethis::use_github()
#usethis::use_readme_md()



# INTRODUCTION TO LEAFLET


library(leaflet)
library(stringr)
library(htmlwidgets)
library(ggmap)
library(dplyr)
library(tidyverse)

#usethis::use_git("Capítulo 1 - curso leaflet") 
#usethis::pr_init(branch = "master")
#usethis::pr_push()
usethis::pr_init()
usethis::use_git("Capítulo 1 - curso leaflet")
usethis::pr_push()

#-----------------------------------------------------------------------------------------------------------#
#                                              CAPÍTULO 1                                                   #
#-----------------------------------------------------------------------------------------------------------#

leaflet() %>% addTiles()

# Print the providers list included in the leaflet library
providers

# Print only the names of the map tiles in the providers list 
names(providers)

# Use str_detect() to determine if the name of each provider tile contains the string "CartoDB"
stringr::str_detect(names(providers), "CartoDB")

# Use str_detect() to print only the provider tile names that include the string "CartoDB"
names(providers)[str_detect(names(providers), "CartoDB")]

# Change addTiles() to addProviderTiles() and set the provider argument to "CartoDB"
leaflet() %>% 
  addProviderTiles(provider = "CartoDB")

# Create a leaflet map that uses the Esri provider tile 
leaflet() %>% 
  addProviderTiles("Esri")

# Create a leaflet map that uses the CartoDB.PositronNoLabels provider tile
leaflet() %>% 
  addProviderTiles("CartoDB.PositronNoLabels")

#geocode("Colby College", output = "more", source = "google")
#Existem duas abordagens comuns para definir a visualização padrão de seu mapa: setview() ou fitBounds()
#setView(lng = , lat = , zoom = )  -> unico ponto no centro do seu mapa
# fitBound(lng1 = , lat1 = , lng2 = , lat2 = ) visualização com base num retângulo

#Para limitar a uma area específica 
#leaflet(options = leafletOptions(dragging = FALSE [EVITAR MOVIMENTO PANORÂMICO],
#                                 minZoom = 
#                                 maxZoom = )) limitar o zoom

#serMaxBounds(lng1 = , lat1 = , lng2= , lat2 = ) -> Se o usuário tentar deslocar seu mapa para fora dos limites
#máximos, eles serão automaticamente devolvidos ao limite.


# Map with CartoDB tile centered on DataCamp's NYC office with zoom of 6
leaflet()  %>% 
  addProviderTiles("CartoDB")  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 6)

# Map with CartoDB.PositronNoLabels tile centered on DataCamp's Belgium office with zoom of 4
leaflet() %>% 
  addProviderTiles("CartoDB.PositronNoLabels") %>% 
  setView(lng = 4.717863, lat =  50.881363, zoom = 4)


leaflet(options = leafletOptions(
  # Set minZoom and dragging 
  minZoom = 12, dragging = TRUE))  %>% 
  addProviderTiles("CartoDB")  %>% 
  
  # Set default zoom level 
  setView(lng = dc_hq$lon[2], lat = dc_hq$lat[2], zoom = 14) %>% 
  
  # Set max bounds of map 
  setMaxBounds(lng1 = dc_hq$lon[2] + .05, 
               lat1 = dc_hq$lat[2] + .05, 
               lng2 = dc_hq$lon[2] - .05, 
               lat2 = dc_hq$lat[2] - .05)


# Plot DataCamp's NYC HQ
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = dc_hq$lon[1], lat = dc_hq$lat[1])


# Plot DataCamp's NYC HQ with zoom of 12    
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = -73.98575, lat = 40.74856)  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 12)


# Plot both DataCamp's NYC and Belgium locations
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = dc_hq$lon, lat = dc_hq$lat)


# Store leaflet hq map in an object called map
map <- leaflet() %>%
  addProviderTiles("CartoDB") %>%
  # Use dc_hq to add the hq column as popups
  addMarkers(lng = dc_hq$lon, lat = dc_hq$lat,
             popup = dc_hq$hq)

# Center the view of map on the Belgium HQ with a zoom of 5
map_zoom <- map %>%
  setView(lat = 50.881363, lng = 4.717863,
          zoom = 5)

# Print map_zoom
map_zoom





#----------------------------------------------- CAPITULO 2 ----------------------------------#


# Remove colleges with missing sector information
ipeds <- 
  ipeds_missing %>% 
  drop_na() 

# Count the number of four-year colleges in each state
ipeds %>% 
  group_by(state) %>% 
  count()


# Create a list of US States in descending order by the number of colleges in each state
ipeds  %>% 
  group_by(state)  %>% 
  count()  %>% 
  arrange(desc(n))


# Create a dataframe called `ca` with data on only colleges in California
ca <- ipeds %>%
  filter(state == "CA")

# Use `addMarkers` to plot all of the colleges in `ca` on the `m` leaflet map
map %>%
  addMarkers(lng = ca$lng, lat = ca$lat)

# Center the map on LA 
map %>% 
  addMarkers(data = ca) %>% 
  setView(lat = la_coords$lat, lng = la_coords$lon, zoom = 12)


# Change the radius of each circle to be 2 pixels and the color to red
map2 %>% 
  addCircleMarkers(lng = ca$lng, lat = ca$lat,
                   radius = 2, color = "red")


# Add circle markers with popups for college names
map %>%
  addCircleMarkers(data = ca, radius = 2, popup = ~name)

# Change circle color to #2cb42c and store map in map_color object
map_color <- map %>% 
  addCircleMarkers(data = ca, radius = 2, color = "#2cb42c", popup = ~name)

# Print map_color
map_color


# Clear the bounds and markers on the map object and store in map2
map2 <- map %>% 
  clearMarkers() %>% 
  clearBounds()

# Add circle markers with popups that display both the institution name and sector
map2 %>% 
  addCircleMarkers(data = ca, radius = 2, 
                   popup = ~paste0(name, "<br/>", sector_label))


# Make the institution name in each popup bold
map2 %>% 
  addCircleMarkers(data = ca, radius = 2, 
                   popup = ~paste0("<b>", name, "</b>", "<br/>", sector_label))


# Add circle markers with labels identifying the name of each college
map %>% 
  addCircleMarkers(data = ca, radius = 2, label = ~name)

# Use paste0 to add sector information to the label inside parentheses 
map %>% 
  addCircleMarkers(data = ca, radius = 2, label = ~paste0(name, " (", sector_label, ")"))


# Make a color palette called pal for the values of `sector_label` using `colorFactor()`  
# Colors should be: "red", "blue", and "#9b4a11" for "Public", "Private", and "For-Profit" colleges, respectively
pal <- colorFactor(palette = c("red", "blue", "#9b4a11"), 
                   levels = c("Public", "Private", "For-Profit"))

# Add circle markers that color colleges using pal() and the values of sector_label
map2 <- 
  map %>% 
  addCircleMarkers(data = ca, radius = 2, 
                   color = ~pal(sector_label), 
                   label = ~paste0(name, " (", sector_label, ")"))

# Print map2
map2


# Add a legend that displays the colors used in pal
m %>% 
  addLegend(pal = pal, 
            values = c("Public", "Private", "For-Profit"))


# Customize the legend
m %>% 
  addLegend(pal = pal, 
            values = c("Public", "Private", "For-Profit"),opacity = 0.5, title = "Sector", position = "topright")



usethis::use_git("Capítulo 3 - curso leaflet")
usethis::pr_push()


# ------------------------------------------------------------   CAPÍTULO  3   ------------------------------------------------------------- #

library(leaflet.extras)


leaflet() %>% 
  addTiles() %>% 
  addSearchOSM()
