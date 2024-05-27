source("scripts/world_map.R")
source("scripts/upset.R")
source("scripts/run_hypertraps.R")
source("scripts/bubbles.R")

plot.world.map()
plot.upset()
load("fitted-model.Rdata") #model.fit <- run.hypertraps()
plot.bubbles(model.fit)
