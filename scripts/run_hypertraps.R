hypertraps.path <- "../hypertraps-ct/hypertraps-r.cpp"

run.hypertraps <- function(country = "germany", seed = 1) {
  source("utils/require_multiple.R")
  source("utils/download_pathogenwatch.R")
  source("utils/preprocess_kleborate.R")
  source("utils/curate_tree.R")
  
  require.multiple(list("Rcpp","ape","phangorn"), 
                   "Failed to load required packages for run_hypertraps.R")
  
  if (file.exists(hypertraps.path)) {
    sourceCpp(hypertraps.path)
    
  } else {
    print(paste("No hypertraps at current path", hypertraps.path))
    print("Update hypertraps.path in run_hypertraps.R to correct source file")
    print("or clone https://github.com/StochasticBiology/hypertraps-ct")
    return (-1)
  }
  
  tree.path <- paste0("trees/",country,".nwk")
  if (file.exists(tree.path)) {
    my.tree = read.tree(tree.path)
    
  } else {
    print(paste("No newick-tree for", country, "in trees directory"))
    return(-1)
  }
  
  download.pw("Klebsiella pneumoniae__kleborate.csv")
  kleborate.df <- read.csv("raw/Klebsiella pneumoniae__kleborate.csv")
  
  resistance.df <- preprocess.kleborate(kleborate.df)
  resistance.df <- resistance.df[,c("Bla",
                                    "Bla_inhR",
                                    "Bla_ESBL",
                                    "Bla_ESBL_inhR",
                                    "Bla_Carb")]
  
  featurenames <- c("Betalactamase", 
                    "Betalactamase_inhR",
                    "ESBL", 
                    "ESBL_inhR", 
                    "ESBL_carba")
  
  resistance.df <- cbind(kleborate.df$Genome.Name, resistance.df)
  resistance.df <- resistance.df[which(kleborate.df$Genome.Name %in% my.tree$tip.label),]
  
  dir.create("clean", showWarnings=FALSE)
  write.csv(resistance.df, "clean/binary.csv", row.names=FALSE)
  ctree <- curate.tree(tree.path, 
                       "clean/binary.csv")
  
  model.fit <- HyperTraPS(ctree$dests, 
                       initialstates=ctree$srcs,
                       length = 4,
                       penalty = 1,
                       seed = seed,
                       featurenames=featurenames)
  
  return (model.fit)
}