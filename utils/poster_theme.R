source("utils/graphical_profile_uib.R")
require(ggplot2)
background.color <- uib.red[[10]]
theme.poster <- theme_classic() +
  theme(panel.background = element_rect(fill = background.color,
                                        colour = background.color,
                                        size = 0.5, 
                                        linetype = "solid"),
        legend.background = element_rect(fill = background.color),
        legend.key = element_rect(fill = background.color),
        plot.background = element_rect(fill = background.color))