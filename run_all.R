source("scripts/world_map.R")
map.plot <- plot.world.map()

svg("worldmap_poster.svg", width=8, height=5)
map.plot
dev.off()

source("scripts/upset.R")
upset.plot <- plot.upset()

sf <- 0.7
svg("upset-plot.svg", width=16*sf, height=10*sf)
upset.plot
dev.off()

source("scripts/run_hypertraps.R")
load("fitted-model.Rdata") #model.fit <- run.hypertraps()

source("scripts/bubbles.R")
bubbles.plot <- plot.bubbles(model.fit)

sf<-35
png("bubbles.png", width=400*sf, height=180*sf,res=72*sf)
bubbles.plot
dev.off()