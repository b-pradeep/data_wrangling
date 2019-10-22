library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)
library(plotly)
library(leaflet)

schools_data = read.csv("clean_schools.csv", header = TRUE)
hospital_data = read.csv("clean_hospital.csv", header = TRUE)
distance_data <- read.csv("clean_shortest_distance.csv")

cities <- schools_data$city %>% unique()
