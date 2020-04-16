# Maps of the distribution of Euphrasia species on Fair Isle #

# using the osmdata api for this
# then plotting using the lovely ggplot functionality
library(osmdata)
library(dplyr)
library(data.table)
library(ggplot2)

# data from Dropbox
mapped <- fread("~/Dropbox/Euphrasia_share/Maps/joint_sites_180816_verifiedAT_HB.csv")

# remove unknowns?
mapped[Taxon == "unknown"]$Taxon <- "None"

# all the available features in osmaps
head(available_features(), 100)

osmdata::available_features()

# list of all features and tags within (takes a while...)
#feat <- list()
#for(i in 1:length(osmdata::available_features())){
 # j <- osmdata::available_features()[i]
  #feat[[j]] <- osmdata::available_tags(feature = osmdata::available_features()[i])
#}

#feat

# all the tags in the available feature, railway
available_tags(feature = "highway")

# this is the box that bounds Fair Isle (or a box, rather...)
FI <- opq(bbox = c(-1.66782, 59.51166, -1.59130, 59.55439))
# I added a road, it's actually unclassified which is interesting.
FI_roads <- add_osm_feature(opq = FI,
                                    key = "highway",
                                    value = c("unclassified")) %>%
  osmdata_sf()

FI_boundary <- add_osm_feature(opq = FI, key = "natural", value = "coastline") %>%
  osmdata_sf()

# 
mapFI <- ggplot() +
  geom_sf(data = FI_boundary$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = 0.5,
          alpha = 0.8) +
  geom_sf(data = FI_roads$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = 0.5,
          alpha = 0.8) +
  geom_point(data = mapped[Taxon %in% c("Euphrasia arctica", "Euphrasia foulaensis", "Euphrasia micrantha")], aes(x = lon, y = lat, fill = Taxon), pch = 21, size = 4)+
  scale_fill_manual(name = "Species", values = c("red", "green", "blue"))+
  theme_bw(base_line_size = 0)+
  xlab("Longitude")+
  ylab("Latitude") 
  
ggsave(plot = mapFI, filename = "./map.pdf", width = 7.5)

