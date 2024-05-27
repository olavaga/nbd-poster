plot.bubbles <- function(model.fit) {
  source("utils/require_multiple.R")
  source("utils/graphical_profile_uib.R")
  source("scripts/run_hypertraps.R")
  fail <- require.multiple(list("ggplot2"),
                   "failed to load required packages for bubbles-plot.")
  if (fail) return(-1)
  bubbles <- model.fit$bubbles
  bubbles.plot <- ggplot(bubbles) + 
    geom_point(aes(Time, OriginalIndex, size=Probability)) +
    xlab("Ordinal time") +
    scale_y_continuous(breaks=0:4, labels=unique(bubbles$Name)) +
    theme(panel.background = element_rect(fill = "#fef9f1",
                                          colour = "#fef9f1",
                                          size = 0.5, 
                                          linetype = "solid"),
          plot.background = element_rect(fill = "#fef9f1")) +
    theme_classic()
  
  sf<-35
  png("bubbles-germany.png", width=400*sf, height=180*sf,res=72*sf)
  bubbles.plot
  dev.off()
  
  return (bubbles.plot)
}