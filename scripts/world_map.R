plot.world.map <- function() {
  source("utils/require_multiple.R")
  source("utils/graphical_profile_uib.R")
  source("utils/download_pathogenwatch.R")
  
  fail <- require.multiple(list("ggplot2", "plyr", "tmap"))
  if (fail) return (-1)
  
  # Import data and select only relevant columns
  data("World")
  World <- World[,c("name","geometry")]
  
  download.pw("Klebsiella pneumoniae__kleborate.csv")
  download.pw("Klebsiella pneumoniae__metadata.csv")
  path <- "raw/Klebsiella pneumoniae__"
  read.pw <- \(tool_name) read.csv(paste0(path,
                                          tool_name,
                                          ".csv"),
                                   stringsAsFactors = FALSE)
  
  kleborate.df <-   read.pw("kleborate")
  metadata.df  <-   read.pw("metadata")
  countries.kp <- metadata.df$Country
  misses.df <- filter(metadata.df, !(countries.kp %in% unique(World$name)))
  
  metadata.df$Country[metadata.df$Country=="USA"] <- "United States"
  metadata.df$Country[metadata.df$Country=="The Gambia"] <- "Gambia"
  metadata.df$Country[metadata.df$Country=="Viet Nam"] <- "Vietnam"
  metadata.df$Country[metadata.df$Country=="UAE"] <- "United Arab Emirates"
  metadata.df$Country[metadata.df$Country=="UK"] <- "United Kingdom"
  metadata.df$Country[metadata.df$Country=="Czech Republic"] <- "Czech Rep."
  metadata.df$Country[metadata.df$Country=="United Kingdom (Scotland)"] <- "United Kingdom"
  metadata.df$Country[metadata.df$Country=="United Kingdom (England/Wales/N. Ireland"] <- "United Kingdom"
  
  metadata.df$Country[metadata.df$Country=="Hong Kong"] <- ""
  metadata.df$Country[metadata.df$Country=="Laos"] <- ""
  metadata.df$Country[metadata.df$Country=="Singapore"] <- ""
  metadata.df$Country[metadata.df$Country=="West Bank"] <- ""
  metadata.df$Country[metadata.df$Country=="Guadeloupe"] <- ""
  metadata.df$Country[metadata.df$Country=="Malta"] <- ""
  metadata.df$Country[metadata.df$Country=="KSA"] <- ""
  metadata.df$Country[metadata.df$Country=="Bahrain"] <- ""
  metadata.df$Country[metadata.df$Country=="South Korea"] <- ""
  metadata.df$Country[metadata.df$Country=="missing"] <- ""
  metadata.df$Country[metadata.df$Country=="Dominican Republic"] <- ""                                    
  metadata.df$Country[metadata.df$Country=="Other (International Space Station)"] <- ""
  metadata.df$Country[metadata.df$Country=="Martinique"] <- ""
  metadata.df$Country[metadata.df$Country=="Curacao"] <- ""
  
  sum(metadata.df$Country == "")
  
  counts <- ddply(metadata.df, .(Country), nrow)
  par(bg=NA)
  KlebsiellaWorld <- merge(World, counts, by.x='name', by.y='Country', all.x=TRUE)
  
  map.plot <- tm_shape(KlebsiellaWorld, projection='+proj=eck4') +
    tm_polygons("V1", 
                title="Number of isolates", 
                palette=rev(uib.red[3:9]), 
                breaks=c(1, 101, 501, 1001, 5001, 10001, 15000),
                textNA="No samples",
                legend.format=list(text.separator="to")) +
                tm_layout(bg.color = uib.red[[10]])
  
  return (map.plot)
}
