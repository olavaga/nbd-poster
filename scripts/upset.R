plot.upset <- function() {
  fail <- require.multiple(list("ggplot2","ggupset","tidyverse"),
                           " failed to load. Required for upset-plot")
  if (fail) return (-1)
  
  source("utils/require_multiple.R")
  source("utils/graphical_profile_uib.R")
  source("utils/download_pathogenwatch.R")
  source("utils/preprocess_kleborate.R")
  source("utils/poster_theme.R")
  
  download.pw("Klebsiella pneumoniae__kleborate.csv")
  kleborate.df <-  read.csv("raw/Klebsiella pneumoniae__kleborate.csv",
                            stringsAsFactors = FALSE)
  
  resistance.df <- preprocess.kleborate(kleborate.df)
  resistance.df <- as.data.frame(apply(resistance.df,c(1,2),\(x) x==1))
  selection <- colnames(resistance.df)
  resistance.df$id <- kleborate.df$Genome.ID
  resistance.df <- pivot_longer(resistance.df, selection)
  resistance.df <- resistance.df[resistance.df$value,]
  
  upset.plot <- resistance.df %>% 
    group_by(id) %>% 
    dplyr::summarize(Genes = list(name)) %>% 
    ggplot(aes(x = Genes)) + 
    geom_bar() + 
    scale_x_upset(n_intersections=30) +
    xlab("Antibiotic resistance gene profiles") +
    theme_classic(base_size=24) +
    theme.poster

  return(upset.plot)  
}